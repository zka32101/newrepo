import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yourwish/features/home/widgets/home_section_divider.dart';

void main() {
  group('HomeSectionDivider', () {
    testWidgets('renders with provided title', (WidgetTester tester) async {
      const testTitle = '📅 テストセクション';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HomeSectionDivider(testTitle),
          ),
        ),
      );

      expect(find.text(testTitle), findsOneWidget);
    });

    testWidgets('has correct text styling', (WidgetTester tester) async {
      const testTitle = '📅 テストセクション';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HomeSectionDivider(testTitle),
          ),
        ),
      );

      final textWidget = find.byType(Text);
      expect(textWidget, findsOneWidget);

      // TextStyle の確認
      final Text textElement = tester.widget(find.byType(Text));
      expect(textElement.style?.fontSize, 12);
      expect(textElement.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('respects light/dark theme', (WidgetTester tester) async {
      const testTitle = '📅 テストセクション';

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: const Scaffold(
            body: HomeSectionDivider(testTitle),
          ),
        ),
      );

      expect(find.text(testTitle), findsOneWidget);

      // ダークテーマでも確認
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            body: HomeSectionDivider(testTitle),
          ),
        ),
      );

      expect(find.text(testTitle), findsOneWidget);
    });
  });
}
