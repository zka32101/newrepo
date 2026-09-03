import 'package:flutter/material.dart';

/// クエリクォータ使用量インジケーター
class QuotaIndicator extends StatelessWidget {
  final int used;
  final int limit;

  const QuotaIndicator({
    required this.used,
    required this.limit,
    Key? key,
  }) : super(key: key);

  Color _getColorForUsage() {
    final ratio = used / limit;
    if (ratio < 0.5) return Colors.green;
    if (ratio < 0.8) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final progress = (used / limit).clamp(0.0, 1.0);
    final color = _getColorForUsage();
    final remaining = limit - used;

    return Tooltip(
      message: '$used / $limit 使用済み（残り $remaining 回）',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 60,
            height: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$used/$limit',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
