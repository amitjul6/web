import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_data_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/date_selector.dart';
import 'food_search_screen.dart';

class FoodLogScreen extends ConsumerWidget {
  const FoodLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(selectedDayLogProvider);
    final dayKey = ref.watch(selectedDayKeyProvider);
    final notifier = ref.read(appDataProvider.notifier);
    final foods = day.foods;

    return Scaffold(
      appBar: AppBar(title: const Text('Food log')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => FoodSearchScreen(dayKey: dayKey)),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add food'),
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
              color: AppTheme.caloriesIn.withOpacity(0.10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.restaurant, color: AppTheme.caloriesIn),
                const SizedBox(width: 10),
                const Text('Total eaten',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const Spacer(),
                Text('${day.caloriesIn.round()} kcal',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          Expanded(
            child: foods.isEmpty
                ? const _Empty()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                    itemCount: foods.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final e = foods[i];
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
                            notifier.removeFood(e.id, dayKey: dayKey),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(e.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text(
                              '${e.portionLabel} · ${e.caloriesPerPortion.round()} kcal each'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () => notifier.changeFoodQty(e.id, -1,
                                    dayKey: dayKey),
                              ),
                              Text(_qty(e.quantity),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () => notifier.changeFoodQty(e.id, 1,
                                    dayKey: dayKey),
                              ),
                              SizedBox(
                                width: 64,
                                child: Text('${e.totalCalories.round()}',
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800)),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  static String _qty(double q) =>
      q == q.roundToDouble() ? q.toInt().toString() : q.toString();
}

class _Empty extends StatelessWidget {
  const _Empty();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🍽️', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text('No food logged for this day',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          const Text('Tap “Add food” to search the library'),
        ],
      ),
    );
  }
}
