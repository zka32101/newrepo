/// 友達情報モデル
///
/// 手書きの不変クラス（`freezed`ではなく）。理由: 他のモデル
/// （`ranking_model.dart` / `privacy_settings_model.dart`）と同様に、
/// 生成ファイルがコミットされておらず `build_runner` も実行されて
/// いないため、`copyWith`/`toJson`/`fromJson`/`==` を手書きで実装している。
class Friend {
  /// 友達のユーザーID（Firebase Auth UID）
  final String userId;

  /// 友達のユーザー名（追加時点のスナップショット）
  final String userName;

  /// 友達のアバター URL
  final String? avatarUrl;

  /// 友達に追加した日時
  final DateTime addedAt;

  const Friend({
    required this.userId,
    required this.userName,
    this.avatarUrl,
    required this.addedAt,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    final rawAddedAt = json['addedAt'];
    final addedAt = switch (rawAddedAt) {
      DateTime d => d,
      String s => DateTime.parse(s),
      _ => DateTime.now(),
    };

    return Friend(
      userId: json['userId'] as String,
      userName: json['userName'] as String? ?? '匿名ユーザー',
      avatarUrl: json['avatarUrl'] as String?,
      addedAt: addedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userName': userName,
        'avatarUrl': avatarUrl,
        'addedAt': addedAt.toIso8601String(),
      };

  Friend copyWith({
    String? userId,
    String? userName,
    String? avatarUrl,
    DateTime? addedAt,
  }) {
    return Friend(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Friend &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          userName == other.userName &&
          avatarUrl == other.avatarUrl &&
          addedAt == other.addedAt;

  @override
  int get hashCode => Object.hash(userId, userName, avatarUrl, addedAt);
}
