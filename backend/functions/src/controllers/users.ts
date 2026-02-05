import * as admin from "firebase-admin";
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { FieldValue } from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";

// Initialize admin if not already
if (!admin.apps.length) {
    admin.initializeApp();
}

const db = admin.firestore();
const auth = admin.auth();

interface RemoveUserRequest {
    uid: string;
}

/**
 * Remove a user from the organization.
 * Can only be called by an Owner.
 */
export const removeUserFromTeam = onCall(async (request) => {
    // Validate caller authentication
    if (!request.auth) {
        throw new HttpsError("unauthenticated", "User must be authenticated");
    }

    const callerUid = request.auth.uid;
    const { uid } = request.data as RemoveUserRequest;

    if (!uid) {
        throw new HttpsError("invalid-argument", "Target user UID is required");
    }

    if (callerUid === uid) {
        throw new HttpsError("invalid-argument", "You cannot remove yourself");
    }

    // 1. Check Caller Permissions (Must be Owner)
    const callerDoc = await db.collection("users").doc(callerUid).get();
    if (!callerDoc.exists) {
        throw new HttpsError("permission-denied", "Caller profile not found");
    }

    const callerData = callerDoc.data()!;
    const callerRoles = callerData.roles || [];
    const callerRole = callerData.role || "";
    const callerOrgId = callerData.organizationId;

    const isOwner = callerRoles.includes("owner") || callerRole === "owner";
    if (!isOwner) {
        throw new HttpsError("permission-denied", "Only owners can remove users");
    }

    // 2. Check Target User (Must be in same Org)
    const targetUserDoc = await db.collection("users").doc(uid).get();
    if (!targetUserDoc.exists) {
        throw new HttpsError("not-found", "Target user not found");
    }

    const targetUserData = targetUserDoc.data()!;
    if (targetUserData.organizationId !== callerOrgId) {
        throw new HttpsError("permission-denied", "User is not in your organization");
    }

    // 3. Perform Removal
    // 3. Perform Removal
    try {
        const batch = db.batch();
        const userShopIds = targetUserData.shopIds || [];

        // Remove from Firestore User Doc
        const userRef = db.collection("users").doc(uid);
        batch.update(userRef, {
            organizationId: FieldValue.delete(),
            roles: [],
            role: FieldValue.delete(),
            shopIds: [],
            updatedAt: FieldValue.serverTimestamp(),
            removedAt: FieldValue.serverTimestamp(),
            removedBy: callerUid,
        });

        // Remove from Shop Docs
        if (userShopIds.length > 0) {
            const shopRefs = userShopIds.map((id: string) =>
                db.collection("organizations").doc(callerOrgId).collection("shops").doc(id)
            );

            const shopDocs = await db.getAll(...shopRefs);

            for (const doc of shopDocs) {
                if (doc.exists) {
                    batch.update(doc.ref, {
                        assignedUserIds: FieldValue.arrayRemove(uid),
                        updatedAt: FieldValue.serverTimestamp(),
                    });
                }
            }
        }

        await batch.commit();

        // Revoke Custom Claims (effectively removes role access)
        await auth.setCustomUserClaims(uid, { roles: [] });

        logger.info(`User ${uid} removed from organization ${callerOrgId} by ${callerUid}`);

        return { success: true, message: "User removed from organization" };
    } catch (error) {
        logger.error("Error removing user:", error);
        throw new HttpsError("internal", "Failed to remove user");
    }
});

interface ToggleBlockRequest {
    uid: string;
    isBlocked: boolean;
}

/**
 * Toggle a user's blocked status.
 * Can only be called by an Owner.
 */
export const toggleUserBlockStatus = onCall(async (request) => {
    // Validate caller authentication
    if (!request.auth) {
        throw new HttpsError("unauthenticated", "User must be authenticated");
    }

    const callerUid = request.auth.uid;
    const { uid, isBlocked } = request.data as ToggleBlockRequest;

    if (!uid) {
        throw new HttpsError("invalid-argument", "Target user UID is required");
    }

    if (callerUid === uid) {
        throw new HttpsError("invalid-argument", "You cannot block yourself");
    }

    // 1. Check Caller Permissions (Must be Owner)
    const callerDoc = await db.collection("users").doc(callerUid).get();
    if (!callerDoc.exists) {
        throw new HttpsError("permission-denied", "Caller profile not found");
    }

    const callerData = callerDoc.data()!;
    const callerRoles = callerData.roles || [];
    const callerRole = callerData.role || "";
    const callerOrgId = callerData.organizationId;

    const isOwner = callerRoles.includes("owner") || callerRole === "owner";
    if (!isOwner) {
        throw new HttpsError("permission-denied", "Only owners can block users");
    }

    // 2. Check Target User (Must be in same Org)
    const targetUserDoc = await db.collection("users").doc(uid).get();
    if (!targetUserDoc.exists) {
        throw new HttpsError("not-found", "Target user not found");
    }

    const targetUserData = targetUserDoc.data()!;
    if (targetUserData.organizationId !== callerOrgId) {
        throw new HttpsError("permission-denied", "User is not in your organization");
    }

    try {
        // 3. Update Custom Claims
        const currentClaims = (await auth.getUser(uid)).customClaims || {};
        await auth.setCustomUserClaims(uid, {
            ...currentClaims,
            isBlocked: isBlocked,
        });

        // 4. Update Firestore User Doc
        await db.collection("users").doc(uid).update({
            isBlocked: isBlocked,
            updatedAt: FieldValue.serverTimestamp(),
            blockedAt: isBlocked ? FieldValue.serverTimestamp() : FieldValue.delete(),
            blockedBy: isBlocked ? callerUid : FieldValue.delete(),
        });

        // 5. If blocking, force token revocation to log them out of sessions immediately
        if (isBlocked) {
            await auth.revokeRefreshTokens(uid);
        }

        logger.info(`User ${uid} block status set to ${isBlocked} by ${callerUid}`);

        return { success: true, message: `User ${isBlocked ? "blocked" : "unblocked"} successfully` };
    } catch (error) {
        logger.error("Error toggling user block status:", error);
        throw new HttpsError("internal", "Failed to update user block status");
    }
});
