import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ranking_model.dart';
import '../providers/ranking_provider.dart';
import '../widgets/ranking_display_widget.dart';
import '../widgets/tier_selector_widget.dart';
import '../widgets/composite_filter_widget.dart';
import '../widgets/tier_stats_widget.dart';
import '../shared/theme/app_theme.dart';
import '../shared/utils/responsive.dart';

/// ランキング画面
class RankingScreen extends ConsumerStatefulWidget {
  const RankingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends ConsumerState<RankingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final List<RankingPeriod> periods = [
    RankingPeriod.daily,
    RankingPeriod.weekly,
    RankingPeriod.monthly,
  ];

  // ティア選択状態
  late RankingTier _selectedTier = RankingTier.allTime;
  late GradeLevel? _gradeFilter;
  late SchoolYear? _monthFilter;
  late bool _applyBothFilters = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: periods.length, vsync: this);
    _gradeFilter = null;
    _monthFilter = null;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: periods.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ランキング'),
          centerTitle: true,
          elevation: 0,
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                text: periods[0].displayLabel,
                icon: const Icon(Icons.calendar_today),
              ),
              Tab(
                text: periods[1].displayLabel,
                icon: const Icon(Icons.calendar_view_week),
              ),
              Tab(
                text: periods[2].displayLabel,
                icon: const Icon(Icons.calendar_view_month),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            // ティア選択セクション
            TierSelectorWidget(
              selectedTier: _selectedTier,
              onTierChanged: (tier) {
                setState(() => _selectedTier = tier);
              },
            ),

            // 複合フィルターセクション（複合ティア選択時のみ表示）
            if (_selectedTier == RankingTier.composite)
              CompositeFilterWidget(
                selectedGrade: _gradeFilter,
                selectedMonth: _monthFilter,
                applyBothFilters: _applyBothFilters,
                onFilterChanged: (grade, month, both) {
                  setState(() {
                    _gradeFilter = grade;
                    _monthFilter = month;
                    _applyBothFilters = both;
                  });
                },
                displayMode: FilterDisplayMode.simple,
              ),

            // ランキングビュー
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPeriodView(periods[0]),
                  _buildPeriodView(periods[1]),
                  _buildPeriodView(periods[2]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodView(RankingPeriod period) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // ティア統計情報（複合ティア以外）
          if (_selectedTier != RankingTier.allTime) ...[
            _buildTierStatsSection(period),
          ],

          // トップ3表示（全体ティアのみ）
          if (_selectedTier == RankingTier.allTime) ...[
            _buildTopThreeSection(period),
            // ユーザー統計
            _buildUserStatsSection(period),
          ],

          // 全ランキング
          _buildRankingListSection(period),
        ],
      ),
    );
  }

  /// 選択されたティアに基づいて適切なランキングプロバイダーを返す
  AsyncValue<RankingList> _getRankingAsync(RankingPeriod period) {
    return switch (_selectedTier) {
      RankingTier.allTime => ref.watch(rankingProvider(period)),
      RankingTier.byGrade => ref.watch(rankingByGradeProvider((
        period: period,
        grade: _gradeFilter ?? GradeLevel.grade3,
      ))),
      RankingTier.byStartMonth => ref.watch(rankingByStartMonthProvider((
        period: period,
        startMonth: _monthFilter ?? SchoolYear.april,
      ))),
      RankingTier.composite => ref.watch(rankingCompositeProvider((
        period: period,
        gradeFilter: _gradeFilter,
        startMonthFilter: _monthFilter,
        applyBothFilters: _applyBothFilters,
      ))),
    };
  }

  Widget _buildTierStatsSection(RankingPeriod period) {
    final rankingAsync = _getRankingAsync(period);

    return rankingAsync.when(
      data: (ranking) {
        if (ranking.userTierInfo == null) {
          return const SizedBox.shrink();
        }
        return TierStatsWidget(
          tierInfo: ranking.userTierInfo!,
          isLoading: false,
        );
      },
      loading: () {
        return const TierStatsWidget(
          tierInfo: TierRankingInfo(
            tier: RankingTier.allTime,
            tierDescription: 'Loading...',
            totalParticipants: 0,
            userRankInTier: 0,
            correctRateRank: 0,
            tierAverageScore: 0,
            tierTopScore: 0,
            isActiveTier: true,
          ),
          isLoading: true,
        );
      },
      error: (error, stack) {
        final responsivePadding = Responsive.getPadding(context);
        return Padding(
          padding: EdgeInsets.all(responsivePadding.left),
          child: Text(
            'ティア情報読み込み失敗: $error',
            style: const TextStyle(color: Colors.red),
          ),
        );
      },
    );
  }

  Widget _buildTopThreeSection(RankingPeriod period) {
    final topThreeAsync = ref.watch(topThreeProvider(period));
    final responsivePadding = Responsive.getPadding(context);

    return topThreeAsync.when(
      data: (topThree) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(responsivePadding.left),
              child: Text(
                '🏆 入賞者',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            TopThreeWidget(
              topThree: topThree,
              isLoading: false,
            ),
            SizedBox(height: responsivePadding.top),
          ],
        );
      },
      loading: () {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(responsivePadding.left),
              child: Text(
                '🏆 入賞者',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            TopThreeWidget(
              topThree: const [],
              isLoading: true,
            ),
            SizedBox(height: responsivePadding.top),
          ],
        );
      },
      error: (error, stack) {
        return Padding(
          padding: EdgeInsets.all(responsivePadding.left),
          child: Text(
            'エラー: $error',
            style: const TextStyle(color: Colors.red),
          ),
        );
      },
    );
  }

  Widget _buildUserStatsSection(RankingPeriod period) {
    final statsAsync = ref.watch(userStatsProvider(period));
    final responsivePadding = Responsive.getPadding(context);

    return statsAsync.when(
      data: (stats) {
        return UserRankWidget(
          stats: stats,
          isLoading: false,
        );
      },
      loading: () {
        return const SizedBox(
          height: 150,
          child: Center(child: CircularProgressIndicator()),
        );
      },
      error: (error, stack) {
        return Padding(
          padding: EdgeInsets.all(responsivePadding.left),
          child: Text(
            'ユーザー統計読み込み失敗: $error',
            style: const TextStyle(color: Colors.red),
          ),
        );
      },
    );
  }

  Widget _buildRankingListSection(RankingPeriod period) {
    final rankingAsync = _getRankingAsync(period);
    final responsivePadding = Responsive.getPadding(context);

    return rankingAsync.when(
      data: (ranking) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(responsivePadding.left),
              child: Text(
                '📊 全ランキング',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            SizedBox(
              height: 400,
              child: RankingListWidget(
                entries: ranking.entries,
                isLoading: false,
                onRefresh: () async {
                  ref.refresh(rankingProvider(period));
                },
              ),
            ),
            SizedBox(height: responsivePadding.top),
          ],
        );
      },
      loading: () {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(responsivePadding.left),
              child: Text(
                '📊 全ランキング',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            SizedBox(
              height: 400,
              child: RankingListWidget(
                entries: const [],
                isLoading: true,
              ),
            ),
            SizedBox(height: responsivePadding.top),
          ],
        );
      },
      error: (error, stack) {
        return Padding(
          padding: EdgeInsets.all(responsivePadding.left),
          child: Text(
            'ランキング読み込み失敗: $error',
            style: const TextStyle(color: Colors.red),
          ),
        );
      },
    );
  }
}

/// ランキング統計表示画面
class RankingStatsScreen extends ConsumerWidget {
  final RankingPeriod period;

  const RankingStatsScreen({
    Key? key,
    required this.period,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(userStatsProvider(period));

    return Scaffold(
      appBar: AppBar(
        title: Text('${period.displayLabel}の成績'),
        centerTitle: true,
      ),
      body: statsAsync.when(
        data: (stats) {
          final responsivePadding = Responsive.getPadding(context);
          return SingleChildScrollView(
            padding: EdgeInsets.all(responsivePadding.left),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ランク情報
                UserRankWidget(
                  stats: stats,
                  isLoading: false,
                ),
                SizedBox(height: responsivePadding.top + 8),
                // 詳細統計
                _buildStatsDetails(context, stats),
              ],
            ),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stack) {
          return Center(
            child: Text(
              'エラー: $error',
              style: const TextStyle(color: Colors.red),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsDetails(BuildContext context, RankingStats stats) {
    final responsivePadding = Responsive.getPadding(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(responsivePadding.left),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📈 詳細情報',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: responsivePadding.top),
            _buildStatRow(
              '1位のスコア',
              '${stats.topScore}',
            ),
            const Divider(),
            _buildStatRow(
              '平均スコア',
              stats.averageScore.toStringAsFixed(1),
            ),
            const Divider(),
            _buildStatRow(
              '参加者数',
              '${stats.totalParticipants}人',
            ),
            const Divider(),
            _buildStatRow(
              'あなたのランク',
              '${stats.currentUserRank}位 / ${stats.totalParticipants}位',
            ),
            const SizedBox(height: 16),
            if (stats.scoreHistory.isNotEmpty) ...[
              Text(
                '📊 スコア推移（過去7日間）',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              _buildScoreHistory(stats.scoreHistory),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildScoreHistory(List<DailyScoreData> history) {
    return Column(
      children: history.map((day) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${day.date.month}/${day.date.day}',
                style: const TextStyle(fontSize: 12),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: day.score / 100,
                        minHeight: 20,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation(
                          day.score > 80
                              ? Colors.green
                              : day.score > 50
                                  ? Colors.orange
                                  : Colors.red,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${day.score}点',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
