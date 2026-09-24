import 'package:flutter/material.dart';

/// {漢字|ふりがな} 形式のテキストを「漢字（ふりがな）」という
/// 括弧書きのプレーンテキストに変換して表示するウィジェット
///
/// 使い方:
///   FuriganaText('{昆虫|こんちゅう}は{体|からだ}が3つに分かれます')
///   → 「昆虫（こんちゅう）は体（からだ）が3つに分かれます」と表示される
class FuriganaText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  const FuriganaText(this.text, {super.key, this.style, this.textAlign});

  @override
  Widget build(BuildContext context) {
    final base =
        style ??
        DefaultTextStyle.of(
          context,
        ).style.copyWith(fontSize: 14, color: Colors.black87);
    return Text(toPlainText(text), style: base, textAlign: textAlign);
  }

  /// {漢字|ふりがな} → 漢字（ふりがな） に変換する。
  /// Text ウィジェット以外（共有テキストなど）でも使えるよう公開している。
  static String toPlainText(String text) {
    final pattern = RegExp(r'\{([^|{}]+)\|([^}]+)\}');
    return text.replaceAllMapped(
      pattern,
      (m) => '${m.group(1)}（${m.group(2)}）',
    );
  }
}
