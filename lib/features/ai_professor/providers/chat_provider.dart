import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_message_model.dart';
import '../models/chat_session_model.dart';
import '../../../services/api_clients/claude_api_client.dart';
import '../../../services/api_clients/api_config.dart';

/// 現在のチャットセッションのプロバイダー
final currentChatSessionProvider =
    StateNotifierProvider<ChatSessionNotifier, ChatSession>((ref) {
  return ChatSessionNotifier();
});

/// チャットセッション用のStateNotifier
class ChatSessionNotifier extends StateNotifier<ChatSession> {
  ChatSessionNotifier()
      : super(
          ChatSession(
            id: const Uuid().v4(),
            title: '新しいチャット',
            messages: [],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

  /// メッセージを追加
  void addMessage(ChatMessage message) {
    final updatedMessages = [...state.messages, message];
    state = state.copyWith(
      messages: updatedMessages,
      updatedAt: DateTime.now(),
      totalTokens: state.totalTokens + message.tokenCount,
    );
  }

  /// 新しいセッションを作成
  void createNewSession({String title = '新しいチャット'}) {
    state = ChatSession(
      id: const Uuid().v4(),
      title: title,
      messages: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// セッションタイトルを更新
  void updateSessionTitle(String title) {
    state = state.copyWith(
      title: title,
      updatedAt: DateTime.now(),
    );
  }

  /// セッションをクリア
  void clearSession() {
    state = state.copyWith(
      messages: [],
      updatedAt: DateTime.now(),
    );
  }

  /// メッセージ履歴をリセット（新規セッション作成）
  void resetSession() {
    state = ChatSession(
      id: const Uuid().v4(),
      title: '新しいチャット',
      messages: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

/// Claude APIクライアントのプロバイダー
final claudeApiClientProvider = Provider((ref) {
  return ClaudeApiClient(apiKey: ApiConfig.claudeApiKey);
});

/// ストリーミングレスポンスプロバイダー
final streamingResponseProvider =
    StreamProvider.family<String, String>((ref, userMessage) async* {
  final client = ref.watch(claudeApiClientProvider);
  final currentSession = ref.watch(currentChatSessionProvider);

  // メッセージ履歴をAPIフォーマットに変換
  final conversationHistory = currentSession.messages
      .map((msg) => {
            'role': msg.role == ChatRole.user ? 'user' : 'assistant',
            'content': msg.content,
          })
      .toList();

  // ストリーミング応答を出力
  yield* client.streamMessage(userMessage, conversationHistory);
});

/// クエリ送信プロバイダー
final sendMessageProvider =
    FutureProvider.family<void, String>((ref, userMessage) async {
  final client = ref.watch(claudeApiClientProvider);
  final session = ref.read(currentChatSessionProvider.notifier);

  // ユーザーメッセージを追加
  final userMsg = ChatMessage(
    id: const Uuid().v4(),
    content: userMessage,
    role: ChatRole.user,
    timestamp: DateTime.now(),
  );
  session.addMessage(userMsg);

  // アシスタントメッセージを作成（ストリーミング状態）
  final assistantMsg = ChatMessage(
    id: const Uuid().v4(),
    content: '',
    role: ChatRole.assistant,
    timestamp: DateTime.now(),
    isStreaming: true,
  );
  session.addMessage(assistantMsg);

  // ストリーミングレスポンスを取得
  try {
    final responseStream = ref.watch(streamingResponseProvider(userMessage));

    var fullResponse = '';

    responseStream.when(
      data: (token) {
        fullResponse += token;
      },
      error: (error, stackTrace) {
        // エラー処理
        final errorMsg = ChatMessage(
          id: const Uuid().v4(),
          content: '',
          role: ChatRole.assistant,
          timestamp: DateTime.now(),
          error: error.toString(),
        );
        session.addMessage(errorMsg);
      },
      loading: () {
        // ローディング状態
      },
    );

    // 完了後、メッセージを更新
    if (fullResponse.isNotEmpty) {
      final completeMsg = ChatMessage(
        id: assistantMsg.id,
        content: fullResponse,
        role: ChatRole.assistant,
        timestamp: DateTime.now(),
        isStreaming: false,
      );
      // メッセージリストを更新
      final messages = ref.read(currentChatSessionProvider).messages;
      final index = messages.length - 1;
      if (index >= 0) {
        final updatedMessages = [...messages];
        updatedMessages[index] = completeMsg;
        session.state = session.state.copyWith(
          messages: updatedMessages,
          updatedAt: DateTime.now(),
        );
      }
    }
  } catch (e) {
    // エラー処理
    final errorMsg = ChatMessage(
      id: const Uuid().v4(),
      content: 'エラーが発生しました：$e',
      role: ChatRole.assistant,
      timestamp: DateTime.now(),
      error: e.toString(),
    );
    session.addMessage(errorMsg);
  }
});
