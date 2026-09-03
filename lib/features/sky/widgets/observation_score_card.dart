import 'package:flutter/material.dart';

/// 観測スコア表示カード
class ObservationScoreCard extends StatelessWidget {
  final int score;
  final String description;
  final bool isSuitable;
  final bool isLoading;

  const ObservationScoreCard({
    required this.score,
    required this.description,
    required this.isSuitable,
    this.isLoading = false,
    Key? key,
  }) : super(key: key);

  /// ローディング状態
  const ObservationScoreCard.loading({Key? key})
      : score = 0,
        description = '',
        isSuitable = false,
        isLoading = true,
        super(key: key);

  Color _getColorForScore() {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.blue;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 12),
              Text(
                '観測条件を計算中...',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      );
    }

    final color = _getColorForScore();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: isSuitable
          ? (isDark ? Colors.green[900] : Colors.green[50])
          : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '天体観測適性スコア',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '$score/100',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // プログレスバー
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: score / 100,
                minHeight: 12,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            const SizedBox(height: 12),
            // 評価テキスト
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    isSuitable
                        ? Icons.thumb_up
                        : Icons.info,
                    color: color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      description,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // ポイント
            Text(
              '💡 ヒント: 雲が少なく、視程が良い夜ほどスコアが高くなります。',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
