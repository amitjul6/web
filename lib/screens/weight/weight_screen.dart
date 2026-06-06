import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/app_data_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/section_card.dart';
import '../../widgets/weight_chart.dart';

class WeightScreen extends ConsumerWidget {
  const WeightScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weights = ref.watch(appDataProvider.select((d) => d.weights));
    final goal = ref.watch(appDataProvider.select((d) => d.profile?.weightGoalKg));
    final current = weights.isNotEmpty ? weights.last.weightKg : null;
    final start = weights.isNotEmpty ? weights.first.weightKg : null;
    final change = (current != null && start != null) ? current - start : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Weight')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addWeight(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add weigh-in'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          Row(
            children: [
              Expanded(
                child: _stat('Current',
                    current != null ? '${current.toStringAsFixed(1)} kg' : '—'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _stat('Goal',
                    goal != null ? '${goal.toStringAsFixed(1)} kg' : '—'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _stat(
                  'Change',
                  change != null
                      ? '${change >= 0 ? '+' : ''}${change.toStringAsFixed(1)} kg'
                      : '—',
                  color: change == null
                      ? null
                      : (change <= 0 ? AppTheme.positive : AppTheme.caloriesIn),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SectionCard(
            title: 'Trend',
            child: WeightChart(entries: weights, goalKg: goal),
          ),
          const SizedBox(height: 16),
          if (weights.isNotEmpty)
            SectionCard(
              title: 'History',
              child: Column(
                children: weights.reversed.map((w) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.monitor_weight_outlined),
                    title: Text('${w.weightKg.toStringAsFixed(1)} kg'),
                    subtitle: Text(DateFormat('EEE, MMM d, y').format(w.date)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () =>
                          ref.read(appDataProvider.notifier).deleteWeight(w.id),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, {Color? color}) => Builder(
        builder: (context) => Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              children: [
                Text(value,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: color)),
                const SizedBox(height: 4),
                Text(label,
                    style: TextStyle(color: Theme.of(context).colorScheme.outline)),
              ],
            ),
          ),
        ),
      );

  Future<void> _addWeight(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController(
      text: ref.read(appDataProvider).profile?.weightKg.toStringAsFixed(1) ?? '',
    );
    final value = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add weigh-in'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Weight (kg)'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () =>
                Navigator.pop(context, double.tryParse(controller.text.trim())),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (value != null && value > 0) {
      ref.read(appDataProvider.notifier).addWeight(value);
    }
  }
}
