import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:health/health.dart';

import '../models/health_vitals.dart';

/// Reads vitals from the OS health platform (Android Health Connect / iOS
/// HealthKit) via the `health` package. Safe no-ops on web/unsupported.
class HealthService {
  final Health _health = Health();

  /// Data types we read.
  static final List<HealthDataType> _types = [
    HealthDataType.HEART_RATE,
    HealthDataType.RESTING_HEART_RATE,
    HealthDataType.HEART_RATE_VARIABILITY_RMSSD,
    HealthDataType.BLOOD_OXYGEN,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
  ];

  List<HealthDataAccess> get _permissions =>
      _types.map((_) => HealthDataAccess.READ).toList();

  /// Whether this platform can use a health platform at all.
  bool get isSupportedPlatform =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<void> _ensureConfigured() async {
    await _health.configure();
  }

  /// Requests read permission for our data types. Returns true if granted.
  Future<bool> requestAuthorization() async {
    if (!isSupportedPlatform) return false;
    try {
      await _ensureConfigured();
      final already =
          await _health.hasPermissions(_types, permissions: _permissions) ??
              false;
      if (already) return true;
      return await _health.requestAuthorization(_types,
          permissions: _permissions);
    } catch (_) {
      return false;
    }
  }

  Future<bool> hasPermissions() async {
    if (!isSupportedPlatform) return false;
    try {
      await _ensureConfigured();
      return await _health.hasPermissions(_types, permissions: _permissions) ??
          false;
    } catch (_) {
      return false;
    }
  }

  /// Pulls the most recent vitals from the last ~36h.
  Future<HealthVitals> fetchVitals() async {
    if (!isSupportedPlatform) return HealthVitals.empty;
    try {
      await _ensureConfigured();
      final now = DateTime.now();
      final start = now.subtract(const Duration(hours: 36));

      final raw = await _health.getHealthDataFromTypes(
        types: _types,
        startTime: start,
        endTime: now,
      );
      final points = _health.removeDuplicates(raw);

      List<HealthDataPoint> of(HealthDataType t) =>
          points.where((p) => p.type == t).toList()
            ..sort((a, b) => a.dateTo.compareTo(b.dateTo));

      double? latest(HealthDataType t) {
        final list = of(t);
        if (list.isEmpty) return null;
        final v = list.last.value;
        return v is NumericHealthValue ? v.numericValue.toDouble() : null;
      }

      // Sum asleep minutes over the window (approximates last night).
      int? sleepMinutes() {
        final list = of(HealthDataType.SLEEP_ASLEEP);
        if (list.isEmpty) return null;
        var mins = 0;
        for (final p in list) {
          mins += p.dateTo.difference(p.dateFrom).inMinutes;
        }
        return mins;
      }

      return HealthVitals(
        heartRate: latest(HealthDataType.HEART_RATE)?.round(),
        restingHeartRate: latest(HealthDataType.RESTING_HEART_RATE)?.round(),
        hrv: latest(HealthDataType.HEART_RATE_VARIABILITY_RMSSD),
        spo2: latest(HealthDataType.BLOOD_OXYGEN),
        sleepMinutes: sleepMinutes(),
        lastSync: now,
      );
    } catch (_) {
      return HealthVitals.empty;
    }
  }
}
