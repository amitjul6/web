import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/enums.dart';
import '../../models/profile.dart';
import '../../providers/app_data_provider.dart';

Future<void> showProfileEditSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => const _ProfileEditSheet(),
  );
}

class _ProfileEditSheet extends ConsumerStatefulWidget {
  const _ProfileEditSheet();

  @override
  ConsumerState<_ProfileEditSheet> createState() => _ProfileEditSheetState();
}

class _ProfileEditSheetState extends ConsumerState<_ProfileEditSheet> {
  late Profile _p;
  late TextEditingController _height;
  late TextEditingController _weight;
  late TextEditingController _goal;

  @override
  void initState() {
    super.initState();
    _p = ref.read(appDataProvider).profile!;
    _height = TextEditingController(text: _p.heightCm.toStringAsFixed(0));
    _weight = TextEditingController(text: _p.weightKg.toStringAsFixed(1));
    _goal = TextEditingController(text: _p.weightGoalKg?.toStringAsFixed(1) ?? '');
  }

  @override
  void dispose() {
    _height.dispose();
    _weight.dispose();
    _goal.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final height = double.tryParse(_height.text) ?? _p.heightCm;
    final weight = double.tryParse(_weight.text) ?? _p.weightKg;
    final updated = _p.copyWith(
      heightCm: height,
      weightKg: weight,
      weightGoalKg: double.tryParse(_goal.text),
    );
    final notifier = ref.read(appDataProvider.notifier);
    await notifier.saveProfile(updated);
    // Record a weigh-in if the weight changed.
    if (weight != _p.weightKg) await notifier.addWeight(weight);
    if (mounted) Navigator.pop(context);
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
          Text('Edit profile',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          SegmentedButton<Sex>(
            segments: Sex.values
                .map((s) => ButtonSegment(value: s, label: Text(s.label)))
                .toList(),
            selected: {_p.sex},
            onSelectionChanged: (v) => setState(() => _p = _p.copyWith(sex: v.first)),
          ),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
              child: TextField(
                controller: _height,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Height (cm)'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _weight,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
              ),
            ),
          ]),
          const SizedBox(height: 16),
          TextField(
            controller: _goal,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Goal weight (kg)'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<ActivityLevel>(
            initialValue: _p.activityLevel,
            decoration: const InputDecoration(labelText: 'Activity level'),
            items: ActivityLevel.values
                .map((a) => DropdownMenuItem(value: a, child: Text(a.label)))
                .toList(),
            onChanged: (v) =>
                setState(() => _p = _p.copyWith(activityLevel: v)),
          ),
          const SizedBox(height: 20),
          FilledButton(onPressed: _save, child: const Text('Save')),
        ],
      ),
    );
  }
}
