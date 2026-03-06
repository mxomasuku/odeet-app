/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import { setGlobalOptions } from "firebase-functions";

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
setGlobalOptions({ maxInstances: 10 });

// Export role management functions
export { setUserRoles, getUserRoles } from "./controllers/roles";

// Export notification triggers
export { onSaleCreated } from "./controllers/notifications";

// Export invite functions
// Export invite functions
export { createInvite, redeemInvite, getOrgInvites } from "./controllers/invites";

// Export user management functions
export { removeUserFromTeam, toggleUserBlockStatus } from "./controllers/users";

// Export admin dashboard functions
export {
    adminListUsers,
    adminGetDashboardStats,
    adminGetUserDetail,
    adminToggleUserBlock,
    adminUpdateTrialDays,
    adminSetAdminClaim,
    onUserCreated,
} from "./controllers/admin";
