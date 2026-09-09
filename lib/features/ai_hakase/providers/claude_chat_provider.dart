import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_message.dart';
import '../services/claude_api_client.dart';
import 'dart:convert';

/// Claude APIチャット状態
class ClaudeChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;
  final int monthlyApiCallCount;
  final int monthlyApiCallLimit;
  final DateTime? lastResetDate;

  const ClaudeChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
    this.monthlyApiCallCount = 0,
    this.monthlyApiCallLimit = 100, // デフォルト: 月100回まで
    this.lastResetDate,
  });

  bool get isLimitReached => monthlyApiCallCount >= monthlyApiCallLimit;

  ClaudeChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
    int? monthlyApiCallCount,
    int? monthlyApiCallLimit,
    DateTime? lastResetDate,
  }) {
    return ClaudeChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      monthlyApiCallCount: monthlyApiCallCount ?? this.monthlyApiCallCount,
      monthlyApiCallLimit: monthlyApiCallLimit ?? this.monthlyApiCallLimit,
      lastResetDate: lastResetDate ?? this.lastResetDate,
    );
  }
}

/// Claude チャットNotifier
class ClaudeChatNotifier extends StateNotifier<ClaudeChatState> {
  late ClaudeApiClient _apiClient;
  late SharedPreferences _prefs;
  final String apiKey;

  // セキュリティ: チャット履歴の保存数制限
  static const int _maxStoredMessages = 10;

  ClaudeChatNotifier({required this.apiKey})
      : super(const ClaudeChatState()) {
    _initializeApiClient();
    _loadChatHistory();
  }

  void _initializeApiClient() {
    _apiClient = ClaudeApiClient(apiKey: apiKey);
  }

  /// チャット履歴を読み込み
  Future<void> _loadChatHistory() async {
    try {
      _prefs = await SharedPreferences.getInstance();

      // チャットメッセージ履歴を読み込み
      final chatJson = _prefs.getString('claude_chat_history');
      List<ChatMessage> messages = [];
      if (chatJson != null) {
        final jsonList = jsonDecode(chatJson) as List;
        messages = jsonList
            .map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
            .toList();
      }

      // 月制限情報を読み込み
      final callCount = _prefs.getInt('claude_api_call_count') ?? 0;
      final lastReset = _prefs.getString('claude_api_reset_date');
      final lastResetDate = lastReset != null ? DateTime.parse(lastReset) : null;

      // 月が変わった場合はリセット
      if (lastResetDate != null && !_isSameMonth(lastResetDate, DateTime.now())) {
        await _resetMonthlyLimit();
      } else {
        state = state.copyWith(
          messages: messages,
          monthlyApiCallCount: callCount,
          lastResetDate: lastResetDate,
        );
      }
    } catch (e) {
      state = state.copyWith(error: 'チャット履歴読み込みエラー: $e');
    }
  }

  /// メッセージ送信
  Future<void> sendMessage(String userMessage) async {
    if (state.isLimitReached) {
      state = state.copyWith(
        error: '月の API 呼び出し制限に達しました。'
            '${state.monthlyApiCallLimit}回まで。'
            '来月をお待ちください。',
      );
      return;
    }

    if (!_apiClient.isApiKeyValid()) {
      state = state.copyWith(error: 'Claude API キーが設定されていません。');
      return;
    }

    // ユーザーメッセージを追加
    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: userMessage,
      role: ChatRole.user,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isLoading: true,
      error: null,
    );

    try {
      // Claude API に送信
      final response = await _apiClient.sendMessage(
        userMessage: userMessage,
        conversationHistory: state.messages,
      );

      // AI レスポンスを追加
      final assistantMsg = ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        content: response,
        role: ChatRole.assistant,
        timestamp: DateTime.now(),
      );

      // API呼び出し回数をインクリメント
      final newCount = state.monthlyApiCallCount + 1;
      await _prefs.setInt('claude_api_call_count', newCount);
      await _prefs.setString(
        'claude_api_reset_date',
        DateTime.now().toIso8601String(),
      );

      // チャット履歴を保存
      await _saveChatHistory([...state.messages, userMsg, assistantMsg]);

      state = state.copyWith(
        messages: [...state.messages, userMsg, assistantMsg],
        isLoading: false,
        monthlyApiCallCount: newCount,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'メッセージ送信エラー: $e',
      );
    }
  }

  /// チャット履歴を保存
  /// セキュリティ: 最新10件のメッセージのみ保存し、データ漏洩リスクを軽減
  Future<void> _saveChatHistory(List<ChatMessage> messages) async {
    try {
      // 最新 _maxStoredMessages 件のメッセージのみを保持
      final recentMessages = messages.length > _maxStoredMessages
          ? messages.sublist(messages.length - _maxStoredMessages)
          : messages;

      final jsonList = recentMessages.map((m) => m.toJson()).toList();
      await _prefs.setString('claude_chat_history', jsonEncode(jsonList));
    } catch (e) {
      // ログのみ
    }
  }

  /// 月制限をリセット
  Future<void> _resetMonthlyLimit() async {
    await _prefs.setInt('claude_api_call_count', 0);
    await _prefs.setString(
      'claude_api_reset_date',
      DateTime.now().toIso8601String(),
    );
    state = state.copyWith(
      monthlyApiCallCount: 0,
      lastResetDate: DateTime.now(),
    );
  }

  /// 同じ月かを判定
  bool _isSameMonth(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month;
  }

  /// チャット履歴をクリア
  Future<void> clearChatHistory() async {
    await _prefs.remove('claude_chat_history');
    state = state.copyWith(messages: []);
  }
}

/// Riverpod Provider
final claudeApiKeyProvider = StateProvider<String?>((ref) => null);

final claudeChatProvider =
    StateNotifierProvider<ClaudeChatNotifier, ClaudeChatState>((ref) {
  final apiKey = ref.watch(claudeApiKeyProvider) ?? '';
  return ClaudeChatNotifier(apiKey: apiKey);
});
