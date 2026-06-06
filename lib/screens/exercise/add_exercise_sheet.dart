import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/exercise_calc.dart';
import '../../data/exercise_catalog.dart';
import '../../models/exercise_type.dart';
import '../../providers/app_data_provider.dart';
import '../../theme/app_theme.dart';

Future<void> showAddExerciseSheet(
    BuildContext context, WidgetRef ref, String dayKey) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _AddExerciseSheet(dayKey: dayKey),
  );
}

class _AddExerciseSheet extends ConsumerStatefulWidget {
  final String dayKey;
  const _AddExerciseSheet({required this.dayKey});

  @override
  ConsumerState<_AddExerciseSheet> createState() => _AddExerciseSheetState();
}

class _AddExerciseSheetState extends ConsumerState<_AddExerciseSheet> {
  ExerciseType _type = kExerciseCatalog.first;
  final _amount = TextEditingController(text: '30');

  @override
  void initState() {
    super.initState();
    _amount.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  double get _weight =>
      ref.read(appDataProvider).profile?.weightKg ?? 70;

  double get _preview {
    final amt = double.tryParse(_amount.text.trim()) ?? 0;
    return computeExerciseCalories(_type, amt, _weight);
  }

  void _save() {
    final amt = double.tryParse(_amount.text.trim());
    if (amt == null || amt <= 0) return;
    ref.read(appDataProvider.notifier).addExercise(
          _type.id,
          _type.name,
          _type.icon,
          _type.inputMode,
          amt,
          computeExerciseCalories(_type, amt, _weight),
          dayKey: widget.dayKey,
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Log exercise',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: kExerciseCatalog.map((t) {
              final selected = t.id == _type.id;
              return ChoiceChip(
                label: Text('${t.icon} ${t.name}'),
                selected: selected,
                onSelected: (_) => setState(() => _type = t),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _amount,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: inputLabelFor(_type.inputMode),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.caloriesOut.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_fire_department,
                    color: AppTheme.caloriesOut),
                const SizedBox(width: 10),
                const Text('Estimated burn'),
                const Spacer(),
                Text('${_preview.round()} kcal',
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.caloriesOut)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: _save, child: const Text('Add to log')),
        ],
      ),
    );
  }
}
