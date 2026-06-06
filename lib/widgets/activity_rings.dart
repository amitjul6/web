import 'dart:math' as math;

import 'package:flutter/material.dart';

/// One ring's data: progress (0..∞, clamped to a full turn) and its color.
class RingData {
  final double progress;
  final Color color;
  const RingData(this.progress, this.color);
}

/// Apple-Watch-style concentric activity rings. [rings] are drawn outermost
/// first. An optional [center] widget sits in the middle.
class ActivityRings extends StatelessWidget {
  final List<RingData> rings;
  final double size;
  final double stroke;
  final double gap;
  final Widget? center;

  const ActivityRings({
    super.key,
    required this.rings,
    this.size = 180,
    this.stroke = 16,
    this.gap = 6,
    this.center,
  });

  @override
  Widget build(BuildContext context) {
    final track = Theme.of(context).colorScheme.surfaceContainerHighest;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingsPainter(
          rings: rings,
          track: track,
          stroke: stroke,
          gap: gap,
        ),
        child: center == null ? null : Center(child: center),
      ),
    );
  }
}

class _RingsPainter extends CustomPainter {
  final List<RingData> rings;
  final Color track;
  final double stroke;
  final double gap;

  _RingsPainter({
    required this.rings,
    required this.track,
    required this.stroke,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    var radius = (size.width - stroke) / 2;

    for (final ring in rings) {
      final trackPaint = Paint()
        ..color = ring.color.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawCircle(center, radius, trackPaint);

      final sweep = 2 * math.pi * ring.progress.clamp(0.0, 1.0);
      final arcPaint = Paint()
        ..color = ring.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        sweep,
        false,
        arcPaint,
      );

      radius -= stroke + gap;
      if (radius <= stroke / 2) break;
    }
  }

  @override
  bool shouldRepaint(_RingsPainter old) =>
      old.rings != rings ||
      old.track != track ||
      old.stroke != stroke ||
      old.gap != gap;
}
