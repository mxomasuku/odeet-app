import { useEffect, useState, useCallback } from "react";
import { Search, AlertCircle, ChevronLeft, ChevronRight } from "lucide-react";
import { UserTable } from "@/components/UserTable";
import { listUsers, type UserListItem } from "@/lib/api";

const PAGE_SIZE = 20;

export function UsersPage() {
  const [users, setUsers] = useState<UserListItem[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [searchQuery, setSearchQuery] = useState("");
  const [debouncedSearch, setDebouncedSearch] = useState("");
  const [offset, setOffset] = useState(0);

  // Debounce search input
  useEffect(() => {
    const timer = setTimeout(() => {
      setDebouncedSearch(searchQuery);
      setOffset(0);
    }, 400);
    return () => clearTimeout(timer);
  }, [searchQuery]);

  const fetchUsers = useCallback(async () => {
    try {
      setLoading(true);
      setError(null);
      const result = await listUsers({
        limit: PAGE_SIZE,
        offset,
        search: debouncedSearch || undefined,
      });
      setUsers(result.users);
      setTotal(result.total);
    } catch (err) {
      setError(
        err instanceof Error ? err.message : "Failed to load users"
      );
    } finally {
      setLoading(false);
    }
  }, [offset, debouncedSearch]);

  useEffect(() => {
    fetchUsers();
  }, [fetchUsers]);

  const currentPage = Math.floor(offset / PAGE_SIZE);
  const totalPages = Math.ceil(total / PAGE_SIZE);
  const hasNextPage = offset + PAGE_SIZE < total;
  const hasPrevPage = offset > 0;

  return (
    <div>
      <div className="mb-6 flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Users</h1>
          <p className="mt-1 text-sm text-gray-500">
            Manage platform users and their access.
          </p>
        </div>

        {/* Search */}
        <div className="relative w-full sm:w-80">
          <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-gray-400" />
          <input
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            placeholder="Search by email or name..."
            className="w-full rounded-lg border border-gray-300 py-2.5 pl-10 pr-4 text-sm text-gray-900 shadow-sm transition-colors placeholder:text-gray-400 focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20 focus:outline-none"
          />
        </div>
      </div>

      {error && (
        <div className="mb-6 flex items-start gap-2 rounded-lg border border-red-200 bg-red-50 p-4 text-sm text-red-700">
          <AlertCircle className="mt-0.5 h-4 w-4 shrink-0" />
          <div>
            <p className="font-medium">Error loading users</p>
            <p className="mt-1 text-red-600">{error}</p>
          </div>
        </div>
      )}

      <UserTable users={users} loading={loading} />

      {/* Pagination */}
      {!loading && users.length > 0 && (
        <div className="mt-4 flex items-center justify-between">
          <p className="text-sm text-gray-500">
            Page {currentPage + 1} of {totalPages}
            {` \u00b7 ${total} total user${total === 1 ? "" : "s"}`}
          </p>
          <div className="flex items-center gap-2">
            <button
              onClick={() => setOffset((o) => Math.max(0, o - PAGE_SIZE))}
              disabled={!hasPrevPage}
              className="inline-flex items-center gap-1 rounded-lg border border-gray-300 bg-white px-3 py-2 text-sm font-medium text-gray-700 shadow-sm transition-colors hover:bg-gray-50 disabled:cursor-not-allowed disabled:opacity-40"
            >
              <ChevronLeft className="h-4 w-4" />
              Previous
            </button>
            <button
              onClick={() => setOffset((o) => o + PAGE_SIZE)}
              disabled={!hasNextPage}
              className="inline-flex items-center gap-1 rounded-lg border border-gray-300 bg-white px-3 py-2 text-sm font-medium text-gray-700 shadow-sm transition-colors hover:bg-gray-50 disabled:cursor-not-allowed disabled:opacity-40"
            >
              Next
              <ChevronRight className="h-4 w-4" />
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
