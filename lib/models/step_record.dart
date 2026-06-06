/// Per-day step state. Effective steps prefer a manual override over the sensor.
class StepRecord {
  final String dayKey;
  final int sensorSteps;
  final int? manualOverride;

  const StepRecord({
    required this.dayKey,
    this.sensorSteps = 0,
    this.manualOverride,
  });

  int get effectiveSteps => manualOverride ?? sensorSteps;
  bool get isManual => manualOverride != null;

  StepRecord copyWith({
    int? sensorSteps,
    int? manualOverride,
    bool clearManual = false,
  }) =>
      StepRecord(
        dayKey: dayKey,
        sensorSteps: sensorSteps ?? this.sensorSteps,
        manualOverride: clearManual ? null : (manualOverride ?? this.manualOverride),
      );

  Map<String, dynamic> toJson() => {
        'dayKey': dayKey,
        'sensorSteps': sensorSteps,
        'manualOverride': manualOverride,
      };

  factory StepRecord.fromJson(Map<String, dynamic> j) => StepRecord(
        dayKey: j['dayKey'] as String,
        sensorSteps: (j['sensorSteps'] as num?)?.toInt() ?? 0,
        manualOverride: (j['manualOverride'] as num?)?.toInt(),
      );
}
