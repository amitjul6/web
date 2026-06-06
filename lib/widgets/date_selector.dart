import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/date_utils.dart';
import '../providers/app_data_provider.dart';

/// Prev/next day pill bound to [selectedDateProvider]. Future days are blocked.
class DateSelector extends ConsumerWidget {
  const DateSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(selectedDateProvider);
    final notifier = ref.read(selectedDateProvider.notifier);
    final isToday = isSameDay(date, DateTime.now());

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton.filledTonal(
          icon: const Icon(Icons.chevron_left),
          onPressed: () =>
              notifier.state = date.subtract(const Duration(days: 1)),
        ),
        const SizedBox(width: 8),
        Column(
          children: [
            Text(
              friendlyDate(date),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              dayKeyOf(date),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
        const SizedBox(width: 8),
        IconButton.filledTonal(
          icon: const Icon(Icons.chevron_right),
          onPressed: isToday
              ? null
              : () => notifier.state = date.add(const Duration(days: 1)),
        ),
      ],
    );
  }
}
