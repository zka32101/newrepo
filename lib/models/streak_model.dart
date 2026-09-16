/// ストリーク情報モデル
///
/// 手書きの不変クラス（`freezed`ではなく）。理由: 生成ファイルが
/// リポジトリにコミットされておらず、`build_runner` による
/// コード生成も行われていなかったため。
class StreakData {
  /// 現在のストリーク日数
  final int currentStreak;

  /// ストリーク開始日
  final DateTime streakStartDate;

  /// 最大ストリーク日数
  final int maxStreak;

  /// 最後に学習した日付
  final DateTime lastActivityDate;

  /// 今日学習したかどうか
  final bool completedToday;

  /// ストリークが途絶した日時（null=継続中）
  final DateTime? streakBrokenDate;

  const StreakData({
    required this.currentStreak,
    required this.streakStartDate,
    required this.maxStreak,
    required this.lastActivityDate,
    required this.completedToday,
    this.streakBrokenDate,
  });

  factory StreakData.fromJson(Map<String, dynamic> json) {
    return StreakData(
      currentStreak: json['currentStreak'] as int,
      streakStartDate: DateTime.parse(json['streakStartDate'] as String),
      maxStreak: json['maxStreak'] as int,
      lastActivityDate: DateTime.parse(json['lastActivityDate'] as String),
      completedToday: json['completedToday'] as bool,
      streakBrokenDate: json['streakBrokenDate'] == null
          ? null
          : DateTime.parse(json['streakBrokenDate'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'currentStreak': currentStreak,
        'streakStartDate': streakStartDate.toIso8601String(),
        'maxStreak': maxStreak,
        'lastActivityDate': lastActivityDate.toIso8601String(),
        'completedToday': completedToday,
        'streakBrokenDate': streakBrokenDate?.toIso8601String(),
      };

  StreakData copyWith({
    int? currentStreak,
    DateTime? streakStartDate,
    int? maxStreak,
    DateTime? lastActivityDate,
    bool? completedToday,
    DateTime? streakBrokenDate,
  }) {
    return StreakData(
      currentStreak: currentStreak ?? this.currentStreak,
      streakStartDate: streakStartDate ?? this.streakStartDate,
      maxStreak: maxStreak ?? this.maxStreak,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      completedToday: completedToday ?? this.completedToday,
      streakBrokenDate: streakBrokenDate ?? this.streakBrokenDate,
    );
  }

  factory StreakData.initial() {
    final now = DateTime.now();
    return StreakData(
      currentStreak: 0,
      streakStartDate: now,
      maxStreak: 0,
      lastActivityDate: now,
      completedToday: false,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreakData &&
          runtimeType == other.runtimeType &&
          currentStreak == other.currentStreak &&
          streakStartDate == other.streakStartDate &&
          maxStreak == other.maxStreak &&
          lastActivityDate == other.lastActivityDate &&
          completedToday == other.completedToday &&
          streakBrokenDate == other.streakBrokenDate;

  @override
  int get hashCode => Object.hash(
        currentStreak,
        streakStartDate,
        maxStreak,
        lastActivityDate,
        completedToday,
        streakBrokenDate,
      );
}

/// ストリークマイルストーン（ユーザーが達成できる目標）
class StreakMilestone {
  final int days;
  final String title;
  final String description;
  final String iconPath;
  final bool isUnlocked;

  const StreakMilestone({
    required this.days,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.isUnlocked,
  });

  factory StreakMilestone.fromJson(Map<String, dynamic> json) {
    return StreakMilestone(
      days: json['days'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      iconPath: json['iconPath'] as String,
      isUnlocked: json['isUnlocked'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'days': days,
        'title': title,
        'description': description,
        'iconPath': iconPath,
        'isUnlocked': isUnlocked,
      };

  StreakMilestone copyWith({
    int? days,
    String? title,
    String? description,
    String? iconPath,
    bool? isUnlocked,
  }) {
    return StreakMilestone(
      days: days ?? this.days,
      title: title ?? this.title,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreakMilestone &&
          runtimeType == other.runtimeType &&
          days == other.days &&
          title == other.title &&
          description == other.description &&
          iconPath == other.iconPath &&
          isUnlocked == other.isUnlocked;

  @override
  int get hashCode =>
      Object.hash(days, title, description, iconPath, isUnlocked);
}

/// 事前定義されたマイルストーン
final predefinedMilestones = [
  const StreakMilestone(
    days: 7,
    title: '1週間チャレンジ',
    description: '7日間連続で学習を継続',
    iconPath: '🔥',
    isUnlocked: false,
  ),
  const StreakMilestone(
    days: 14,
    title: '2週間チャレンジ',
    description: '14日間連続で学習を継続',
    iconPath: '💪',
    isUnlocked: false,
  ),
  const StreakMilestone(
    days: 30,
    title: '1ヶ月チャレンジ',
    description: '30日間連続で学習を継続',
    iconPath: '⭐',
    isUnlocked: false,
  ),
  const StreakMilestone(
    days: 100,
    title: '100日チャレンジ',
    description: '100日間連続で学習を継続',
    iconPath: '🏆',
    isUnlocked: false,
  ),
  const StreakMilestone(
    days: 365,
    title: '1年チャレンジ',
    description: '365日間連続で学習を継続',
    iconPath: '👑',
    isUnlocked: false,
  ),
];
