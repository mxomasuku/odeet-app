import { createBrowserRouter, Navigate, Outlet } from "react-router-dom";
import { useAuth } from "@/contexts/AuthContext";
import { Layout } from "@/components/Layout";
import { LoginPage } from "@/pages/LoginPage";
import { DashboardPage } from "@/pages/DashboardPage";
import { UsersPage } from "@/pages/UsersPage";
import { UserDetailPage } from "@/pages/UserDetailPage";
import { Loader2 } from "lucide-react";

function ProtectedRoute() {
  const { user, isAdmin, loading } = useAuth();

  if (loading) {
    return (
      <div className="flex h-screen w-screen items-center justify-center bg-gray-50">
        <Loader2 className="h-8 w-8 text-blue-600 spinner" />
      </div>
    );
  }

  if (!user || !isAdmin) {
    return <Navigate to="/login" replace />;
  }

  return (
    <Layout>
      <Outlet />
    </Layout>
  );
}

function PublicRoute() {
  const { user, isAdmin, loading } = useAuth();

  if (loading) {
    return (
      <div className="flex h-screen w-screen items-center justify-center bg-gray-50">
        <Loader2 className="h-8 w-8 text-blue-600 spinner" />
      </div>
    );
  }

  if (user && isAdmin) {
    return <Navigate to="/" replace />;
  }

  return <Outlet />;
}

export const router = createBrowserRouter([
  {
    element: <PublicRoute />,
    children: [
      {
        path: "/login",
        element: <LoginPage />,
      },
    ],
  },
  {
    element: <ProtectedRoute />,
    children: [
      {
        path: "/",
        element: <DashboardPage />,
      },
      {
        path: "/users",
        element: <UsersPage />,
      },
      {
        path: "/users/:id",
        element: <UserDetailPage />,
      },
    ],
  },
]);
