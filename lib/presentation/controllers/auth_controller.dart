import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/models/user_model.dart';
import '../../core/errors/exceptions.dart';
import '../../core/services/local_storage_service.dart';

/// Auth state provider - watches Firebase auth state
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

/// Current user provider - fetches user data from Firestore
final currentUserProvider = StreamProvider<UserModel?>((ref) {
  final authState = ref.watch(authStateProvider);
  final user = authState.valueOrNull;

  if (user == null) return Stream.value(null);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((doc) {
    if (!doc.exists) return null;
    try {
      final data = _convertTimestamps(doc.data()!);
      return UserModel.fromJson({
        'id': doc.id,
        ...data,
      });
    } catch (e) {
      debugPrint('Error parsing UserModel: $e');
      return null;
    }
  });
});

/// Current organization provider
final currentOrganizationProvider = StreamProvider<OrganizationModel?>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  final user = userAsync.valueOrNull;

  if (user == null) return Stream.value(null);

  return FirebaseFirestore.instance
      .collection('organizations')
      .doc(user.organizationId)
      .snapshots()
      .map((doc) {
    if (!doc.exists) return null;
    try {
      final data = _convertTimestamps(doc.data()!);
      return OrganizationModel.fromJson({
        'id': doc.id,
        ...data,
      });
    } catch (e) {
      debugPrint('Error parsing OrganizationModel: $e');
      return null;
    }
  });
});

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

      // Update last login
      if (credential.user != null) {
        await _firestore.collection('users').doc(credential.user!.uid).update({
          'lastLoginAt': FieldValue.serverTimestamp(),
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

  /// Sign out
  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      // Clear local data
      await _ref.read(localStorageServiceProvider).clearAllData();

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
