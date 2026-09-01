import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/achievement_service.dart';
import '../models/achievement_model.dart';

/// アチーブメントサービスプロバイダー
final achievementServiceProvider = Provider<AchievementService>((ref) {
  return AchievementService.instance;
});

/// 全アチーブメント取得プロバイダー
final allAchievementsProvider = FutureProvider<List<Achievement>>(
  (ref) async {
    final service = ref.watch(achievementServiceProvider);
    return service.getAllAchievements();
  },
);

/// ユーザーのアチーブメント取得プロバイダー
final userAchievementsProvider = FutureProvider<List<UserAchievement>>(
  (ref) async {
    final service = ref.watch(achievementServiceProvider);
    return service.getUserAchievements();
  },
);

/// アチーブメント統計プロバイダー
final achievementStatsProvider = FutureProvider<AchievementStats>(
  (ref) async {
    final service = ref.watch(achievementServiceProvider);
    return service.getAchievementStats();
  },
);

/// クイズ完了時にアチーブメントを確認するプロバイダー
final checkQuizAchievementsProvider = FutureProvider.family<
    List<AchievementUnlockedNotification>,
    Map<String, dynamic>>(
  (ref, params) async {
    final service = ref.watch(achievementServiceProvider);
    final notifications = await service.checkQuizCompletion(
      totalQuizzes: params['totalQuizzes'] as int,
      correctCount: params['correctCount'] as int,
      totalQuestions: params['totalQuestions'] as int,
    );

    // アチーブメント取得を更新
    ref.invalidate(userAchievementsProvider);
    ref.invalidate(achievementStatsProvider);

    return notifications;
  },
);

/// ストリーク更新時にアチーブメントを確認するプロバイダー
final checkStreakAchievementsProvider = FutureProvider.family<
    List<AchievementUnlockedNotification>,
    int>(
  (ref, currentStreak) async {
    final service = ref.watch(achievementServiceProvider);
    final notifications = await service.checkStreakAchievements(
      currentStreak: currentStreak,
    );

    // アチーブメント取得を更新
    ref.invalidate(userAchievementsProvider);
    ref.invalidate(achievementStatsProvider);

    return notifications;
  },
);

/// ランキング更新時にアチーブメントを確認するプロバイダー
final checkRankingAchievementsProvider = FutureProvider.family<
    List<AchievementUnlockedNotification>,
    int>(
  (ref, currentRank) async {
    final service = ref.watch(achievementServiceProvider);
    final notifications = await service.checkRankingAchievements(
      currentRank: currentRank,
    );

    // アチーブメント取得を更新
    ref.invalidate(userAchievementsProvider);
    ref.invalidate(achievementStatsProvider);

    return notifications;
  },
);

/// SNS共有時にアチーブメントを確認するプロバイダー
final checkSharingAchievementsProvider = FutureProvider<
    List<AchievementUnlockedNotification>>(
  (ref) async {
    final service = ref.watch(achievementServiceProvider);
    final notifications = await service.checkSharingAchievements();

    // アチーブメント取得を更新
    ref.invalidate(userAchievementsProvider);
    ref.invalidate(achievementStatsProvider);

    return notifications;
  },
);
