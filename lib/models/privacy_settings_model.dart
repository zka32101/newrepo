import 'package:cloud_firestore/cloud_firestore.dart';

/// ユーザーのプライバシー設定
///
/// ランキング表示、通知、データ共有などのプライバシー設定を管理
///
/// 手書きの不変クラス（`freezed`ではなく）。理由: 生成ファイル
/// (`*.freezed.dart` / `*.g.dart`) がリポジトリにコミットされておらず
/// `build_runner` によるコード生成も行われていなかったため、
/// `@freezed` 宣言だけが存在しビルドが常に失敗する状態だった。
/// このクラスは `copyWith`/`toJson`/`fromJson`/`==` を含め、
/// 他の freezed モデルと同等のAPI表面を持つよう手書きで実装している。
class UserPrivacySettings {
  /// ユーザーID
  final String userId;

  /// ランキングに名前を表示するかどうか
  /// false (デフォルト): 匿名表示（「プレイヤー ★123」）
  /// true: 本名表示
  final bool showNameInRanking;

  /// 親向けダッシュボードに進捗を公表
  /// false (デフォルト): 非公表
  /// true: 保護者が確認可能
  final bool showProgressToParents;

  /// アプリ通知を許可
  final bool allowNotifications;

  /// マーケティング通知を許可
  final bool allowMarketingNotifications;

  /// データ分析への参加を許可
  /// （ユーザー行動分析、学習効果測定など）
  final bool allowAnalytics;

  /// 設定更新日時
  final DateTime updatedAt;

  const UserPrivacySettings({
    required this.userId,
    this.showNameInRanking = false,
    this.showProgressToParents = false,
    this.allowNotifications = true,
    this.allowMarketingNotifications = false,
    this.allowAnalytics = false,
    required this.updatedAt,
  });

  /// デフォルト設定（最もプライベート）
  factory UserPrivacySettings.defaultSettings(String userId) {
    return UserPrivacySettings(
      userId: userId,
      showNameInRanking: false,
      showProgressToParents: false,
      allowNotifications: true,
      allowMarketingNotifications: false,
      allowAnalytics: false,
      updatedAt: DateTime.now(),
    );
  }

  factory UserPrivacySettings.fromJson(Map<String, dynamic> json) {
    final rawUpdatedAt = json['updatedAt'];
    final updatedAt = switch (rawUpdatedAt) {
      DateTime d => d,
      Timestamp ts => ts.toDate(),
      String s => DateTime.parse(s),
      _ => DateTime.now(),
    };

    return UserPrivacySettings(
      userId: json['userId'] as String,
      showNameInRanking: json['showNameInRanking'] as bool? ?? false,
      showProgressToParents: json['showProgressToParents'] as bool? ?? false,
      allowNotifications: json['allowNotifications'] as bool? ?? true,
      allowMarketingNotifications:
          json['allowMarketingNotifications'] as bool? ?? false,
      allowAnalytics: json['allowAnalytics'] as bool? ?? false,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'showNameInRanking': showNameInRanking,
        'showProgressToParents': showProgressToParents,
        'allowNotifications': allowNotifications,
        'allowMarketingNotifications': allowMarketingNotifications,
        'allowAnalytics': allowAnalytics,
        'updatedAt': updatedAt.toIso8601String(),
      };

  UserPrivacySettings copyWith({
    String? userId,
    bool? showNameInRanking,
    bool? showProgressToParents,
    bool? allowNotifications,
    bool? allowMarketingNotifications,
    bool? allowAnalytics,
    DateTime? updatedAt,
  }) {
    return UserPrivacySettings(
      userId: userId ?? this.userId,
      showNameInRanking: showNameInRanking ?? this.showNameInRanking,
      showProgressToParents:
          showProgressToParents ?? this.showProgressToParents,
      allowNotifications: allowNotifications ?? this.allowNotifications,
      allowMarketingNotifications:
          allowMarketingNotifications ?? this.allowMarketingNotifications,
      allowAnalytics: allowAnalytics ?? this.allowAnalytics,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPrivacySettings &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          showNameInRanking == other.showNameInRanking &&
          showProgressToParents == other.showProgressToParents &&
          allowNotifications == other.allowNotifications &&
          allowMarketingNotifications == other.allowMarketingNotifications &&
          allowAnalytics == other.allowAnalytics &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode => Object.hash(
        userId,
        showNameInRanking,
        showProgressToParents,
        allowNotifications,
        allowMarketingNotifications,
        allowAnalytics,
        updatedAt,
      );
}

/// ランキング表示用ユーザー情報
///
/// プライバシー設定に基づいて名前を匿名化して返す
class RankingDisplayUser {
  final String userId;
  final String displayName;  // プライバシー設定に基づいて処理済み
  final int score;
  final int rank;
  final int? yesterdayRank;  // 昨日のランク（順位変動計算用）
  final bool isCurrentUser;  // 現在のユーザーかどうか
  final String originalUserName;  // 元の名前（内部用）

  RankingDisplayUser({
    required this.userId,
    required this.displayName,
    required this.score,
    required this.rank,
    this.yesterdayRank,
    required this.isCurrentUser,
    required this.originalUserName,
  });

  /// ランク変動を取得（文字列）
  String getRankChangeDisplay() {
    if (yesterdayRank == null) return '';
    if (rank < yesterdayRank!) {
      return '↑${yesterdayRank! - rank}';  // ランクが上がった（数字は小さくなる）
    } else if (rank > yesterdayRank!) {
      return '↓${rank - yesterdayRank!}';  // ランクが下がった
    }
    return '-';
  }

  /// ランク変動を数値で取得
  int getRankChangeValue() {
    if (yesterdayRank == null) return 0;
    return yesterdayRank! - rank;  // 正=上昇、負=下降
  }
}

/// プライバシー設定ユーティリティ
class PrivacyUtils {
  /// ユーザーの表示名を取得
  ///
  /// プライバシー設定に基づいて、名前または匿名IDを返す
  static String getDisplayName(
    String userId,
    String userName,
    bool showNameInRanking,
    bool isCurrentUser,
  ) {
    // 自分のランクは常に名前を表示
    if (isCurrentUser) {
      return '👤 $userName (あなた)';
    }

    // ランキング名前公表が有効な場合は本名表示
    if (showNameInRanking) {
      return userName;
    }

    // 非公表の場合は匿名ID
    return _generateAnonymousId(userId);
  }

  /// 匿名IDを生成
  ///
  /// ユーザーごとに一貫性のある匿名IDを生成
  /// 同じユーザーは常に同じIDが生成される
  static String _generateAnonymousId(String userId) {
    final hashCode = userId.hashCode.abs();
    final anonymousNumber = (hashCode % 9999) + 1;  // 1-9999
    return 'プレイヤー ★${anonymousNumber.toString().padLeft(4, '0')}';
  }

  /// ランク変動アイコンを取得
  static String getRankChangeIcon(int change) {
    if (change > 0) {
      return '📈';  // 上昇
    } else if (change < 0) {
      return '📉';  // 下降
    }
    return '➡️';  // 変化なし
  }

  /// プライバシーレベルを日本語で取得
  static String getPrivacyLevelLabel(UserPrivacySettings settings) {
    final enabledCount = [
      settings.showNameInRanking,
      settings.showProgressToParents,
      settings.allowNotifications,
      settings.allowMarketingNotifications,
      settings.allowAnalytics,
    ].where((e) => e).length;

    switch (enabledCount) {
      case 0:
        return 'プライベート 🔒';
      case 1:
      case 2:
        return 'やや限定的 🔒🔓';
      case 3:
      case 4:
        return 'やや開放的 🔓';
      case 5:
        return 'すべて公開 🔓✨';
      default:
        return '不明';
    }
  }
}
