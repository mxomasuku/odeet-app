import * as admin from "firebase-admin";
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { beforeUserCreated } from "firebase-functions/v2/identity";
import { FieldValue, Timestamp } from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";

// Initialize admin if not already
if (!admin.apps.length) {
    admin.initializeApp();
}

const db = admin.firestore();
const auth = admin.auth();

const TRIAL_DURATION_DAYS = 90;

/**
 * Verify that the caller has the isAdmin custom claim.
 * Throws an HttpsError if not authenticated or not an admin.
 */
function verifyAdmin(request: { auth?: { uid: string; token: { [key: string]: unknown } } }): string {
    if (!request.auth) {
        throw new HttpsError("unauthenticated", "User must be authenticated");
    }

    if (!request.auth.token.isAdmin) {
        throw new HttpsError("permission-denied", "Caller must be an admin");
    }

    return request.auth.uid;
}

// ---------------------------------------------------------------------------
// 1. adminListUsers
// ---------------------------------------------------------------------------

interface AdminListUsersRequest {
    limit?: number;
    offset?: number;
    search?: string;
}

/**
 * List all users from Firestore with pagination and optional search.
 * Returns user docs enriched with Firebase Auth metadata.
 */
export const adminListUsers = onCall(async (request) => {
    const callerUid = verifyAdmin(request);

    const { limit = 20, offset = 0, search } = request.data as AdminListUsersRequest;

    logger.info(`adminListUsers called by ${callerUid} | limit=${limit} offset=${offset} search=${search || ""}`);

    try {
        let query: FirebaseFirestore.Query = db.collection("users")
            .orderBy("createdAt", "desc");

        // Firestore doesn't natively support LIKE / full-text search.
        // For a simple prefix search on email or name we fetch a wider set and
        // filter in-memory. For production-grade search consider Algolia or
        // a dedicated search index.
        if (search) {
            const lowerSearch = search.toLowerCase().trim();

            // Fetch a larger batch so we can filter in-memory
            const snapshot = await query.limit(500).get();

            const filtered = snapshot.docs.filter((doc) => {
                const data = doc.data();
                const email = (data.email || "").toLowerCase();
                const name = (data.name || "").toLowerCase();
                return email.includes(lowerSearch) || name.includes(lowerSearch);
            });

            const paged = filtered.slice(offset, offset + limit);

            const users = await enrichUsersWithAuth(paged);

            return {
                users,
                total: filtered.length,
                limit,
                offset,
            };
        }

        // Standard paginated query (no search)
        const countSnapshot = await db.collection("users").count().get();
        const total = countSnapshot.data().count;

        const snapshot = await query.offset(offset).limit(limit).get();

        const users = await enrichUsersWithAuth(snapshot.docs);

        return {
            users,
            total,
            limit,
            offset,
        };
    } catch (error) {
        logger.error("Error listing users:", error);
        throw new HttpsError("internal", "Failed to list users");
    }
});

/**
 * Enrich Firestore user docs with Firebase Auth metadata.
 */
async function enrichUsersWithAuth(
    docs: FirebaseFirestore.QueryDocumentSnapshot[]
): Promise<Record<string, unknown>[]> {
    const users: Record<string, unknown>[] = [];

    for (const doc of docs) {
        const data = doc.data();
        let authMeta: Record<string, unknown> = {};

        try {
            const userRecord = await auth.getUser(doc.id);
            authMeta = {
                lastSignInTime: userRecord.metadata.lastSignInTime || null,
                creationTime: userRecord.metadata.creationTime || null,
            };
        } catch {
            // User may not exist in Auth (e.g. deleted auth account)
            authMeta = { lastSignInTime: null, creationTime: null };
        }

        users.push({
            uid: doc.id,
            ...data,
            createdAt: data.createdAt?.toDate?.()?.toISOString() || null,
            updatedAt: data.updatedAt?.toDate?.()?.toISOString() || null,
            ...authMeta,
        });
    }

    return users;
}

// ---------------------------------------------------------------------------
// 2. adminGetDashboardStats
// ---------------------------------------------------------------------------

/**
 * Get aggregate statistics for the admin dashboard.
 */
export const adminGetDashboardStats = onCall(async (request) => {
    const callerUid = verifyAdmin(request);

    logger.info(`adminGetDashboardStats called by ${callerUid}`);

    try {
        // Total users
        const usersCountSnap = await db.collection("users").count().get();
        const totalUsers = usersCountSnap.data().count;

        // Total organizations
        const orgsCountSnap = await db.collection("organizations").count().get();
        const totalOrganizations = orgsCountSnap.data().count;

        // Date thresholds
        const now = new Date();

        const sevenDaysAgo = new Date(now);
        sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);

        const thirtyDaysAgo = new Date(now);
        thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

        // New signups in last 7 days
        const newSignups7Snap = await db
            .collection("users")
            .where("createdAt", ">=", Timestamp.fromDate(sevenDaysAgo))
            .count()
            .get();
        const newSignups7Days = newSignups7Snap.data().count;

        // New signups in last 30 days
        const newSignups30Snap = await db
            .collection("users")
            .where("createdAt", ">=", Timestamp.fromDate(thirtyDaysAgo))
            .count()
            .get();
        const newSignups30Days = newSignups30Snap.data().count;

        // Blocked users
        const blockedSnap = await db
            .collection("users")
            .where("isBlocked", "==", true)
            .count()
            .get();
        const blockedUsers = blockedSnap.data().count;

        // Active users in last 7 days (based on Firebase Auth lastSignInTime)
        // Firebase Auth doesn't support querying by lastSignInTime directly,
        // so we iterate through users. For large user bases consider caching
        // this value via a scheduled function.
        let activeUsersLast7Days = 0;
        let nextPageToken: string | undefined;

        do {
            const listResult = await auth.listUsers(1000, nextPageToken);

            for (const userRecord of listResult.users) {
                const lastSignIn = userRecord.metadata.lastSignInTime;
                if (lastSignIn) {
                    const lastSignInDate = new Date(lastSignIn);
                    if (lastSignInDate >= sevenDaysAgo) {
                        activeUsersLast7Days++;
                    }
                }
            }

            nextPageToken = listResult.pageToken;
        } while (nextPageToken);

        return {
            totalUsers,
            totalOrganizations,
            newSignups7Days,
            newSignups30Days,
            activeUsersLast7Days,
            blockedUsers,
        };
    } catch (error) {
        logger.error("Error getting dashboard stats:", error);
        throw new HttpsError("internal", "Failed to get dashboard stats");
    }
});

// ---------------------------------------------------------------------------
// 3. adminGetUserDetail
// ---------------------------------------------------------------------------

interface AdminGetUserDetailRequest {
    uid: string;
}

/**
 * Get detailed information for a single user by UID.
 */
export const adminGetUserDetail = onCall(async (request) => {
    const callerUid = verifyAdmin(request);

    const { uid } = request.data as AdminGetUserDetailRequest;

    if (!uid) {
        throw new HttpsError("invalid-argument", "Target user UID is required");
    }

    logger.info(`adminGetUserDetail called by ${callerUid} for user ${uid}`);

    try {
        // Firestore user doc
        const userDoc = await db.collection("users").doc(uid).get();
        if (!userDoc.exists) {
            throw new HttpsError("not-found", "User not found");
        }

        const userData = userDoc.data()!;

        // Firebase Auth record
        let authData: Record<string, unknown> = {};
        try {
            const userRecord = await auth.getUser(uid);
            authData = {
                creationTime: userRecord.metadata.creationTime || null,
                lastSignInTime: userRecord.metadata.lastSignInTime || null,
                customClaims: userRecord.customClaims || {},
                disabled: userRecord.disabled,
                email: userRecord.email || null,
                emailVerified: userRecord.emailVerified,
                displayName: userRecord.displayName || null,
                photoURL: userRecord.photoURL || null,
            };
        } catch {
            authData = { error: "Auth record not found" };
        }

        // Organization data
        let organizationData: Record<string, unknown> | null = null;
        if (userData.organizationId) {
            const orgDoc = await db.collection("organizations").doc(userData.organizationId).get();
            if (orgDoc.exists) {
                const orgData = orgDoc.data()!;
                organizationData = {
                    id: orgDoc.id,
                    ...orgData,
                    createdAt: orgData.createdAt?.toDate?.()?.toISOString() || null,
                    updatedAt: orgData.updatedAt?.toDate?.()?.toISOString() || null,
                    trialStartDate: orgData.trialStartDate?.toDate?.()?.toISOString() || null,
                };
            }
        }

        return {
            uid: userDoc.id,
            ...userData,
            createdAt: userData.createdAt?.toDate?.()?.toISOString() || null,
            updatedAt: userData.updatedAt?.toDate?.()?.toISOString() || null,
            blockedAt: userData.blockedAt?.toDate?.()?.toISOString() || null,
            removedAt: userData.removedAt?.toDate?.()?.toISOString() || null,
            auth: authData,
            organization: organizationData,
        };
    } catch (error) {
        if (error instanceof HttpsError) throw error;
        logger.error("Error getting user detail:", error);
        throw new HttpsError("internal", "Failed to get user detail");
    }
});

// ---------------------------------------------------------------------------
// 4. adminToggleUserBlock
// ---------------------------------------------------------------------------

interface AdminToggleUserBlockRequest {
    uid: string;
    isBlocked: boolean;
}

/**
 * Block or unblock a user. Uses isAdmin claim instead of owner check.
 * Updates custom claims, Firestore user doc, and revokes tokens if blocking.
 */
export const adminToggleUserBlock = onCall(async (request) => {
    const callerUid = verifyAdmin(request);

    const { uid, isBlocked } = request.data as AdminToggleUserBlockRequest;

    if (!uid) {
        throw new HttpsError("invalid-argument", "Target user UID is required");
    }

    if (typeof isBlocked !== "boolean") {
        throw new HttpsError("invalid-argument", "isBlocked must be a boolean");
    }

    if (callerUid === uid) {
        throw new HttpsError("invalid-argument", "You cannot block yourself");
    }

    logger.info(`adminToggleUserBlock called by ${callerUid} | uid=${uid} isBlocked=${isBlocked}`);

    try {
        // Verify target user exists
        const targetUserDoc = await db.collection("users").doc(uid).get();
        if (!targetUserDoc.exists) {
            throw new HttpsError("not-found", "Target user not found");
        }

        // Update Custom Claims
        const currentClaims = (await auth.getUser(uid)).customClaims || {};
        await auth.setCustomUserClaims(uid, {
            ...currentClaims,
            isBlocked: isBlocked,
        });

        // Update Firestore User Doc
        await db.collection("users").doc(uid).update({
            isBlocked: isBlocked,
            updatedAt: FieldValue.serverTimestamp(),
            blockedAt: isBlocked ? FieldValue.serverTimestamp() : FieldValue.delete(),
            blockedBy: isBlocked ? callerUid : FieldValue.delete(),
        });

        // If blocking, force token revocation to log them out immediately
        if (isBlocked) {
            await auth.revokeRefreshTokens(uid);
        }

        logger.info(`User ${uid} block status set to ${isBlocked} by admin ${callerUid}`);

        return { success: true, message: `User ${isBlocked ? "blocked" : "unblocked"} successfully` };
    } catch (error) {
        if (error instanceof HttpsError) throw error;
        logger.error("Error toggling user block status:", error);
        throw new HttpsError("internal", "Failed to update user block status");
    }
});

// ---------------------------------------------------------------------------
// 5. adminUpdateTrialDays
// ---------------------------------------------------------------------------

interface AdminUpdateTrialDaysRequest {
    organizationId: string;
    trialDays: number;
}

/**
 * Extend or set the trial period for an organization.
 *
 * The Flutter app calculates trial expiry as: trialStartDate + 90 days.
 * To give X days remaining from now, we set trialStartDate to:
 *   now - (90 - X) days
 *
 * This way the app sees: trialStartDate + 90 = now + X  (i.e. X days left).
 */
export const adminUpdateTrialDays = onCall(async (request) => {
    const callerUid = verifyAdmin(request);

    const { organizationId, trialDays } = request.data as AdminUpdateTrialDaysRequest;

    if (!organizationId) {
        throw new HttpsError("invalid-argument", "organizationId is required");
    }

    if (typeof trialDays !== "number" || trialDays < 0) {
        throw new HttpsError("invalid-argument", "trialDays must be a non-negative number");
    }

    logger.info(`adminUpdateTrialDays called by ${callerUid} | orgId=${organizationId} trialDays=${trialDays}`);

    try {
        const orgRef = db.collection("organizations").doc(organizationId);
        const orgDoc = await orgRef.get();

        if (!orgDoc.exists) {
            throw new HttpsError("not-found", "Organization not found");
        }

        // Calculate the trialStartDate so that the trial expires in trialDays from now.
        // trialExpiry = trialStartDate + 90 days
        // We want trialExpiry = now + trialDays
        // Therefore trialStartDate = now - (90 - trialDays) days
        const now = new Date();
        const daysToSubtract = TRIAL_DURATION_DAYS - trialDays;
        const newTrialStartDate = new Date(now);
        newTrialStartDate.setDate(newTrialStartDate.getDate() - daysToSubtract);

        await orgRef.update({
            trialStartDate: Timestamp.fromDate(newTrialStartDate),
            subscriptionTier: "trial",
            updatedAt: FieldValue.serverTimestamp(),
        });

        const expiryDate = new Date(now);
        expiryDate.setDate(expiryDate.getDate() + trialDays);

        logger.info(`Organization ${organizationId} trial updated: ${trialDays} days remaining (expires ${expiryDate.toISOString()})`);

        return {
            success: true,
            message: `Trial updated to ${trialDays} days remaining`,
            trialStartDate: newTrialStartDate.toISOString(),
            trialExpiryDate: expiryDate.toISOString(),
        };
    } catch (error) {
        if (error instanceof HttpsError) throw error;
        logger.error("Error updating trial days:", error);
        throw new HttpsError("internal", "Failed to update trial days");
    }
});

// ---------------------------------------------------------------------------
// 6. adminSetAdminClaim
// ---------------------------------------------------------------------------

interface AdminSetAdminClaimRequest {
    uid: string;
    isAdmin: boolean;
}

/**
 * Promote or demote a user to/from admin.
 * Only callable by existing admins.
 */
export const adminSetAdminClaim = onCall(async (request) => {
    const callerUid = verifyAdmin(request);

    const { uid, isAdmin } = request.data as AdminSetAdminClaimRequest;

    if (!uid) {
        throw new HttpsError("invalid-argument", "Target user UID is required");
    }

    if (typeof isAdmin !== "boolean") {
        throw new HttpsError("invalid-argument", "isAdmin must be a boolean");
    }

    if (callerUid === uid && !isAdmin) {
        throw new HttpsError("invalid-argument", "You cannot remove your own admin privileges");
    }

    logger.info(`adminSetAdminClaim called by ${callerUid} | uid=${uid} isAdmin=${isAdmin}`);

    try {
        // Verify target user exists in Auth
        const userRecord = await auth.getUser(uid);
        const currentClaims = userRecord.customClaims || {};

        await auth.setCustomUserClaims(uid, {
            ...currentClaims,
            isAdmin: isAdmin,
        });

        // Also store in Firestore for easy querying
        const userRef = db.collection("users").doc(uid);
        const userDoc = await userRef.get();

        if (userDoc.exists) {
            await userRef.update({
                isAdmin: isAdmin,
                updatedAt: FieldValue.serverTimestamp(),
            });
        }

        // Log the activity
        await db.collection("admin_activity_log").add({
            type: isAdmin ? "admin_promoted" : "admin_demoted",
            userId: uid,
            email: userRecord.email || null,
            performedBy: callerUid,
            timestamp: FieldValue.serverTimestamp(),
        });

        logger.info(`User ${uid} admin status set to ${isAdmin} by ${callerUid}`);

        return { success: true, message: `User ${isAdmin ? "promoted to" : "demoted from"} admin` };
    } catch (error) {
        if (error instanceof HttpsError) throw error;
        logger.error("Error setting admin claim:", error);
        throw new HttpsError("internal", "Failed to set admin claim");
    }
});

// ---------------------------------------------------------------------------
// 7. onUserCreated
// ---------------------------------------------------------------------------

/**
 * Auth trigger that fires before a user is created.
 * Logs the new signup to the admin_activity_log collection.
 *
 * Since we don't return a blocking response, the user creation proceeds
 * normally.
 */
export const onUserCreated = beforeUserCreated(async (event) => {
    const user = event.data;

    if (!user) {
        logger.warn("onUserCreated triggered with no user data");
        return;
    }

    logger.info(`New user signup: ${user.uid} (${user.email || "no email"})`);

    try {
        await db.collection("admin_activity_log").add({
            type: "signup",
            userId: user.uid,
            email: user.email || null,
            timestamp: FieldValue.serverTimestamp(),
        });
    } catch (error) {
        // Don't block user creation if logging fails
        logger.error("Failed to log user signup to admin_activity_log:", error);
    }

    // Return nothing to allow user creation to proceed
    return;
});
