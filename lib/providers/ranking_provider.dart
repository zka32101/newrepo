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

/// 学年別ランキング取得プロバイダー
/// 使用例: ref.watch(rankingByGradeProvider((period: RankingPeriod.daily, grade: GradeLevel.grade3)))
final rankingByGradeProvider = FutureProvider.family<
    RankingList,
    ({RankingPeriod period, GradeLevel grade})>(
  (ref, params) async {
    final service = ref.watch(rankingServiceProvider);
    return service.getRankingByGrade(
      grade: params.grade,
      period: params.period,
    );
  },
);

/// 開始月別ランキング取得プロバイダー
/// 使用例: ref.watch(rankingByStartMonthProvider((period: RankingPeriod.daily, startMonth: SchoolYear.april)))
final rankingByStartMonthProvider = FutureProvider.family<
    RankingList,
    ({RankingPeriod period, SchoolYear startMonth})>(
  (ref, params) async {
    final service = ref.watch(rankingServiceProvider);
    return service.getRankingByStartMonth(
      startMonth: params.startMonth,
      period: params.period,
    );
  },
);

/// 複合グループランキング取得プロバイダー
/// 使用例: ref.watch(rankingCompositeProvider((
///   period: RankingPeriod.daily,
///   gradeFilter: GradeLevel.grade5,
///   startMonthFilter: SchoolYear.april,
///   applyBothFilters: true
/// )))
final rankingCompositeProvider = FutureProvider.family<
    RankingList,
    ({
      RankingPeriod period,
      GradeLevel? gradeFilter,
      SchoolYear? startMonthFilter,
      bool applyBothFilters,
    })>(
  (ref, params) async {
    final service = ref.watch(rankingServiceProvider);
    return service.getRankingComposite(
      period: params.period,
      gradeFilter: params.gradeFilter,
      startMonthFilter: params.startMonthFilter,
      applyBothFilters: params.applyBothFilters,
    );
  },
);

/// スコア更新プロバイダー（ティア情報付き）
final updateScoreTierProvider = FutureProvider.family<void, Map<String, dynamic>>(
  (ref, params) async {
    final service = ref.watch(rankingServiceProvider);

    final gradeLevel = params['gradeLevel'] != null
        ? GradeLevel.fromGradeNumber(params['gradeLevel'] as int)
        : null;
    final startMonth = params['startMonth'] != null
        ? SchoolYear.fromMonthNumber(params['startMonth'] as int)
        : null;

    await service.updateUserScore(
      score: params['score'] as int,
      correctAnswers: params['correctAnswers'] as int,
      totalQuestions: params['totalQuestions'] as int,
      gradeLevel: gradeLevel,
      startMonth: startMonth,
    );

    // スコア更新後、全てのランキングプロバイダーを無効化
    ref.invalidate(rankingProvider);
    ref.invalidate(userStatsProvider);
    ref.invalidate(topThreeProvider);
    ref.invalidate(rankingByGradeProvider);
    ref.invalidate(rankingByStartMonthProvider);
    ref.invalidate(rankingCompositeProvider);
  },
);
