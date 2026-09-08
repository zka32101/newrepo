/// セキュリティテスト - shokollen_science
///
/// 実装済みの機能に対してのみ、実際にアサーションで検証する。
/// 本アプリには認証・DB・ディープリンクは存在しないため、それらを
/// 装った「実装依存」「〜を想定」といった無検証テストは置かない
/// （実体のない検証は誤った安心感を生むため）。
///
/// 検査項目：
/// - lib/ 配下にハードコードされたAPIキー・シークレットがないか
/// - 署名用シークレット（key.properties / keystore.jks）が
///   誤ってコミットされていないか
/// - 不正な入力値でアプリがクラッシュしないか
/// - AndroidManifest.xml で不要なコンポーネントが export されていないか

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:shokollen_science/main.dart';

void main() {
  group('セキュリティテスト', () {
    test('lib/ にハードコードされたAPIキー・シークレットが存在しない', () {
      final libDir = Directory('lib');
      final secretPattern = RegExp(
        r'sk-ant-[a-zA-Z0-9\-_]{10,}'
        r'|sk-[a-zA-Z0-9]{20,}'
        r'|AIza[0-9A-Za-z\-_]{35}'
        r'''|["']?[Aa]pi[_-]?[Kk]ey["']?\s*[:=]\s*["'][A-Za-z0-9]{16,}["']''',
      );

      final offenders = <String>[];
      for (final entity in libDir.listSync(recursive: true)) {
        if (entity is File && entity.path.endsWith('.dart')) {
          final content = entity.readAsStringSync();
          if (secretPattern.hasMatch(content)) {
            offenders.add(entity.path);
          }
        }
      }

      expect(
        offenders,
        isEmpty,
        reason: 'ハードコードされたシークレットの疑いがあるファイル: $offenders',
      );
    });

    test('署名用シークレットファイルがワーキングツリーに残っていない', () {
      // android/key.properties・keystore.jks は .gitignore 対象で
      // リポジトリに追跡されるべきではない（過去に誤ってコミットされた
      // 実績があるため回帰検知として残す）。
      for (final path in ['android/key.properties', 'android/keystore.jks']) {
        expect(
          File(path).existsSync(),
          isFalse,
          reason: '$path が誤ってコミット/配置されている可能性があります',
        );
      }
    });

    testWidgets('不正な入力値でアプリがクラッシュしない', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final textFieldFinder = find.byType(TextField);
      if (textFieldFinder.evaluate().isNotEmpty) {
        for (final payload in [
          "'; DROP TABLE users; --",
          '<script>alert("XSS")</script>',
          '../../etc/passwd',
        ]) {
          await tester.enterText(textFieldFinder.first, payload);
          await tester.pump();

          expect(tester.takeException(), isNull);
          expect(find.byType(MaterialApp), findsWidgets);
        }
      }
    });

    test('AndroidManifest.xml で不要なコンポーネントが export されていない', () {
      final manifest =
          File('android/app/src/main/AndroidManifest.xml').readAsStringSync();

      // MainActivity（ランチャー起動に必須）以外に
      // android:exported="true" のコンポーネントがないことを確認する。
      final exportedTrueCount =
          RegExp('android:exported="true"').allMatches(manifest).length;

      expect(
        exportedTrueCount,
        lessThanOrEqualTo(1),
        reason: 'MainActivity 以外に exported="true" のコンポーネントが見つかりました',
      );
    });
  });
}
