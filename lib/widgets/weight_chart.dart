import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/weight_entry.dart';
import '../theme/app_theme.dart';

/// Line chart of weight over time, with an optional goal reference line.
class WeightChart extends StatelessWidget {
  final List<WeightEntry> entries; // ascending by date
  final double? goalKg;

  const WeightChart({super.key, required this.entries, this.goalKg});

  @override
  Widget build(BuildContext context) {
    if (entries.length < 2) {
      return const SizedBox(
        height: 180,
        child: Center(child: Text('Log at least 2 weigh-ins to see a trend')),
      );
    }

    final spots = <FlSpot>[
      for (var i = 0; i < entries.length; i++)
        FlSpot(i.toDouble(), entries[i].weightKg),
    ];

    final weights = entries.map((e) => e.weightKg).toList();
    var minY = weights.reduce((a, b) => a < b ? a : b);
    var maxY = weights.reduce((a, b) => a > b ? a : b);
    if (goalKg != null) {
      minY = minY < goalKg! ? minY : goalKg!;
      maxY = maxY > goalKg! ? maxY : goalKg!;
    }
    final pad = ((maxY - minY) * 0.15).clamp(1.0, 10.0);
    minY -= pad;
    maxY += pad;

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          gridData: const FlGridData(show: true, drawVerticalLine: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 38,
                getTitlesWidget: (v, meta) => Text('${v.round()}',
                    style: const TextStyle(fontSize: 11)),
              ),
            ),
          ),
          extraLinesData: goalKg == null
              ? const ExtraLinesData()
              : ExtraLinesData(horizontalLines: [
                  HorizontalLine(
                    y: goalKg!,
                    color: AppTheme.positive,
                    strokeWidth: 2,
                    dashArray: [6, 4],
                    label: HorizontalLineLabel(
                      show: true,
                      labelResolver: (_) => 'Goal',
                      style: const TextStyle(
                          color: AppTheme.positive, fontSize: 11),
                    ),
                  ),
                ]),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppTheme.seed,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: AppTheme.seed.withOpacity(0.12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
