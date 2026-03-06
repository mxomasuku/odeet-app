import { initializeApp } from "firebase/app";
import { getAuth, connectAuthEmulator } from "firebase/auth";
import { getFirestore, connectFirestoreEmulator } from "firebase/firestore";
import {
  getFunctions,
  connectFunctionsEmulator,
} from "firebase/functions";

const firebaseConfig = {
  apiKey: import.meta.env.VITE_FIREBASE_API_KEY || "AIzaSyB4tWXf02LzylyuZZdRVFoTQ4w4UxqK6I4",
  authDomain: "odeet-app.firebaseapp.com",
  projectId: "odeet-app",
  storageBucket: "odeet-app.firebasestorage.app",
  messagingSenderId: "1077847279793",
  appId: import.meta.env.VITE_FIREBASE_APP_ID || "1:1077847279793:web:placeholder",
};

const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
const db = getFirestore(app);
const functions = getFunctions(app);

// Connect to emulators in development
if (import.meta.env.VITE_USE_EMULATORS === "true") {
  connectAuthEmulator(auth, "http://127.0.0.1:9099", { disableWarnings: true });
  connectFirestoreEmulator(db, "127.0.0.1", 8080);
  connectFunctionsEmulator(functions, "127.0.0.1", 5001);
}

export { app, auth, db, functions };
