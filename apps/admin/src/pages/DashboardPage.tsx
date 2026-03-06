import { useEffect, useState } from "react";
import {
  Users,
  Building2,
  UserPlus,
  Activity,
  ShieldBan,
  AlertCircle,
} from "lucide-react";
import { StatCard } from "@/components/StatCard";
import { getDashboardStats, type DashboardStats } from "@/lib/api";

export function DashboardPage() {
  const [stats, setStats] = useState<DashboardStats | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let cancelled = false;

    async function fetchStats() {
      try {
        setLoading(true);
        setError(null);
        const data = await getDashboardStats();
        if (!cancelled) {
          setStats(data);
        }
      } catch (err) {
        if (!cancelled) {
          setError(
            err instanceof Error ? err.message : "Failed to load dashboard stats"
          );
        }
      } finally {
        if (!cancelled) {
          setLoading(false);
        }
      }
    }

    fetchStats();
    return () => {
      cancelled = true;
    };
  }, []);

  return (
    <div>
      <div className="mb-8">
        <h1 className="text-2xl font-bold text-gray-900">Overview</h1>
        <p className="mt-1 text-sm text-gray-500">
          Key metrics for the Odeet platform.
        </p>
      </div>

      {error && (
        <div className="mb-6 flex items-start gap-2 rounded-lg border border-red-200 bg-red-50 p-4 text-sm text-red-700">
          <AlertCircle className="mt-0.5 h-4 w-4 shrink-0" />
          <div>
            <p className="font-medium">Failed to load statistics</p>
            <p className="mt-1 text-red-600">{error}</p>
          </div>
        </div>
      )}

      <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-5">
        <StatCard
          label="Total Users"
          value={stats?.totalUsers ?? 0}
          icon={Users}
          color="blue"
          loading={loading}
        />
        <StatCard
          label="Organizations"
          value={stats?.totalOrganizations ?? 0}
          icon={Building2}
          color="purple"
          loading={loading}
        />
        <StatCard
          label="New Signups (7d)"
          value={stats?.newSignups7Days ?? 0}
          icon={UserPlus}
          color="green"
          loading={loading}
        />
        <StatCard
          label="Active Users (7d)"
          value={stats?.activeUsersLast7Days ?? 0}
          icon={Activity}
          color="orange"
          loading={loading}
        />
        <StatCard
          label="Blocked Users"
          value={stats?.blockedUsers ?? 0}
          icon={ShieldBan}
          color="red"
          loading={loading}
        />
      </div>

      {/* Placeholder for future charts / activity feed */}
      <div className="mt-10">
        <div className="rounded-xl border border-gray-200 bg-white p-8 shadow-sm">
          <h3 className="text-sm font-semibold text-gray-500 uppercase tracking-wider">
            Recent Activity
          </h3>
          <p className="mt-4 text-sm text-gray-400">
            Activity feed and charts coming soon.
          </p>
        </div>
      </div>
    </div>
  );
}
