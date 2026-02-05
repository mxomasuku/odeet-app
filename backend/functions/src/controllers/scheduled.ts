import * as admin from 'firebase-admin';

const db = admin.firestore();

const TRIAL_DURATION_DAYS = 90;

/**
 * Check for expired trials and send notifications
 */
export const checkTrialExpiration = async (context: any) => {
  console.log('Running trial expiration check...');

  const now = new Date();
  const trialExpiryThreshold = new Date(now);
  trialExpiryThreshold.setDate(trialExpiryThreshold.getDate() - TRIAL_DURATION_DAYS);

  try {
    // Find organizations on trial that have expired
    const expiredTrials = await db
      .collection('organizations')
      .where('subscriptionTier', '==', 'trial')
      .where('trialStartDate', '<=', admin.firestore.Timestamp.fromDate(trialExpiryThreshold))
      .get();

    console.log(`Found ${expiredTrials.size} expired trials`);

    const batch = db.batch();
    const notifications: Promise<void>[] = [];

    for (const orgDoc of expiredTrials.docs) {
      const org = orgDoc.data();

      // Update organization status
      batch.update(orgDoc.ref, {
        subscriptionTier: 'expired',
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      // Send notification to owner
      notifications.push(
        sendTrialExpiredNotification(org.ownerId, org.name)
      );
    }

    await batch.commit();
    await Promise.all(notifications);

    // Also check for trials expiring soon (7 days warning)
    const warningThreshold = new Date(now);
    warningThreshold.setDate(warningThreshold.getDate() - (TRIAL_DURATION_DAYS - 7));
    const almostExpired = new Date(now);
    almostExpired.setDate(almostExpired.getDate() - (TRIAL_DURATION_DAYS - 8));

    const expiringTrials = await db
      .collection('organizations')
      .where('subscriptionTier', '==', 'trial')
      .where('trialStartDate', '<=', admin.firestore.Timestamp.fromDate(warningThreshold))
      .where('trialStartDate', '>', admin.firestore.Timestamp.fromDate(almostExpired))
      .get();

    console.log(`Found ${expiringTrials.size} trials expiring soon`);

    for (const orgDoc of expiringTrials.docs) {
      const org = orgDoc.data();
      const trialStart = org.trialStartDate.toDate();
      const daysRemaining = TRIAL_DURATION_DAYS - Math.floor(
        (now.getTime() - trialStart.getTime()) / (1000 * 60 * 60 * 24)
      );

      await sendTrialExpiringNotification(org.ownerId, org.name, daysRemaining);
    }

    console.log('Trial expiration check completed');
    return null;
  } catch (error) {
    console.error('Trial expiration check failed:', error);
    throw error;
  }
};

/**
 * Send daily sales summary to organization owners/managers
 */
export const sendDailySummary = async (context: any) => {
  console.log('Running daily summary...');

  const now = new Date();
  const todayStart = new Date(now);
  todayStart.setHours(0, 0, 0, 0);

  try {
    // Get all active organizations
    const organizations = await db
      .collection('organizations')
      .where('subscriptionTier', '!=', 'expired')
      .get();

    console.log(`Processing ${organizations.size} organizations`);

    for (const orgDoc of organizations.docs) {
      const org = orgDoc.data();
      const orgId = orgDoc.id;

      // Get today's sales
      const salesQuery = await db
        .collection('organizations')
        .doc(orgId)
        .collection('sales')
        .where('saleDate', '>=', admin.firestore.Timestamp.fromDate(todayStart))
        .get();

      if (salesQuery.empty) continue;

      // Calculate summary
      let totalSales = 0;
      let totalProfit = 0;
      let transactionCount = 0;

      salesQuery.forEach((saleDoc) => {
        const sale = saleDoc.data();
        totalSales += sale.totalAmount || 0;
        totalProfit += sale.items?.reduce(
          (sum: number, item: any) => sum + ((item.unitPrice - item.costPrice) * item.quantity),
          0
        ) || 0;
        transactionCount++;
      });

      // Get low stock alerts
      const lowStockQuery = await db
        .collectionGroup('inventory')
        .where('organizationId', '==', orgId)
        .where('quantity', '<=', 10) // Default threshold
        .get();

      const summary = {
        date: todayStart,
        totalSales,
        totalProfit,
        transactionCount,
        lowStockCount: lowStockQuery.size,
        currency: org.currency || 'USD',
      };

      // Send notification to owner
      await sendDailySummaryNotification(org.ownerId, org.name, summary);
    }

    console.log('Daily summary completed');
    return null;
  } catch (error) {
    console.error('Daily summary failed:', error);
    throw error;
  }
};

/**
 * Send trial expired notification
 */
async function sendTrialExpiredNotification(userId: string, orgName: string) {
  try {
    // Get user's FCM token
    const userDoc = await db.collection('users').doc(userId).get();
    const user = userDoc.data();

    if (!user?.fcmToken) return;

    await admin.messaging().send({
      token: user.fcmToken,
      notification: {
        title: 'Trial Expired',
        body: `Your trial for ${orgName} has expired. Subscribe now to continue using StockTake.`,
      },
      data: {
        type: 'trial_expired',
        organizationId: user.organizationId,
      },
    });
  } catch (error) {
    console.error('Failed to send trial expired notification:', error);
  }
}

/**
 * Send trial expiring soon notification
 */
async function sendTrialExpiringNotification(userId: string, orgName: string, daysRemaining: number) {
  try {
    const userDoc = await db.collection('users').doc(userId).get();
    const user = userDoc.data();

    if (!user?.fcmToken) return;

    await admin.messaging().send({
      token: user.fcmToken,
      notification: {
        title: 'Trial Expiring Soon',
        body: `Your trial for ${orgName} expires in ${daysRemaining} days. Subscribe now to avoid interruption.`,
      },
      data: {
        type: 'trial_expiring',
        daysRemaining: daysRemaining.toString(),
      },
    });
  } catch (error) {
    console.error('Failed to send trial expiring notification:', error);
  }
}

/**
 * Send daily summary notification
 */
async function sendDailySummaryNotification(
  userId: string,
  orgName: string,
  summary: {
    date: Date;
    totalSales: number;
    totalProfit: number;
    transactionCount: number;
    lowStockCount: number;
    currency: string;
  }
) {
  try {
    const userDoc = await db.collection('users').doc(userId).get();
    const user = userDoc.data();

    if (!user?.fcmToken) return;

    const symbol = summary.currency === 'USD' ? '$' : summary.currency;

    await admin.messaging().send({
      token: user.fcmToken,
      notification: {
        title: `Daily Summary - ${orgName}`,
        body: `Sales: ${symbol}${summary.totalSales.toFixed(2)} | Transactions: ${summary.transactionCount} | Low Stock: ${summary.lowStockCount}`,
      },
      data: {
        type: 'daily_summary',
        totalSales: summary.totalSales.toString(),
        transactionCount: summary.transactionCount.toString(),
      },
    });
  } catch (error) {
    console.error('Failed to send daily summary notification:', error);
  }
}
