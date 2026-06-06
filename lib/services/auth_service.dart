import 'package:google_sign_in/google_sign_in.dart';

import '../models/auth_user.dart';

/// Google sign-in wrapper (google_sign_in v6 API). Requires a configured
/// `google-services.json` + SHA-1 registration to work on a real build; see
/// docs/android_setup.md. A guest path keeps the app usable without that setup.
class AuthService {
  final GoogleSignIn _google = GoogleSignIn(scopes: const ['email', 'profile']);

  AuthUser? _fromAccount(GoogleSignInAccount? a) => a == null
      ? null
      : AuthUser(name: a.displayName, email: a.email, photoUrl: a.photoUrl);

  /// Interactive sign-in. Returns null if the user cancels.
  Future<AuthUser?> signInWithGoogle() async {
    final account = await _google.signIn();
    return _fromAccount(account);
  }

  /// Tries to restore a previous Google session without UI.
  Future<AuthUser?> trySilentSignIn() async {
    try {
      final account = await _google.signInSilently();
      return _fromAccount(account);
    } catch (_) {
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _google.signOut();
    } catch (_) {/* ignore — guest or not signed in */}
  }
}
