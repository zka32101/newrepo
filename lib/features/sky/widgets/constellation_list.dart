import 'package:flutter/material.dart';
import '../models/astronomy_model.dart';

/// 見える星座リスト表示
class ConstellationList extends StatelessWidget {
  final List<ConstellationData> constellations;
  final bool isLoading;

  const ConstellationList({
    required this.constellations,
    this.isLoading = false,
    Key? key,
  }) : super(key: key);

  /// ローディング状態
  const ConstellationList.loading({Key? key})
      : constellations = const [],
        isLoading = true,
        super(key: key);

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
                '星座情報を読み込み中...',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: Text(
            '🌟 今夜見える星座（${constellations.length}個）',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ...constellations.asMap().entries.map((entry) {
          final index = entry.key;
          return Padding(
            padding: EdgeInsets.only(bottom: index == constellations.length - 1 ? 0 : 8),
            child: _buildConstellationTile(context, entry.value),
          );
        }),
      ],
    );
  }

  /// 星座タイルを構築
  Widget _buildConstellationTile(
    BuildContext context,
    ConstellationData constellation,
  ) {
    return Card(
      child: ExpansionTile(
        leading: Text(constellation.emoji, style: const TextStyle(fontSize: 24)),
        title: Text(
          constellation.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        subtitle: constellation.brightestStar != null
            ? Text('主星: ${constellation.brightestStar}')
            : null,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  constellation.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                if (constellation.visibleMonths.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '見える季節',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 6,
                        children: constellation.visibleMonths.map((month) {
                          const monthNames = [
                            '',
                            '1月',
                            '2月',
                            '3月',
                            '4月',
                            '5月',
                            '6月',
                            '7月',
                            '8月',
                            '9月',
                            '10月',
                            '11月',
                            '12月',
                          ];
                          return Chip(
                            label: Text(
                              monthNames[month],
                              style: const TextStyle(fontSize: 11),
                            ),
                            visualDensity:
                                VisualDensity.compact,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                if (constellation.brightestStar != null) ...[
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '主星',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          constellation.brightestStar!,
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.visibility,
                        size: 16,
                        color: Colors.amber[700],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          constellation.isVisibleNow
                              ? '🎯 今夜見える時間帯があります！'
                              : '📅 この季節は昼間に見えます',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.amber[900],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
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
