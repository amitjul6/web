import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_data_provider.dart';
import 'service_providers.dart';

/// Permission status for the step sensor, surfaced to the UI.
enum StepSensorStatus { unknown, granted, denied }

/// Requests ACTIVITY_RECOGNITION, starts the pedometer, and pipes today's
/// sensor steps into AppData. Manual overrides always win in the summary math.
class StepsController extends Notifier<StepSensorStatus> {
  StreamSubscription<int>? _sub;

  @override
  StepSensorStatus build() {
    ref.onDispose(() => _sub?.cancel());
    return StepSensorStatus.unknown;
  }

  Future<void> initialize() async {
    // The step sensor / activity permission plugins are mobile-only; skip on
    // web and desktop so they never throw there.
    if (kIsWeb) {
      state = StepSensorStatus.denied;
      return;
    }
    try {
      final granted = await ref
          .read(permissionServiceProvider)
          .requestActivityPermission();
      state = granted ? StepSensorStatus.granted : StepSensorStatus.denied;
      if (!granted) return;

      final pedometer = ref.read(pedometerServiceProvider);
      _sub?.cancel();
      _sub = pedometer.todaySteps.listen((steps) {
        ref.read(appDataProvider.notifier).setSensorSteps(steps);
      });
      pedometer.start();
    } catch (_) {
      state = StepSensorStatus.denied;
    }
  }
}

final stepsControllerProvider =
    NotifierProvider<StepsController, StepSensorStatus>(StepsController.new);
