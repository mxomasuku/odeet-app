import { useNavigate } from "react-router-dom";
import { format } from "date-fns";
import { ChevronRight } from "lucide-react";
import type { UserListItem } from "@/lib/api";

interface UserTableProps {
  users: UserListItem[];
  loading?: boolean;
}

function SkeletonRows() {
  return (
    <>
      {Array.from({ length: 8 }).map((_, i) => (
        <tr key={i} className="border-b border-gray-100">
          <td className="px-6 py-4">
            <div className="skeleton h-4 w-32" />
          </td>
          <td className="px-6 py-4">
            <div className="skeleton h-4 w-44" />
          </td>
          <td className="px-6 py-4">
            <div className="skeleton h-4 w-28" />
          </td>
          <td className="px-6 py-4">
            <div className="skeleton h-4 w-20" />
          </td>
          <td className="px-6 py-4">
            <div className="skeleton h-5 w-16 rounded-full" />
          </td>
          <td className="px-6 py-4">
            <div className="skeleton h-4 w-24" />
          </td>
          <td className="px-6 py-4">
            <div className="skeleton h-4 w-24" />
          </td>
          <td className="px-6 py-4">
            <div className="skeleton h-4 w-4" />
          </td>
        </tr>
      ))}
    </>
  );
}

function formatDate(dateStr: string | null | undefined): string {
  if (!dateStr) return "--";
  try {
    return format(new Date(dateStr), "MMM d, yyyy");
  } catch {
    return "--";
  }
}

export function UserTable({ users, loading = false }: UserTableProps) {
  const navigate = useNavigate();

  return (
    <div className="overflow-hidden rounded-xl border border-gray-200 bg-white shadow-sm">
      <div className="overflow-x-auto">
        <table className="w-full text-left text-sm">
          <thead>
            <tr className="border-b border-gray-200 bg-gray-50">
              <th className="px-6 py-3 font-semibold text-gray-600">Name</th>
              <th className="px-6 py-3 font-semibold text-gray-600">Email</th>
              <th className="px-6 py-3 font-semibold text-gray-600">Role</th>
              <th className="px-6 py-3 font-semibold text-gray-600">Status</th>
              <th className="px-6 py-3 font-semibold text-gray-600">Created</th>
              <th className="px-6 py-3 font-semibold text-gray-600">Last Login</th>
              <th className="px-6 py-3 font-semibold text-gray-600" />
            </tr>
          </thead>
          <tbody>
            {loading ? (
              <SkeletonRows />
            ) : users.length === 0 ? (
              <tr>
                <td
                  colSpan={7}
                  className="px-6 py-12 text-center text-gray-500"
                >
                  No users found.
                </td>
              </tr>
            ) : (
              users.map((user) => (
                <tr
                  key={user.uid}
                  onClick={() => navigate(`/users/${user.uid}`)}
                  className="cursor-pointer border-b border-gray-100 transition-colors hover:bg-gray-50"
                >
                  <td className="px-6 py-4 font-medium text-gray-900">
                    {user.name || "--"}
                  </td>
                  <td className="px-6 py-4 text-gray-600">{user.email}</td>
                  <td className="px-6 py-4">
                    <span className="capitalize text-gray-600">
                      {user.role || user.roles?.[0] || "--"}
                    </span>
                  </td>
                  <td className="px-6 py-4">
                    {user.isBlocked ? (
                      <span className="inline-flex items-center rounded-full bg-red-50 px-2.5 py-0.5 text-xs font-medium text-red-700 ring-1 ring-red-600/20 ring-inset">
                        Blocked
                      </span>
                    ) : (
                      <span className="inline-flex items-center rounded-full bg-emerald-50 px-2.5 py-0.5 text-xs font-medium text-emerald-700 ring-1 ring-emerald-600/20 ring-inset">
                        Active
                      </span>
                    )}
                  </td>
                  <td className="px-6 py-4 text-gray-500">
                    {formatDate(user.createdAt || user.creationTime)}
                  </td>
                  <td className="px-6 py-4 text-gray-500">
                    {formatDate(user.lastSignInTime)}
                  </td>
                  <td className="px-6 py-4 text-gray-400">
                    <ChevronRight className="h-4 w-4" />
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}
