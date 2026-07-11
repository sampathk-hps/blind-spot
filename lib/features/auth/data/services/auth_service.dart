import 'package:firebase_auth/firebase_auth.dart';

/// Data-layer abstraction over [FirebaseAuth].
///
/// Isolates all Firebase Auth SDK calls from the presentation layer so that
/// the auth implementation can be swapped without touching any notifier or UI.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── Streams ───────────────────────────────────────────────────────────────

  /// Emits the current [User] whenever the auth state changes.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// The currently signed-in [User], or `null` if not authenticated.
  User? get currentUser => _auth.currentUser;

  // ── Commands ──────────────────────────────────────────────────────────────

  Future<UserCredential> signInWithEmail(
      String email, String password) async {
    return _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<UserCredential> signUpWithEmail(
      String email, String password) async {
    return _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> updateDisplayName(String name) async {
    await _auth.currentUser?.updateDisplayName(name);
  }

  Future<void> signOut() async => _auth.signOut();

  // ── Error mapping ─────────────────────────────────────────────────────────

  /// Translates a [FirebaseAuthException] code into a human-readable message.
  String mapError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'Password is too weak. Use at least 8 characters.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }
}
