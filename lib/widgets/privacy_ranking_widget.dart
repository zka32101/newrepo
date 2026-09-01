import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shokollen_science/models/ranking_model.dart';
import 'package:shokollen_science/models/privacy_settings_model.dart';
import 'package:shokollen_science/providers/privacy_settings_provider.dart';

/// プライバシー保護対応ランキング一覧ウィジェット
///
/// 複数のランキングエントリを表示し、プライバシー設定に基づいて名前を匿名化
class PrivacyRankingListWidget extends StatelessWidget {
  final List<RankingEntry> entries;
  final bool isLoading;
  final VoidCallback? onRefresh;

  const PrivacyRankingListWidget({
    Key? key,
    required this.entries,
    this.isLoading = false,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'ランキングがまだありません',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey.shade600,
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
          return PrivacyRankingEntryWidget(
            entry: entry,
            isCurrentUser: entry.isCurrentUser,
          );
        },
      ),
    );
  }
}

/// プライバシー保護対応ランキング表示ウィジェット
///
/// ユーザーのプライバシー設定に基づいて、名前を匿名化して表示します
/// - デフォルト：匿名ID "プレイヤー ★XXXX" で表示
/// - opt-in：本名表示
/// - 現在のユーザー：常に本名表示
class PrivacyRankingEntryWidget extends ConsumerWidget {
  final RankingEntry entry;
  final bool isCurrentUser;
  final String? currentUserPrivacySettingSnapshot;

  const PrivacyRankingEntryWidget({
    Key? key,
    required this.entry,
    required this.isCurrentUser,
    this.currentUserPrivacySettingSnapshot,
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
  Widget build(BuildContext context, WidgetRef ref) {
    // ランキングエントリから プライバシー設定を取得
    final displayName = PrivacyUtils.getDisplayName(
      entry.userId,
      entry.userName,
      entry.showNameInRanking,
      isCurrentUser,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color: isCurrentUser ? Colors.blue : Colors.grey.shade300,
          width: isCurrentUser ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isCurrentUser ? Colors.blue.shade50 : Colors.grey.shade50,
        boxShadow: isCurrentUser
            ? [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
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
                              displayName,
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
                      if (isCurrentUser)
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

/// プライバシー保護対応トップ3ウィジェット
class PrivacyTopThreeWidget extends ConsumerWidget {
  final List<RankingEntry> topThree;
  final bool isLoading;

  const PrivacyTopThreeWidget({
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
    // エントリからプライバシー設定を取得して表示名を決定
    final displayName = PrivacyUtils.getDisplayName(
      entry.userId,
      entry.userName,
      entry.showNameInRanking,
      false, // トップ3は常に他のユーザー
    );

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
                displayName,
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
