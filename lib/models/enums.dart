/// Biological sex used for the Mifflin-St Jeor BMR formula.
enum Sex {
  male('Male'),
  female('Female');

  const Sex(this.label);
  final String label;
}

/// Activity multiplier applied to BMR to estimate TDEE.
enum ActivityLevel {
  sedentary('Sedentary', 'Little or no exercise', 1.2),
  light('Lightly active', 'Light exercise 1-3 days/week', 1.375),
  moderate('Moderately active', 'Moderate exercise 3-5 days/week', 1.55),
  active('Very active', 'Hard exercise 6-7 days/week', 1.725),
  extra('Extra active', 'Very hard exercise / physical job', 1.9);

  const ActivityLevel(this.label, this.description, this.factor);
  final String label;
  final String description;
  final double factor;
}

enum UnitSystem {
  metric('Metric (kg, cm)'),
  imperial('Imperial (lb, in)');

  const UnitSystem(this.label);
  final String label;
}

/// How an exercise's amount is entered (drives the input UI and calorie math).
enum ExerciseInputMode { duration, reps, distance }
