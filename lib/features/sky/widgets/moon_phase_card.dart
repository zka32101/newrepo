import 'package:flutter/material.dart';
import '../models/astronomy_model.dart';

/// 月の満ち欠け表示カード
class MoonPhaseCard extends StatelessWidget {
  final MoonPhase moonPhase;

  const MoonPhaseCard({
    required this.moonPhase,
    Key? key,
  }) : super(key: key);

  String _getMoonEmoji(double phase) {
    if (phase < 0.0625 || phase >= 0.9375) return '🌑'; // 新月
    if (phase < 0.1875) return '🌒'; // 三日月
    if (phase < 0.3125) return '🌓'; // 上弦の月（前半）
    if (phase < 0.4375) return '🌔'; // 半月
    if (phase < 0.5625) return '🌕'; // 満月
    if (phase < 0.6875) return '🌖'; // 半月（欠ける方）
    if (phase < 0.8125) return '🌗'; // 下弦の月
    return '🌘'; // 三日月（逆）
  }

  @override
  Widget build(BuildContext context) {
    final emoji = _getMoonEmoji(moonPhase.phase);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '月の満ち欠け',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(emoji, style: const TextStyle(fontSize: 36)),
              ],
            ),
            const SizedBox(height: 12),
            // 月齢と位相
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '月齢',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${moonPhase.age.toStringAsFixed(1)}日',
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '照面率',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${moonPhase.illumination.toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 位相の説明
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                moonPhase.phaseName,
                style: TextStyle(
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // 光害への影響
            Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    moonPhase.illumination > 50
                        ? '明るい月が出ています。観測には工夫が必要です。'
                        : '暗い月の夜です。星が見やすい条件です！',
                    style: Theme.of(context).textTheme.bodySmall,
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
