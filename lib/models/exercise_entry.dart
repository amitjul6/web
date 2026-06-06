import 'enums.dart';

/// A logged exercise for a day. Calories are computed at entry time (snapshotted).
class ExerciseEntry {
  final String id;
  final String typeId;
  final String name;
  final String icon;
  final ExerciseInputMode inputMode;
  final double amount; // minutes | reps | km depending on inputMode
  final double caloriesBurned;
  final DateTime timestamp;

  const ExerciseEntry({
    required this.id,
    required this.typeId,
    required this.name,
    required this.icon,
    required this.inputMode,
    required this.amount,
    required this.caloriesBurned,
    required this.timestamp,
  });

  String get amountLabel {
    switch (inputMode) {
      case ExerciseInputMode.duration:
        return '${amount.toStringAsFixed(0)} min';
      case ExerciseInputMode.reps:
        return '${amount.toStringAsFixed(0)} reps';
      case ExerciseInputMode.distance:
        return '${amount.toStringAsFixed(1)} km';
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'typeId': typeId,
        'name': name,
        'icon': icon,
        'inputMode': inputMode.name,
        'amount': amount,
        'caloriesBurned': caloriesBurned,
        'timestamp': timestamp.toIso8601String(),
      };

  factory ExerciseEntry.fromJson(Map<String, dynamic> j) => ExerciseEntry(
        id: j['id'] as String,
        typeId: j['typeId'] as String,
        name: j['name'] as String,
        icon: j['icon'] as String,
        inputMode: ExerciseInputMode.values.byName(j['inputMode'] as String),
        amount: (j['amount'] as num).toDouble(),
        caloriesBurned: (j['caloriesBurned'] as num).toDouble(),
        timestamp: DateTime.parse(j['timestamp'] as String),
      );
}
