import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';

/// Claude API クライアント
class ClaudeApiClient {
  static const String _apiUrl = 'https://api.anthropic.com/v1/messages';
  static const String _model = 'claude-3-5-sonnet-20241022';
  static const int _maxTokens = 1024;
  static const int _requestTimeoutSeconds = 30;

  final String apiKey;
  final String? apiBaseUrl; // テスト用

  ClaudeApiClient({
    required this.apiKey,
    this.apiBaseUrl,
  });

  /// メッセージを Claude に送信
  Future<String> sendMessage({
    required String userMessage,
    required List<ChatMessage> conversationHistory,
    String? systemPrompt,
  }) async {
    try {
      if (!isApiKeyValid()) {
        throw ClaudeApiException('API キーが無効です');
      }

      final messages = [
        ...conversationHistory.map((m) => {
          'role': m.role == ChatRole.user ? 'user' : 'assistant',
          'content': m.content,
        }).toList(),
        {
          'role': 'user',
          'content': userMessage,
        },
      ];

      const systemPromptDefault =
          'あなたは小学3〜6年生向けの理科学習サポートAI「はかせ」です。子どもにもわかりやすく、楽しく理科を説明してください。回答は常に日本語で、難しい言葉は避けてください。';

      final requestBody = {
        'model': _model,
        'max_tokens': _maxTokens,
        'system': systemPrompt ?? systemPromptDefault,
        'messages': messages,
      };

      if (kDebugMode) {
        print('[Claude API Request] URL: ${apiBaseUrl ?? _apiUrl}');
      }

      // Claude API へリクエスト送信
      final url = Uri.parse(apiBaseUrl ?? _apiUrl);
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': apiKey,
          'anthropic-version': '2023-06-01',
        },
        body: jsonEncode(requestBody),
      ).timeout(
        Duration(seconds: _requestTimeoutSeconds),
        onTimeout: () => throw ClaudeApiException(
          'Claude API リクエストがタイムアウトしました（${_requestTimeoutSeconds}秒）',
        ),
      );

      if (kDebugMode) {
        print('[Claude API Response] Status: ${response.statusCode}');
      }

      // ステータスコード判定
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        final content = responseData['content'] as List?;
        if (content != null && content.isNotEmpty) {
          final firstContent = content[0] as Map<String, dynamic>;
          return firstContent['text'] as String? ?? 'レスポンスを取得できませんでした';
        }
        throw ClaudeApiException('Claude API レスポンスが不正です');
      } else if (response.statusCode == 401) {
        throw ClaudeApiException('API キーが無効です');
      } else if (response.statusCode == 429) {
        throw ClaudeApiException('API リクエストが多すぎます。しばらく待ってから再度お試しください。');
      } else if (response.statusCode >= 500) {
        throw ClaudeApiException('Claude API サーバーエラーが発生しました。しばらく待ってから再度お試しください。');
      } else {
        throw ClaudeApiException('Claude API エラーが発生しました。リクエストを確認してもう一度お試しください。');
      }
    } catch (e) {
      throw ClaudeApiException('Claude API エラー: $e');
    }
  }

  /// テスト用ダミーレスポンス生成
  String _generateDummyResponse(String userMessage) {
    const response1 = '磁石は、北と南の2つの磁極を持った不思議な石です。同じ磁極同士は反発し、反対の磁極同士は引き付け合いますよ。';
    const response2 = '電気は、目には見えませんが、電子という小さな粒が動くことで作られます。雷も電気の仲間なんですよ。';
    const response3 = '植物は、太陽の光を使って、空気と水から栄養を作ります。これを光合成と言うんです。';
    const response4 = '星は遠くにある大きな火の玉で、太陽も実は星なんですよ。夜の空に見える星は、昼間は太陽に隠れているんです。';

    final responses = {
      '磁石': response1,
      '電気': response2,
      '植物': response3,
      '星': response4,
    };

    for (final entry in responses.entries) {
      if (userMessage.contains(entry.key)) {
        return entry.value;
      }
    }

    return 'いい質問だね！$userMessage について、もっと詳しく教えてほしいです。わからないことは、何度でも聞いてくれていいんですよ。';
  }

  /// API キーの有効性を確認（簡易版）
  bool isApiKeyValid() {
    return apiKey.isNotEmpty && apiKey.startsWith('sk-ant-');
  }
}

/// Claude API 例外
class ClaudeApiException implements Exception {
  final String message;
  ClaudeApiException(this.message);

  @override
  String toString() => message;
}
