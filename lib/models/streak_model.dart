import 'package:freezed_annotation/freezed_annotation.dart';

part 'streak_model.freezed.dart';
part 'streak_model.g.dart';

/// ストリーク情報モデル
@freezed
class StreakData with _$StreakData {
  const factory StreakData({
    /// 現在のストリーク日数
    required int currentStreak,

    /// ストリーク開始日
    required DateTime streakStartDate,

    /// 最大ストリーク日数
    required int maxStreak,

    /// 最後に学習した日付
    required DateTime lastActivityDate,

    /// 今日学習したかどうか
    required bool completedToday,

    /// ストリークが途絶した日時（null=継続中）
    DateTime? streakBrokenDate,
  }) = _StreakData;

  factory StreakData.fromJson(Map<String, dynamic> json) =>
      _$StreakDataFromJson(json);

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
}

/// ストリークマイルストーン（ユーザーが達成できる目標）
@freezed
class StreakMilestone with _$StreakMilestone {
  const factory StreakMilestone({
    required int days,
    required String title,
    required String description,
    required String iconPath,
    required bool isUnlocked,
  }) = _StreakMilestone;

  factory StreakMilestone.fromJson(Map<String, dynamic> json) =>
      _$StreakMilestoneFromJson(json);
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
