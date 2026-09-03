import 'package:flutter_dotenv/flutter_dotenv.dart';

/// API設定クラス - 各APIのエンドポイントとキーを管理
class ApiConfig {
  // Claude API設定
  static String get claudeApiKey => dotenv.env['CLAUDE_API_KEY'] ?? '';
  static const String claudeApiBaseUrl = 'https://api.anthropic.com/v1';
  static const String claudeApiVersion = '2024-06-01';

  // OpenWeatherMap API設定
  static String get openWeatherMapApiKey =>
      dotenv.env['OPENWEATHERMAP_API_KEY'] ?? '';
  static const String openWeatherMapBaseUrl =
      'https://api.openweathermap.org/data/2.5';

  // レート制限設定
  static const int monthlyClaudeQuota = 50; // 月間クエリ数上限
  static const Duration claudeRateLimitWindow = Duration(minutes: 1);
  static const int claudeMaxRequestsPerMinute = 5; // 1分あたり最大5リクエスト

  // タイムアウト設定
  static const Duration apiTimeout = Duration(seconds: 30);

  // キャッシュ設定
  static const Duration weatherCacheDuration = Duration(minutes: 30);
  static const Duration astronomyCacheDuration = Duration(hours: 24);

  // システムプロンプト（科学チューターAI）
  static const String scienceTutorSystemPrompt = '''
あなたは小学3〜6年生向けの経験豊富な理科の先生です。以下の指針に従ってください：

【言語】日本語で回答してください

【対象学年】小学3〜6年生の理解度に合わせた説明

【説明方法】
- 簡潔で分かりやすい言葉を使う
- 難しい用語は言い換えるか、例を挙げて説明する
- 実生活の例を織り交ぜる
- 好奇心を刺激する質問を含める

【構成】
- 冒頭：質問・話題への簡潔な回答
- 本文：丁寧な説明と実例
- 結び：学んだことを実生活に結びつける発展的な質問

【トーン】
- 親しみやすく、励ましの気持ちを込めて
- 間違いを否定せず、学びのチャンスとして捉える

【禁止】
- 長すぎる説明（3段落程度に留める）
- 学年を超えた高度な化学式や物理式
- 政治的・宗教的な内容

科学的な正確さを保ちつつ、子どもの学びを楽しく、わかりやすくサポートしてください。
''';
}
