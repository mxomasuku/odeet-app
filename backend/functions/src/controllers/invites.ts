import * as admin from "firebase-admin";
import { FieldValue, Timestamp } from "firebase-admin/firestore";
import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";

// Initialize admin if not already
if (!admin.apps.length) {
    admin.initializeApp();
}

const db = admin.firestore();
const auth = admin.auth();

/**
 * Generate a random 6-character invite code
 */
function generateInviteCode(): string {
    const chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"; // Exclude confusing chars
    let code = "";
    for (let i = 0; i < 6; i++) {
        code += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return code;
}

interface CreateInviteRequest {
    email: string;
    role: string;
    shopIds?: string[];
}

/**
 * Create an invite for a new team member
 */
export const createInvite = onCall(async (request) => {
    if (!request.auth) {
        throw new HttpsError("unauthenticated", "User must be authenticated");
    }

    const callerUid = request.auth.uid;
    const { email, role, shopIds } = request.data as CreateInviteRequest;

    // Validate input
    if (!email || !role) {
        throw new HttpsError("invalid-argument", "Email and role are required");
    }

    const validRoles = ["manager", "shopkeeper", "auditor"];
    if (!validRoles.includes(role)) {
        throw new HttpsError("invalid-argument", `Invalid role: ${role}`);
    }

    // Get caller's user doc
    const callerDoc = await db.collection("users").doc(callerUid).get();
    if (!callerDoc.exists) {
        throw new HttpsError("permission-denied", "User not found");
    }

    const callerData = callerDoc.data()!;
    const callerRoles = callerData.roles || [];
    const callerRole = callerData.role || "";
    const orgId = callerData.organizationId;

    if (!orgId) {
        throw new HttpsError("failed-precondition", "User has no organization");
    }

    // Check permissions
    const isOwner = callerRoles.includes("owner") || callerRole === "owner";
    const isManager = callerRoles.includes("manager") || callerRole === "manager";

    if (!isOwner && !isManager) {
        throw new HttpsError(
            "permission-denied",
            "Only owners and managers can invite users"
        );
    }

    // Managers cannot invite managers
    if (!isOwner && role === "manager") {
        throw new HttpsError(
            "permission-denied",
            "Only owners can invite managers"
        );
    }

    // Generate unique code
    let code = generateInviteCode();
    let attempts = 0;
    while (attempts < 5) {
        const existing = await db
            .collectionGroup("invites")
            .where("code", "==", code)
            .where("status", "==", "pending")
            .limit(1)
            .get();

        if (existing.empty) break;
        code = generateInviteCode();
        attempts++;
    }

    // Create invite document
    const inviteRef = db
        .collection("organizations")
        .doc(orgId)
        .collection("invites")
        .doc();

    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + 7); // 7 days

    const inviteData = {
        organizationId: orgId,
        code: code,
        email: email.toLowerCase().trim(),
        role: role,
        shopIds: shopIds || [],
        createdBy: callerUid,
        createdByName: callerData.name || "Unknown",
        createdAt: FieldValue.serverTimestamp(),
        expiresAt: Timestamp.fromDate(expiresAt),
        status: "pending",
    };

    await inviteRef.set(inviteData);

    logger.info(`Invite created: ${code} for ${email} as ${role}`);

    return {
        success: true,
        code: code,
        link: `stocktake://invite?code=${code}`,
        expiresAt: expiresAt.toISOString(),
    };
});

interface RedeemInviteRequest {
    code: string;
}

/**
 * Redeem an invite code after signup
 */
export const redeemInvite = onCall(async (request) => {
    if (!request.auth) {
        throw new HttpsError("unauthenticated", "User must be authenticated");
    }

    const uid = request.auth.uid;
    const { code } = request.data as RedeemInviteRequest;

    if (!code) {
        throw new HttpsError("invalid-argument", "Invite code is required");
    }

    // Find the invite
    const invitesSnapshot = await db
        .collectionGroup("invites")
        .where("code", "==", code.toUpperCase().trim())
        .where("status", "==", "pending")
        .limit(1)
        .get();

    if (invitesSnapshot.empty) {
        throw new HttpsError("not-found", "Invalid or expired invite code");
    }

    const inviteDoc = invitesSnapshot.docs[0];
    const inviteData = inviteDoc.data();

    // Check expiration
    const expiresAt = inviteData.expiresAt.toDate();
    if (new Date() > expiresAt) {
        await inviteDoc.ref.update({ status: "expired" });
        throw new HttpsError("failed-precondition", "Invite has expired");
    }

    const orgId = inviteData.organizationId;
    const role = inviteData.role;
    const shopIds = inviteData.shopIds || [];

    // Create a batch to handle updates atomically
    const batch = db.batch();

    // 1. Update user document (use set with merge to handle partial documents)
    batch.set(db.collection("users").doc(uid), {
        organizationId: orgId,
        role: role,
        roles: [role],
        shopIds: shopIds,
        updatedAt: FieldValue.serverTimestamp(),
    }, { merge: true });

    // 2. Update shop documents (Add user to assignedUserIds)
    if (shopIds.length > 0) {
        for (const shopId of shopIds) {
            const shopRef = db
                .collection("organizations")
                .doc(orgId)
                .collection("shops")
                .doc(shopId);
            batch.update(shopRef, {
                assignedUserIds: FieldValue.arrayUnion(uid),
                updatedAt: FieldValue.serverTimestamp(),
            });
        }
    }

    // 3. Mark invite as accepted
    batch.update(inviteDoc.ref, {
        status: "accepted",
        acceptedBy: uid,
        acceptedAt: FieldValue.serverTimestamp(),
    });

    // Commit batch
    await batch.commit();

    // Set custom claims (must be separate from batch)
    await auth.setCustomUserClaims(uid, { roles: [role] });

    logger.info(`Invite redeemed: ${code} by user ${uid}`);

    return {
        success: true,
        organizationId: orgId,
        role: role,
        message: "You have joined the organization",
    };
});

/**
 * Get pending invites for an organization
 */
export const getOrgInvites = onCall(async (request) => {
    if (!request.auth) {
        throw new HttpsError("unauthenticated", "User must be authenticated");
    }

    const uid = request.auth.uid;

    // Get user's org
    const userDoc = await db.collection("users").doc(uid).get();
    if (!userDoc.exists) {
        throw new HttpsError("not-found", "User not found");
    }

    const userData = userDoc.data()!;
    const orgId = userData.organizationId;
    const roles = userData.roles || [];
    const role = userData.role || "";

    if (!orgId) {
        throw new HttpsError("failed-precondition", "User has no organization");
    }

    // Check permissions
    const canManage =
        roles.includes("owner") ||
        roles.includes("manager") ||
        role === "owner" ||
        role === "manager";

    if (!canManage) {
        throw new HttpsError("permission-denied", "Not authorized to view invites");
    }

    const invitesSnapshot = await db
        .collection("organizations")
        .doc(orgId)
        .collection("invites")
        .orderBy("createdAt", "desc")
        .limit(50)
        .get();

    const invites = invitesSnapshot.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
        createdAt: doc.data().createdAt?.toDate()?.toISOString(),
        expiresAt: doc.data().expiresAt?.toDate()?.toISOString(),
        acceptedAt: doc.data().acceptedAt?.toDate()?.toISOString(),
    }));

    return { invites };
});
