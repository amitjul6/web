import 'dart:convert';

import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import '../core/constants.dart';
import '../models/daily_goals.dart';
import '../models/day_log.dart';
import '../models/profile.dart';
import '../models/streak_state.dart';
import '../models/weight_entry.dart';

/// Thin Hive wrapper. Values are stored as JSON strings to sidestep Hive's
/// dynamic map-typing quirks and keep the schema migration-friendly.
class LocalStore {
  late final Box _profile;
  late final Box _goals;
  late final Box _days;
  late final Box _weights;
  late final Box _streak;
  late final Box _flags;

  Future<void> init() async {
    await Hive.initFlutter();
    _profile = await Hive.openBox(K.boxProfile);
    _goals = await Hive.openBox(K.boxGoals);
    _days = await Hive.openBox(K.boxDays);
    _weights = await Hive.openBox(K.boxWeights);
    _streak = await Hive.openBox(K.boxStreak);
    _flags = await Hive.openBox(K.boxFlags);
  }

  Map<String, dynamic>? _decode(Object? raw) {
    if (raw is String && raw.isNotEmpty) {
      return Map<String, dynamic>.from(jsonDecode(raw) as Map);
    }
    return null;
  }

  // ----- Profile -----
  Profile? loadProfile() {
    final j = _decode(_profile.get(K.keySingle));
    return j == null ? null : Profile.fromJson(j);
  }

  Future<void> saveProfile(Profile p) =>
      _profile.put(K.keySingle, jsonEncode(p.toJson()));

  Future<void> deleteProfile() => _profile.delete(K.keySingle);

  // ----- Goals -----
  DailyGoals loadGoals() {
    final j = _decode(_goals.get(K.keySingle));
    return j == null ? const DailyGoals() : DailyGoals.fromJson(j);
  }

  Future<void> saveGoals(DailyGoals g) =>
      _goals.put(K.keySingle, jsonEncode(g.toJson()));

  // ----- Days -----
  Map<String, DayLog> loadDays() {
    final out = <String, DayLog>{};
    for (final key in _days.keys) {
      final j = _decode(_days.get(key));
      if (j != null) out[key as String] = DayLog.fromJson(j);
    }
    return out;
  }

  Future<void> saveDay(DayLog log) =>
      _days.put(log.dayKey, jsonEncode(log.toJson()));

  // ----- Weights -----
  List<WeightEntry> loadWeights() {
    final list = <WeightEntry>[];
    for (final key in _weights.keys) {
      final j = _decode(_weights.get(key));
      if (j != null) list.add(WeightEntry.fromJson(j));
    }
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  Future<void> saveWeight(WeightEntry w) =>
      _weights.put(w.id, jsonEncode(w.toJson()));

  Future<void> deleteWeight(String id) => _weights.delete(id);

  // ----- Streak -----
  StreakState loadStreak() {
    final j = _decode(_streak.get(K.keySingle));
    return j == null ? const StreakState() : StreakState.fromJson(j);
  }

  Future<void> saveStreak(StreakState s) =>
      _streak.put(K.keySingle, jsonEncode(s.toJson()));

  // ----- Flags -----
  bool get onboarded => _flags.get(K.flagOnboarded, defaultValue: false) as bool;
  Future<void> setOnboarded(bool v) => _flags.put(K.flagOnboarded, v);
}
