import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/social_share_service.dart';

/// SNS シェアサービスプロバイダー
final shareServiceProvider = Provider<SocialShareService>((ref) {
  return SocialShareService.instance;
});

/// スコアシェアプロバイダー
final shareScoreProvider = FutureProvider.family<void, Map<String, dynamic>>(
  (ref, params) async {
    final service = ref.watch(shareServiceProvider);
    await service.shareScore(
      score: params['score'] as int,
      categoryName: params['categoryName'] as String,
      currentStreak: params['currentStreak'] as int,
      maxStreak: params['maxStreak'] as int,
    );
  },
);

/// ストリークシェアプロバイダー
final shareStreakProvider = FutureProvider.family<void, Map<String, dynamic>>(
  (ref, params) async {
    final service = ref.watch(shareServiceProvider);
    await service.shareStreak(
      streakDays: params['streakDays'] as int,
      milestoneTitle: params['milestoneTitle'] as String,
      milestoneEmoji: params['milestoneEmoji'] as String,
    );
  },
);

/// バッジシェアプロバイダー
final shareBadgeProvider = FutureProvider.family<void, Map<String, dynamic>>(
  (ref, params) async {
    final service = ref.watch(shareServiceProvider);
    await service.shareBadge(
      badgeTitle: params['badgeTitle'] as String,
      badgeEmoji: params['badgeEmoji'] as String,
      description: params['description'] as String,
    );
  },
);

/// ランキングシェアプロバイダー
final shareRankingProvider = FutureProvider.family<void, Map<String, dynamic>>(
  (ref, params) async {
    final service = ref.watch(shareServiceProvider);
    await service.shareRanking(
      rank: params['rank'] as int,
      score: params['score'] as int,
      period: params['period'] as String,
    );
  },
);

/// 問題シェアプロバイダー
final shareQuestionProvider = FutureProvider.family<void, Map<String, dynamic>>(
  (ref, params) async {
    final service = ref.watch(shareServiceProvider);
    await service.shareQuestion(
      questionText: params['questionText'] as String,
      correctAnswer: params['correctAnswer'] as String,
      categoryName: params['categoryName'] as String,
    );
  },
);
