/// Latest vitals pulled from a connected health platform. Cached locally so the
/// dashboard can show last-known values between syncs. Null = no data yet.
class HealthVitals {
  final int? heartRate; // latest bpm
  final int? restingHeartRate; // bpm
  final double? hrv; // ms (RMSSD)
  final double? spo2; // % (0-100)
  final int? sleepMinutes; // last night's sleep
  final DateTime? lastSync;

  const HealthVitals({
    this.heartRate,
    this.restingHeartRate,
    this.hrv,
    this.spo2,
    this.sleepMinutes,
    this.lastSync,
  });

  bool get hasAny =>
      heartRate != null ||
      restingHeartRate != null ||
      hrv != null ||
      spo2 != null ||
      sleepMinutes != null;

  String get sleepLabel {
    if (sleepMinutes == null) return '—';
    final h = sleepMinutes! ~/ 60;
    final m = sleepMinutes! % 60;
    return '${h}h ${m}m';
  }

  HealthVitals copyWith({
    int? heartRate,
    int? restingHeartRate,
    double? hrv,
    double? spo2,
    int? sleepMinutes,
    DateTime? lastSync,
  }) =>
      HealthVitals(
        heartRate: heartRate ?? this.heartRate,
        restingHeartRate: restingHeartRate ?? this.restingHeartRate,
        hrv: hrv ?? this.hrv,
        spo2: spo2 ?? this.spo2,
        sleepMinutes: sleepMinutes ?? this.sleepMinutes,
        lastSync: lastSync ?? this.lastSync,
      );

  Map<String, dynamic> toJson() => {
        'heartRate': heartRate,
        'restingHeartRate': restingHeartRate,
        'hrv': hrv,
        'spo2': spo2,
        'sleepMinutes': sleepMinutes,
        'lastSync': lastSync?.toIso8601String(),
      };

  factory HealthVitals.fromJson(Map<String, dynamic> j) => HealthVitals(
        heartRate: (j['heartRate'] as num?)?.toInt(),
        restingHeartRate: (j['restingHeartRate'] as num?)?.toInt(),
        hrv: (j['hrv'] as num?)?.toDouble(),
        spo2: (j['spo2'] as num?)?.toDouble(),
        sleepMinutes: (j['sleepMinutes'] as num?)?.toInt(),
        lastSync:
            j['lastSync'] != null ? DateTime.parse(j['lastSync'] as String) : null,
      );

  static const empty = HealthVitals();
}
