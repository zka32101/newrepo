import 'package:freezed_annotation/freezed_annotation.dart';
import 'chat_message_model.dart';

part 'chat_session_model.freezed.dart';
part 'chat_session_model.g.dart';

/// チャットセッションモデル（会話履歴）
@freezed
class ChatSession with _$ChatSession {
  const factory ChatSession({
    /// セッションID
    required String id,

    /// セッションのタイトル
    required String title,

    /// 説明（オプション）
    String? description,

    /// チャットメッセージのリスト
    @Default([]) List<ChatMessage> messages,

    /// セッション作成時刻
    required DateTime createdAt,

    /// セッション更新時刻
    required DateTime updatedAt,

    /// セッションに使用したトークン数
    @Default(0) int totalTokens,

    /// セッションの月間使用クォータ内かどうか
    @Default(true) bool isWithinQuota,
  }) = _ChatSession;

  factory ChatSession.fromJson(Map<String, dynamic> json) =>
      _$ChatSessionFromJson(json);
}
