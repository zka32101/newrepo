import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:developer' as developer;
import '../models/streak_model.dart';

/// ストリーク管理サービス
class StreakService {
  static final StreakService _instance = StreakService._internal();
  static StreakService get instance => _instance;

  factory StreakService() {
    return _instance;
  }

  StreakService._internal();

  static const String _streakDataKey = 'streak_data';
  static const String _milestonesKey = 'streak_milestones';

  late SharedPreferences _prefs;
  bool _isInitialized = false;

  /// 初期化
  Future<void> initialize() async {
    if (_isInitialized) return;
    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;
    developer.log('StreakService initialized');
  }

  /// ストリークデータを取得
  Future<StreakData> getStreakData() async {
    await _ensureInitialized();

    try {
      final jsonString = _prefs.getString(_streakDataKey);
      if (jsonString == null) {
        return StreakData.initial();
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return StreakData.fromJson(json);
    } catch (e) {
      developer.log('Error loading streak data: $e', error: e);
      return StreakData.initial();
    }
  }

  /// ストリークデータを保存
  Future<void> saveStreakData(StreakData data) async {
    await _ensureInitialized();

    try {
      final json = data.toJson();
      final jsonString = jsonEncode(json);
      await _prefs.setString(_streakDataKey, jsonString);
      developer.log('Streak data saved');
    } catch (e) {
      developer.log('Error saving streak data: $e', error: e);
    }
  }

  /// 学習完了時に呼び出す（1日1回）
  Future<StreakData> recordDailyActivity() async {
    final now = DateTime.now();
    final streak = await getStreakData();

    // 既に今日実施済みの場合はスキップ
    if (streak.completedToday) {
      return streak;
    }

    final lastActivity = streak.lastActivityDate;
    final daysSinceLastActivity = _daysBetween(lastActivity, now);

    StreakData updatedStreak;

    if (daysSinceLastActivity == 1) {
      // 昨日の後に今日学習 → ストリーク継続
      updatedStreak = streak.copyWith(
        currentStreak: streak.currentStreak + 1,
        lastActivityDate: now,
        completedToday: true,
        maxStreak: (streak.currentStreak + 1 > streak.maxStreak)
            ? streak.currentStreak + 1
            : streak.maxStreak,
      );
    } else if (daysSinceLastActivity == 0) {
      // 今日の別の時間に学習 → 変化なし
      updatedStreak = streak.copyWith(
        lastActivityDate: now,
        completedToday: true,
      );
    } else {
      // 2日以上の間隔 → ストリークリセット
      updatedStreak = streak.copyWith(
        currentStreak: 1,
        streakStartDate: now,
        lastActivityDate: now,
        completedToday: true,
        streakBrokenDate: now,
      );
      developer.log('Streak broken! Days missed: $daysSinceLastActivity');
    }

    await saveStreakData(updatedStreak);

    // マイルストーン確認
    await _checkAndUpdateMilestones(updatedStreak);

    return updatedStreak;
  }

  /// 毎日 00:00 に completedToday をリセット（Schedulerから呼び出し）
  Future<void> resetDailyFlag() async {
    final streak = await getStreakData();
    final updatedStreak = streak.copyWith(completedToday: false);
    await saveStreakData(updatedStreak);
    developer.log('Daily completion flag reset');
  }

  /// マイルストーンを取得
  Future<List<StreakMilestone>> getMilestones() async {
    await _ensureInitialized();

    try {
      final jsonString = _prefs.getString(_milestonesKey);
      if (jsonString == null) {
        return predefinedMilestones;
      }

      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((json) => StreakMilestone.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      developer.log('Error loading milestones: $e', error: e);
      return predefinedMilestones;
    }
  }

  /// マイルストーン情報を更新
  Future<void> _checkAndUpdateMilestones(StreakData streak) async {
    try {
      final milestones = await getMilestones();
      final updated = milestones.map((m) {
        return m.copyWith(
          isUnlocked: streak.currentStreak >= m.days,
        );
      }).toList();

      final jsonList = updated.map((m) => m.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await _prefs.setString(_milestonesKey, jsonString);
    } catch (e) {
      developer.log('Error updating milestones: $e', error: e);
    }
  }

  /// 次のマイルストーンまでの残り日数
  Future<int?> daysUntilNextMilestone() async {
    final streak = await getStreakData();
    final milestones = await getMilestones();

    for (final milestone in milestones) {
      if (!milestone.isUnlocked && streak.currentStreak < milestone.days) {
        return milestone.days - streak.currentStreak;
      }
    }

    return null; // すべてのマイルストーン達成
  }

  /// 本日のストリーク状態を確認
  Future<StreakStatus> checkStreakStatus() async {
    final streak = await getStreakData();
    final now = DateTime.now();
    final daysSinceLastActivity = _daysBetween(streak.lastActivityDate, now);

    if (daysSinceLastActivity == 0 && streak.completedToday) {
      return StreakStatus.completedToday;
    } else if (daysSinceLastActivity == 0) {
      return StreakStatus.incompleteToday;
    } else if (daysSinceLastActivity == 1) {
      return StreakStatus.lastChance; // ストリーク継続のラストチャンス（翌日）
    } else {
      return StreakStatus.broken;
    }
  }

  /// 2つの日付間の日数差（00:00時点での差）
  int _daysBetween(DateTime from, DateTime to) {
    return DateTime(to.year, to.month, to.day)
        .difference(DateTime(from.year, from.month, from.day))
        .inDays;
  }

  /// ストリーク状態をリセット（テスト用・管理者用）
  Future<void> resetStreak() async {
    await saveStreakData(StreakData.initial());
    await _prefs.remove(_milestonesKey);
    developer.log('Streak data reset');
  }

  /// 初期化確認
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }
}

/// ストリークの状態
enum StreakStatus {
  /// 今日の学習完了済み
  completedToday,

  /// 今日の学習がまだ
  incompleteToday,

  /// ストリーク継続のラストチャンス（翌日）
  lastChance,

  /// ストリークが途絶
  broken,
}
