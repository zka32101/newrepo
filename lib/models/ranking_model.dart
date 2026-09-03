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

    /// ユーザーの学年（ティア別ランキング用）
    GradeLevel? userGradeLevel,

    /// ユーザーの開始月（ティア別ランキング用）
    SchoolYear? userStartMonth,

    /// このエントリーが属するランキングティア
    RankingTier? rankingTier,
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

    /// ランキングティア（null = 従来の期間ベース）
    RankingTier? rankingTier,

    /// ティア説明（例: "全体" または "3年生"）
    String? tierDescription,

    /// ティアランキング情報（ユーザー自身のティア内での詳細情報）
    TierRankingInfo? userTierInfo,

    /// 複合グループフィルター（tier が composite の場合）
    CompositeGroupFilter? compositeFilter,
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

/// ランキングの4つのティア区分
enum RankingTier {
  allTime('全体ランキング'),
  byGrade('学年別ランキング'),
  byStartMonth('開始月別ランキング'),
  composite('複合グループランキング');

  final String label;
  const RankingTier(this.label);

  String get displayLabel => switch (this) {
    RankingTier.allTime => '全体',
    RankingTier.byGrade => '学年別',
    RankingTier.byStartMonth => '開始月別',
    RankingTier.composite => '複合グループ',
  };
}

/// 学年レベル
enum GradeLevel {
  grade3('3年'),
  grade4('4年'),
  grade5('5年'),
  grade6('6年');

  final String label;
  const GradeLevel(this.label);

  /// 学年から GradeLevel を取得
  static GradeLevel fromGradeNumber(int gradeNumber) {
    return switch (gradeNumber) {
      3 => GradeLevel.grade3,
      4 => GradeLevel.grade4,
      5 => GradeLevel.grade5,
      6 => GradeLevel.grade6,
      _ => GradeLevel.grade3,
    };
  }

  /// GradeLevel を学年番号に変換
  int toGradeNumber() => switch (this) {
    GradeLevel.grade3 => 3,
    GradeLevel.grade4 => 4,
    GradeLevel.grade5 => 5,
    GradeLevel.grade6 => 6,
  };
}

/// 学年度（4月-3月 学校年度）
enum SchoolYear {
  april('4月'),
  may('5月'),
  june('6月'),
  july('7月'),
  august('8月'),
  september('9月'),
  october('10月'),
  november('11月'),
  december('12月'),
  january('1月'),
  february('2月'),
  march('3月');

  final String label;
  const SchoolYear(this.label);

  /// 月番号から SchoolYear を取得（1-12）
  static SchoolYear fromMonthNumber(int month) {
    return switch (month) {
      1 => SchoolYear.january,
      2 => SchoolYear.february,
      3 => SchoolYear.march,
      4 => SchoolYear.april,
      5 => SchoolYear.may,
      6 => SchoolYear.june,
      7 => SchoolYear.july,
      8 => SchoolYear.august,
      9 => SchoolYear.september,
      10 => SchoolYear.october,
      11 => SchoolYear.november,
      12 => SchoolYear.december,
      _ => SchoolYear.april,
    };
  }

  /// SchoolYear を月番号に変換
  int toMonthNumber() => switch (this) {
    SchoolYear.january => 1,
    SchoolYear.february => 2,
    SchoolYear.march => 3,
    SchoolYear.april => 4,
    SchoolYear.may => 5,
    SchoolYear.june => 6,
    SchoolYear.july => 7,
    SchoolYear.august => 8,
    SchoolYear.september => 9,
    SchoolYear.october => 10,
    SchoolYear.november => 11,
    SchoolYear.december => 12,
  };

  /// 学年度を表す文字列を取得（例: "2025-2026年度"）
  static String getSchoolYearString(DateTime date) {
    final year = date.year;
    final month = date.month;
    // 4月以降は翌年度、1月-3月は現年度
    if (month >= 4) {
      return '$year-${year + 1}年度';
    } else {
      return '${year - 1}-$year年度';
    }
  }
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

/// ティア別ランキング情報
@freezed
class TierRankingInfo with _$TierRankingInfo {
  const factory TierRankingInfo({
    /// ランキングティア
    required RankingTier tier,

    /// ティア内での説明（例: "3年生" または "2025-2026年度"）
    required String tierDescription,

    /// ティア内での全体参加者数
    required int totalParticipants,

    /// ユーザーのティア内ランク
    required int userRankInTier,

    /// ティア内での正答率の順位
    required int correctRateRank,

    /// ティア内での平均スコア
    required double tierAverageScore,

    /// ティア内での最高スコア
    required int tierTopScore,

    /// このティアが現在アクティブなティアかどうか
    required bool isActiveTier,
  }) = _TierRankingInfo;

  factory TierRankingInfo.fromJson(Map<String, dynamic> json) =>
      _$TierRankingInfoFromJson(json);
}

/// 複合グループのフィルター設定
@freezed
class CompositeGroupFilter with _$CompositeGroupFilter {
  const factory CompositeGroupFilter({
    /// 学年フィルター（null = 全学年）
    GradeLevel? gradeFilter,

    /// 開始月フィルター（null = 全月）
    SchoolYear? startMonthFilter,

    /// 両方のフィルターを適用するかどうか
    @Default(false) bool applyBothFilters,
  }) = _CompositeGroupFilter;

  factory CompositeGroupFilter.fromJson(Map<String, dynamic> json) =>
      _$CompositeGroupFilterFromJson(json);

  /// フィルター説明文を取得
  String getFilterDescription() {
    if (gradeFilter == null && startMonthFilter == null) {
      return '全ユーザー';
    } else if (applyBothFilters && gradeFilter != null && startMonthFilter != null) {
      return '${gradeFilter!.label} & ${startMonthFilter!.label}開始ユーザー';
    } else if (gradeFilter != null) {
      return '${gradeFilter!.label}ユーザー';
    } else if (startMonthFilter != null) {
      return '${startMonthFilter!.label}開始ユーザー';
    }
    return '全ユーザー';
  }
}
