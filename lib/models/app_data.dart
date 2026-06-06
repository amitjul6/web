import 'daily_goals.dart';
import 'day_log.dart';
import 'profile.dart';
import 'streak_state.dart';
import 'weight_entry.dart';

/// Immutable in-memory snapshot of all persisted app state.
class AppData {
  final Profile? profile;
  final DailyGoals goals;
  final Map<String, DayLog> days; // dayKey -> DayLog
  final List<WeightEntry> weights; // sorted ascending by date
  final StreakState streak;
  final bool onboarded;

  const AppData({
    this.profile,
    this.goals = const DailyGoals(),
    this.days = const {},
    this.weights = const [],
    this.streak = const StreakState(),
    this.onboarded = false,
  });

  DayLog day(String dayKey) => days[dayKey] ?? DayLog(dayKey: dayKey);

  AppData copyWith({
    Profile? profile,
    bool clearProfile = false,
    DailyGoals? goals,
    Map<String, DayLog>? days,
    List<WeightEntry>? weights,
    StreakState? streak,
    bool? onboarded,
  }) =>
      AppData(
        profile: clearProfile ? null : (profile ?? this.profile),
        goals: goals ?? this.goals,
        days: days ?? this.days,
        weights: weights ?? this.weights,
        streak: streak ?? this.streak,
        onboarded: onboarded ?? this.onboarded,
      );

  AppData withDay(DayLog log) {
    final next = Map<String, DayLog>.from(days);
    next[log.dayKey] = log;
    return copyWith(days: next);
  }
}
