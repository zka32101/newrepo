import 'package:freezed_annotation/freezed_annotation.dart';

part 'achievement_model.freezed.dart';
part 'achievement_model.g.dart';

/// アチーブメント/バッジ情報
@freezed
class Achievement with _$Achievement {
  const factory Achievement({
    /// アチーブメントID
    required String id,

    /// タイトル
    required String title,

    /// 説明
    required String description,

    /// 絵文字
    required String emoji,

    /// カテゴリー
    required AchievementCategory category,

    /// 達成条件
    required AchievementCondition condition,

    /// レアリティ（表示色など）
    @Default(AchievementRarity.common) AchievementRarity rarity,

    /// 表示順序
    @Default(0) int order,
  }) = _Achievement;

  factory Achievement.fromJson(Map<String, dynamic> json) =>
      _$AchievementFromJson(json);
}

/// ユーザーの達成記録
@freezed
class UserAchievement with _$UserAchievement {
  const factory UserAchievement({
    /// アチーブメントID
    required String achievementId,

    /// 達成日時
    required DateTime unlockedAt,

    /// 初回達成かどうか
    @Default(true) bool isFirstTime,

    /// 回数（連続達成など）
    @Default(1) int count,
  }) = _UserAchievement;

  factory UserAchievement.fromJson(Map<String, dynamic> json) =>
      _$UserAchievementFromJson(json);
}

/// アチーブメント達成通知
@freezed
class AchievementUnlockedNotification with _$AchievementUnlockedNotification {
  const factory AchievementUnlockedNotification({
    /// アチーブメント情報
    required Achievement achievement,

    /// ユーザー達成情報
    required UserAchievement userAchievement,

    /// メッセージ
    required String message,

    /// 通知時刻
    required DateTime notifiedAt,
  }) = _AchievementUnlockedNotification;

  factory AchievementUnlockedNotification.fromJson(Map<String, dynamic> json) =>
      _$AchievementUnlockedNotificationFromJson(json);
}

/// アチーブメントカテゴリー
enum AchievementCategory {
  /// クイズ完了系
  quiz('クイズ'),

  /// ストリーク系
  streak('ストリーク'),

  /// ランキング系
  ranking('ランキング'),

  /// SNS共有系
  sharing('シェア'),

  /// その他
  other('その他');

  final String label;
  const AchievementCategory(this.label);
}

/// アチーブメント達成条件
@freezed
class AchievementCondition with _$AchievementCondition {
  const factory AchievementCondition({
    /// 条件の種類
    required ConditionType type,

    /// 目標値
    required int targetValue,

    /// 説明
    required String description,
  }) = _AchievementCondition;

  factory AchievementCondition.fromJson(Map<String, dynamic> json) =>
      _$AchievementConditionFromJson(json);
}

/// 達成条件の種類
enum ConditionType {
  /// 完了したクイズ数
  quizzesClosed('クイズ完了'),

  /// 連続ログイン日数
  streakDays('ストリーク日数'),

  /// 全問正解回数
  perfectScores('全問正解'),

  /// ランキング上位達成
  rankingTop('ランキング上位'),

  /// SNS共有回数
  sharesCount('シェア回数'),

  /// 正答率達成
  correctRate('正答率'),

  /// その他
  other('その他');

  final String label;
  const ConditionType(this.label);
}

/// レアリティ（希少性）
enum AchievementRarity {
  /// 一般的（灰色）
  common('一般', 0xFF9E9E9E),

  /// 通常（青色）
  uncommon('通常', 0xFF2196F3),

  /// レア（緑色）
  rare('レア', 0xFF4CAF50),

  /// エピック（紫色）
  epic('エピック', 0xFF9C27B0),

  /// レジェンド（金色）
  legendary('レジェンド', 0xFFFF9800);

  final String label;
  final int color;
  const AchievementRarity(this.label, this.color);
}

/// アチーブメント統計
@freezed
class AchievementStats with _$AchievementStats {
  const factory AchievementStats({
    /// 総アチーブメント数
    required int totalAchievements,

    /// 達成済みアチーブメント数
    required int unlockedCount,

    /// 達成率（パーセンテージ）
    required double completionRate,

    /// 最新の達成
    UserAchievement? lastUnlocked,

    /// カテゴリー別達成数
    required Map<String, int> categoryStats,
  }) = _AchievementStats;

  factory AchievementStats.fromJson(Map<String, dynamic> json) =>
      _$AchievementStatsFromJson(json);
}
