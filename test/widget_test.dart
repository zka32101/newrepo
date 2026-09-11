// This is a basic Flutter widget test for shokollen_science app.
// It verifies that the app builds and starts without crashing.

import 'package:flutter_test/flutter_test.dart';

import 'package:shokollen_science/main.dart';

void main() {
  testWidgets('App builds without crashing', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // If we reach here without exceptions, the app built successfully.
    // Verify the MyApp widget is present in the widget tree.
    expect(find.byType(MyApp), findsWidgets);
  });
}
