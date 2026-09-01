import 'dart:convert';
import 'package:http/http.dart' as http;

// ② AIはかせチャット: Claude API呼び出しサービス
class ClaudeServiceException implements Exception {
  final String message;
  ClaudeServiceException(this.message);

  @override
  String toString() => message;
}

class ClaudeService {
  static const String _apiUrl = 'https://api.anthropic.com/v1/messages';
  static const String _model = 'claude-haiku-4-5-20251001';

  // APIキーはソースにハードコードしない。ビルド時に
  // `--dart-define=ANTHROPIC_API_KEY=...` で注入する（本番はサーバー経由の
  // プロキシ越しに呼び出すのが望ましく、これはその移行までの暫定対応）。
  static const String _apiKey =
      String.fromEnvironment('ANTHROPIC_API_KEY');

  static const String _systemPrompt = '''
あなたは「りかハカセ」という小学生の理科の先生キャラクターです。
小学3〜6年生がわかる言葉で、やさしく・楽しく理科の質問に答えてください。

ルール:
- むずかしい言葉を使わないで、できるだけかんたんに
- 「〜だよ！」「〜なんだよ！」など、元気な話し方で
- ふりがなを使ってわかりやすく（例：磁石（じしゃく））
- 答えが長くなりすぎないように（200文字以内を目安に）
- 理科・科学以外の質問には「それはりかハカセには難しいな〜！理科の質問をしてね！」と答えて
- 危険なこと・不適切な内容には答えないで

キャラクター:
- 理科が大好きで明るい博士
- 実験の話が大好き
- 子どもを応援するポジティブな言葉をよく使う
''';

  Future<String> askHaiku(String question) async {
    if (_apiKey.isEmpty) {
      throw ClaudeServiceException(
        'りかハカセは今おやすみ中だよ。少ししてからもう一度聞いてね！',
      );
    }

    try {
      final response = await http
          .post(
            Uri.parse(_apiUrl),
            headers: {
              'Content-Type': 'application/json',
              'x-api-key': _apiKey,
              'anthropic-version': '2023-06-01',
            },
            body: jsonEncode({
              'model': _model,
              'max_tokens': 300,
              'system': _systemPrompt,
              'messages': [
                {'role': 'user', 'content': question},
              ],
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>?;
        if (data == null) {
          throw ClaudeServiceException('APIレスポンスが不正です');
        }

        final content = data['content'] as List?;
        if (content == null || content.isEmpty) {
          throw ClaudeServiceException('APIレスポンスにコンテンツがありません');
        }

        final firstContent = content[0] as Map<String, dynamic>?;
        if (firstContent == null) {
          throw ClaudeServiceException('APIコンテンツが不正です');
        }

        final text = firstContent['text'] as String?;
        if (text == null || text.isEmpty) {
          throw ClaudeServiceException('AIからの応答がありません');
        }

        return text;
      } else if (response.statusCode == 429) {
        throw ClaudeServiceException(
          'ただいまりかハカセはとても混んでいます。少し待ってからもう一度聞いてね！',
        );
      } else {
        throw ClaudeServiceException(
          'エラーが起きたよ（${response.statusCode}）。もう一度試してね！',
        );
      }
    } on ClaudeServiceException {
      rethrow;
    } catch (e) {
      throw ClaudeServiceException('つながらなかったよ。インターネットをかくにんしてね！');
    }
  }
}
