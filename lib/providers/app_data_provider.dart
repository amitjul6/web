import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../core/date_utils.dart';
import '../data/local_store.dart';
import '../models/app_data.dart';
import '../models/auth_user.dart';
import '../models/daily_goals.dart';
import '../models/daily_summary.dart';
import '../models/day_log.dart';
import '../models/enums.dart';
import '../models/exercise_entry.dart';
import '../models/food_item.dart';
import '../models/food_log_entry.dart';
import '../models/profile.dart';
import '../models/weight_entry.dart';
import '../services/streak_service.dart';
import 'service_providers.dart';

const _uuid = Uuid();

/// Single source of truth for all persisted state. Loads synchronously from the
/// already-open Hive boxes, then mutates + persists incrementally.
class AppDataNotifier extends Notifier<AppData> {
  LocalStore get _store => ref.read(localStoreProvider);

  @override
  AppData build() {
    return AppData(
      profile: _store.loadProfile(),
      goals: _store.loadGoals(),
      days: _store.loadDays(),
      weights: _store.loadWeights(),
      streak: _store.loadStreak(),
      onboarded: _store.onboarded,
    );
  }

  // ---- Day mutations ----
  DayLog _day(String key) => state.day(key);

  Future<void> _commitDay(DayLog log) async {
    await _store.saveDay(log);
    state = state.withDay(log);
    await _refreshStreak();
  }

  Future<void> addFood(FoodItem food, double quantity, {String? dayKey}) async {
    final key = dayKey ?? todayKey();
    final day = _day(key);
    final foods = [...day.foods];
    final existing = foods.indexWhere((e) => e.foodItemId == food.id);
    if (existing >= 0) {
      foods[existing] = foods[existing]
          .copyWith(quantity: foods[existing].quantity + quantity);
    } else {
      foods.add(FoodLogEntry.fromFood(food, _uuid.v4(), quantity));
    }
    await _commitDay(day.copyWith(foods: foods));
  }

  Future<void> changeFoodQty(String entryId, double delta,
      {required String dayKey}) async {
    final day = _day(dayKey);
    final foods = <FoodLogEntry>[];
    for (final e in day.foods) {
      if (e.id == entryId) {
        final q = e.quantity + delta;
        if (q > 0) foods.add(e.copyWith(quantity: q));
      } else {
        foods.add(e);
      }
    }
    await _commitDay(day.copyWith(foods: foods));
  }

  Future<void> removeFood(String entryId, {required String dayKey}) async {
    final day = _day(dayKey);
    await _commitDay(day.copyWith(
        foods: day.foods.where((e) => e.id != entryId).toList()));
  }

  Future<void> addExercise(
    String typeId,
    String name,
    String icon,
    ExerciseInputMode inputMode,
    double amount,
    double calories, {
    String? dayKey,
  }) async {
    final key = dayKey ?? todayKey();
    final day = _day(key);
    final entry = ExerciseEntry(
      id: _uuid.v4(),
      typeId: typeId,
      name: name,
      icon: icon,
      inputMode: inputMode,
      amount: amount,
      caloriesBurned: calories,
      timestamp: DateTime.now(),
    );
    await _commitDay(day.copyWith(exercises: [...day.exercises, entry]));
  }

  Future<void> removeExercise(String entryId, {required String dayKey}) async {
    final day = _day(dayKey);
    await _commitDay(day.copyWith(
        exercises: day.exercises.where((e) => e.id != entryId).toList()));
  }

  // ---- Steps ----
  Future<void> setSensorSteps(int steps, {String? dayKey}) async {
    final key = dayKey ?? todayKey();
    final day = _day(key);
    // Don't let a stale sensor value clobber a manual override.
    await _commitDay(day.copyWith(steps: day.steps.copyWith(sensorSteps: steps)));
  }

  Future<void> setManualSteps(int? steps, {String? dayKey}) async {
    final key = dayKey ?? todayKey();
    final day = _day(key);
    final next = steps == null
        ? day.steps.copyWith(clearManual: true)
        : day.steps.copyWith(manualOverride: steps);
    await _commitDay(day.copyWith(steps: next));
  }

  // ---- Weight ----
  Future<void> addWeight(double weightKg, {DateTime? date}) async {
    final entry = WeightEntry(
      id: _uuid.v4(),
      date: date ?? DateTime.now(),
      weightKg: weightKg,
    );
    await _store.saveWeight(entry);
    final weights = [...state.weights, entry]
      ..sort((a, b) => a.date.compareTo(b.date));
    // Keep current profile weight in sync with the latest measurement.
    final profile = state.profile?.copyWith(weightKg: weightKg);
    if (profile != null) await _store.saveProfile(profile);
    state = state.copyWith(weights: weights, profile: profile);
    await _refreshStreak();
  }

  Future<void> deleteWeight(String id) async {
    await _store.deleteWeight(id);
    state = state.copyWith(
        weights: state.weights.where((w) => w.id != id).toList());
    await _refreshStreak();
  }

  // ---- Profile / goals / onboarding ----
  Future<void> saveProfile(Profile profile, {bool completeOnboarding = false}) async {
    await _store.saveProfile(profile);
    if (completeOnboarding) await _store.setOnboarded(true);
    state = state.copyWith(
      profile: profile,
      onboarded: completeOnboarding ? true : state.onboarded,
    );
  }

  Future<void> attachIdentity(AuthUser user) async {
    final p = state.profile;
    if (p == null) return;
    final updated = p.copyWith(
      name: user.name,
      email: user.email,
      photoUrl: user.photoUrl,
    );
    await _store.saveProfile(updated);
    state = state.copyWith(profile: updated);
  }

  Future<void> saveGoals(DailyGoals goals) async {
    await _store.saveGoals(goals);
    state = state.copyWith(goals: goals);
    await _refreshStreak();
  }

  Future<void> _refreshStreak() async {
    final streak = StreakService.recompute(state);
    await _store.saveStreak(streak);
    state = state.copyWith(streak: streak);
  }
}

final appDataProvider =
    NotifierProvider<AppDataNotifier, AppData>(AppDataNotifier.new);

// ---- Selected-day derivations ----
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final selectedDayKeyProvider =
    Provider<String>((ref) => dayKeyOf(ref.watch(selectedDateProvider)));

final selectedDayLogProvider = Provider<DayLog>((ref) {
  final data = ref.watch(appDataProvider);
  return data.day(ref.watch(selectedDayKeyProvider));
});

final selectedSummaryProvider = Provider<DailySummary>((ref) {
  final data = ref.watch(appDataProvider);
  final log = data.day(ref.watch(selectedDayKeyProvider));
  return DailySummary.from(log, data.profile);
});
