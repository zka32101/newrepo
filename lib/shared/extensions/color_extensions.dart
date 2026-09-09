import 'package:flutter/material.dart';

/// Color クラスの互換性拡張
extension ColorExtensions on Color {
  /// withOpacity の互換性メソッド
  /// 古い API との互換性のために提供
  Color withOpacity(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0, 'opacity must be between 0.0 and 1.0');
    return withAlpha((opacity * 255).toInt());
  }
}
