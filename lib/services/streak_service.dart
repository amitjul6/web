import '../core/date_utils.dart';
import '../models/app_data.dart';
import '../models/day_log.dart';
import '../models/streak_state.dart';

/// Pure streak + badge evaluation. A day "qualifies" when effective steps meet
/// the step goal. Recomputed deterministically from the stored days.
class StreakService {
  StreakService._();

  /// Current consecutive-day streak ending today (or yesterday if today not yet met).
  static int currentStreak(Map<String, DayLog> days, int stepGoal) {
    bool qualifies(String key) =>
        (days[key]?.steps.effectiveSteps ?? 0) >= stepGoal;

    var cursor = todayKey();
    // Allow the streak to "hold" if today isn't met yet but yesterday was.
    if (!qualifies(cursor)) cursor = yesterdayKey(cursor);

    var count = 0;
    while (qualifies(cursor)) {
      count++;
      cursor = yesterdayKey(cursor);
    }
    return count;
  }

  /// Longest consecutive run across all recorded days.
  static int longestStreak(Map<String, DayLog> days, int stepGoal) {
    final qualifiedKeys = days.entries
        .where((e) => e.value.steps.effectiveSteps >= stepGoal)
        .map((e) => e.key)
        .toList()
      ..sort();
    var best = 0;
    var run = 0;
    String? prev;
    for (final key in qualifiedKeys) {
      if (prev != null && yesterdayKey(key) == prev) {
        run++;
      } else {
        run = 1;
      }
      if (run > best) best = run;
      prev = key;
    }
    return best;
  }

  static StreakState recompute(AppData data) {
    final goal = data.goals.stepGoal;
    final current = currentStreak(data.days, goal);
    final longest = longestStreak(data.days, goal);
    final earned = evaluateBadges(data, current: current, longest: longest);
    return StreakState(
      currentStreak: current,
      longestStreak: longest,
      lastQualifiedDayKey: _lastQualified(data.days, goal),
      earnedBadgeIds: earned,
    );
  }

  static String? _lastQualified(Map<String, DayLog> days, int goal) {
    final keys = days.entries
        .where((e) => e.value.steps.effectiveSteps >= goal)
        .map((e) => e.key)
        .toList()
      ..sort();
    return keys.isEmpty ? null : keys.last;
  }

  /// Returns the full set of earned badge ids (additive: never revokes).
  static Set<String> evaluateBadges(
    AppData data, {
    required int current,
    required int longest,
  }) {
    final earned = {...data.streak.earnedBadgeIds};
    final goal = data.goals.stepGoal;

    final anyFood = data.days.values.any((d) => d.foods.isNotEmpty);
    final anyExercise = data.days.values.any((d) => d.exercises.isNotEmpty);
    final hitGoal =
        data.days.values.any((d) => d.steps.effectiveSteps >= goal);
    final hit10k =
        data.days.values.any((d) => d.steps.effectiveSteps >= 10000);

    if (anyFood) earned.add('first_log');
    if (anyExercise) earned.add('first_exercise');
    if (hitGoal) earned.add('steps_goal');
    if (hit10k) earned.add('steps_10k');
    if (longest >= 3 || current >= 3) earned.add('streak_3');
    if (longest >= 7 || current >= 7) earned.add('streak_7');
    if (data.weights.isNotEmpty) earned.add('weight_logged');

    return earned;
  }
}
