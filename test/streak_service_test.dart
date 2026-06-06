import 'package:caloriedesi/core/date_utils.dart';
import 'package:caloriedesi/models/app_data.dart';
import 'package:caloriedesi/models/daily_goals.dart';
import 'package:caloriedesi/models/day_log.dart';
import 'package:caloriedesi/models/step_record.dart';
import 'package:caloriedesi/services/streak_service.dart';
import 'package:flutter_test/flutter_test.dart';

DayLog _dayWithSteps(String key, int steps) =>
    DayLog(dayKey: key, steps: StepRecord(dayKey: key, sensorSteps: steps));

void main() {
  const goal = 8000;

  test('counts consecutive qualifying days ending today', () {
    final today = todayKey();
    final y1 = yesterdayKey(today);
    final y2 = yesterdayKey(y1);
    final days = {
      today: _dayWithSteps(today, 9000),
      y1: _dayWithSteps(y1, 8500),
      y2: _dayWithSteps(y2, 3000), // breaks the streak
    };
    expect(StreakService.currentStreak(days, goal), 2);
  });

  test('streak holds when today not yet met but yesterday was', () {
    final today = todayKey();
    final y1 = yesterdayKey(today);
    final days = {
      today: _dayWithSteps(today, 1000),
      y1: _dayWithSteps(y1, 9000),
    };
    expect(StreakService.currentStreak(days, goal), 1);
  });

  test('badges are additive and awarded on conditions', () {
    final today = todayKey();
    final data = AppData(
      goals: const DailyGoals(stepGoal: goal),
      days: {today: _dayWithSteps(today, 10500)},
    );
    final earned = StreakService.evaluateBadges(data, current: 1, longest: 1);
    expect(earned, contains('steps_goal'));
    expect(earned, contains('steps_10k'));
    expect(earned, isNot(contains('streak_7')));
  });
}
