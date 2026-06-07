import 'package:caloriedesi/providers/service_providers.dart';
import 'package:caloriedesi/screens/integrations/integrations_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Integrations screen renders the source cards', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
        child: const MaterialApp(home: IntegrationsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Health Connect'), findsOneWidget);
    expect(find.text('Fitbit'), findsOneWidget);
    expect(find.text('Apple Health'), findsOneWidget);
  });
}
