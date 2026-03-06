import { useEffect, useState, type FormEvent } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { format } from "date-fns";
import {
  ArrowLeft,
  Loader2,
  AlertCircle,
  ShieldBan,
  ShieldCheck,
  Calendar,
  Mail,
  Phone,
  Building2,
  UserCircle,
  Clock,
  CheckCircle2,
  XCircle,
} from "lucide-react";
import {
  getUserDetail,
  toggleUserBlock,
  updateTrialDays,
  type UserDetailData,
} from "@/lib/api";

type ToastType = "success" | "error";

interface Toast {
  message: string;
  type: ToastType;
  id: number;
}

let toastCounter = 0;

function formatDate(dateStr: string | null | undefined): string {
  if (!dateStr) return "--";
  try {
    return format(new Date(dateStr), "MMM d, yyyy 'at' h:mm a");
  } catch {
    return "--";
  }
}

export function UserDetailPage() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();

  const [data, setData] = useState<UserDetailData | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Action states
  const [blockLoading, setBlockLoading] = useState(false);
  const [trialDaysInput, setTrialDaysInput] = useState("");
  const [trialLoading, setTrialLoading] = useState(false);
  const [showBlockConfirm, setShowBlockConfirm] = useState(false);

  // Toast state
  const [toasts, setToasts] = useState<Toast[]>([]);

  const showToast = (message: string, type: ToastType) => {
    const toastId = ++toastCounter;
    setToasts((prev) => [...prev, { message, type, id: toastId }]);
    setTimeout(() => {
      setToasts((prev) => prev.filter((t) => t.id !== toastId));
    }, 4000);
  };

  useEffect(() => {
    if (!id) return;

    let cancelled = false;

    async function fetchUser() {
      try {
        setLoading(true);
        setError(null);
        const result = await getUserDetail(id!);
        if (!cancelled) {
          setData(result);
        }
      } catch (err) {
        if (!cancelled) {
          setError(
            err instanceof Error ? err.message : "Failed to load user details"
          );
        }
      } finally {
        if (!cancelled) {
          setLoading(false);
        }
      }
    }

    fetchUser();
    return () => {
      cancelled = true;
    };
  }, [id]);

  const handleToggleBlock = async () => {
    if (!data || !id) return;

    const newBlockedState = !data.isBlocked;
    setBlockLoading(true);
    setShowBlockConfirm(false);

    try {
      await toggleUserBlock(id, newBlockedState);
      setData((prev) =>
        prev ? { ...prev, isBlocked: newBlockedState } : null
      );
      showToast(
        `User ${newBlockedState ? "blocked" : "unblocked"} successfully.`,
        "success"
      );
    } catch (err) {
      showToast(
        err instanceof Error ? err.message : "Failed to update user status",
        "error"
      );
    } finally {
      setBlockLoading(false);
    }
  };

  const handleUpdateTrialDays = async (e: FormEvent) => {
    e.preventDefault();
    if (!data?.organizationId || !trialDaysInput) return;

    const days = parseInt(trialDaysInput, 10);
    if (isNaN(days) || days < 0) {
      showToast("Please enter a valid number of days.", "error");
      return;
    }

    setTrialLoading(true);

    try {
      await updateTrialDays(data.organizationId, days);
      showToast(`Trial updated to ${days} days.`, "success");
      setTrialDaysInput("");
      // Refresh user data
      const refreshed = await getUserDetail(id!);
      setData(refreshed);
    } catch (err) {
      showToast(
        err instanceof Error ? err.message : "Failed to update trial days",
        "error"
      );
    } finally {
      setTrialLoading(false);
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center py-24">
        <Loader2 className="h-8 w-8 text-blue-600 spinner" />
      </div>
    );
  }

  if (error || !data) {
    return (
      <div>
        <button
          onClick={() => navigate("/users")}
          className="mb-6 inline-flex items-center gap-1 text-sm font-medium text-gray-600 transition-colors hover:text-gray-900"
        >
          <ArrowLeft className="h-4 w-4" />
          Back to Users
        </button>
        <div className="flex items-start gap-2 rounded-lg border border-red-200 bg-red-50 p-4 text-sm text-red-700">
          <AlertCircle className="mt-0.5 h-4 w-4 shrink-0" />
          <div>
            <p className="font-medium">Error loading user</p>
            <p className="mt-1 text-red-600">{error ?? "User not found"}</p>
          </div>
        </div>
      </div>
    );
  }

  const isBlocked = data.isBlocked || data.auth?.disabled;

  return (
    <div>
      {/* Toast notifications */}
      <div className="fixed top-4 right-4 z-50 space-y-2">
        {toasts.map((toast) => (
          <div
            key={toast.id}
            className={`toast-enter flex items-center gap-2 rounded-lg px-4 py-3 text-sm font-medium shadow-lg ${
              toast.type === "success"
                ? "bg-emerald-600 text-white"
                : "bg-red-600 text-white"
            }`}
          >
            {toast.type === "success" ? (
              <CheckCircle2 className="h-4 w-4" />
            ) : (
              <XCircle className="h-4 w-4" />
            )}
            {toast.message}
          </div>
        ))}
      </div>

      {/* Back button */}
      <button
        onClick={() => navigate("/users")}
        className="mb-6 inline-flex items-center gap-1 text-sm font-medium text-gray-600 transition-colors hover:text-gray-900"
      >
        <ArrowLeft className="h-4 w-4" />
        Back to Users
      </button>

      <div className="grid grid-cols-1 gap-6 lg:grid-cols-3">
        {/* User Info Card */}
        <div className="lg:col-span-2 space-y-6">
          <div className="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
            <div className="flex items-start justify-between">
              <div className="flex items-start gap-4">
                <div className="flex h-14 w-14 items-center justify-center rounded-full bg-slate-100">
                  <UserCircle className="h-8 w-8 text-slate-400" />
                </div>
                <div>
                  <h2 className="text-xl font-bold text-gray-900">
                    {data.name || "Unnamed User"}
                  </h2>
                  <div className="mt-1 flex items-center gap-2">
                    {isBlocked ? (
                      <span className="inline-flex items-center gap-1 rounded-full bg-red-50 px-2.5 py-0.5 text-xs font-medium text-red-700 ring-1 ring-red-600/20 ring-inset">
                        <ShieldBan className="h-3 w-3" />
                        Blocked
                      </span>
                    ) : (
                      <span className="inline-flex items-center gap-1 rounded-full bg-emerald-50 px-2.5 py-0.5 text-xs font-medium text-emerald-700 ring-1 ring-emerald-600/20 ring-inset">
                        <ShieldCheck className="h-3 w-3" />
                        Active
                      </span>
                    )}
                    {data.role && (
                      <span className="inline-flex items-center rounded-full bg-blue-50 px-2.5 py-0.5 text-xs font-medium text-blue-700 ring-1 ring-blue-600/20 ring-inset capitalize">
                        {data.role}
                      </span>
                    )}
                  </div>
                </div>
              </div>
            </div>

            <div className="mt-6 grid grid-cols-1 gap-4 sm:grid-cols-2">
              <InfoRow icon={Mail} label="Email" value={data.email} />
              <InfoRow
                icon={Phone}
                label="Phone"
                value={data.phone || "--"}
              />
              <InfoRow
                icon={Building2}
                label="Organization"
                value={data.organization?.name || "--"}
              />
              <InfoRow
                icon={UserCircle}
                label="Roles"
                value={
                  data.roles && data.roles.length > 0
                    ? data.roles.join(", ")
                    : "--"
                }
              />
            </div>
          </div>

          {/* Auth Info */}
          <div className="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
            <h3 className="mb-4 text-sm font-semibold text-gray-500 uppercase tracking-wider">
              Authentication Info
            </h3>
            <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
              <InfoRow
                icon={Calendar}
                label="Created"
                value={formatDate(data.auth?.creationTime)}
              />
              <InfoRow
                icon={Clock}
                label="Last Sign In"
                value={formatDate(data.auth?.lastSignInTime)}
              />
              <InfoRow
                icon={ShieldCheck}
                label="Email Verified"
                value={data.auth?.emailVerified ? "Yes" : "No"}
              />
              <InfoRow
                icon={UserCircle}
                label="UID"
                value={data.uid}
              />
            </div>

            {data.auth?.customClaims &&
              Object.keys(data.auth.customClaims).length > 0 && (
                <div className="mt-4">
                  <p className="mb-2 text-xs font-medium text-gray-500">
                    Custom Claims
                  </p>
                  <pre className="rounded-lg bg-gray-50 p-3 text-xs text-gray-700 overflow-x-auto">
                    {JSON.stringify(data.auth.customClaims, null, 2)}
                  </pre>
                </div>
              )}
          </div>
        </div>

        {/* Actions Sidebar */}
        <div className="space-y-6">
          {/* Organization / Trial Info */}
          {data.organization && (
            <div className="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
              <h3 className="mb-4 text-sm font-semibold text-gray-500 uppercase tracking-wider">
                Organization
              </h3>
              <div className="space-y-3 text-sm">
                <div>
                  <p className="text-gray-500">Name</p>
                  <p className="font-medium text-gray-900">
                    {data.organization.name}
                  </p>
                </div>
                <div>
                  <p className="text-gray-500">Subscription</p>
                  <p className="font-medium capitalize text-gray-900">
                    {data.organization.subscriptionTier || "Trial"}
                  </p>
                </div>
                <div>
                  <p className="text-gray-500">Created</p>
                  <p className="font-medium text-gray-900">
                    {formatDate(data.organization.createdAt)}
                  </p>
                </div>
              </div>
            </div>
          )}

          {/* Block / Unblock */}
          <div className="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
            <h3 className="mb-4 text-sm font-semibold text-gray-500 uppercase tracking-wider">
              Actions
            </h3>

            {!showBlockConfirm ? (
              <button
                onClick={() => setShowBlockConfirm(true)}
                disabled={blockLoading}
                className={`flex w-full items-center justify-center gap-2 rounded-lg px-4 py-2.5 text-sm font-medium shadow-sm transition-colors ${
                  isBlocked
                    ? "border border-emerald-300 bg-emerald-50 text-emerald-700 hover:bg-emerald-100"
                    : "border border-red-300 bg-red-50 text-red-700 hover:bg-red-100"
                }`}
              >
                {isBlocked ? (
                  <>
                    <ShieldCheck className="h-4 w-4" />
                    Unblock User
                  </>
                ) : (
                  <>
                    <ShieldBan className="h-4 w-4" />
                    Block User
                  </>
                )}
              </button>
            ) : (
              <div className="rounded-lg border border-amber-200 bg-amber-50 p-4">
                <p className="mb-3 text-sm text-amber-800">
                  {isBlocked
                    ? "Are you sure you want to unblock this user? They will regain access to the platform."
                    : "Are you sure you want to block this user? They will be signed out and unable to access the platform."}
                </p>
                <div className="flex gap-2">
                  <button
                    onClick={handleToggleBlock}
                    disabled={blockLoading}
                    className={`flex-1 rounded-lg px-3 py-2 text-sm font-medium text-white shadow-sm ${
                      isBlocked
                        ? "bg-emerald-600 hover:bg-emerald-700"
                        : "bg-red-600 hover:bg-red-700"
                    }`}
                  >
                    {blockLoading ? (
                      <Loader2 className="mx-auto h-4 w-4 spinner" />
                    ) : isBlocked ? (
                      "Confirm Unblock"
                    ) : (
                      "Confirm Block"
                    )}
                  </button>
                  <button
                    onClick={() => setShowBlockConfirm(false)}
                    className="flex-1 rounded-lg border border-gray-300 bg-white px-3 py-2 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50"
                  >
                    Cancel
                  </button>
                </div>
              </div>
            )}
          </div>

          {/* Add Trial Days */}
          {data.organizationId && (
            <div className="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
              <h3 className="mb-4 text-sm font-semibold text-gray-500 uppercase tracking-wider">
                Trial Management
              </h3>
              <form onSubmit={handleUpdateTrialDays} className="space-y-3">
                <div>
                  <label
                    htmlFor="trialDays"
                    className="mb-1.5 block text-sm font-medium text-gray-700"
                  >
                    Set Trial Days Remaining
                  </label>
                  <input
                    id="trialDays"
                    type="number"
                    min="0"
                    value={trialDaysInput}
                    onChange={(e) => setTrialDaysInput(e.target.value)}
                    placeholder="e.g. 14"
                    className="w-full rounded-lg border border-gray-300 px-3.5 py-2.5 text-sm text-gray-900 shadow-sm transition-colors placeholder:text-gray-400 focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20 focus:outline-none"
                  />
                </div>
                <button
                  type="submit"
                  disabled={trialLoading || !trialDaysInput}
                  className="flex w-full items-center justify-center gap-2 rounded-lg bg-blue-600 px-4 py-2.5 text-sm font-medium text-white shadow-sm transition-colors hover:bg-blue-700 disabled:cursor-not-allowed disabled:opacity-60"
                >
                  {trialLoading ? (
                    <>
                      <Loader2 className="h-4 w-4 spinner" />
                      Updating...
                    </>
                  ) : (
                    "Update Trial"
                  )}
                </button>
              </form>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

// ---- Helper Component ----

function InfoRow({
  icon: Icon,
  label,
  value,
}: {
  icon: typeof Mail;
  label: string;
  value: string;
}) {
  return (
    <div className="flex items-start gap-3">
      <Icon className="mt-0.5 h-4 w-4 shrink-0 text-gray-400" />
      <div className="min-w-0">
        <p className="text-xs text-gray-500">{label}</p>
        <p className="truncate text-sm font-medium text-gray-900">{value}</p>
      </div>
    </div>
  );
}
