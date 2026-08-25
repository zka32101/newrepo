import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yourwish/features/home/widgets/home_section_records.dart';

void main() {
  group('HomeSectionRecords', () {
    testWidgets('renders without errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HomeSectionRecords(),
          ),
        ),
      );

      expect(find.byType(HomeSectionRecords), findsOneWidget);
      expect(find.text('🏆 がんばりの記録'), findsOneWidget);
    });

    testWidgets('displays weekly report card', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HomeSectionRecords(),
          ),
        ),
      );

      expect(find.textContaining('今週のレポート'), findsWidgets);
      expect(find.textContaining('📊'), findsOneWidget);
    });

    testWidgets('displays grade test card', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HomeSectionRecords(),
          ),
        ),
      );

      expect(find.textContaining('学年末まとめテスト'), findsWidgets);
      expect(find.textContaining('🏆'), findsWidgets);
    });

    testWidgets('has trophy emoji in section header',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HomeSectionRecords(),
          ),
        ),
      );

      // Trophy emoji appears in both header and grade test card
      expect(find.textContaining('🏆'), findsWidgets);
    });
  });
}
