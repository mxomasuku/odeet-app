import { type ReactNode } from "react";
import { NavLink, useLocation } from "react-router-dom";
import { LayoutDashboard, Users, LogOut, Shield } from "lucide-react";
import { useAuth } from "@/contexts/AuthContext";

const navItems = [
  { to: "/", label: "Dashboard", icon: LayoutDashboard },
  { to: "/users", label: "Users", icon: Users },
];

export function Layout({ children }: { children: ReactNode }) {
  const { user, logout } = useAuth();
  const location = useLocation();

  const getPageTitle = () => {
    if (location.pathname === "/") return "Dashboard";
    if (location.pathname === "/users") return "Users";
    if (location.pathname.startsWith("/users/")) return "User Detail";
    return "Admin";
  };

  return (
    <div className="flex h-screen overflow-hidden">
      {/* Sidebar */}
      <aside className="flex w-64 flex-col bg-slate-900 text-white">
        {/* Branding */}
        <div className="flex items-center gap-3 border-b border-slate-700/50 px-6 py-5">
          <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-blue-600">
            <Shield className="h-5 w-5 text-white" />
          </div>
          <div>
            <h1 className="text-lg font-bold tracking-tight">Odeet</h1>
            <p className="text-xs text-slate-400">Admin Panel</p>
          </div>
        </div>

        {/* Navigation */}
        <nav className="flex-1 space-y-1 px-3 py-4">
          {navItems.map((item) => (
            <NavLink
              key={item.to}
              to={item.to}
              end={item.to === "/"}
              className={({ isActive }) =>
                `flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium transition-colors ${
                  isActive
                    ? "bg-blue-600/20 text-blue-400"
                    : "text-slate-300 hover:bg-slate-800 hover:text-white"
                }`
              }
            >
              <item.icon className="h-5 w-5" />
              {item.label}
            </NavLink>
          ))}
        </nav>

        {/* User info at bottom */}
        <div className="border-t border-slate-700/50 px-4 py-4">
          <div className="flex items-center justify-between">
            <div className="min-w-0 flex-1">
              <p className="truncate text-sm font-medium text-slate-200">
                {user?.email ?? "Admin"}
              </p>
              <p className="text-xs text-slate-500">Administrator</p>
            </div>
            <button
              onClick={logout}
              className="ml-2 rounded-lg p-2 text-slate-400 transition-colors hover:bg-slate-800 hover:text-red-400"
              title="Sign out"
            >
              <LogOut className="h-4 w-4" />
            </button>
          </div>
        </div>
      </aside>

      {/* Main content */}
      <main className="flex flex-1 flex-col overflow-hidden">
        {/* Header */}
        <header className="flex h-16 shrink-0 items-center border-b border-gray-200 bg-white px-8">
          <h2 className="text-lg font-semibold text-gray-900">{getPageTitle()}</h2>
        </header>

        {/* Content area */}
        <div className="flex-1 overflow-y-auto p-8">{children}</div>
      </main>
    </div>
  );
}
