import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_model.freezed.dart';
part 'chat_message_model.g.dart';

/// チャットメッセージの役割
enum ChatRole {
  @JsonValue('user')
  user,
  @JsonValue('assistant')
  assistant,
}

/// チャットメッセージモデル
@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    /// メッセージID（UUID）
    required String id,

    /// メッセージの内容
    required String content,

    /// メッセージの役割（ユーザーまたはアシスタント）
    required ChatRole role,

    /// メッセージの作成時刻
    required DateTime timestamp,

    /// 画像URL（オプション）
    String? imageUrl,

    /// トークン数（APIレスポンス用）
    @Default(0) int tokenCount,

    /// エラーメッセージ（APIエラー時）
    String? error,

    /// ストリーミング中のフラグ
    @Default(false) bool isStreaming,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}
