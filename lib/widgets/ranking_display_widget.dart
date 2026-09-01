import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ranking_model.dart';
import '../shared/theme/app_theme.dart';
import '../shared/animations/page_transitions.dart';

/// ランキング一覧ウィジェット
class RankingListWidget extends StatelessWidget {
  final List<RankingEntry> entries;
  final bool isLoading;
  final VoidCallback? onRefresh;

  const RankingListWidget({
    Key? key,
    required this.entries,
    this.isLoading = false,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.leaderboard_outlined,
              size: 64,
              color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'ランキングがまだありません',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => onRefresh?.call(),
      child: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return SlideInFadeAnimation(
            duration: Duration(milliseconds: 300 + (index * 50)),
            child: RankingEntryWidget(entry: entry),
          );
        },
      ),
    );
  }
}

/// ランキング エントリーウィジェット
class RankingEntryWidget extends StatelessWidget {
  final RankingEntry entry;

  const RankingEntryWidget({
    Key? key,
    required this.entry,
  }) : super(key: key);

  String _getRankEmoji(int rank) {
    switch (rank) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '🎖️';
    }
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber.shade700;
      case 2:
        return Colors.grey.shade400;
      case 3:
        return Colors.orange.shade700;
      default:
        return Colors.blue.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final colors = AppColors.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color: entry.isCurrentUser
              ? colors.primary
              : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
          width: entry.isCurrentUser ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: entry.isCurrentUser
            ? colors.primary.withOpacity(isDark ? 0.15 : 0.08)
            : (isDark ? Colors.grey.shade900 : Colors.grey.shade50),
        boxShadow: entry.isCurrentUser
            ? [
                BoxShadow(
                  color: colors.primary.withOpacity(0.2),
                  blurRadius: 8,
                )
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // ランク表示
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _getRankColor(entry.rank).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getRankEmoji(entry.rank),
                    style: const TextStyle(fontSize: 24),
                  ),
                  Text(
                    '${entry.rank}位',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _getRankColor(entry.rank),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // ユーザー情報
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (entry.avatarUrl != null)
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: NetworkImage(entry.avatarUrl!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      else
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.grey.shade300,
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 18,
                          ),
                        ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.userName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (entry.streak > 0)
                              Text(
                                '🔥 ${entry.streak}日',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (entry.isCurrentUser)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'あなた',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // スコア表示
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${entry.score}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${entry.correctRate.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// トップ3入賞者ウィジェット（メダル表示）
class TopThreeWidget extends ConsumerWidget {
  final List<RankingEntry> topThree;
  final bool isLoading;

  const TopThreeWidget({
    Key? key,
    required this.topThree,
    this.isLoading = false,
  }) : super(key: key);

  String _getMedalEmoji(int rank) {
    switch (rank) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '';
    }
  }

  Color _getMedalColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey.shade400;
      case 3:
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  double _getHeightForRank(int rank) {
    switch (rank) {
      case 1:
        return 180;
      case 2:
        return 150;
      case 3:
        return 120;
      default:
        return 100;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isLoading) {
      return const SizedBox(
        height: 250,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (topThree.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'トップ3データがまだありません',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(
            topThree.length,
            (index) {
              final entry = topThree[index];
              return _buildMedalColumn(entry);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMedalColumn(RankingEntry entry) {
    return Column(
      children: [
        // メダルバッジ
        Container(
          width: 80,
          height: _getHeightForRank(entry.rank),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _getMedalColor(entry.rank).withOpacity(0.3),
                _getMedalColor(entry.rank).withOpacity(0.1),
              ],
            ),
            border: Border.all(
              color: _getMedalColor(entry.rank),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _getMedalEmoji(entry.rank),
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 8),
              Text(
                '${entry.rank}位',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _getMedalColor(entry.rank),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // ユーザー情報
        Container(
          width: 90,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              if (entry.avatarUrl != null)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(entry.avatarUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade300,
                  ),
                  child: const Icon(Icons.person, size: 20),
                ),
              const SizedBox(height: 4),
              Text(
                entry.userName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${entry.score}点',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _getMedalColor(entry.rank),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// ユーザーランク表示ウィジェット
class UserRankWidget extends ConsumerWidget {
  final RankingStats stats;
  final bool isLoading;

  const UserRankWidget({
    Key? key,
    required this.stats,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isLoading) {
      return Card(
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: const SizedBox(
          height: 150,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.blue.shade100,
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              stats.period.displayLabel,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'あなたのランク',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${stats.currentUserRank}',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        Text(
                          '位',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'スコア',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${stats.currentUserScore}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'パーセンテージ',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Top ${stats.percentile.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '参加者',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${stats.totalParticipants}人',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '平均スコア',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stats.averageScore.toStringAsFixed(0),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// ランク変動表示ウィジェット
class RankChangeIndicator extends StatelessWidget {
  final RankingChangeNotification notification;

  const RankChangeIndicator({
    Key? key,
    required this.notification,
  }) : super(key: key);

  Color _getDirectionColor() {
    switch (notification.direction) {
      case RankChangeDirection.up:
        return Colors.green;
      case RankChangeDirection.down:
        return Colors.red;
      case RankChangeDirection.same:
        return Colors.grey;
    }
  }

  IconData _getDirectionIcon() {
    switch (notification.direction) {
      case RankChangeDirection.up:
        return Icons.trending_up;
      case RankChangeDirection.down:
        return Icons.trending_down;
      case RankChangeDirection.same:
        return Icons.remove;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: _getDirectionColor()),
        borderRadius: BorderRadius.circular(12),
        color: _getDirectionColor().withOpacity(0.05),
      ),
      child: Row(
        children: [
          Icon(
            _getDirectionIcon(),
            color: _getDirectionColor(),
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${notification.previousRank}位 → ${notification.currentRank}位',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  notification.message,
                  style: TextStyle(
                    fontSize: 12,
                    color: _getDirectionColor(),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
