import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants.dart';
import 'providers/app_data_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login/login_screen.dart';
import 'screens/main_scaffold.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'theme/app_theme.dart';

class CalorieDesiApp extends ConsumerWidget {
  const CalorieDesiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: K.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: const _Gate(),
    );
  }
}

/// Routes between Login → Onboarding → Main based on auth + profile state.
class _Gate extends ConsumerWidget {
  const _Gate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final onboarded = ref.watch(appDataProvider.select((d) => d.onboarded));

    if (user == null) return const LoginScreen();
    if (!onboarded) return const OnboardingScreen();
    return const MainScaffold();
  }
}
