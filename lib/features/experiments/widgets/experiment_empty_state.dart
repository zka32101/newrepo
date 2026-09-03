import 'package:flutter/material.dart';

/// 実験が見つからない場合の空状態ウィジェット
class ExperimentEmptyState extends StatelessWidget {
  final int? selectedGrade;
  final VoidCallback? onReset;

  const ExperimentEmptyState({
    Key? key,
    this.selectedGrade,
    this.onReset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // アイコン
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isDark ? Colors.grey[700] : Colors.grey[100])!,
                ),
                child: Icon(
                  Icons.science_outlined,
                  size: 48,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),

              // タイトル
              Text(
                'じっけんがまだありません',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),

              // 説明文
              Text(
                selectedGrade != null && selectedGrade != 0
                    ? '${selectedGrade}年生のじっけんは\nもう少しお待ちください'
                    : '学年を選んでじっけんを\nやってみてね！',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // リセットボタン
              if (selectedGrade != null && selectedGrade != 0 && onReset != null)
                ElevatedButton.icon(
                  onPressed: onReset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('すべて表示'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
