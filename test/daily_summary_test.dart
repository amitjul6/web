import 'package:caloriedesi/core/date_utils.dart';
import 'package:caloriedesi/data/food_library.dart';
import 'package:caloriedesi/models/daily_summary.dart';
import 'package:caloriedesi/models/day_log.dart';
import 'package:caloriedesi/models/enums.dart';
import 'package:caloriedesi/models/food_log_entry.dart';
import 'package:caloriedesi/models/profile.dart';
import 'package:caloriedesi/models/step_record.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final profile = Profile(
    sex: Sex.male,
    birthDate: DateTime(1995, 1, 1),
    heightCm: 175,
    weightKg: 70,
    activityLevel: ActivityLevel.light,
  );

  test('net = caloriesIn - (bmr + steps + exercise)', () {
    final roti = kFoodLibrary.firstWhere((f) => f.id == 'roti');
    final key = todayKey();
    final day = DayLog(
      dayKey: key,
      foods: [FoodLogEntry.fromFood(roti, 'e1', 3)], // 3 * 104 = 312
      steps: StepRecord(dayKey: key, sensorSteps: 10000),
    );

    final s = DailySummary.from(day, profile);
    expect(s.caloriesIn, closeTo(312, 0.001));
    expect(s.stepCalories, closeTo(399.0, 0.001));
    expect(s.bmr, closeTo(profile.bmr, 0.001));
    expect(s.net, closeTo(s.caloriesIn - s.caloriesOut, 0.001));
    // Out uses BMR not TDEE.
    expect(s.caloriesOut, closeTo(profile.bmr + 399.0, 0.001));
  });

  test('manual override beats sensor in the summary', () {
    final key = todayKey();
    final day = DayLog(
      dayKey: key,
      steps: StepRecord(dayKey: key, sensorSteps: 2000, manualOverride: 9000),
    );
    final s = DailySummary.from(day, profile);
    expect(s.steps, 9000);
  });
}
