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

interface SetUserRolesRequest {
  uid: string;
  roles: string[];
  shopIds?: string[];
}


export const setUserRoles = onCall(async (request) => {
  // Validate caller is authenticated
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "User must be authenticated");
  }

  const callerUid = request.auth.uid;
  const { uid, roles, shopIds } = request.data as SetUserRolesRequest;

  // Validate input
  if (!uid || !roles || !Array.isArray(roles)) {
    throw new HttpsError("invalid-argument", "uid and roles array required");
  }

  const validRoles = ["owner", "manager", "shopkeeper", "auditor"];
  for (const role of roles) {
    if (!validRoles.includes(role)) {
      throw new HttpsError("invalid-argument", `Invalid role: ${role}`);
    }
  }

  // Check caller permissions (must be owner)
  const callerDoc = await db.collection("users").doc(callerUid).get();
  if (!callerDoc.exists) {
    throw new HttpsError("permission-denied", "Caller user not found");
  }

  const callerData = callerDoc.data();
  const callerRoles = callerData?.roles || [];
  const callerRole = callerData?.role || "";

  const isOwner = callerRoles.includes("owner") || callerRole === "owner";
  if (!isOwner) {
    throw new HttpsError("permission-denied", "Only owners can assign roles");
  }

  try {
    // Set custom claims on Firebase Auth user
    await auth.setCustomUserClaims(uid, { roles });

    const batch = db.batch();

    // Fetch target user to get current shop assignments for diffing
    const targetUserRef = db.collection("users").doc(uid);
    const targetUserDoc = await targetUserRef.get();
    const targetUserData = targetUserDoc.data();
    const currentShopIds: string[] = targetUserData?.shopIds || [];

    // Update Firestore user document
    const updateData: any = {
      roles: roles,
      role: roles[0] || "shopkeeper",
      updatedAt: FieldValue.serverTimestamp(),
    };

    // Only update shopIds if provided in request
    if (shopIds && Array.isArray(shopIds)) {
      updateData.shopIds = shopIds;
    }

    batch.update(targetUserRef, updateData);

    // If shopIds provided, sync shop assignments (Add/Remove)
    if (shopIds && Array.isArray(shopIds)) {
      const callerOrgId = callerData?.organizationId;

      if (callerOrgId) {
        // Calculate diff
        const newShopIds = new Set(shopIds);
        const oldShopIds = new Set(currentShopIds);

        const shopsToAdd = shopIds.filter(id => !oldShopIds.has(id));
        const shopsToRemove = currentShopIds.filter(id => !newShopIds.has(id));

        // 1. Add user to new shops
        if (shopsToAdd.length > 0) {
          const addRefs = shopsToAdd.map((id: string) =>
            db.collection("organizations").doc(callerOrgId).collection("shops").doc(id)
          );
          const addDocs = await db.getAll(...addRefs);
          for (const doc of addDocs) {
            if (doc.exists) {
              batch.update(doc.ref, {
                assignedUserIds: FieldValue.arrayUnion(uid),
                updatedAt: FieldValue.serverTimestamp(),
              });
            }
          }
        }

        // 2. Remove user from old shops
        if (shopsToRemove.length > 0) {
          const removeRefs = shopsToRemove.map((id: string) =>
            db.collection("organizations").doc(callerOrgId).collection("shops").doc(id)
          );
          const removeDocs = await db.getAll(...removeRefs);
          for (const doc of removeDocs) {
            if (doc.exists) {
              batch.update(doc.ref, {
                assignedUserIds: FieldValue.arrayRemove(uid),
                updatedAt: FieldValue.serverTimestamp(),
              });
            }
          }
        }
      }
    }

    await batch.commit();

    logger.info(`Roles updated for user ${uid}:`, roles);

    return { success: true, message: `Roles updated: ${roles.join(", ")}` };
  } catch (error) {
    logger.error("Error setting user roles:", error);
    throw new HttpsError("internal", "Failed to set user roles");
  }
});

/**
 * Get current user's roles from custom claims
 */
export const getUserRoles = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "User must be authenticated");
  }

  const uid = request.auth.uid;

  try {
    const userRecord = await auth.getUser(uid);
    const claims = userRecord.customClaims || {};

    return {
      roles: claims.roles || [],
      uid: uid,
    };
  } catch (error) {
    logger.error("Error getting user roles:", error);
    throw new HttpsError("internal", "Failed to get user roles");
  }
});
