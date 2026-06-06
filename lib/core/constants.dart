/// App-wide constants and storage keys.
class K {
  K._();

  static const String appName = 'CalorieDesi';

  // Hive box names.
  static const String boxProfile = 'profile_box';
  static const String boxGoals = 'goals_box';
  static const String boxDays = 'days_box'; // key: dayKey -> DayLog json
  static const String boxWeights = 'weights_box'; // key: id -> WeightEntry json
  static const String boxStreak = 'streak_box';
  static const String boxFlags = 'flags_box';

  static const String keySingle = 'value'; // single-value box entry key
  static const String flagOnboarded = 'onboarded';

  // Defaults.
  static const int defaultStepGoal = 8000;
  static const int defaultNetCalorieGoal = 1800; // target net calories/day
  static const int defaultActiveCalorieGoal = 500; // "move" ring target
  static const int defaultWorkoutMinutesGoal = 30; // "exercise" ring target

  // Energy model. ~0.04 kcal/step at 70 kg; weight-scaled.
  static const double kcalPerStepPerKg = 0.00057;

  // Unit conversions.
  static const double lbPerKg = 2.20462;
  static const double cmPerInch = 2.54;
}
