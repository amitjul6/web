import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/enums.dart';
import '../../models/profile.dart';
import '../../providers/app_data_provider.dart';
import '../../providers/auth_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  Sex _sex = Sex.male;
  ActivityLevel _activity = ActivityLevel.light;
  DateTime _birthDate = DateTime(1995, 1, 1);
  final _height = TextEditingController(text: '170');
  final _weight = TextEditingController(text: '70');
  final _goal = TextEditingController();

  @override
  void dispose() {
    _height.dispose();
    _weight.dispose();
    _goal.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  Future<void> _finish() async {
    final height = double.tryParse(_height.text);
    final weight = double.tryParse(_weight.text);
    if (height == null || height < 80 || height > 250) {
      _err('Enter a valid height in cm (80–250)');
      return;
    }
    if (weight == null || weight < 25 || weight > 350) {
      _err('Enter a valid weight in kg (25–350)');
      return;
    }
    final user = ref.read(authProvider);
    final profile = Profile(
      name: user?.name,
      email: user?.email,
      photoUrl: user?.photoUrl,
      sex: _sex,
      birthDate: _birthDate,
      heightCm: height,
      weightKg: weight,
      activityLevel: _activity,
      weightGoalKg: double.tryParse(_goal.text),
    );
    final notifier = ref.read(appDataProvider.notifier);
    await notifier.saveProfile(profile, completeOnboarding: true);
    await notifier.addWeight(weight);
  }

  void _err(String msg) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About you')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'We use these to estimate your calories burned and daily targets.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          _label('Sex'),
          SegmentedButton<Sex>(
            segments: Sex.values
                .map((s) => ButtonSegment(value: s, label: Text(s.label)))
                .toList(),
            selected: {_sex},
            onSelectionChanged: (v) => setState(() => _sex = v.first),
          ),
          const SizedBox(height: 20),
          _label('Date of birth'),
          OutlinedButton.icon(
            onPressed: _pickBirthDate,
            icon: const Icon(Icons.cake_outlined),
            label: Text(
              '${_birthDate.year}-${_birthDate.month.toString().padLeft(2, '0')}-${_birthDate.day.toString().padLeft(2, '0')}',
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _numField(_height, 'Height (cm)')),
              const SizedBox(width: 12),
              Expanded(child: _numField(_weight, 'Weight (kg)')),
            ],
          ),
          const SizedBox(height: 20),
          _label('Activity level'),
          RadioGroup<ActivityLevel>(
            groupValue: _activity,
            onChanged: (v) => setState(() => _activity = v!),
            child: Column(
              children: ActivityLevel.values
                  .map(
                    (a) => RadioListTile<ActivityLevel>(
                      value: a,
                      title: Text(a.label),
                      subtitle: Text(a.description),
                      contentPadding: EdgeInsets.zero,
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          _numField(_goal, 'Goal weight (kg) — optional'),
          const SizedBox(height: 28),
          FilledButton(
            onPressed: _finish,
            child: const Text('Get started'),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      );

  Widget _numField(TextEditingController c, String label) => TextField(
        controller: c,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(labelText: label),
      );
}
