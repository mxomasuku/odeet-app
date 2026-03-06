import {
  signInWithEmailAndPassword as firebaseSignIn,
  signOut as firebaseSignOut,
  onAuthStateChanged as firebaseOnAuthStateChanged,
  type User,
  type NextOrObserver,
} from "firebase/auth";
import { auth } from "./firebase";

/**
 * Sign in with email and password.
 */
export async function signIn(email: string, password: string) {
  return firebaseSignIn(auth, email, password);
}

/**
 * Sign out the current user.
 */
export async function signOut() {
  return firebaseSignOut(auth);
}

/**
 * Subscribe to auth state changes.
 */
export function onAuthStateChanged(callback: NextOrObserver<User>) {
  return firebaseOnAuthStateChanged(auth, callback);
}

/**
 * Check if the current user has admin custom claims.
 * Returns true if the user's token contains isAdmin: true.
 */
export async function checkIsAdmin(user: User): Promise<boolean> {
  const tokenResult = await user.getIdTokenResult(true);
  return tokenResult.claims.isAdmin === true;
}

/**
 * Get the full set of custom claims for the current user.
 */
export async function getUserClaims(user: User) {
  const tokenResult = await user.getIdTokenResult(true);
  return tokenResult.claims;
}
