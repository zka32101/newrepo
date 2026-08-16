import 'package:flutter/foundation.dart';

/// デバッグビルドでのみコンソールに出力するロガー。
/// `print()` を直接使うとリリースビルドでも出力され得るため、
/// エラーログ・デバッグログは必ずこれ経由で出力する。
void logDebug(String message) {
  if (kDebugMode) {
    // ignore: avoid_print
    print(message);
  }
}
