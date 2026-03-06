import { useState, type FormEvent } from "react";
import { useNavigate } from "react-router-dom";
import { Shield, Loader2, AlertCircle } from "lucide-react";
import { useAuth } from "@/contexts/AuthContext";

export function LoginPage() {
  const { login } = useAuth();
  const navigate = useNavigate();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    setError(null);
    setLoading(true);

    try {
      await login(email, password);
      navigate("/", { replace: true });
    } catch (err) {
      if (err instanceof Error) {
        if (err.message.includes("Access denied")) {
          setError("Access denied. You do not have admin privileges.");
        } else if (err.message.includes("auth/invalid-credential") || err.message.includes("auth/wrong-password")) {
          setError("Invalid email or password.");
        } else if (err.message.includes("auth/user-not-found")) {
          setError("No account found with this email.");
        } else if (err.message.includes("auth/too-many-requests")) {
          setError("Too many failed attempts. Please try again later.");
        } else {
          setError(err.message);
        }
      } else {
        setError("An unexpected error occurred. Please try again.");
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="flex min-h-screen items-center justify-center bg-slate-50 px-4">
      <div className="w-full max-w-sm">
        {/* Branding */}
        <div className="mb-8 text-center">
          <div className="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-2xl bg-slate-900 shadow-lg">
            <Shield className="h-7 w-7 text-blue-400" />
          </div>
          <h1 className="text-2xl font-bold text-slate-900">Odeet Admin</h1>
          <p className="mt-1 text-sm text-slate-500">
            Sign in to access the admin dashboard
          </p>
        </div>

        {/* Login Form */}
        <form
          onSubmit={handleSubmit}
          className="rounded-xl border border-gray-200 bg-white p-6 shadow-sm"
        >
          {error && (
            <div className="mb-4 flex items-start gap-2 rounded-lg bg-red-50 p-3 text-sm text-red-700">
              <AlertCircle className="mt-0.5 h-4 w-4 shrink-0" />
              <span>{error}</span>
            </div>
          )}

          <div className="space-y-4">
            <div>
              <label
                htmlFor="email"
                className="mb-1.5 block text-sm font-medium text-gray-700"
              >
                Email
              </label>
              <input
                id="email"
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
                autoComplete="email"
                autoFocus
                placeholder="admin@odeet.com"
                className="w-full rounded-lg border border-gray-300 px-3.5 py-2.5 text-sm text-gray-900 shadow-sm transition-colors placeholder:text-gray-400 focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20 focus:outline-none"
              />
            </div>

            <div>
              <label
                htmlFor="password"
                className="mb-1.5 block text-sm font-medium text-gray-700"
              >
                Password
              </label>
              <input
                id="password"
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
                autoComplete="current-password"
                placeholder="Enter your password"
                className="w-full rounded-lg border border-gray-300 px-3.5 py-2.5 text-sm text-gray-900 shadow-sm transition-colors placeholder:text-gray-400 focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20 focus:outline-none"
              />
            </div>
          </div>

          <button
            type="submit"
            disabled={loading}
            className="mt-6 flex w-full items-center justify-center gap-2 rounded-lg bg-slate-900 px-4 py-2.5 text-sm font-medium text-white shadow-sm transition-colors hover:bg-slate-800 focus:ring-2 focus:ring-slate-900/20 focus:ring-offset-2 focus:outline-none disabled:cursor-not-allowed disabled:opacity-60"
          >
            {loading ? (
              <>
                <Loader2 className="h-4 w-4 spinner" />
                Signing in...
              </>
            ) : (
              "Sign in"
            )}
          </button>
        </form>

        <p className="mt-6 text-center text-xs text-slate-400">
          Only authorized administrators can access this panel.
        </p>
      </div>
    </div>
  );
}
