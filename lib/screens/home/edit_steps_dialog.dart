import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_data_provider.dart';

/// Lets the user manually set or clear today's step count.
Future<void> showEditStepsDialog(
    BuildContext context, WidgetRef ref, String dayKey) async {
  final data = ref.read(appDataProvider);
  final record = data.day(dayKey).steps;
  final controller = TextEditingController(
    text: record.isManual ? record.manualOverride.toString() : '',
  );

  await showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Override steps'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sensor reading: ${record.sensorSteps} steps'),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Manual step count',
                hintText: 'e.g. 8000',
              ),
            ),
          ],
        ),
        actions: [
          if (record.isManual)
            TextButton(
              onPressed: () {
                ref.read(appDataProvider.notifier).setManualSteps(null, dayKey: dayKey);
                Navigator.pop(context);
              },
              child: const Text('Use sensor'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(controller.text.trim());
              if (value != null && value >= 0) {
                ref
                    .read(appDataProvider.notifier)
                    .setManualSteps(value, dayKey: dayKey);
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
