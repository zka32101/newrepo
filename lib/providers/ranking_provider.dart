import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ranking_service.dart';
import '../models/ranking_model.dart';

/// ランキングサービスプロバイダー
final rankingServiceProvider = Provider<RankingService>((ref) {
  return RankingService.instance;
});

/// ランキング取得プロバイダー
final rankingProvider = FutureProvider.family<RankingList, RankingPeriod>(
  (ref, period) async {
    final service = ref.watch(rankingServiceProvider);
    return service.getRanking(period: period);
  },
);

/// トップ3入賞者取得プロバイダー
final topThreeProvider = FutureProvider.family<List<RankingEntry>, RankingPeriod>(
  (ref, period) async {
    final service = ref.watch(rankingServiceProvider);
    return service.getTopThree(period: period);
  },
);

/// ユーザー統計取得プロバイダー
final userStatsProvider = FutureProvider.family<RankingStats, RankingPeriod>(
  (ref, period) async {
    final service = ref.watch(rankingServiceProvider);
    return service.getUserStats(period: period);
  },
);

/// スコア更新プロバイダー
final updateScoreProvider = FutureProvider.family<void, Map<String, dynamic>>(
  (ref, params) async {
    final service = ref.watch(rankingServiceProvider);
    await service.updateUserScore(
      score: params['score'] as int,
      correctAnswers: params['correctAnswers'] as int,
      totalQuestions: params['totalQuestions'] as int,
    );
    // スコア更新後、ランキングを再取得
    ref.invalidate(rankingProvider);
    ref.invalidate(userStatsProvider);
    ref.invalidate(topThreeProvider);
  },
);

/// ランク変動検知プロバイダー
final detectRankChangeProvider = FutureProvider.family<
    RankingChangeNotification?,
    Map<String, dynamic>>(
  (ref, params) async {
    final service = ref.watch(rankingServiceProvider);
    return service.detectRankChange(
      previousRank: params['previousRank'] as int,
      currentRank: params['currentRank'] as int,
    );
  },
);
