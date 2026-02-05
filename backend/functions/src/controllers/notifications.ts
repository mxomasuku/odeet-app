import * as admin from "firebase-admin";
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import * as logger from "firebase-functions/logger";

// Initialize admin if not already
if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

/**
 * Firestore trigger: When a new sale is created, notify managers/owners
 */
export const onSaleCreated = onDocumentCreated(
  "organizations/{orgId}/sales/{saleId}",
  async (event) => {
    const saleData = event.data?.data();
    if (!saleData) {
      logger.warn("No sale data found");
      return;
    }

    const orgId = event.params.orgId;
    const saleId = event.params.saleId;
    const shopkeeperName = saleData.createdByName || "Unknown";
    const totalAmount = saleData.totalAmount || 0;
    const currency = saleData.currency || "USD";

    logger.info(`New sale created: ${saleId} by ${shopkeeperName}`);

    try {
      // Find all managers and owners in this organization
      const usersSnapshot = await db
        .collection("users")
        .where("organizationId", "==", orgId)
        .get();

      const managerTokens: string[] = [];

      for (const userDoc of usersSnapshot.docs) {
        const userData = userDoc.data();
        const roles = userData.roles || [];
        const role = userData.role || "";

        // Check if user is manager or owner
        const isManagerOrOwner =
          roles.includes("manager") ||
          roles.includes("owner") ||
          role === "manager" ||
          role === "owner";

        if (isManagerOrOwner && userData.fcmToken) {
          managerTokens.push(userData.fcmToken);
        }
      }

      if (managerTokens.length === 0) {
        logger.info("No manager FCM tokens found");
        return;
      }

      // Send FCM notification
      const message = {
        notification: {
          title: "New Sale Recorded",
          body: `${shopkeeperName} recorded a sale of ${currency}${totalAmount.toFixed(2)}`,
        },
        data: {
          type: "new_sale",
          saleId: saleId,
          orgId: orgId,
        },
        tokens: managerTokens,
      };

      const response = await admin.messaging().sendEachForMulticast(message);
      logger.info(`Notifications sent: ${response.successCount} success, ${response.failureCount} failed`);
    } catch (error) {
      logger.error("Error sending sale notification:", error);
    }
  }
);
