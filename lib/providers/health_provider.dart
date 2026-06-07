import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/health_source.dart';
import '../models/health_vitals.dart';
import 'service_providers.dart';

class HealthState {
  final Set<HealthSource> connected;
  final HealthVitals vitals;
  final bool syncing;

  const HealthState({
    this.connected = const {},
    this.vitals = HealthVitals.empty,
    this.syncing = false,
  });

  HealthState copyWith({
    Set<HealthSource>? connected,
    HealthVitals? vitals,
    bool? syncing,
  }) =>
      HealthState(
        connected: connected ?? this.connected,
        vitals: vitals ?? this.vitals,
        syncing: syncing ?? this.syncing,
      );
}

/// Result of a connect attempt, so the UI can show a useful message.
enum ConnectResult { connected, denied, unsupported, notImplemented }

class HealthNotifier extends Notifier<HealthState> {
  static const _kConnected = 'health:connected';
  static const _kVitals = 'health:vitals';

  @override
  HealthState build() {
    final prefs = ref.read(sharedPrefsProvider);
    final names = prefs.getStringList(_kConnected) ?? const [];
    final connected = <HealthSource>{};
    for (final n in names) {
      for (final s in HealthSource.values) {
        if (s.name == n) connected.add(s);
      }
    }
    final vitalsRaw = prefs.getString(_kVitals);
    final vitals = vitalsRaw != null
        ? HealthVitals.fromJson(
            Map<String, dynamic>.from(jsonDecode(vitalsRaw) as Map))
        : HealthVitals.empty;
    return HealthState(connected: connected, vitals: vitals);
  }

  void _persistConnected() {
    ref
        .read(sharedPrefsProvider)
        .setStringList(_kConnected, state.connected.map((s) => s.name).toList());
  }

  Future<ConnectResult> connect(HealthSource source) async {
    switch (source) {
      case HealthSource.healthConnect:
        final svc = ref.read(healthServiceProvider);
        if (!svc.isSupportedPlatform) return ConnectResult.unsupported;
        final granted = await svc.requestAuthorization();
        if (!granted) return ConnectResult.denied;
        state = state.copyWith(connected: {...state.connected, source});
        _persistConnected();
        await sync();
        return ConnectResult.connected;
      case HealthSource.fitbit:
      case HealthSource.appleHealth:
        // Wired up in later phases (Fitbit OAuth / iOS HealthKit build).
        return ConnectResult.notImplemented;
    }
  }

  void disconnect(HealthSource source) {
    state = state.copyWith(
        connected: state.connected.where((s) => s != source).toSet());
    _persistConnected();
  }

  Future<void> sync() async {
    if (!state.connected.contains(HealthSource.healthConnect)) return;
    state = state.copyWith(syncing: true);
    final vitals = await ref.read(healthServiceProvider).fetchVitals();
    ref.read(sharedPrefsProvider).setString(_kVitals, jsonEncode(vitals.toJson()));
    state = state.copyWith(vitals: vitals, syncing: false);
  }
}

final healthProvider =
    NotifierProvider<HealthNotifier, HealthState>(HealthNotifier.new);
