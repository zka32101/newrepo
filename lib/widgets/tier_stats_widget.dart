import 'package:flutter/material.dart';
import '../models/ranking_model.dart';

/// ティア別ランキング統計表示ウィジェット
/// 選択したティアにおけるユーザーの位置情報と統計情報を表示
class TierStatsWidget extends StatelessWidget {
  /// ティア情報
  final TierRankingInfo tierInfo;

  /// ローディング中かどうか
  final bool isLoading;

  const TierStatsWidget({
    Key? key,
    required this.tierInfo,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: const SizedBox(
          height: 150,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ティア情報ヘッダー
            _buildTierHeader(context),
            const SizedBox(height: 16),

            // ユーザーランク情報
            _buildUserRankInfo(context),
            const SizedBox(height: 12),

            // ティア統計情報
            _buildTierStats(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTierHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getTierColor().withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            tierInfo.tier.displayLabel,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _getTierColor(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            tierInfo.tierDescription,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildUserRankInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getTierColor().withOpacity(0.1),
            _getTierColor().withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildInfoColumn(
            context,
            'ティア内順位',
            '${tierInfo.userRankInTier}位',
            Icons.emoji_events,
          ),
          const VerticalDivider(),
          _buildInfoColumn(
            context,
            '参加者数',
            '${tierInfo.totalParticipants}人',
            Icons.people,
          ),
          const VerticalDivider(),
          _buildInfoColumn(
            context,
            '成績順位',
            'Top ${((tierInfo.userRankInTier / tierInfo.totalParticipants) * 100).toStringAsFixed(1)}%',
            Icons.trending_up,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: _getTierColor(),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTierStats(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📊 ティア内統計',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        _buildStatRow(
          '最高スコア',
          '${tierInfo.tierTopScore}点',
          context,
        ),
        const SizedBox(height: 6),
        _buildStatRow(
          '平均スコア',
          '${tierInfo.tierAverageScore.toStringAsFixed(1)}点',
          context,
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, String value, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Color _getTierColor() {
    return switch (tierInfo.tier) {
      RankingTier.allTime => Colors.amber,
      RankingTier.byGrade => Colors.blue,
      RankingTier.byStartMonth => Colors.green,
      RankingTier.composite => Colors.purple,
    };
  }
}
