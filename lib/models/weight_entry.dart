/// A single weight measurement.
class WeightEntry {
  final String id;
  final DateTime date;
  final double weightKg;

  const WeightEntry({
    required this.id,
    required this.date,
    required this.weightKg,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'weightKg': weightKg,
      };

  factory WeightEntry.fromJson(Map<String, dynamic> j) => WeightEntry(
        id: j['id'] as String,
        date: DateTime.parse(j['date'] as String),
        weightKg: (j['weightKg'] as num).toDouble(),
      );
}
