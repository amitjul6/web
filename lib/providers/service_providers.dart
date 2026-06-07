import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/local_store.dart';
import '../services/auth_service.dart';
import '../services/health_service.dart';
import '../services/pedometer_service.dart';
import '../services/permission_service.dart';

/// Overridden in main() after async initialization.
final localStoreProvider = Provider<LocalStore>(
  (ref) => throw UnimplementedError('localStoreProvider must be overridden'),
);

final sharedPrefsProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPrefsProvider must be overridden'),
);

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final healthServiceProvider = Provider<HealthService>((ref) => HealthService());

final permissionServiceProvider =
    Provider<PermissionService>((ref) => PermissionService());

final pedometerServiceProvider = Provider<PedometerService>((ref) {
  final service = PedometerService(ref.watch(sharedPrefsProvider));
  ref.onDispose(service.dispose);
  return service;
});
