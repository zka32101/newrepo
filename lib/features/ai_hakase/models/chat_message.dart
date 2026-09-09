/// メッセージの役割
enum ChatRole {
  user, // ユーザー
  assistant, // AIはかせ
}

extension ChatRoleExt on ChatRole {
  String get label {
    switch (this) {
      case ChatRole.user:
        return 'ユーザー';
      case ChatRole.assistant:
        return 'AIはかせ';
    }
  }

  bool get isUser => this == ChatRole.user;
  bool get isAssistant => this == ChatRole.assistant;
}

/// AIはかせチャットメッセージ
class ChatMessage {
  final String id;
  final String content;
  final ChatRole role;
  final DateTime timestamp;
  final String? imagePath; // Vision用の画像パス（オプション）

  ChatMessage({
    required this.id,
    required this.content,
    required this.role,
    required this.timestamp,
    this.imagePath,
  });

  /// JSON から復元
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String? ?? '',
      content: json['content'] as String? ?? '',
      role: _parseRole(json['role'] as String? ?? 'user'),
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
      imagePath: json['imagePath'] as String?,
    );
  }

  /// JSON に変換
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'role': role.name,
      'timestamp': timestamp.toIso8601String(),
      'imagePath': imagePath,
    };
  }

  static ChatRole _parseRole(String roleStr) {
    return roleStr == 'assistant' ? ChatRole.assistant : ChatRole.user;
  }
}
