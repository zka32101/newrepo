import 'package:freezed_annotation/freezed_annotation.dart';

part 'ranking_model.freezed.dart';
part 'ranking_model.g.dart';

/// ユーザーのランキング情報
@freezed
class RankingEntry with _$RankingEntry {
  const factory RankingEntry({
    /// ユーザーID
    required String userId,

    /// ユーザー名
    required String userName,

    /// ユーザーアバター URL
    required String? avatarUrl,

    /// スコア
    required int score,

    /// ランク順位
    required int rank,

    /// 正答数
    required int correctAnswers,

    /// 問題数
    required int totalQuestions,

    /// 正答率（パーセンテージ）
    required double correctRate,

    /// ストリーク日数
    required int streak,

    /// 最後のスコア更新日時
    required DateTime lastScoreDate,

    /// このユーザーが現在のユーザー自身かどうか
    @Default(false) bool isCurrentUser,
  }) = _RankingEntry;

  factory RankingEntry.fromJson(Map<String, dynamic> json) =>
      _$RankingEntryFromJson(json);
}

/// ランキングリスト
@freezed
class RankingList with _$RankingList {
  const factory RankingList({
    /// ランキング期間
    required RankingPeriod period,

    /// ランキングエントリー
    required List<RankingEntry> entries,

    /// 現在のユーザーのランク（entries に含まれていない場合）
    RankingEntry? currentUserRank,

    /// 最終更新日時
    required DateTime lastUpdatedAt,

    /// ランキング更新までの時間（秒）
    required int refreshIntervalSeconds,
  }) = _RankingList;

  factory RankingList.fromJson(Map<String, dynamic> json) =>
      _$RankingListFromJson(json);
}

/// ランキング期間
enum RankingPeriod {
  daily('日間'),
  weekly('週間'),
  monthly('月間');

  final String label;
  const RankingPeriod(this.label);

  String get displayLabel => switch (this) {
    RankingPeriod.daily => '本日',
    RankingPeriod.weekly => '今週',
    RankingPeriod.monthly => '今月',
  };
}

/// ランキング統計情報
@freezed
class RankingStats with _$RankingStats {
  const factory RankingStats({
    /// 期間
    required RankingPeriod period,

    /// 合計参加者数
    required int totalParticipants,

    /// 現在のユーザーのランク
    required int currentUserRank,

    /// 現在のユーザーのスコア
    required int currentUserScore,

    /// ランク内のパーセンテージ（Top 何 %）
    required double percentile,

    /// 1位のスコア
    required int topScore,

    /// 平均スコア
    required double averageScore,

    /// ユーザーのスコア推移（過去7日間の日別データ）
    required List<DailyScoreData> scoreHistory,
  }) = _RankingStats;

  factory RankingStats.fromJson(Map<String, dynamic> json) =>
      _$RankingStatsFromJson(json);
}

/// 日別スコア記録
@freezed
class DailyScoreData with _$DailyScoreData {
  const factory DailyScoreData({
    required DateTime date,
    required int score,
    required int questionsCompleted,
  }) = _DailyScoreData;

  factory DailyScoreData.fromJson(Map<String, dynamic> json) =>
      _$DailyScorDataFromJson(json);
}

/// ランキング変動通知
@freezed
class RankingChangeNotification with _$RankingChangeNotification {
  const factory RankingChangeNotification({
    /// 前回のランク
    required int previousRank,

    /// 現在のランク
    required int currentRank,

    /// ランク変動方向（up/down/same）
    required RankChangeDirection direction,

    /// 変動幅（例: 5位上昇の場合は 5）
    required int delta,

    /// 通知メッセージ
    required String message,

    /// 通知時刻
    required DateTime notifiedAt,
  }) = _RankingChangeNotification;

  factory RankingChangeNotification.fromJson(Map<String, dynamic> json) =>
      _$RankingChangeNotificationFromJson(json);
}

/// ランク変動方向
enum RankChangeDirection {
  up('上昇'),
  down('下降'),
  same('変わらず');

  final String label;
  const RankChangeDirection(this.label);
}

/// ユーザーの達成状況
@freezed
class UserAchievement with _$UserAchievement {
  const factory UserAchievement({
    /// 達成ID
    required String achievementId,

    /// 達成内容
    required String title,

    /// 達成詳細
    required String description,

    /// 達成絵文字
    required String emoji,

    /// 達成日時
    required DateTime unlockedAt,

    /// 達成数（リーダーボード）
    @Default(1) int count,
  }) = _UserAchievement;

  factory UserAchievement.fromJson(Map<String, dynamic> json) =>
      _$UserAchievementFromJson(json);
}
