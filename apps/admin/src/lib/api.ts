import { httpsCallable } from "firebase/functions";
import { functions } from "./firebase";

// ---- Types ----

export interface DashboardStats {
  totalUsers: number;
  totalOrganizations: number;
  newSignups7Days: number;
  newSignups30Days: number;
  activeUsersLast7Days: number;
  blockedUsers: number;
}

export interface UserListItem {
  uid: string;
  email: string;
  name: string;
  phone?: string | null;
  organizationId?: string;
  roles?: string[];
  role?: string;
  isBlocked?: boolean;
  isActive?: boolean;
  shopIds?: string[];
  createdAt: string | null;
  updatedAt?: string | null;
  // Auth metadata
  lastSignInTime: string | null;
  creationTime: string | null;
}

export interface ListUsersParams {
  limit?: number;
  offset?: number;
  search?: string;
}

export interface ListUsersResponse {
  users: UserListItem[];
  total: number;
  limit: number;
  offset: number;
}

export interface UserDetailData {
  uid: string;
  email: string;
  name: string;
  phone?: string | null;
  organizationId?: string;
  roles?: string[];
  role?: string;
  isBlocked?: boolean;
  isActive?: boolean;
  shopIds?: string[];
  createdAt: string | null;
  updatedAt?: string | null;
  blockedAt?: string | null;
  removedAt?: string | null;
  // Auth sub-object
  auth: {
    creationTime: string | null;
    lastSignInTime: string | null;
    customClaims: Record<string, unknown>;
    disabled: boolean;
    email: string | null;
    emailVerified: boolean;
    displayName: string | null;
    photoURL: string | null;
  };
  // Organization sub-object
  organization: {
    id: string;
    name: string;
    subscriptionTier?: string;
    trialStartDate?: string | null;
    createdAt: string | null;
    ownerId?: string;
    currency?: string;
  } | null;
}

// ---- API Functions ----

export async function getDashboardStats(): Promise<DashboardStats> {
  const fn = httpsCallable<void, DashboardStats>(functions, "adminGetDashboardStats");
  const result = await fn();
  return result.data;
}

export async function listUsers(params: ListUsersParams = {}): Promise<ListUsersResponse> {
  const fn = httpsCallable<ListUsersParams, ListUsersResponse>(functions, "adminListUsers");
  const result = await fn(params);
  return result.data;
}

export async function getUserDetail(uid: string): Promise<UserDetailData> {
  const fn = httpsCallable<{ uid: string }, UserDetailData>(functions, "adminGetUserDetail");
  const result = await fn({ uid });
  return result.data;
}

export async function toggleUserBlock(
  uid: string,
  isBlocked: boolean
): Promise<{ success: boolean; message: string }> {
  const fn = httpsCallable<
    { uid: string; isBlocked: boolean },
    { success: boolean; message: string }
  >(functions, "adminToggleUserBlock");
  const result = await fn({ uid, isBlocked });
  return result.data;
}

export async function updateTrialDays(
  organizationId: string,
  trialDays: number
): Promise<{ success: boolean; message: string }> {
  const fn = httpsCallable<
    { organizationId: string; trialDays: number },
    { success: boolean; message: string }
  >(functions, "adminUpdateTrialDays");
  const result = await fn({ organizationId, trialDays });
  return result.data;
}

export async function setAdminClaim(
  uid: string,
  isAdmin: boolean
): Promise<{ success: boolean; message: string }> {
  const fn = httpsCallable<
    { uid: string; isAdmin: boolean },
    { success: boolean; message: string }
  >(functions, "adminSetAdminClaim");
  const result = await fn({ uid, isAdmin });
  return result.data;
}
