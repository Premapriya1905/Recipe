import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:recipe_app/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that the app has started.
    expect(find.text('Recipes'), findsOneWidget); // Check for app's title

    // Verify that no recipe is listed initially (or another widget check as per your UI).
    // You might want to check a part of the UI that indicates the recipes are being loaded.

    // For example, checking for the "CircularProgressIndicator" when fetching data
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Trigger a search field interaction, check results, or test other widgets as needed
  });
}
