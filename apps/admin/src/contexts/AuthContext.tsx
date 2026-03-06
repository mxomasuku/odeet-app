import {
  createContext,
  useContext,
  useEffect,
  useState,
  useCallback,
  type ReactNode,
} from "react";
import type { User } from "firebase/auth";
import { onAuthStateChanged, signIn, signOut, checkIsAdmin } from "@/lib/auth";

interface AuthContextType {
  user: User | null;
  isAdmin: boolean;
  loading: boolean;
  login: (email: string, password: string) => Promise<void>;
  logout: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType | null>(null);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [isAdmin, setIsAdmin] = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(async (firebaseUser) => {
      if (firebaseUser) {
        setUser(firebaseUser);
        try {
          const adminStatus = await checkIsAdmin(firebaseUser);
          setIsAdmin(adminStatus);
        } catch {
          setIsAdmin(false);
        }
      } else {
        setUser(null);
        setIsAdmin(false);
      }
      setLoading(false);
    });

    return unsubscribe;
  }, []);

  const login = useCallback(async (email: string, password: string) => {
    const credential = await signIn(email, password);
    const adminStatus = await checkIsAdmin(credential.user);
    if (!adminStatus) {
      await signOut();
      throw new Error("Access denied. You do not have admin privileges.");
    }
    setIsAdmin(true);
  }, []);

  const logout = useCallback(async () => {
    await signOut();
    setUser(null);
    setIsAdmin(false);
  }, []);

  return (
    <AuthContext.Provider value={{ user, isAdmin, loading, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth(): AuthContextType {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error("useAuth must be used within an AuthProvider");
  }
  return context;
}
