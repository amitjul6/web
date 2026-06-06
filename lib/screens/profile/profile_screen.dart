import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/badge_catalog.dart';
import '../../models/daily_goals.dart';
import '../../providers/app_data_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/section_card.dart';
import 'profile_edit_sheet.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(appDataProvider.select((d) => d.profile));
    final goals = ref.watch(appDataProvider.select((d) => d.goals));
    final streak = ref.watch(appDataProvider.select((d) => d.streak));

    if (profile == null) {
      return const Scaffold(body: Center(child: Text('No profile')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => showProfileEditSheet(context, ref),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: (profile.photoUrl != null)
                    ? NetworkImage(profile.photoUrl!)
                    : null,
                child: profile.photoUrl == null
                    ? const Icon(Icons.person, size: 32)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.name?.isNotEmpty == true ? profile.name! : 'Guest',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700)),
                    if (profile.email != null)
                      Text(profile.email!,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.outline)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SectionCard(
            title: 'Body & metabolism',
            child: Column(
              children: [
                _kv('Age', '${profile.age} yrs'),
                _kv('Sex', profile.sex.label),
                _kv('Height', '${profile.heightCm.toStringAsFixed(0)} cm'),
                _kv('Weight', '${profile.weightKg.toStringAsFixed(1)} kg'),
                _kv('Activity', profile.activityLevel.label),
                const Divider(height: 20),
                _kv('BMR', '${profile.bmr.round()} kcal/day'),
                _kv('TDEE (maintenance)', '${profile.tdee.round()} kcal/day'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SectionCard(
            title: 'Daily goals',
            trailing: TextButton(
              onPressed: () => _editGoals(context, ref, goals),
              child: const Text('Edit'),
            ),
            child: Column(
              children: [
                _kv('Step goal', '${goals.stepGoal} steps'),
                _kv('Net calorie target', '${goals.netCalorieGoal} kcal'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SectionCard(
            title: 'Badges (${streak.earnedBadgeIds.length}/${kBadgeCatalog.length})',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: kBadgeCatalog.map((b) {
                final got = streak.earnedBadgeIds.contains(b.id);
                return Opacity(
                  opacity: got ? 1 : 0.3,
                  child: Chip(
                    avatar: Text(b.icon),
                    label: Text(b.name),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => ref.read(authProvider.notifier).signOut(),
            icon: const Icon(Icons.logout),
            label: const Text('Sign out'),
          ),
        ],
      ),
    );
  }

  Widget _kv(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Expanded(child: Text(k)),
            Text(v, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      );

  Future<void> _editGoals(
      BuildContext context, WidgetRef ref, DailyGoals goals) async {
    final stepC = TextEditingController(text: goals.stepGoal.toString());
    final calC = TextEditingController(text: goals.netCalorieGoal.toString());
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Daily goals'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: stepC,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Step goal'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: calC,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Net calorie target'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Save')),
        ],
      ),
    );
    if (saved == true) {
      ref.read(appDataProvider.notifier).saveGoals(
            goals.copyWith(
              stepGoal: int.tryParse(stepC.text) ?? goals.stepGoal,
              netCalorieGoal:
                  int.tryParse(calC.text) ?? goals.netCalorieGoal,
            ),
          );
    }
  }
}
