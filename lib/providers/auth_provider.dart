import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/auth_user.dart';
import 'app_data_provider.dart';
import 'service_providers.dart';

/// Holds the current signed-in identity (in-memory; sign-in is required per launch).
class AuthNotifier extends Notifier<AuthUser?> {
  @override
  AuthUser? build() => null;

  /// Interactive Google sign-in. Returns true on success.
  Future<bool> signInWithGoogle() async {
    final user = await ref.read(authServiceProvider).signInWithGoogle();
    if (user == null) return false;
    state = user;
    await ref.read(appDataProvider.notifier).attachIdentity(user);
    return true;
  }

  void continueAsGuest() => state = AuthUser.guest;

  Future<void> signOut() async {
    await ref.read(authServiceProvider).signOut();
    state = null;
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthUser?>(AuthNotifier.new);
