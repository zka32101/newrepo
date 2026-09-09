/// アチーブメント/バッジ情報
///
/// 手書きの不変クラス（`freezed`ではなく）。理由: 生成ファイルが
/// リポジトリにコミットされておらず、`build_runner` による
/// コード生成も行われていなかったため。
class Achievement {
  /// アチーブメントID
  final String id;

  /// タイトル
  final String title;

  /// 説明
  final String description;

  /// 絵文字
  final String emoji;

  /// カテゴリー
  final AchievementCategory category;

  /// 達成条件
  final AchievementCondition condition;

  /// レアリティ（表示色など）
  final AchievementRarity rarity;

  /// 表示順序
  final int order;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.category,
    required this.condition,
    this.rarity = AchievementRarity.common,
    this.order = 0,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      emoji: json['emoji'] as String,
      category:
          AchievementCategory.values.byName(json['category'] as String),
      condition: AchievementCondition.fromJson(
          json['condition'] as Map<String, dynamic>),
      rarity: json['rarity'] == null
          ? AchievementRarity.common
          : AchievementRarity.values.byName(json['rarity'] as String),
      order: json['order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'emoji': emoji,
        'category': category.name,
        'condition': condition.toJson(),
        'rarity': rarity.name,
        'order': order,
      };

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? emoji,
    AchievementCategory? category,
    AchievementCondition? condition,
    AchievementRarity? rarity,
    int? order,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
      category: category ?? this.category,
      condition: condition ?? this.condition,
      rarity: rarity ?? this.rarity,
      order: order ?? this.order,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Achievement &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          emoji == other.emoji &&
          category == other.category &&
          condition == other.condition &&
          rarity == other.rarity &&
          order == other.order;

  @override
  int get hashCode =>
      Object.hash(id, title, description, emoji, category, condition, rarity, order);
}

/// ユーザーの達成記録
class UserAchievement {
  /// アチーブメントID
  final String achievementId;

  /// 達成日時
  final DateTime unlockedAt;

  /// 初回達成かどうか
  final bool isFirstTime;

  /// 回数（連続達成など）
  final int count;

  const UserAchievement({
    required this.achievementId,
    required this.unlockedAt,
    this.isFirstTime = true,
    this.count = 1,
  });

  factory UserAchievement.fromJson(Map<String, dynamic> json) {
    return UserAchievement(
      achievementId: json['achievementId'] as String,
      unlockedAt: DateTime.parse(json['unlockedAt'] as String),
      isFirstTime: json['isFirstTime'] as bool? ?? true,
      count: json['count'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'achievementId': achievementId,
        'unlockedAt': unlockedAt.toIso8601String(),
        'isFirstTime': isFirstTime,
        'count': count,
      };

  UserAchievement copyWith({
    String? achievementId,
    DateTime? unlockedAt,
    bool? isFirstTime,
    int? count,
  }) {
    return UserAchievement(
      achievementId: achievementId ?? this.achievementId,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      isFirstTime: isFirstTime ?? this.isFirstTime,
      count: count ?? this.count,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAchievement &&
          runtimeType == other.runtimeType &&
          achievementId == other.achievementId &&
          unlockedAt == other.unlockedAt &&
          isFirstTime == other.isFirstTime &&
          count == other.count;

  @override
  int get hashCode =>
      Object.hash(achievementId, unlockedAt, isFirstTime, count);
}

/// アチーブメント達成通知
class AchievementUnlockedNotification {
  /// アチーブメント情報
  final Achievement achievement;

  /// ユーザー達成情報
  final UserAchievement userAchievement;

  /// メッセージ
  final String message;

  /// 通知時刻
  final DateTime notifiedAt;

  const AchievementUnlockedNotification({
    required this.achievement,
    required this.userAchievement,
    required this.message,
    required this.notifiedAt,
  });

  factory AchievementUnlockedNotification.fromJson(Map<String, dynamic> json) {
    return AchievementUnlockedNotification(
      achievement:
          Achievement.fromJson(json['achievement'] as Map<String, dynamic>),
      userAchievement: UserAchievement.fromJson(
          json['userAchievement'] as Map<String, dynamic>),
      message: json['message'] as String,
      notifiedAt: DateTime.parse(json['notifiedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'achievement': achievement.toJson(),
        'userAchievement': userAchievement.toJson(),
        'message': message,
        'notifiedAt': notifiedAt.toIso8601String(),
      };

  AchievementUnlockedNotification copyWith({
    Achievement? achievement,
    UserAchievement? userAchievement,
    String? message,
    DateTime? notifiedAt,
  }) {
    return AchievementUnlockedNotification(
      achievement: achievement ?? this.achievement,
      userAchievement: userAchievement ?? this.userAchievement,
      message: message ?? this.message,
      notifiedAt: notifiedAt ?? this.notifiedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AchievementUnlockedNotification &&
          runtimeType == other.runtimeType &&
          achievement == other.achievement &&
          userAchievement == other.userAchievement &&
          message == other.message &&
          notifiedAt == other.notifiedAt;

  @override
  int get hashCode =>
      Object.hash(achievement, userAchievement, message, notifiedAt);
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
class AchievementCondition {
  /// 条件の種類
  final ConditionType type;

  /// 目標値
  final int targetValue;

  /// 説明
  final String description;

  const AchievementCondition({
    required this.type,
    required this.targetValue,
    required this.description,
  });

  factory AchievementCondition.fromJson(Map<String, dynamic> json) {
    return AchievementCondition(
      type: ConditionType.values.byName(json['type'] as String),
      targetValue: json['targetValue'] as int,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'targetValue': targetValue,
        'description': description,
      };

  AchievementCondition copyWith({
    ConditionType? type,
    int? targetValue,
    String? description,
  }) {
    return AchievementCondition(
      type: type ?? this.type,
      targetValue: targetValue ?? this.targetValue,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AchievementCondition &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          targetValue == other.targetValue &&
          description == other.description;

  @override
  int get hashCode => Object.hash(type, targetValue, description);
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
class AchievementStats {
  /// 総アチーブメント数
  final int totalAchievements;

  /// 達成済みアチーブメント数
  final int unlockedCount;

  /// 達成率（パーセンテージ）
  final double completionRate;

  /// 最新の達成
  final UserAchievement? lastUnlocked;

  /// カテゴリー別達成数
  final Map<String, int> categoryStats;

  const AchievementStats({
    required this.totalAchievements,
    required this.unlockedCount,
    required this.completionRate,
    this.lastUnlocked,
    required this.categoryStats,
  });

  factory AchievementStats.fromJson(Map<String, dynamic> json) {
    return AchievementStats(
      totalAchievements: json['totalAchievements'] as int,
      unlockedCount: json['unlockedCount'] as int,
      completionRate: (json['completionRate'] as num).toDouble(),
      lastUnlocked: json['lastUnlocked'] == null
          ? null
          : UserAchievement.fromJson(
              json['lastUnlocked'] as Map<String, dynamic>),
      categoryStats:
          Map<String, int>.from(json['categoryStats'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'totalAchievements': totalAchievements,
        'unlockedCount': unlockedCount,
        'completionRate': completionRate,
        'lastUnlocked': lastUnlocked?.toJson(),
        'categoryStats': categoryStats,
      };

  AchievementStats copyWith({
    int? totalAchievements,
    int? unlockedCount,
    double? completionRate,
    UserAchievement? lastUnlocked,
    Map<String, int>? categoryStats,
  }) {
    return AchievementStats(
      totalAchievements: totalAchievements ?? this.totalAchievements,
      unlockedCount: unlockedCount ?? this.unlockedCount,
      completionRate: completionRate ?? this.completionRate,
      lastUnlocked: lastUnlocked ?? this.lastUnlocked,
      categoryStats: categoryStats ?? this.categoryStats,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AchievementStats &&
          runtimeType == other.runtimeType &&
          totalAchievements == other.totalAchievements &&
          unlockedCount == other.unlockedCount &&
          completionRate == other.completionRate &&
          lastUnlocked == other.lastUnlocked &&
          categoryStats == other.categoryStats;

  @override
  int get hashCode => Object.hash(
      totalAchievements, unlockedCount, completionRate, lastUnlocked, categoryStats);
}
