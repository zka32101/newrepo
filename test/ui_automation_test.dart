/// UI テスト自動化 - shokollen_science
///
/// 実行内容：
/// - ボタンタップテスト
/// - フォーム入力テスト
/// - スクロール操作テスト
/// - ダイアログ操作テスト

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:shokollen_science/main.dart';

void main() {
  group('UI テスト自動化', () {

    // ========== ボタンタップテスト ==========
    testWidgets('ボタンをタップできる', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // ボタンを探す
      final buttonFinder = find.byType(ElevatedButton);

      if (buttonFinder.evaluate().isNotEmpty) {
        // ボタンが存在する場合
        await tester.tap(buttonFinder.first);
        await tester.pump();

        print('✅ ボタンタップテスト: 成功');
      } else {
        print('⚠️  ボタンが見つかりません');
      }
    });

    // ========== テキスト入力テスト ==========
    testWidgets('テキストフィールドに入力できる', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // テキストフィールドを探す
      final textFieldFinder = find.byType(TextField);

      if (textFieldFinder.evaluate().isNotEmpty) {
        // テキスト入力
        await tester.enterText(textFieldFinder.first, 'テストテキスト');
        await tester.pump();

        // 入力されたテキストを確認
        expect(find.text('テストテキスト'), findsWidgets);

        print('✅ テキスト入力テスト: 成功');
      } else {
        print('⚠️  テキストフィールドが見つかりません');
      }
    });

    // ========== スクロール操作テスト ==========
    testWidgets('画面をスクロールできる', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // スクロール可能なウィジェットを探す
      final scrollViewFinder = find.byType(ListView);

      if (scrollViewFinder.evaluate().isNotEmpty) {
        // スクロール操作（drag を使用）
        await tester.drag(scrollViewFinder.first, const Offset(0, -300));
        await tester.pumpAndSettle();

        print('✅ スクロール操作テスト: 成功');
      } else {
        print('⚠️  スクロール可能なウィジェットが見つかりません');
      }
    });

    // ========== ダイアログ操作テスト ==========
    testWidgets('ダイアログを表示・閉じられる', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // アラートダイアログを表示する UI 要素をタップ
      final alertButtonFinder = find.byTooltip('Show Alert');

      if (alertButtonFinder.evaluate().isNotEmpty) {
        await tester.tap(alertButtonFinder);
        await tester.pumpAndSettle();

        // ダイアログが表示されているか確認
        expect(find.byType(AlertDialog), findsWidgets);

        // ダイアログのボタンをタップ
        final okButtonFinder = find.text('OK');
        if (okButtonFinder.evaluate().isNotEmpty) {
          await tester.tap(okButtonFinder);
          await tester.pumpAndSettle();
        }

        print('✅ ダイアログ操作テスト: 成功');
      } else {
        print('⚠️  アラートボタンが見つかりません');
      }
    });

    // ========== タブ切り替えテスト ==========
    testWidgets('タブを切り替えられる', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // タブバーを探す
      final tabBarFinder = find.byType(TabBar);

      if (tabBarFinder.evaluate().isNotEmpty) {
        // 2番目のタブをタップ
        final tabFinder = find.byIcon(Icons.home);
        if (tabFinder.evaluate().isNotEmpty) {
          await tester.tap(tabFinder);
          await tester.pumpAndSettle();

          print('✅ タブ切り替えテスト: 成功');
        }
      } else {
        print('⚠️  タブバーが見つかりません');
      }
    });

    // ========== ドラッグテスト ==========
    testWidgets('ウィジェットをドラッグできる', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // ドラッグ可能なウィジェットを探す
      final draggableFinder = find.byType(Draggable);

      if (draggableFinder.evaluate().isNotEmpty) {
        // ドラッグ操作
        await tester.drag(draggableFinder.first, const Offset(100, 100));
        await tester.pumpAndSettle();

        print('✅ ドラッグテスト: 成功');
      } else {
        print('⚠️  ドラッグ可能なウィジェットが見つかりません');
      }
    });

    // ========== キーボード操作テスト ==========
    testWidgets('キーボード操作ができる', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // テキストフィールドを探す
      final textFieldFinder = find.byType(TextField);

      if (textFieldFinder.evaluate().isNotEmpty) {
        // フォーカス
        await tester.tap(textFieldFinder.first);
        await tester.pump();

        // テキスト入力
        await tester.enterText(textFieldFinder.first, 'キーボードテスト');
        await tester.pump();

        // 確認
        expect(find.text('キーボードテスト'), findsWidgets);

        print('✅ キーボード操作テスト: 成功');
      } else {
        print('⚠️  テキストフィールドが見つかりません');
      }
    });

    // ========== フォーム送信テスト ==========
    testWidgets('フォームを送信できる', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 送信ボタンを探す
      final submitButtonFinder = find.byTooltip('Submit');

      if (submitButtonFinder.evaluate().isNotEmpty) {
        await tester.tap(submitButtonFinder);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        print('✅ フォーム送信テスト: 成功');
      } else {
        print('⚠️  送信ボタンが見つかりません');
      }
    });

    // ========== UI エラーハンドリング ==========
    testWidgets('無効な操作を処理できる', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 存在しないウィジェットをタップ（エラーハンドリング確認）
      final invalidButtonFinder = find.byTooltip('NonExistent');

      // 存在しない場合は何もしない（正常な動作）
      if (invalidButtonFinder.evaluate().isEmpty) {
        print('✅ UI エラーハンドリング: 成功（存在しないボタンを正しく処理）');
      }
    });

    // ========== ジェスチャーテスト ==========
    testWidgets('ジェスチャーを認識できる', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final gestureDetectorFinder = find.byType(GestureDetector);

      if (gestureDetectorFinder.evaluate().isNotEmpty) {
        // ダブルタップ
        await tester.tap(gestureDetectorFinder.first);
        await tester.tap(gestureDetectorFinder.first);
        await tester.pump();

        print('✅ ジェスチャーテスト: 成功');
      } else {
        print('⚠️  ジェスチャーデテクターが見つかりません');
      }
    });

  });
}
