// AutoHub Widget Test
// Basic smoke test to verify app launches correctly

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:autohub/main.dart';

void main() {
  testWidgets('AutoHub app launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app builds without errors
    expect(find.byType(MaterialApp), findsOneWidget);

    // Note: Full testing requires Firebase configuration
    // For comprehensive tests, see TESTING_GUIDE.md
  });
}
