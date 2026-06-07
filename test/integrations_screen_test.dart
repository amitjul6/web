import 'package:caloriedesi/providers/service_providers.dart';
import 'package:caloriedesi/screens/integrations/integrations_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('source card subtitle lays out wide (not vertical)',
      (tester) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
        child: const MaterialApp(home: IntegrationsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    final size =
        tester.getSize(find.text('Google Fit, Samsung Health & more (Android)'));
    // Broken layout collapses the text to ~1 char wide + very tall.
    expect(size.width, greaterThan(150),
        reason: 'subtitle should be wide, got $size');
    expect(size.height, lessThan(80),
        reason: 'subtitle should be short, got $size');
  });
}
