import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/badge_catalog.dart';
import '../../models/daily_goals.dart';
import '../../models/daily_summary.dart';
import '../../widgets/activity_rings.dart';
import '../../providers/app_data_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/steps_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/calorie_ring.dart';
import '../../widgets/date_selector.dart';
import '../../widgets/section_card.dart';
import 'edit_steps_dialog.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(selectedSummaryProvider);
    final goals = ref.watch(appDataProvider.select((d) => d.goals));
    final streak = ref.watch(appDataProvider.select((d) => d.streak));
    final name = ref.watch(authProvider)?.name ??
        ref.watch(appDataProvider.select((d) => d.profile?.name));
    final dayKey = ref.watch(selectedDayKeyProvider);
    final sensorStatus = ref.watch(stepsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, ${(name == null || name.isEmpty) ? 'there' : name.split(' ').first} 👋'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const DateSelector(),
          const SizedBox(height: 16),
          _ActivityRingsCard(summary: summary, goals: goals),
          const SizedBox(height: 16),
          _NetHero(summary: summary, netGoal: goals.netCalorieGoal),
          const SizedBox(height: 16),
          _StepsCard(
            steps: summary.steps,
            goal: goals.stepGoal,
            sensorStatus: sensorStatus,
            onEdit: () => showEditStepsDialog(context, ref, dayKey),
          ),
          const SizedBox(height: 16),
          _EnergyOutCard(summary: summary),
          const SizedBox(height: 16),
          _MacrosCard(summary: summary),
          const SizedBox(height: 16),
          _StreakCard(
            current: streak.currentStreak,
            longest: streak.longestStreak,
            earned: streak.earnedBadgeIds,
          ),
        ],
      ),
    );
  }
}

class _ActivityRingsCard extends StatelessWidget {
  final DailySummary summary;
  final DailyGoals goals;
  const _ActivityRingsCard({required this.summary, required this.goals});

  static const _stepsColor = AppTheme.steps; // indigo
  static const _moveColor = AppTheme.caloriesIn; // orange
  static const _workoutColor = AppTheme.positive; // green

  @override
  Widget build(BuildContext context) {
    final stepP = goals.stepGoal <= 0 ? 0.0 : summary.steps / goals.stepGoal;
    final moveP = goals.activeCalorieGoal <= 0
        ? 0.0
        : summary.activeCalories / goals.activeCalorieGoal;
    final workP = goals.workoutMinutesGoal <= 0
        ? 0.0
        : summary.workoutMinutes / goals.workoutMinutesGoal;

    return SectionCard(
      title: 'Today',
      child: Row(
        children: [
          ActivityRings(
            size: 150,
            stroke: 15,
            rings: [
              RingData(stepP, _stepsColor),
              RingData(moveP, _moveColor),
              RingData(workP, _workoutColor),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _legend(_stepsColor, 'Steps', '${summary.steps}',
                    '${goals.stepGoal}'),
                const SizedBox(height: 12),
                _legend(_moveColor, 'Move', '${summary.activeCalories.round()}',
                    '${goals.activeCalorieGoal} kcal'),
                const SizedBox(height: 12),
                _legend(_workoutColor, 'Workout',
                    '${summary.workoutMinutes.round()}',
                    '${goals.workoutMinutesGoal} min'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legend(Color color, String label, String value, String goal) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label,
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
        Text.rich(TextSpan(children: [
          TextSpan(
              text: value,
              style: TextStyle(fontWeight: FontWeight.w800, color: color)),
          TextSpan(
              text: ' / $goal',
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ])),
      ],
    );
  }
}

class _NetHero extends StatelessWidget {
  final DailySummary summary;
  final int netGoal;
  const _NetHero({required this.summary, required this.netGoal});

  @override
  Widget build(BuildContext context) {
    final net = summary.net.round();
    final inP = summary.caloriesIn;
    final outP = summary.caloriesOut;
    final progress = outP <= 0 ? 0.0 : inP / outP;
    final overEaten = net > 0;

    return SectionCard(
      child: Column(
        children: [
          CalorieRing(
            progress: progress,
            color: overEaten ? AppTheme.caloriesIn : AppTheme.positive,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$net',
                    style: const TextStyle(
                        fontSize: 40, fontWeight: FontWeight.w800)),
                const Text('net kcal'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            overEaten
                ? 'Surplus of $net kcal today'
                : 'Deficit of ${net.abs()} kcal today',
            style: TextStyle(
              color: overEaten ? AppTheme.caloriesIn : AppTheme.positive,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: 'Eaten',
                  value: '${inP.round()}',
                  unit: 'kcal',
                  color: AppTheme.caloriesIn,
                  icon: Icons.restaurant,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MiniStat(
                  label: 'Burned',
                  value: '${outP.round()}',
                  unit: 'kcal',
                  color: AppTheme.caloriesOut,
                  icon: Icons.local_fire_department,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;
  final IconData icon;
  const _MiniStat({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 6),
          Text.rich(TextSpan(children: [
            TextSpan(
                text: value,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w800)),
            TextSpan(text: ' $unit', style: const TextStyle(fontSize: 12)),
          ])),
        ],
      ),
    );
  }
}

class _StepsCard extends StatelessWidget {
  final int steps;
  final int goal;
  final StepSensorStatus sensorStatus;
  final VoidCallback onEdit;
  const _StepsCard({
    required this.steps,
    required this.goal,
    required this.sensorStatus,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final progress = goal <= 0 ? 0.0 : steps / goal;
    return SectionCard(
      title: 'Steps',
      trailing: TextButton.icon(
        onPressed: onEdit,
        icon: const Icon(Icons.edit, size: 16),
        label: const Text('Override'),
      ),
      child: Row(
        children: [
          CalorieRing(
            progress: progress,
            color: AppTheme.steps,
            size: 110,
            stroke: 11,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('👟', style: TextStyle(fontSize: 20)),
                Text('${(progress * 100).clamp(0, 999).round()}%',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$steps',
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.w800)),
                Text('of $goal step goal',
                    style: TextStyle(color: Theme.of(context).colorScheme.outline)),
                const SizedBox(height: 6),
                if (sensorStatus == StepSensorStatus.denied)
                  const Text(
                    'Sensor off — use Override',
                    style: TextStyle(
                        color: AppTheme.warning,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EnergyOutCard extends StatelessWidget {
  final DailySummary summary;
  const _EnergyOutCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Calories burned',
      child: Column(
        children: [
          _row('Base (BMR)', summary.bmr, Icons.bedtime_outlined),
          _row('Steps', summary.stepCalories, Icons.directions_walk),
          _row('Exercise', summary.exerciseCalories, Icons.fitness_center),
          const Divider(height: 24),
          _row('Total burned', summary.caloriesOut, Icons.local_fire_department,
              bold: true),
        ],
      ),
    );
  }

  Widget _row(String label, double kcal, IconData icon, {bool bold = false}) {
    final style = TextStyle(
      fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
      fontSize: bold ? 16 : 14,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.caloriesOut),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: style)),
          Text('${kcal.round()} kcal', style: style),
        ],
      ),
    );
  }
}

class _MacrosCard extends StatelessWidget {
  final DailySummary summary;
  const _MacrosCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Macros eaten',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _macro('Protein', summary.proteinG, const Color(0xFF3949AB)),
          _macro('Carbs', summary.carbsG, const Color(0xFFEF6C00)),
          _macro('Fat', summary.fatG, const Color(0xFF8E24AA)),
        ],
      ),
    );
  }

  Widget _macro(String label, double grams, Color color) => Column(
        children: [
          Text('${grams.round()} g',
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 4),
          Text(label),
        ],
      );
}

class _StreakCard extends StatelessWidget {
  final int current;
  final int longest;
  final Set<String> earned;
  const _StreakCard({
    required this.current,
    required this.longest,
    required this.earned,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Streak & badges',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🔥', style: TextStyle(fontSize: 30)),
              const SizedBox(width: 10),
              Text('$current-day streak',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700)),
              const Spacer(),
              Text('Best: $longest',
                  style: TextStyle(color: Theme.of(context).colorScheme.outline)),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: kBadgeCatalog.map((b) {
              final got = earned.contains(b.id);
              return Opacity(
                opacity: got ? 1 : 0.35,
                child: Tooltip(
                  message: '${b.name}\n${b.description}',
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(b.icon, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 6),
                      Text(b.name,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
