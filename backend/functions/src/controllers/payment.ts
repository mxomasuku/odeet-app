import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { Request, Response } from 'express';
import { v4 as uuidv4 } from 'uuid';

const db = admin.firestore();

// Paynow configuration (would come from environment config)
// Paynow configuration (would come from environment config)
// Paynow configuration (would come from environment config)
// const config = (functions as any).config();
// const PAYNOW_INTEGRATION_ID = config.paynow?.integration_id || '';
// const PAYNOW_INTEGRATION_KEY = config.paynow?.integration_key || '';
// const PAYNOW_RESULT_URL = config.paynow?.result_url || '';
// const PAYNOW_RETURN_URL = config.paynow?.return_url || '';

interface PaymentRequest {
  organizationId: string;
  amount: number;
  email: string;
  phone: string;
  method: 'ecocash' | 'onemoney' | 'innbucks' | 'visa' | 'mastercard';
  purpose: string;
}

// interface PaynowResponse {
//   status: string;
//   browserurl?: string;
//   pollurl?: string;
//   paynowreference?: string;
//   error?: string;
// }

/**
 * Initiate a payment via Paynow
 */
export const initiatePayment = async (
  data: PaymentRequest,
  context: any
) => {
  // Verify authentication
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const { organizationId, amount, email, phone, method, purpose } = data;

  // Validate input
  if (!amount || amount <= 0) {
    throw new functions.https.HttpsError('invalid-argument', 'Invalid amount');
  }

  try {
    const paymentId = uuidv4();
    const reference = `STK-${Date.now()}-${paymentId.substring(0, 8)}`;

    // Create payment record
    await db.collection('payments').doc(paymentId).set({
      organizationId,
      amount,
      email,
      phone,
      method,
      purpose,
      reference,
      status: 'pending',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      createdBy: context.auth.uid,
    });

    // For mobile money (EcoCash, OneMoney, InnBucks)
    if (['ecocash', 'onemoney', 'innbucks'].includes(method)) {
      // In production, this would call Paynow API
      // For now, return mock response
      const mockPollUrl = `https://www.paynow.co.zw/Interface/CheckPayment/?guid=${paymentId}`;

      await db.collection('payments').doc(paymentId).update({
        pollUrl: mockPollUrl,
        status: 'awaiting_payment',
      });

      return {
        success: true,
        paymentId,
        pollUrl: mockPollUrl,
        message: `Please approve the payment on your ${method} phone`,
      };
    }

    // For card payments (Visa/Mastercard)
    if (['visa', 'mastercard'].includes(method)) {
      const mockRedirectUrl = `https://www.paynow.co.zw/Payment/BrowserPaymentConfirmation/${paymentId}`;

      await db.collection('payments').doc(paymentId).update({
        redirectUrl: mockRedirectUrl,
        status: 'awaiting_payment',
      });

      return {
        success: true,
        paymentId,
        redirectUrl: mockRedirectUrl,
        message: 'Redirecting to payment page',
      };
    }

    throw new functions.https.HttpsError('invalid-argument', 'Invalid payment method');
  } catch (error) {
    console.error('Payment initiation error:', error);
    throw new functions.https.HttpsError('internal', 'Failed to initiate payment');
  }
};

/**
 * Check payment status
 */
export const checkPaymentStatus = async (
  data: { paymentId: string },
  context: any
) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const { paymentId } = data;

  try {
    const paymentDoc = await db.collection('payments').doc(paymentId).get();

    if (!paymentDoc.exists) {
      throw new functions.https.HttpsError('not-found', 'Payment not found');
    }

    const payment = paymentDoc.data()!;

    // In production, would poll Paynow for status
    // For now, return stored status
    return {
      status: payment.status,
      amount: payment.amount,
      reference: payment.reference,
      completedAt: payment.completedAt?.toDate?.() || null,
    };
  } catch (error) {
    console.error('Payment status check error:', error);
    throw new functions.https.HttpsError('internal', 'Failed to check payment status');
  }
};

/**
 * Paynow webhook handler
 */
export const paynowWebhook = async (req: Request, res: Response): Promise<any> => {
  try {
    const { reference, paynowreference, status, amount } = req.body;

    console.log('Paynow webhook received:', { reference, status, amount });

    // Find payment by reference
    const paymentsQuery = await db
      .collection('payments')
      .where('reference', '==', reference)
      .limit(1)
      .get();

    if (paymentsQuery.empty) {
      console.error('Payment not found for reference:', reference);
      return res.status(404).send('Payment not found');
    }

    const paymentDoc = paymentsQuery.docs[0];
    const payment = paymentDoc.data();

    // Update payment status
    const updateData: any = {
      paynowReference: paynowreference,
      paynowStatus: status,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    if (status === 'Paid' || status === 'Delivered') {
      updateData.status = 'completed';
      updateData.completedAt = admin.firestore.FieldValue.serverTimestamp();

      // If this is a subscription payment, update the organization's subscription
      if (payment.purpose === 'subscription') {
        await updateSubscription(payment.organizationId, payment.subscriptionTier);
      }
    } else if (status === 'Failed' || status === 'Cancelled') {
      updateData.status = 'failed';
      updateData.errorMessage = `Payment ${status.toLowerCase()}`;
    }

    await paymentDoc.ref.update(updateData);

    res.status(200).send('OK');
  } catch (error) {
    console.error('Webhook processing error:', error);
    res.status(500).send('Internal Server Error');
  }
};

/**
 * Update organization subscription after successful payment
 */
async function updateSubscription(organizationId: string, tier: string) {
  const now = new Date();
  const expiryDate = new Date(now);
  expiryDate.setMonth(expiryDate.getMonth() + 1); // 1 month subscription

  await db.collection('organizations').doc(organizationId).update({
    subscriptionTier: tier,
    subscriptionExpiresAt: admin.firestore.Timestamp.fromDate(expiryDate),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  // Create subscription record
  await db.collection('subscriptions').add({
    organizationId,
    tier,
    startDate: admin.firestore.FieldValue.serverTimestamp(),
    endDate: admin.firestore.Timestamp.fromDate(expiryDate),
    status: 'active',
    autoRenew: true,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });
}
