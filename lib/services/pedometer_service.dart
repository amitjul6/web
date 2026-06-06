import 'dart:async';

import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/date_utils.dart';

/// Streams *today's* step count from the device step counter.
///
/// The Android step counter is cumulative since boot, so we keep a per-day
/// baseline (the raw reading when the day's first sample arrived). On reboot the
/// raw value drops below the baseline; we detect that and re-baseline to avoid
/// negative counts.
class PedometerService {
  PedometerService(this._prefs);

  final SharedPreferences _prefs;
  StreamSubscription<StepCount>? _sub;
  final _controller = StreamController<int>.broadcast();

  static const _kLastRaw = 'ped_last_raw';
  String _baselineKey(String dayKey) => 'ped_base_$dayKey';

  /// Emits today's step total whenever the sensor updates.
  Stream<int> get todaySteps => _controller.stream;

  void start() {
    _sub?.cancel();
    _sub = Pedometer.stepCountStream.listen(
      _onStep,
      onError: (_) {/* sensor unavailable (e.g. emulator) — ignore */},
      cancelOnError: false,
    );
  }

  void _onStep(StepCount event) {
    final raw = event.steps;
    final today = todayKey();
    final baselineKeyToday = _baselineKey(today);

    var baseline = _prefs.getInt(baselineKeyToday);
    final lastRaw = _prefs.getInt(_kLastRaw);

    // First sample of the day: start counting from here.
    baseline ??= raw;

    // Reboot / counter reset: raw fell below our reference → re-baseline.
    if (raw < baseline || (lastRaw != null && raw < lastRaw)) {
      baseline = raw;
    }

    final todayTotal = (raw - baseline).clamp(0, 1 << 31);

    _prefs.setInt(baselineKeyToday, baseline);
    _prefs.setInt(_kLastRaw, raw);

    _controller.add(todayTotal);
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    await _controller.close();
  }
}
