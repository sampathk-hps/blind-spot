import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blindspot/features/auth/data/services/auth_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AuthService provider
// ─────────────────────────────────────────────────────────────────────────────

/// Provides the [AuthService] singleton. Override in tests to inject a mock.
final authServiceProvider = Provider<AuthService>(
  (_) => AuthService.instance,
);

// ─────────────────────────────────────────────────────────────────────────────
// Auth state stream
// ─────────────────────────────────────────────────────────────────────────────

/// Reactive stream of the currently signed-in [User].
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(authServiceProvider).authStateChanges;
});

/// Convenience provider that returns a display-friendly greeting name.
final currentUserNameProvider = Provider<String>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  return user?.displayName ?? user?.email?.split('@').first ?? 'there';
});

// ─────────────────────────────────────────────────────────────────────────────
// AuthNotifier
// ─────────────────────────────────────────────────────────────────────────────

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<void>>(
        (ref) => AuthNotifier(ref.read(authServiceProvider)));

/// Presentation-layer notifier that delegates all Firebase calls to
/// [AuthService], keeping the UI fully decoupled from the Firebase SDK.
class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  AuthNotifier(this._service) : super(const AsyncValue.data(null));

  final AuthService _service;

  Future<void> signInWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _service.signInWithEmail(email, password);
      state = const AsyncValue.data(null);
    } on FirebaseAuthException catch (e) {
      state = AsyncValue.error(_service.mapError(e), StackTrace.current);
      rethrow;
    }
  }

  Future<void> signUpWithEmail(
      String email, String password, String name) async {
    state = const AsyncValue.loading();
    try {
      await _service.signUpWithEmail(email, password);
      await _service.updateDisplayName(name);
      state = const AsyncValue.data(null);
    } on FirebaseAuthException catch (e) {
      state = AsyncValue.error(_service.mapError(e), StackTrace.current);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _service.signOut();
    state = const AsyncValue.data(null);
  }

  /// Google Sign-In — requires the `google_sign_in` package to be configured.
  Future<void> signInWithGoogle() async {
    throw UnimplementedError(
        'Google Sign-In requires google_sign_in package setup.');
  }
}
