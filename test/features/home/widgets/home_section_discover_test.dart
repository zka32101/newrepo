import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yourwish/features/home/widgets/home_section_discover.dart';

void main() {
  group('HomeSectionDiscover', () {
    testWidgets('renders without errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: HomeSectionDiscover(),
            ),
          ),
        ),
      );

      expect(find.byType(HomeSectionDiscover), findsOneWidget);
      expect(find.text('✨ もっと理科をたのしむ'), findsOneWidget);
    });

    testWidgets('displays innovation features section',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: HomeSectionDiscover(),
            ),
          ),
        ),
      );

      expect(find.textContaining('特別チャレンジ'), findsWidgets);
    });

    testWidgets('displays all 8 feature cards', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: HomeSectionDiscover(),
            ),
          ),
        ),
      );

      // 8つの機能カード
      expect(find.textContaining('よそうラボ'), findsWidgets);
      expect(find.textContaining('りかハカセ'), findsWidgets);
      expect(find.textContaining('失敗ラボ'), findsWidgets);
      expect(find.textContaining('親子バトル'), findsWidgets);
      expect(find.textContaining('おうちラボ'), findsWidgets);
      expect(find.textContaining('今夜の空'), findsWidgets);
      expect(find.textContaining('いきものカメラ'), findsWidgets);
      expect(find.textContaining('タイムトラベル'), findsWidgets);
    });

    testWidgets('has sparkle emoji in section header',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: HomeSectionDiscover(),
            ),
          ),
        ),
      );

      expect(find.textContaining('✨'), findsOneWidget);
    });
  });
}
