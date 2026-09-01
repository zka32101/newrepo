import 'package:freezed_annotation/freezed_annotation.dart';

part 'privacy_settings_model.freezed.dart';
part 'privacy_settings_model.g.dart';

/// ユーザーのプライバシー設定
///
/// ランキング表示、通知、データ共有などのプライバシー設定を管理
@freezed
class UserPrivacySettings with _$UserPrivacySettings {
  const factory UserPrivacySettings({
    /// ユーザーID
    required String userId,

    /// ランキングに名前を表示するかどうか
    /// false (デフォルト): 匿名表示（「プレイヤー ★123」）
    /// true: 本名表示
    @Default(false) bool showNameInRanking,

    /// 親向けダッシュボードに進捗を公表
    /// false (デフォルト): 非公表
    /// true: 保護者が確認可能
    @Default(false) bool showProgressToParents,

    /// アプリ通知を許可
    @Default(true) bool allowNotifications,

    /// マーケティング通知を許可
    @Default(false) bool allowMarketingNotifications,

    /// データ分析への参加を許可
    /// （ユーザー行動分析、学習効果測定など）
    @Default(false) bool allowAnalytics,

    /// 設定更新日時
    required DateTime updatedAt,
  }) = _UserPrivacySettings;

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

  factory UserPrivacySettings.fromJson(Map<String, dynamic> json) =>
      _$UserPrivacySettingsFromJson(json);
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
