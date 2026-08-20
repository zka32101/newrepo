/// 小学コレ！理科 共通スペーシング・タイポグラフィスケール
///
/// これまで画面ごとに fontSize / EdgeInsets の数値がバラバラに直書きされていたため、
/// 新規コードではここに定義した定数を使うこと。既存コードの一括置き換えは行っていない
/// （大規模な機械的変更になるため、コンパイル環境での検証なしに実施するのはリスクが高い）。
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

/// 共通フォントサイズスケール
class AppFontSize {
  static const double caption = 11;  // 補足・キャプション（最小サイズ。9px等はNG）
  static const double body = 14;     // 本文
  static const double bodyLarge = 16;
  static const double title = 18;
  static const double titleLarge = 22;
  static const double headline = 28;
}
