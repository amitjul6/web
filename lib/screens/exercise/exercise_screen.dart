import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_data_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/date_selector.dart';
import 'add_exercise_sheet.dart';

class ExerciseScreen extends ConsumerWidget {
  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(selectedDayLogProvider);
    final dayKey = ref.watch(selectedDayKeyProvider);
    final notifier = ref.read(appDataProvider.notifier);
    final exercises = day.exercises;

    return Scaffold(
      appBar: AppBar(title: const Text('Exercise')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAddExerciseSheet(context, ref, dayKey),
        icon: const Icon(Icons.add),
        label: const Text('Log exercise'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: DateSelector(),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.caloriesOut.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_fire_department,
                    color: AppTheme.caloriesOut),
                const SizedBox(width: 10),
                const Text('Burned from exercise',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const Spacer(),
                Text('${day.exerciseCalories.round()} kcal',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          Expanded(
            child: exercises.isEmpty
                ? const _Empty()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                    itemCount: exercises.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final e = exercises[i];
                      return Dismissible(
                        key: ValueKey(e.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: AppTheme.warning,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) =>
                            notifier.removeExercise(e.id, dayKey: dayKey),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Text(e.icon,
                              style: const TextStyle(fontSize: 26)),
                          title: Text(e.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text(e.amountLabel),
                          trailing: Text('${e.caloriesBurned.round()} kcal',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.caloriesOut)),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🏃', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text('No exercise logged',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          const Text('Tap “Log exercise” to add one'),
        ],
      ),
    );
  }
}
