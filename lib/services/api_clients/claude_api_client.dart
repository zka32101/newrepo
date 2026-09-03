import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

/// Claude APIとの通信を管理するクライアント
/// ストリーミングレスポンス、レート制限、エラーハンドリングに対応
class ClaudeApiClient {
  final String apiKey;
  final http.Client httpClient;

  // レート制限用の状態管理
  final List<DateTime> _requestTimestamps = [];
  int _monthlyRequestCount = 0;
  DateTime? _monthlyResetDate;

  ClaudeApiClient({
    required this.apiKey,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  /// ストリーミングメッセージを送信
  /// 回答をトークンごとにストリームで受け取ります
  Stream<String> streamMessage(
    String userMessage,
    List<Map<String, dynamic>> conversationHistory,
  ) async* {
    // レート制限チェック
    if (!_canMakeRequest()) {
      yield 'エラー：月間クエリ上限に達しました。来月をお待ちください。';
      return;
    }

    try {
      // リクエスト履歴を記録
      _recordRequest();

      // メッセージ履歴を構築
      final messages = <Map<String, dynamic>>[
        ...conversationHistory,
        {'role': 'user', 'content': userMessage},
      ];

      // リクエストボディを構築
      final body = {
        'model': 'claude-3-5-sonnet-20241022',
        'max_tokens': 1024,
        'system': ApiConfig.scienceTutorSystemPrompt,
        'messages': messages,
        'stream': true,
      };

      // HTTPリクエストを送信
      final request = http.StreamedRequest(
        'POST',
        Uri.parse('${ApiConfig.claudeApiBaseUrl}/messages'),
      );

      request.headers.addAll({
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
        'anthropic-version': ApiConfig.claudeApiVersion,
      });

      request.write(jsonEncode(body));

      final response = await httpClient.send(request).timeout(
        ApiConfig.apiTimeout,
        onTimeout: () {
          throw TimeoutException('API request timeout');
        },
      );

      if (response.statusCode != 200) {
        yield 'エラー：APIからの応答が正しくありません。もう一度試してください。';
        return;
      }

      // ストリーミングレスポンスを処理
      String buffer = '';

      await for (final chunk in response.stream.transform(utf8.decoder)) {
        buffer += chunk;

        // 改行で区切られた複数のイベントが含まれる可能性がある
        final lines = buffer.split('\n');

        // 最後の不完全な行をバッファに戻す
        buffer = lines.last;

        // 完全な行を処理
        for (int i = 0; i < lines.length - 1; i++) {
          final line = lines[i].trim();

          if (line.isEmpty || !line.startsWith('data: ')) {
            continue;
          }

          try {
            final jsonStr = line.substring(6); // "data: " を削除

            if (jsonStr == '[DONE]') {
              break;
            }

            final json = jsonDecode(jsonStr) as Map<String, dynamic>;

            // content_block_deltaイベント内のテキストデルタを抽出
            if (json['type'] == 'content_block_delta') {
              final delta = json['delta'] as Map<String, dynamic>;
              if (delta['type'] == 'text_delta') {
                final text = delta['text'] as String;
                yield text;
              }
            }
          } catch (e) {
            // JSON解析エラーは無視
            continue;
          }
        }
      }
    } catch (e) {
      yield 'エラーが発生しました：${e.toString()}';
    }
  }

  /// レート制限をチェック
  bool _canMakeRequest() {
    // 月間リセット日のチェック
    final now = DateTime.now();
    if (_monthlyResetDate == null ||
        now.month != _monthlyResetDate!.month ||
        now.year != _monthlyResetDate!.year) {
      // 新しい月なのでリセット
      _monthlyRequestCount = 0;
      _monthlyResetDate = now;
    }

    // 月間クォータをチェック
    if (_monthlyRequestCount >= ApiConfig.monthlyClaudeQuota) {
      return false;
    }

    return true;
  }

  /// リクエストを記録
  void _recordRequest() {
    final now = DateTime.now();
    final oneMinuteAgo = now.subtract(ApiConfig.claudeRateLimitWindow);

    // 1分以上前のリクエストを削除
    _requestTimestamps
        .removeWhere((timestamp) => timestamp.isBefore(oneMinuteAgo));

    // 1分あたりのリクエスト数を制限
    if (_requestTimestamps.length >= ApiConfig.claudeMaxRequestsPerMinute) {
      // 古いリクエストが削除されるまで待つ
      // 実装上は呼び出し側でこれを処理すべき
    }

    _requestTimestamps.add(now);
    _monthlyRequestCount++;
  }

  /// 現在の使用状況を取得
  Map<String, dynamic> getRateLimitStatus() {
    final now = DateTime.now();

    // 月間リセット日の更新
    if (_monthlyResetDate == null ||
        now.month != _monthlyResetDate!.month ||
        now.year != _monthlyResetDate!.year) {
      _monthlyRequestCount = 0;
      _monthlyResetDate = now;
    }

    // 1分あたりのリクエスト数
    final oneMinuteAgo = now.subtract(ApiConfig.claudeRateLimitWindow);
    final requestsThisMinute =
        _requestTimestamps.where((t) => t.isAfter(oneMinuteAgo)).length;

    return {
      'monthlyUsed': _monthlyRequestCount,
      'monthlyLimit': ApiConfig.monthlyClaudeQuota,
      'monthlyRemaining':
          ApiConfig.monthlyClaudeQuota - _monthlyRequestCount,
      'requestsThisMinute': requestsThisMinute,
      'minuteLimit': ApiConfig.claudeMaxRequestsPerMinute,
      'monthlyResetDate': _monthlyResetDate?.toString() ?? 'Not set',
    };
  }

  /// キャッシュをクリア
  void clearCache() {
    _requestTimestamps.clear();
  }

  /// APIクライアントを破棄
  void dispose() {
    httpClient.close();
  }
}
