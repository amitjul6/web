import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/health_source.dart';
import '../../providers/health_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/section_card.dart';

class IntegrationsScreen extends ConsumerWidget {
  const IntegrationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(healthProvider);
    final notifier = ref.read(healthProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connected apps & devices'),
        actions: [
          if (state.connected.contains(HealthSource.healthConnect))
            IconButton(
              tooltip: 'Sync now',
              icon: state.syncing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.sync),
              onPressed: state.syncing ? null : notifier.sync,
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Text(
            'Connect a source to pull heart rate, HRV, SpO₂, sleep and workouts '
            'from your watch or band.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ...HealthSource.values.map((s) => _SourceCard(
                source: s,
                connected: state.connected.contains(s),
                onConnect: () => _connect(context, ref, s),
                onDisconnect: () => notifier.disconnect(s),
              )),
          const SizedBox(height: 8),
          if (state.vitals.hasAny) _VitalsSummary(state: state),
          const SizedBox(height: 16),
          Text(
            'Note: vitals come from a wearable that writes to the platform above. '
            'Health Connect also receives Samsung Health & Google Fit data. '
            'Fitbit and Apple Health arrive in upcoming updates.',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Theme.of(context).colorScheme.outline),
          ),
        ],
      ),
    );
  }

  Future<void> _connect(
      BuildContext context, WidgetRef ref, HealthSource s) async {
    final result = await ref.read(healthProvider.notifier).connect(s);
    if (!context.mounted) return;
    final msg = switch (result) {
      ConnectResult.connected => 'Connected to ${s.label}',
      ConnectResult.denied =>
        'Permission denied. Grant access in Health Connect to sync.',
      ConnectResult.unsupported =>
        '${s.label} only works in the installed Android app, not the web preview.',
      ConnectResult.notImplemented =>
        '${s.label} support is coming in an upcoming update.',
    };
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

class _SourceCard extends StatelessWidget {
  final HealthSource source;
  final bool connected;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  const _SourceCard({
    required this.source,
    required this.connected,
    required this.onConnect,
    required this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SectionCard(
        child: Row(
          children: [
            Text(source.icon, style: const TextStyle(fontSize: 30)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(source.label,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      if (connected) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.check_circle,
                            size: 16, color: AppTheme.positive),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(source.subtitle,
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.outline)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            connected
                ? TextButton(
                    onPressed: onDisconnect, child: const Text('Disconnect'))
                : FilledButton.tonal(
                    onPressed: onConnect, child: const Text('Connect')),
          ],
        ),
      ),
    );
  }
}

class _VitalsSummary extends StatelessWidget {
  final HealthState state;
  const _VitalsSummary({required this.state});

  @override
  Widget build(BuildContext context) {
    final v = state.vitals;
    return SectionCard(
      title: 'Latest vitals',
      child: Column(
        children: [
          _row('Heart rate', v.heartRate != null ? '${v.heartRate} bpm' : '—'),
          _row('Resting HR',
              v.restingHeartRate != null ? '${v.restingHeartRate} bpm' : '—'),
          _row('HRV', v.hrv != null ? '${v.hrv!.round()} ms' : '—'),
          _row('SpO₂', v.spo2 != null ? '${v.spo2!.round()} %' : '—'),
          _row('Sleep', v.sleepLabel),
        ],
      ),
    );
  }

  Widget _row(String k, String val) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(child: Text(k)),
            Text(val, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      );
}
