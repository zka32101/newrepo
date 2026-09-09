import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart'
    show globalRankingProvider, GlobalRankingEntry, missionProvider;
import '../models/ranking_model.dart';
import '../providers/ranking_provider.dart';
import '../widgets/ranking_display_widget.dart';
import '../widgets/tier_selector_widget.dart';
import '../widgets/composite_filter_widget.dart';
import '../widgets/tier_stats_widget.dart';
import '../shared/theme/app_theme.dart';
import '../shared/utils/responsive.dart';
import 'add_friend_screen.dart';

/// ランキング画面（Phase 4.3-4.6 Global Ranking Integration）
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

  // 新しいグローバルランキング用タブ
  int _globalTabIndex = 0;

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
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ランキング'),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.person_add_alt_1),
              tooltip: '友達を追加',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AddFriendScreen(),
                  ),
                );
              },
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.green,
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
            onTap: (index) {
              setState(() => _globalTabIndex = index);
            },
            tabs: const [
              Tab(
                text: 'グローバル',
                icon: Icon(Icons.public),
              ),
              Tab(
                text: '教科別',
                icon: Icon(Icons.school),
              ),
              Tab(
                text: 'フレンド',
                icon: Icon(Icons.people),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildGlobalRankingTab(),
            _buildSubjectRankingTab(),
            _buildFriendRankingTab(),
          ],
        ),
      ),
    );
  }

  /// グローバルランキングタブ
  Widget _buildGlobalRankingTab() {
    return Consumer(
      builder: (context, ref, _) {
        try {
          final globalRankingAsync = ref.watch(globalRankingProvider);

          return globalRankingAsync.when(
            data: (entries) {
              if (entries.isEmpty) {
                return const Center(
                  child: Text('グローバルランキングデータがありません'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return _GlobalRankEntryCard(
                    rank: index + 1,
                    entry: entry,
                    color: Colors.green,
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text('エラー: $error'),
            ),
          );
        } catch (e) {
          // Fallback: デモデータまたは空表示
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.public, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('グローバルランキングは準備中です\n($e)'),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  /// 教科別ランキングタブ（science）
  Widget _buildSubjectRankingTab() {
    return Consumer(
      builder: (context, ref, _) {
        try {
          // subject_id: 'science' のランキング取得
          final subjectRankingAsync = ref.watch(
            globalRankingProvider, // TODO: implement fetchSubjectRanking
          );

          return subjectRankingAsync.when(
            data: (entries) {
              if (entries.isEmpty) {
                return const Center(
                  child: Text('理科のランキングデータがありません'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return _GlobalRankEntryCard(
                    rank: index + 1,
                    entry: entry,
                    color: Colors.green,
                    subjectLabel: '理科',
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text('エラー: $error'),
            ),
          );
        } catch (e) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.school, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('教科別ランキングは準備中です\n($e)'),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  /// フレンドランキングタブ（既存実装保持）
  Widget _buildFriendRankingTab() {
    return DefaultTabController(
      length: periods.length,
      child: Column(
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

          // 既存のランキングビュー
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
      RankingTier.friends => ref.watch(rankingFriendsProvider(period)),
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

  Widget _buildNoFriendsHint(double padding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Card(
        color: Colors.blue.shade50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.people_outline, color: Colors.blue),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'まだ友達が登録されていません。招待コードを送って友達と競争しよう！',
                  style: TextStyle(color: Colors.blue.shade900),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AddFriendScreen(),
                    ),
                  );
                },
                child: const Text('追加する'),
              ),
            ],
          ),
        ),
      ),
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
                _selectedTier == RankingTier.friends ? '👫 友達ランキング' : '📊 全ランキング',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            if (_selectedTier == RankingTier.friends &&
                ranking.entries.length <= 1)
              _buildNoFriendsHint(responsivePadding.left),
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

/// グローバルランキング用カードウィジェット
class _GlobalRankEntryCard extends StatelessWidget {
  final int rank;
  final dynamic entry; // GlobalRankingEntry
  final Color color;
  final String? subjectLabel;

  const _GlobalRankEntryCard({
    required this.rank,
    required this.entry,
    required this.color,
    this.subjectLabel,
  });

  @override
  Widget build(BuildContext context) {
    final rankMedal = _getMedalEmoji(rank);

    // entry の属性を安全に取得
    final String userName = _safeGet(entry, 'userName', 'ユーザー$rank');
    final int score = _safeGetInt(entry, 'score', 0);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // ランク表示（メダル）
            SizedBox(
              width: 50,
              child: Text(
                rankMedal,
                style: const TextStyle(fontSize: 32),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 12),

            // ユーザー情報
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (subjectLabel != null)
                    Text(
                      subjectLabel!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${score}点',
                        style: TextStyle(
                          fontSize: 14,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMedalEmoji(int rank) {
    return switch (rank) {
      1 => '🥇',
      2 => '🥈',
      3 => '🥉',
      _ => '${rank}位',
    };
  }

  String _safeGet(dynamic obj, String key, String defaultValue) {
    try {
      if (obj is Map && obj.containsKey(key)) {
        return obj[key].toString();
      }
      // Handle objects with properties
      final value = obj?.toString() ?? defaultValue;
      return value;
    } catch (_) {
      return defaultValue;
    }
  }

  int _safeGetInt(dynamic obj, String key, int defaultValue) {
    try {
      if (obj is Map && obj.containsKey(key)) {
        return (obj[key] as num).toInt();
      }
      return defaultValue;
    } catch (_) {
      return defaultValue;
    }
  }
}

/// フレンドランキング用カードウィジェット（統合版）
class _FriendRankCard extends StatelessWidget {
  final int rank;
  final RankingEntry entry;
  final Color color;

  const _FriendRankCard({
    required this.rank,
    required this.entry,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final rankMedal = _getMedalEmoji(rank);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // ランク表示（メダル）
            SizedBox(
              width: 50,
              child: Text(
                rankMedal,
                style: const TextStyle(fontSize: 32),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 12),

            // ユーザー情報
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.displayName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${entry.rank}位',
                        style: TextStyle(
                          fontSize: 14,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMedalEmoji(int rank) {
    return switch (rank) {
      1 => '🥇',
      2 => '🥈',
      3 => '🥉',
      _ => '${rank}位',
    };
  }
}
