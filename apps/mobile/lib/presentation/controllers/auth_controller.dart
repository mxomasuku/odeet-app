import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'dart:convert';

import '../../data/models/user_model.dart';
import '../../core/errors/exceptions.dart';
import '../../core/services/local_storage_service.dart';
import '../../core/utils/stream_extensions.dart';

// ---------------------------------------------------------------------------
// Local session persistence helpers
// ---------------------------------------------------------------------------

/// Save auth session locally so that the user stays logged in across restarts.
/// This is the key to offline-first auth: we don't rely solely on Firebase Auth.
Future<void> _saveLocalSession(String uid, String email) async {
  try {
    final box = Hive.box('user');
    await box.put('auth_session', jsonEncode({'uid': uid, 'email': email}));
    debugPrint('Local auth session saved for $email');
  } catch (e) {
    debugPrint('Error saving local auth session: $e');
  }
}

/// Read the persisted local session. Returns {uid, email} or null.
Map<String, String>? _readLocalSession() {
  try {
    final box = Hive.box('user');
    final raw = box.get('auth_session');
    if (raw == null) return null;
    final data = jsonDecode(raw) as Map<String, dynamic>;
    return {
      'uid': data['uid'] as String,
      'email': data['email'] as String,
    };
  } catch (e) {
    debugPrint('Error reading local auth session: $e');
    return null;
  }
}

/// Clear the local session — called ONLY on explicit sign-out.
Future<void> _clearLocalSession() async {
  try {
    final box = Hive.box('user');
    await box.delete('auth_session');
    debugPrint('Local auth session cleared');
  } catch (e) {
    debugPrint('Error clearing local auth session: $e');
  }
}

// ---------------------------------------------------------------------------
// Provider that exposes whether we have a local session
// ---------------------------------------------------------------------------

/// Returns true if a local auth session exists in Hive.
/// This is synchronous and available immediately — no waiting for Firebase.
final hasLocalSessionProvider = Provider<bool>((ref) {
  return _readLocalSession() != null;
});

/// Returns the locally-persisted UID (or null).
final localSessionUidProvider = Provider<String?>((ref) {
  return _readLocalSession()?['uid'];
});

// ---------------------------------------------------------------------------
// Firebase Auth state stream (for when Firebase is available)
// ---------------------------------------------------------------------------

/// Auth state provider - watches Firebase auth state.
final authStateProvider = StreamProvider<User?>((ref) {
  final controller = StreamController<User?>();
  final auth = FirebaseAuth.instance;
  late final StreamSubscription<User?> sub;
  bool firstEmitted = false;

  sub = auth.authStateChanges().listen(
    (user) {
      if (!firstEmitted) {
        firstEmitted = true;
        debugPrint('Firebase Auth initialized. User: ${user?.email ?? 'null'}');
      }
      // When Firebase Auth confirms a user, save the session locally.
      if (user != null) {
        _saveLocalSession(user.uid, user.email ?? '');
      }
      controller.add(user);
    },
    onError: (error) => controller.addError(error),
    onDone: () => controller.close(),
  );

  controller.onCancel = () => sub.cancel();
  return controller.stream;
});

// ---------------------------------------------------------------------------
// Current user provider — offline-first with cache
// ---------------------------------------------------------------------------

/// Current user provider - fetches user data from Firestore with local caching.
/// Handles three states:
///   1. Firebase Auth still loading → serve cached user as a bridge
///   2. Firebase Auth has a user → use Firestore with caching
///   3. Firebase Auth definitively returned null → session expired → clear & logout
final currentUserProvider = StreamProvider<UserModel?>((ref) {
  final authState = ref.watch(authStateProvider);

  // Case 1: Firebase Auth is still loading — serve cached user as a bridge
  // so the UI isn't blank while Firebase restores the session.
  if (authState.isLoading) {
    final localSession = _readLocalSession();
    if (localSession != null) {
      final cachedUser = _getCachedUser(localSession['uid']!);
      if (cachedUser != null) {
        debugPrint('Bridge: serving cached user while Firebase Auth loads');
        return Stream.value(cachedUser);
      }
    }
    // No cached user available — stay in loading state
    return const Stream.empty();
  }

  final firebaseUser = authState.valueOrNull;

  // Case 2: Firebase Auth has a valid user → use Firestore with caching
  if (firebaseUser != null) {
    return _userStreamWithCache(firebaseUser.uid);
  }

  // Case 3: Firebase Auth returned null (done loading, no Firebase user).
  // This can happen on cold start (token expired, offline, timing).
  // If we have a local session with cached data, TRUST IT — don't clear.
  // Only explicit sign-out (AuthController.signOut) clears the local session.
  final localSession = _readLocalSession();
  if (localSession != null) {
    final cachedUser = _getCachedUser(localSession['uid']!);
    if (cachedUser != null) {
      debugPrint(
        'Firebase Auth has no user but local session exists — serving cached user',
      );
      return Stream.value(cachedUser);
    }
  }

  // No Firebase user AND no local session — genuinely not logged in
  debugPrint('No Firebase user and no local session — user is not logged in');
  return Stream.value(null);
});

/// Get cached UserModel synchronously from Hive
UserModel? _getCachedUser(String uid) {
  try {
    final userBox = Hive.box('user');
    final cachedJson = userBox.get('current_user');
    if (cachedJson == null) return null;
    final cachedData = jsonDecode(cachedJson) as Map<String, dynamic>;
    final cachedUser = UserModel.fromJson(cachedData);
    if (cachedUser.id == uid) return cachedUser;
    return null;
  } catch (e) {
    debugPrint('Error reading cached user: $e');
    return null;
  }
}

/// Stream user data with local cache fallback
Stream<UserModel?> _userStreamWithCache(String uid) async* {
  final userBox = Hive.box('user');
  UserModel? lastEmitted;

  // First, emit cached user immediately if available
  final cachedUser = _getCachedUser(uid);
  if (cachedUser != null) {
    lastEmitted = cachedUser;
    yield cachedUser;
  }

  // Then listen to Firestore for real-time updates
  try {
    await for (final doc in FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()) {
      if (!doc.exists) {
        if (lastEmitted != null) {
          lastEmitted = null;
          yield null;
        }
        continue;
      }
      try {
        final data = _convertTimestamps(doc.data()!);
        final userModel = UserModel.fromJson({
          'id': doc.id,
          ...data,
        });

        // Cache the user locally
        await userBox.put('current_user', jsonEncode(userModel.toJson()));

        // Only yield if different from last emitted to avoid unnecessary rebuilds
        if (lastEmitted == null || lastEmitted != userModel) {
          lastEmitted = userModel;
          yield userModel;
        }
      } catch (e) {
        debugPrint('Error parsing UserModel: $e');
        if (lastEmitted != null) {
          lastEmitted = null;
          yield null;
        }
      }
    }
  } catch (e) {
    // Firestore permission denied or network error — serve cached user
    debugPrint('Firestore user stream error (serving cached): $e');
    if (lastEmitted == null) {
      final cached = _getCachedUser(uid);
      if (cached != null) yield cached;
    }
  }
}

/// Clear cached user on logout
Future<void> _clearCachedUser() async {
  try {
    final userBox = Hive.box('user');
    await userBox.delete('current_user');
  } catch (e) {
    debugPrint('Error clearing cached user: $e');
  }
}

// ---------------------------------------------------------------------------
// Organization provider
// ---------------------------------------------------------------------------

/// Current organization provider.
/// Fetches from Firestore and caches in Hive. Falls back to Hive on error.
final currentOrganizationProvider = StreamProvider<OrganizationModel?>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  final user = userAsync.valueOrNull;
  if (user == null || user.organizationId.isEmpty) {
    // Try to serve cached org even when user is null (e.g. loading from Hive)
    return Stream.value(_getCachedOrganization());
  }

  return FirebaseFirestore.instance
      .collection('organizations')
      .doc(user.organizationId)
      .snapshots()
      .map((doc) {
    if (!doc.exists) return null;
    try {
      final data = _convertTimestamps(doc.data()!);
      final org = OrganizationModel.fromJson({
        'id': doc.id,
        ...data,
      });
      // Cache in Hive for offline use
      _cacheOrganization(org);
      return org;
    } catch (e) {
      debugPrint('Error parsing OrganizationModel: $e');
      return null;
    }
  }).onErrorEmit(() => _getCachedOrganization());
});

/// Cache organization in Hive
void _cacheOrganization(OrganizationModel org) {
  try {
    final box = Hive.box('user');
    box.put('cached_organization', jsonEncode(org.toJson()));
  } catch (e) {
    debugPrint('Error caching organization: $e');
  }
}

/// Get cached organization from Hive
OrganizationModel? _getCachedOrganization() {
  try {
    final box = Hive.box('user');
    final raw = box.get('cached_organization');
    if (raw == null) return null;
    return OrganizationModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  } catch (e) {
    debugPrint('Error reading cached organization: $e');
    return null;
  }
}

// ---------------------------------------------------------------------------
// Timestamp helper
// ---------------------------------------------------------------------------

/// Helper to convert Firestore Timestamps to DateTime ISO strings
Map<String, dynamic> _convertTimestamps(Map<String, dynamic> data) {
  final result = <String, dynamic>{};
  for (final entry in data.entries) {
    if (entry.value is Timestamp) {
      result[entry.key] = (entry.value as Timestamp).toDate().toIso8601String();
    } else if (entry.value is Map<String, dynamic>) {
      result[entry.key] =
          _convertTimestamps(entry.value as Map<String, dynamic>);
    } else {
      result[entry.key] = entry.value;
    }
  }
  return result;
}

// ---------------------------------------------------------------------------
// Auth controller
// ---------------------------------------------------------------------------

/// Auth controller provider
final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref);
});

/// Auth controller for handling authentication actions
class AuthController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthController(this._ref) : super(const AsyncValue.data(null));

  /// Sign in with email and password
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Save local session immediately so user stays logged in
      if (credential.user != null) {
        await _saveLocalSession(
          credential.user!.uid,
          credential.user!.email ?? email.trim(),
        );

        // Update last login in the background
        _firestore.collection('users').doc(credential.user!.uid).update({
          'lastLoginAt': FieldValue.serverTimestamp(),
        }).catchError((e) {
          debugPrint('Error updating lastLoginAt: $e');
        });
      }

      state = const AsyncValue.data(null);
    } on FirebaseException catch (e) {
      state = AsyncValue.error(_mapAuthException(e), StackTrace.current);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Sign up with email and password
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String organizationName,
    String? phone,
    bool isInviteSignup = false,
  }) async {
    state = const AsyncValue.loading();
    try {
      // Create auth user
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user == null) {
        throw const AuthException(message: 'Failed to create user');
      }

      // Save local session immediately
      await _saveLocalSession(
        credential.user!.uid,
        credential.user!.email ?? email.trim(),
      );

      if (isInviteSignup) {
        // For invite signups, create a minimal user document
        // The redeemInvite Cloud Function will set the organizationId and role
        await _firestore.collection('users').doc(credential.user!.uid).set({
          'email': email.trim(),
          'name': name.trim(),
          'phone': phone?.trim(),
          'organizationId': null, // Will be set by redeemInvite
          'role': 'pending', // Will be set by redeemInvite
          'createdAt': FieldValue.serverTimestamp(),
          'lastLoginAt': FieldValue.serverTimestamp(),
          'isActive': true,
        });
      } else {
        // For regular signups, create profile and organization
        await createProfile(
          uid: credential.user!.uid,
          email: email,
          name: name,
          organizationName: organizationName,
          phone: phone,
        );
      }

      state = const AsyncValue.data(null);
    } on FirebaseException catch (e) {
      state = AsyncValue.error(_mapAuthException(e), StackTrace.current);
    } catch (e, st) {
      // Ensure we don't return "List<Object>" or other unreadable errors
      final errorMessage = e.toString();
      state = AsyncValue.error(
        AuthException(
          message: 'Sign up failed: $errorMessage',
          originalError: e,
        ),
        st,
      );
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    state = const AsyncValue.loading();
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      state = const AsyncValue.data(null);
    } on FirebaseException catch (e) {
      state = AsyncValue.error(_mapAuthException(e), StackTrace.current);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Sign out — this is the ONLY place that clears the local session
  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      // Clear local session FIRST
      await _clearLocalSession();

      // Clear all local data
      await _ref.read(localStorageServiceProvider).clearAllData();

      // Sign out of Firebase
      await _auth.signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    required String name,
    String? phone,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw const SessionExpiredException();
      }

      await _firestore.collection('users').doc(user.uid).update({
        'name': name.trim(),
        if (phone != null) 'phone': phone.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = _auth.currentUser;
      if (user == null || user.email == null) {
        throw const SessionExpiredException();
      }

      // Re-authenticate
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);

      state = const AsyncValue.data(null);
    } on FirebaseException catch (e) {
      state = AsyncValue.error(_mapAuthException(e), StackTrace.current);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Create user profile and organization (for manual cleanup or retry)
  Future<void> createProfile({
    required String uid,
    required String email,
    required String name,
    required String organizationName,
    String? phone,
  }) async {
    try {
      // Create organization
      final orgRef = _firestore.collection('organizations').doc();
      await orgRef.set({
        'name': organizationName.trim(),
        'ownerId': uid,
        'ownerEmail': email.trim(),
        'currency': 'USD',
        'timezone': 'Africa/Harare',
        'createdAt': FieldValue.serverTimestamp(),
        'trialStartDate': FieldValue.serverTimestamp(),
        'subscriptionTier': 'trial',
        'settings': {},
      });

      // Create user document
      await _firestore.collection('users').doc(uid).set({
        'email': email.trim(),
        'name': name.trim(),
        'phone': phone?.trim(),
        'organizationId': orgRef.id,
        'role': 'owner',
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
        'isActive': true,
      });
    } catch (e) {
      debugPrint('Error creating profile: $e');
      throw DatabaseException(
        message: 'Failed to setup account profile: $e',
        originalError: e,
      );
    }
  }

  /// Map Firebase auth exceptions to app exceptions
  AppException _mapAuthException(FirebaseException e) {
    switch (e.code) {
      case 'user-not-found':
        return const UserNotFoundException();
      case 'wrong-password':
        return const InvalidCredentialsException();
      case 'invalid-credential':
        return const InvalidCredentialsException();
      case 'email-already-in-use':
        return const EmailAlreadyInUseException();
      case 'weak-password':
        return const WeakPasswordException();
      case 'invalid-email':
        return const AuthException(
          message: 'Invalid email address',
          code: 'INVALID_EMAIL',
        );
      case 'too-many-requests':
        return const AuthException(
          message: 'Too many attempts. Please try again later.',
          code: 'TOO_MANY_REQUESTS',
        );
      default:
        return AuthException(
          message: e.message ?? 'Authentication failed',
          code: e.code,
          originalError: e,
        );
    }
  }
}
