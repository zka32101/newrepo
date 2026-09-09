/// ユーザーのランキング情報
///
/// 手書きの不変クラス（`freezed`ではなく）。理由: 生成ファイルが
/// リポジトリにコミットされておらず、`build_runner` による
/// コード生成も行われていなかったため。このクラスは `copyWith`/`toJson`/
/// `fromJson`/`==` を含め、freezed と同等のAPI表面を持つよう実装している。
class RankingEntry {
  /// ユーザーID
  final String userId;

  /// ユーザー名
  final String userName;

  /// ユーザーアバター URL
  final String? avatarUrl;

  /// スコア
  final int score;

  /// ランク順位
  final int rank;

  /// 正答数
  final int correctAnswers;

  /// 問題数
  final int totalQuestions;

  /// 正答率（パーセンテージ）
  final double correctRate;

  /// ストリーク日数
  final int streak;

  /// 最後のスコア更新日時
  final DateTime lastScoreDate;

  /// このユーザーが現在のユーザー自身かどうか
  final bool isCurrentUser;

  /// ユーザーの学年（ティア別ランキング用）
  final GradeLevel? userGradeLevel;

  /// ユーザーの開始月（ティア別ランキング用）
  final SchoolYear? userStartMonth;

  /// このエントリーが属するランキングティア
  final RankingTier? rankingTier;

  const RankingEntry({
    required this.userId,
    required this.userName,
    required this.avatarUrl,
    required this.score,
    required this.rank,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.correctRate,
    required this.streak,
    required this.lastScoreDate,
    this.isCurrentUser = false,
    this.userGradeLevel,
    this.userStartMonth,
    this.rankingTier,
  });

  factory RankingEntry.fromJson(Map<String, dynamic> json) {
    return RankingEntry(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      score: json['score'] as int,
      rank: json['rank'] as int,
      correctAnswers: json['correctAnswers'] as int,
      totalQuestions: json['totalQuestions'] as int,
      correctRate: (json['correctRate'] as num).toDouble(),
      streak: json['streak'] as int,
      lastScoreDate: DateTime.parse(json['lastScoreDate'] as String),
      isCurrentUser: json['isCurrentUser'] as bool? ?? false,
      userGradeLevel: json['userGradeLevel'] == null
          ? null
          : GradeLevel.values.byName(json['userGradeLevel'] as String),
      userStartMonth: json['userStartMonth'] == null
          ? null
          : SchoolYear.values.byName(json['userStartMonth'] as String),
      rankingTier: json['rankingTier'] == null
          ? null
          : RankingTier.values.byName(json['rankingTier'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userName': userName,
        'avatarUrl': avatarUrl,
        'score': score,
        'rank': rank,
        'correctAnswers': correctAnswers,
        'totalQuestions': totalQuestions,
        'correctRate': correctRate,
        'streak': streak,
        'lastScoreDate': lastScoreDate.toIso8601String(),
        'isCurrentUser': isCurrentUser,
        'userGradeLevel': userGradeLevel?.name,
        'userStartMonth': userStartMonth?.name,
        'rankingTier': rankingTier?.name,
      };

  RankingEntry copyWith({
    String? userId,
    String? userName,
    String? avatarUrl,
    int? score,
    int? rank,
    int? correctAnswers,
    int? totalQuestions,
    double? correctRate,
    int? streak,
    DateTime? lastScoreDate,
    bool? isCurrentUser,
    GradeLevel? userGradeLevel,
    SchoolYear? userStartMonth,
    RankingTier? rankingTier,
  }) {
    return RankingEntry(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      score: score ?? this.score,
      rank: rank ?? this.rank,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      correctRate: correctRate ?? this.correctRate,
      streak: streak ?? this.streak,
      lastScoreDate: lastScoreDate ?? this.lastScoreDate,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
      userGradeLevel: userGradeLevel ?? this.userGradeLevel,
      userStartMonth: userStartMonth ?? this.userStartMonth,
      rankingTier: rankingTier ?? this.rankingTier,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RankingEntry &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          userName == other.userName &&
          avatarUrl == other.avatarUrl &&
          score == other.score &&
          rank == other.rank &&
          correctAnswers == other.correctAnswers &&
          totalQuestions == other.totalQuestions &&
          correctRate == other.correctRate &&
          streak == other.streak &&
          lastScoreDate == other.lastScoreDate &&
          isCurrentUser == other.isCurrentUser &&
          userGradeLevel == other.userGradeLevel &&
          userStartMonth == other.userStartMonth &&
          rankingTier == other.rankingTier;

  @override
  int get hashCode => Object.hash(
        userId,
        userName,
        avatarUrl,
        score,
        rank,
        correctAnswers,
        totalQuestions,
        correctRate,
        streak,
        lastScoreDate,
        isCurrentUser,
        userGradeLevel,
        userStartMonth,
        rankingTier,
      );
}

/// ランキングリスト
class RankingList {
  /// ランキング期間
  final RankingPeriod period;

  /// ランキングエントリー
  final List<RankingEntry> entries;

  /// 現在のユーザーのランク（entries に含まれていない場合）
  final RankingEntry? currentUserRank;

  /// 最終更新日時
  final DateTime lastUpdatedAt;

  /// ランキング更新までの時間（秒）
  final int refreshIntervalSeconds;

  /// ランキングティア（null = 従来の期間ベース）
  final RankingTier? rankingTier;

  /// ティア説明（例: "全体" または "3年生"）
  final String? tierDescription;

  /// ティアランキング情報（ユーザー自身のティア内での詳細情報）
  final TierRankingInfo? userTierInfo;

  /// 複合グループフィルター（tier が composite の場合）
  final CompositeGroupFilter? compositeFilter;

  const RankingList({
    required this.period,
    required this.entries,
    this.currentUserRank,
    required this.lastUpdatedAt,
    required this.refreshIntervalSeconds,
    this.rankingTier,
    this.tierDescription,
    this.userTierInfo,
    this.compositeFilter,
  });

  factory RankingList.fromJson(Map<String, dynamic> json) {
    return RankingList(
      period: RankingPeriod.values.byName(json['period'] as String),
      entries: (json['entries'] as List<dynamic>)
          .map((e) => RankingEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentUserRank: json['currentUserRank'] == null
          ? null
          : RankingEntry.fromJson(
              json['currentUserRank'] as Map<String, dynamic>),
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt'] as String),
      refreshIntervalSeconds: json['refreshIntervalSeconds'] as int,
      rankingTier: json['rankingTier'] == null
          ? null
          : RankingTier.values.byName(json['rankingTier'] as String),
      tierDescription: json['tierDescription'] as String?,
      userTierInfo: json['userTierInfo'] == null
          ? null
          : TierRankingInfo.fromJson(
              json['userTierInfo'] as Map<String, dynamic>),
      compositeFilter: json['compositeFilter'] == null
          ? null
          : CompositeGroupFilter.fromJson(
              json['compositeFilter'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'period': period.name,
        'entries': entries.map((e) => e.toJson()).toList(),
        'currentUserRank': currentUserRank?.toJson(),
        'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
        'refreshIntervalSeconds': refreshIntervalSeconds,
        'rankingTier': rankingTier?.name,
        'tierDescription': tierDescription,
        'userTierInfo': userTierInfo?.toJson(),
        'compositeFilter': compositeFilter?.toJson(),
      };

  RankingList copyWith({
    RankingPeriod? period,
    List<RankingEntry>? entries,
    RankingEntry? currentUserRank,
    DateTime? lastUpdatedAt,
    int? refreshIntervalSeconds,
    RankingTier? rankingTier,
    String? tierDescription,
    TierRankingInfo? userTierInfo,
    CompositeGroupFilter? compositeFilter,
  }) {
    return RankingList(
      period: period ?? this.period,
      entries: entries ?? this.entries,
      currentUserRank: currentUserRank ?? this.currentUserRank,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      refreshIntervalSeconds:
          refreshIntervalSeconds ?? this.refreshIntervalSeconds,
      rankingTier: rankingTier ?? this.rankingTier,
      tierDescription: tierDescription ?? this.tierDescription,
      userTierInfo: userTierInfo ?? this.userTierInfo,
      compositeFilter: compositeFilter ?? this.compositeFilter,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RankingList &&
          runtimeType == other.runtimeType &&
          period == other.period &&
          entries == other.entries &&
          currentUserRank == other.currentUserRank &&
          lastUpdatedAt == other.lastUpdatedAt &&
          refreshIntervalSeconds == other.refreshIntervalSeconds &&
          rankingTier == other.rankingTier &&
          tierDescription == other.tierDescription &&
          userTierInfo == other.userTierInfo &&
          compositeFilter == other.compositeFilter;

  @override
  int get hashCode => Object.hash(
        period,
        entries,
        currentUserRank,
        lastUpdatedAt,
        refreshIntervalSeconds,
        rankingTier,
        tierDescription,
        userTierInfo,
        compositeFilter,
      );
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
class RankingStats {
  /// 期間
  final RankingPeriod period;

  /// 合計参加者数
  final int totalParticipants;

  /// 現在のユーザーのランク
  final int currentUserRank;

  /// 現在のユーザーのスコア
  final int currentUserScore;

  /// ランク内のパーセンテージ（Top 何 %）
  final double percentile;

  /// 1位のスコア
  final int topScore;

  /// 平均スコア
  final double averageScore;

  /// ユーザーのスコア推移（過去7日間の日別データ）
  final List<DailyScoreData> scoreHistory;

  const RankingStats({
    required this.period,
    required this.totalParticipants,
    required this.currentUserRank,
    required this.currentUserScore,
    required this.percentile,
    required this.topScore,
    required this.averageScore,
    required this.scoreHistory,
  });

  factory RankingStats.fromJson(Map<String, dynamic> json) {
    return RankingStats(
      period: RankingPeriod.values.byName(json['period'] as String),
      totalParticipants: json['totalParticipants'] as int,
      currentUserRank: json['currentUserRank'] as int,
      currentUserScore: json['currentUserScore'] as int,
      percentile: (json['percentile'] as num).toDouble(),
      topScore: json['topScore'] as int,
      averageScore: (json['averageScore'] as num).toDouble(),
      scoreHistory: (json['scoreHistory'] as List<dynamic>)
          .map((e) => DailyScoreData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'period': period.name,
        'totalParticipants': totalParticipants,
        'currentUserRank': currentUserRank,
        'currentUserScore': currentUserScore,
        'percentile': percentile,
        'topScore': topScore,
        'averageScore': averageScore,
        'scoreHistory': scoreHistory.map((e) => e.toJson()).toList(),
      };

  RankingStats copyWith({
    RankingPeriod? period,
    int? totalParticipants,
    int? currentUserRank,
    int? currentUserScore,
    double? percentile,
    int? topScore,
    double? averageScore,
    List<DailyScoreData>? scoreHistory,
  }) {
    return RankingStats(
      period: period ?? this.period,
      totalParticipants: totalParticipants ?? this.totalParticipants,
      currentUserRank: currentUserRank ?? this.currentUserRank,
      currentUserScore: currentUserScore ?? this.currentUserScore,
      percentile: percentile ?? this.percentile,
      topScore: topScore ?? this.topScore,
      averageScore: averageScore ?? this.averageScore,
      scoreHistory: scoreHistory ?? this.scoreHistory,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RankingStats &&
          runtimeType == other.runtimeType &&
          period == other.period &&
          totalParticipants == other.totalParticipants &&
          currentUserRank == other.currentUserRank &&
          currentUserScore == other.currentUserScore &&
          percentile == other.percentile &&
          topScore == other.topScore &&
          averageScore == other.averageScore &&
          scoreHistory == other.scoreHistory;

  @override
  int get hashCode => Object.hash(
        period,
        totalParticipants,
        currentUserRank,
        currentUserScore,
        percentile,
        topScore,
        averageScore,
        scoreHistory,
      );
}

/// 日別スコア記録
class DailyScoreData {
  final DateTime date;
  final int score;
  final int questionsCompleted;

  const DailyScoreData({
    required this.date,
    required this.score,
    required this.questionsCompleted,
  });

  factory DailyScoreData.fromJson(Map<String, dynamic> json) {
    return DailyScoreData(
      date: DateTime.parse(json['date'] as String),
      score: json['score'] as int,
      questionsCompleted: json['questionsCompleted'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'score': score,
        'questionsCompleted': questionsCompleted,
      };

  DailyScoreData copyWith({
    DateTime? date,
    int? score,
    int? questionsCompleted,
  }) {
    return DailyScoreData(
      date: date ?? this.date,
      score: score ?? this.score,
      questionsCompleted: questionsCompleted ?? this.questionsCompleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyScoreData &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          score == other.score &&
          questionsCompleted == other.questionsCompleted;

  @override
  int get hashCode => Object.hash(date, score, questionsCompleted);
}

/// ランキング変動通知
class RankingChangeNotification {
  /// 前回のランク
  final int previousRank;

  /// 現在のランク
  final int currentRank;

  /// ランク変動方向（up/down/same）
  final RankChangeDirection direction;

  /// 変動幅（例: 5位上昇の場合は 5）
  final int delta;

  /// 通知メッセージ
  final String message;

  /// 通知時刻
  final DateTime notifiedAt;

  const RankingChangeNotification({
    required this.previousRank,
    required this.currentRank,
    required this.direction,
    required this.delta,
    required this.message,
    required this.notifiedAt,
  });

  factory RankingChangeNotification.fromJson(Map<String, dynamic> json) {
    return RankingChangeNotification(
      previousRank: json['previousRank'] as int,
      currentRank: json['currentRank'] as int,
      direction:
          RankChangeDirection.values.byName(json['direction'] as String),
      delta: json['delta'] as int,
      message: json['message'] as String,
      notifiedAt: DateTime.parse(json['notifiedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'previousRank': previousRank,
        'currentRank': currentRank,
        'direction': direction.name,
        'delta': delta,
        'message': message,
        'notifiedAt': notifiedAt.toIso8601String(),
      };

  RankingChangeNotification copyWith({
    int? previousRank,
    int? currentRank,
    RankChangeDirection? direction,
    int? delta,
    String? message,
    DateTime? notifiedAt,
  }) {
    return RankingChangeNotification(
      previousRank: previousRank ?? this.previousRank,
      currentRank: currentRank ?? this.currentRank,
      direction: direction ?? this.direction,
      delta: delta ?? this.delta,
      message: message ?? this.message,
      notifiedAt: notifiedAt ?? this.notifiedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RankingChangeNotification &&
          runtimeType == other.runtimeType &&
          previousRank == other.previousRank &&
          currentRank == other.currentRank &&
          direction == other.direction &&
          delta == other.delta &&
          message == other.message &&
          notifiedAt == other.notifiedAt;

  @override
  int get hashCode => Object.hash(
      previousRank, currentRank, direction, delta, message, notifiedAt);
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
class UserAchievement {
  /// 達成ID
  final String achievementId;

  /// 達成内容
  final String title;

  /// 達成詳細
  final String description;

  /// 達成絵文字
  final String emoji;

  /// 達成日時
  final DateTime unlockedAt;

  /// 達成数（リーダーボード）
  final int count;

  const UserAchievement({
    required this.achievementId,
    required this.title,
    required this.description,
    required this.emoji,
    required this.unlockedAt,
    this.count = 1,
  });

  factory UserAchievement.fromJson(Map<String, dynamic> json) {
    return UserAchievement(
      achievementId: json['achievementId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      emoji: json['emoji'] as String,
      unlockedAt: DateTime.parse(json['unlockedAt'] as String),
      count: json['count'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'achievementId': achievementId,
        'title': title,
        'description': description,
        'emoji': emoji,
        'unlockedAt': unlockedAt.toIso8601String(),
        'count': count,
      };

  UserAchievement copyWith({
    String? achievementId,
    String? title,
    String? description,
    String? emoji,
    DateTime? unlockedAt,
    int? count,
  }) {
    return UserAchievement(
      achievementId: achievementId ?? this.achievementId,
      title: title ?? this.title,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      count: count ?? this.count,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAchievement &&
          runtimeType == other.runtimeType &&
          achievementId == other.achievementId &&
          title == other.title &&
          description == other.description &&
          emoji == other.emoji &&
          unlockedAt == other.unlockedAt &&
          count == other.count;

  @override
  int get hashCode =>
      Object.hash(achievementId, title, description, emoji, unlockedAt, count);
}

/// ティア別ランキング情報
class TierRankingInfo {
  /// ランキングティア
  final RankingTier tier;

  /// ティア内での説明（例: "3年生" または "2025-2026年度"）
  final String tierDescription;

  /// ティア内での全体参加者数
  final int totalParticipants;

  /// ユーザーのティア内ランク
  final int userRankInTier;

  /// ティア内での正答率の順位
  final int correctRateRank;

  /// ティア内での平均スコア
  final double tierAverageScore;

  /// ティア内での最高スコア
  final int tierTopScore;

  /// このティアが現在アクティブなティアかどうか
  final bool isActiveTier;

  const TierRankingInfo({
    required this.tier,
    required this.tierDescription,
    required this.totalParticipants,
    required this.userRankInTier,
    required this.correctRateRank,
    required this.tierAverageScore,
    required this.tierTopScore,
    required this.isActiveTier,
  });

  factory TierRankingInfo.fromJson(Map<String, dynamic> json) {
    return TierRankingInfo(
      tier: RankingTier.values.byName(json['tier'] as String),
      tierDescription: json['tierDescription'] as String,
      totalParticipants: json['totalParticipants'] as int,
      userRankInTier: json['userRankInTier'] as int,
      correctRateRank: json['correctRateRank'] as int,
      tierAverageScore: (json['tierAverageScore'] as num).toDouble(),
      tierTopScore: json['tierTopScore'] as int,
      isActiveTier: json['isActiveTier'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'tier': tier.name,
        'tierDescription': tierDescription,
        'totalParticipants': totalParticipants,
        'userRankInTier': userRankInTier,
        'correctRateRank': correctRateRank,
        'tierAverageScore': tierAverageScore,
        'tierTopScore': tierTopScore,
        'isActiveTier': isActiveTier,
      };

  TierRankingInfo copyWith({
    RankingTier? tier,
    String? tierDescription,
    int? totalParticipants,
    int? userRankInTier,
    int? correctRateRank,
    double? tierAverageScore,
    int? tierTopScore,
    bool? isActiveTier,
  }) {
    return TierRankingInfo(
      tier: tier ?? this.tier,
      tierDescription: tierDescription ?? this.tierDescription,
      totalParticipants: totalParticipants ?? this.totalParticipants,
      userRankInTier: userRankInTier ?? this.userRankInTier,
      correctRateRank: correctRateRank ?? this.correctRateRank,
      tierAverageScore: tierAverageScore ?? this.tierAverageScore,
      tierTopScore: tierTopScore ?? this.tierTopScore,
      isActiveTier: isActiveTier ?? this.isActiveTier,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TierRankingInfo &&
          runtimeType == other.runtimeType &&
          tier == other.tier &&
          tierDescription == other.tierDescription &&
          totalParticipants == other.totalParticipants &&
          userRankInTier == other.userRankInTier &&
          correctRateRank == other.correctRateRank &&
          tierAverageScore == other.tierAverageScore &&
          tierTopScore == other.tierTopScore &&
          isActiveTier == other.isActiveTier;

  @override
  int get hashCode => Object.hash(
        tier,
        tierDescription,
        totalParticipants,
        userRankInTier,
        correctRateRank,
        tierAverageScore,
        tierTopScore,
        isActiveTier,
      );
}

/// 複合グループのフィルター設定
class CompositeGroupFilter {
  /// 学年フィルター（null = 全学年）
  final GradeLevel? gradeFilter;

  /// 開始月フィルター（null = 全月）
  final SchoolYear? startMonthFilter;

  /// 両方のフィルターを適用するかどうか
  final bool applyBothFilters;

  const CompositeGroupFilter({
    this.gradeFilter,
    this.startMonthFilter,
    this.applyBothFilters = false,
  });

  factory CompositeGroupFilter.fromJson(Map<String, dynamic> json) {
    return CompositeGroupFilter(
      gradeFilter: json['gradeFilter'] == null
          ? null
          : GradeLevel.values.byName(json['gradeFilter'] as String),
      startMonthFilter: json['startMonthFilter'] == null
          ? null
          : SchoolYear.values.byName(json['startMonthFilter'] as String),
      applyBothFilters: json['applyBothFilters'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'gradeFilter': gradeFilter?.name,
        'startMonthFilter': startMonthFilter?.name,
        'applyBothFilters': applyBothFilters,
      };

  CompositeGroupFilter copyWith({
    GradeLevel? gradeFilter,
    SchoolYear? startMonthFilter,
    bool? applyBothFilters,
  }) {
    return CompositeGroupFilter(
      gradeFilter: gradeFilter ?? this.gradeFilter,
      startMonthFilter: startMonthFilter ?? this.startMonthFilter,
      applyBothFilters: applyBothFilters ?? this.applyBothFilters,
    );
  }

  /// フィルター説明文を取得
  String getFilterDescription() {
    if (gradeFilter == null && startMonthFilter == null) {
      return '全ユーザー';
    } else if (applyBothFilters &&
        gradeFilter != null &&
        startMonthFilter != null) {
      return '${gradeFilter!.label} & ${startMonthFilter!.label}開始ユーザー';
    } else if (gradeFilter != null) {
      return '${gradeFilter!.label}ユーザー';
    } else if (startMonthFilter != null) {
      return '${startMonthFilter!.label}開始ユーザー';
    }
    return '全ユーザー';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompositeGroupFilter &&
          runtimeType == other.runtimeType &&
          gradeFilter == other.gradeFilter &&
          startMonthFilter == other.startMonthFilter &&
          applyBothFilters == other.applyBothFilters;

  @override
  int get hashCode =>
      Object.hash(gradeFilter, startMonthFilter, applyBothFilters);
}
