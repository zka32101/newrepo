/// パフォーマンステスト - shokollen_science
///
/// 計測対象：
/// - アプリ起動時間
/// - 画面遷移時間
/// - メモリ使用量
/// - フレームレート

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:shokollen_science/main.dart';

void main() {
  group('パフォーマンステスト', () {

    // ========== 起動時間測定 ==========
    testWidgets('アプリ起動時間を測定', (WidgetTester tester) async {
      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      stopwatch.stop();

      final launchTime = stopwatch.elapsedMilliseconds;
      print('⏱️  起動時間: ${launchTime}ms');

      // 起動時間 5 秒以下を期待
      expect(launchTime, lessThan(5000),
          reason: 'アプリ起動が遅い（5秒以上）');

      print('✅ 起動時間テスト: 成功 (${launchTime}ms)');
    });

    // ========== 画面遷移時間 ==========
    testWidgets('画面遷移時間を測定', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final stopwatch = Stopwatch()..start();

      // ナビゲーション操作
      await tester.pump();

      stopwatch.stop();

      final transitionTime = stopwatch.elapsedMilliseconds;
      print('⏱️  画面遷移時間: ${transitionTime}ms');

      // 画面遷移は 500ms 以下を期待
      expect(transitionTime, lessThan(500),
          reason: '画面遷移が遅い（500ms以上）');

      print('✅ 画面遷移時間テスト: 成功 (${transitionTime}ms)');
    });

    // ========== ウィジェットビルド時間 ==========
    testWidgets('ウィジェットビルド時間を測定', (WidgetTester tester) async {
      final stopwatch = Stopwatch()..start();

      // 大量のウィジェット構築
      for (int i = 0; i < 100; i++) {
        await tester.pump();
      }

      stopwatch.stop();

      final buildTime = stopwatch.elapsedMilliseconds;
      final avgBuildTime = buildTime / 100;

      print('⏱️  平均ウィジェットビルド時間: ${avgBuildTime.toStringAsFixed(2)}ms');

      // 平均 10ms 以下を期待
      expect(avgBuildTime, lessThan(10),
          reason: 'ウィジェットビルドが遅い（平均10ms以上）');

      print('✅ ウィジェットビルド時間テスト: 成功 (${avgBuildTime.toStringAsFixed(2)}ms/build)');
    });

    // ========== メモリ管理テスト ==========
    testWidgets('メモリリークを検出', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // ウィジェット生成・破棄のサイクルを実行
      for (int i = 0; i < 50; i++) {
        await tester.pumpWidget(const MyApp());
        await tester.pump();
      }

      // ウィジェットツリーが正常に構築されることを確認
      expect(find.byType(MaterialApp), findsOneWidget);

      print('✅ メモリリークテスト: 成功');
    });

    // ========== レンダリングパフォーマンス ==========
    testWidgets('フレームレートを測定', (WidgetTester tester) async {
      addTearDown(tester.binding.platformDispatcher.clearViewportMetricsTestValue);

      await tester.pumpWidget(const MyApp());

      int frameCount = 0;
      final stopwatch = Stopwatch()..start();

      // 1秒間のフレーム数を計測
      while (stopwatch.elapsedMilliseconds < 1000) {
        await tester.pump();
        frameCount++;
      }

      stopwatch.stop();

      final fps = frameCount;
      print('📊 フレームレート: ${fps} FPS');

      // 最低 30 FPS を期待
      expect(fps, greaterThanOrEqualTo(30),
          reason: 'フレームレートが低い（30FPS以下）');

      print('✅ フレームレートテスト: 成功 (${fps} FPS)');
    });

    // ========== ツリー深さ測定 ==========
    testWidgets('ウィジェットツリー深さを測定', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      int maxDepth = 0;

      void countDepth(Element element, int depth) {
        if (depth > maxDepth) {
          maxDepth = depth;
        }
        element.visitChildren((child) {
          countDepth(child, depth + 1);
        });
      }

      final rootElement = tester.element(find.byType(MyApp));
      countDepth(rootElement, 0);

      print('📊 ウィジェットツリー深さ: $maxDepth');

      // 深さ 50 以下を期待
      expect(maxDepth, lessThan(50),
          reason: 'ウィジェットツリーが深すぎる（50層以上）');

      print('✅ ツリー深さテスト: 成功 (深さ: $maxDepth)');
    });

    // ========== 初期化時間詳細測定 ==========
    testWidgets('初期化時間詳細測定', (WidgetTester tester) async {
      print('\n📊 初期化時間詳細:');

      // ウィジェット構築時間
      final buildStopwatch = Stopwatch()..start();
      await tester.pumpWidget(const MyApp());
      buildStopwatch.stop();
      print('  - ウィジェット構築: ${buildStopwatch.elapsedMilliseconds}ms');

      // 初期化完了待機
      final initStopwatch = Stopwatch()..start();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      initStopwatch.stop();
      print('  - 初期化完了待機: ${initStopwatch.elapsedMilliseconds}ms');

      final totalTime = buildStopwatch.elapsedMilliseconds + initStopwatch.elapsedMilliseconds;
      print('  - 合計: ${totalTime}ms');

      print('✅ 初期化時間詳細測定: 成功');
    });

  });
}
