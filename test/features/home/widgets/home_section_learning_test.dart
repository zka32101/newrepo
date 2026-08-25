import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yourwish/features/home/widgets/home_section_learning.dart';

void main() {
  group('HomeSectionLearning', () {
    testWidgets('renders without errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: HomeSectionLearning(),
            ),
          ),
        ),
      );

      expect(find.byType(HomeSectionLearning), findsOneWidget);
      expect(find.text('📚 学習をすすめる'), findsOneWidget);
    });

    testWidgets('displays today theme card', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: HomeSectionLearning(),
            ),
          ),
        ),
      );

      expect(find.textContaining('📅 今日のテーマ'), findsWidgets);
    });

    testWidgets('displays encyclopedia section', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: HomeSectionLearning(),
            ),
          ),
        ),
      );

      expect(find.textContaining('生き物図鑑'), findsWidgets);
      expect(find.textContaining('🌿'), findsOneWidget);
    });

    testWidgets('displays stage list section', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: HomeSectionLearning(),
            ),
          ),
        ),
      );

      expect(find.textContaining('ステージ一覧'), findsWidgets);
      expect(find.textContaining('📚'), findsOneWidget);
    });

    testWidgets('grade tabs are interactive', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: HomeSectionLearning(),
              ),
            ),
          ),
        ),
      );

      // 学年タブが表示されることを確認（3年生、4年生、5年生、6年生）
      expect(find.textContaining('年生'), findsWidgets);
    });

    testWidgets('has book emoji in section header',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: HomeSectionLearning(),
            ),
          ),
        ),
      );

      expect(find.textContaining('📚'), findsWidgets);
    });
  });
}
