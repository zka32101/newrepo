import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yourwish/features/home/widgets/home_section_action.dart';

void main() {
  group('HomeSectionAction', () {
    testWidgets('renders without errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: HomeSectionAction(),
            ),
          ),
        ),
      );

      expect(find.byType(HomeSectionAction), findsOneWidget);
      expect(find.text('📅 今日のアクション'), findsOneWidget);
    });

    testWidgets('displays section divider', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: HomeSectionAction(),
            ),
          ),
        ),
      );

      // セクションヘッダーが表示されることを確認
      expect(find.textContaining('今日のアクション'), findsWidgets);
    });

    testWidgets('contains streak banner icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: HomeSectionAction(),
            ),
          ),
        ),
      );

      // 炎のアイコンが表示されることを確認
      expect(find.textContaining('🔥'), findsOneWidget);
    });
  });
}
