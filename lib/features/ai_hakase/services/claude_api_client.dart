import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';

/// Claude API クライアント
class ClaudeApiClient {
  static const String _apiUrl = 'https://api.anthropic.com/v1/messages';
  static const String _model = 'claude-3-5-sonnet-20241022';
  static const int _maxTokens = 1024;

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

      final requestBody = {
        'model': _model,
        'max_tokens': _maxTokens,
        'system': systemPrompt ??
            'あなたは小学3〜6年生向けの理科学習サポートAI「はかせ」です。'
            '子どもにもわかりやすく、楽しく理科を説明してください。',
        'messages': messages,
      };

      // 実装待ち: 実際のHTTP リクエスト
      // HTTP クライアント（http パッケージ）で実装予定
      if (kDebugMode) {
        print('[Claude API Request]');
        print(jsonEncode(requestBody));
      }

      // テスト用のダミーレスポンス
      return 'これは Claude のテストレスポンスです。'
             'APIキーの設定と HTTP リクエストを実装してください。';
    } catch (e) {
      throw ClaudeApiException('Claude API エラー: $e');
    }
  }

  /// API キーの有効性を確認（簡易版）
  bool isApiKeyValid() {
    return apiKey.isNotEmpty && apiKey.length > 10;
  }
}

/// Claude API 例外
class ClaudeApiException implements Exception {
  final String message;
  ClaudeApiException(this.message);

  @override
  String toString() => message;
}
