import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yourwish/features/home/widgets/home_section_recommend.dart';

void main() {
  group('HomeSectionRecommend', () {
    testWidgets('renders without errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: HomeSectionRecommend(),
            ),
          ),
        ),
      );

      expect(find.byType(HomeSectionRecommend), findsOneWidget);
      expect(find.text('🔬 おすすめ・キャラクター'), findsOneWidget);
    });

    testWidgets('displays character collection text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: HomeSectionRecommend(),
            ),
          ),
        ),
      );

      expect(find.textContaining('理科博士コレクション'), findsWidgets);
    });

    testWidgets('has telescope emoji in section header',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: HomeSectionRecommend(),
            ),
          ),
        ),
      );

      expect(find.textContaining('🔬'), findsWidgets);
    });
  });
}
