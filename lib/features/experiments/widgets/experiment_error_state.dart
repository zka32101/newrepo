import 'package:flutter/material.dart';

/// 実験データ読み込みエラー時の状態ウィジェット
class ExperimentErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final bool isLoading;

  const ExperimentErrorState({
    Key? key,
    required this.message,
    required this.onRetry,
    this.isLoading = false,
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
              // エラーアイコン
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isDark ? Colors.red[900] : Colors.red[50])!,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red[400],
                ),
              ),
              const SizedBox(height: 24),

              // エラータイトル
              Text(
                'エラーが発生しました',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),

              // エラーメッセージ
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // リトライボタン
              ElevatedButton.icon(
                onPressed: isLoading ? null : onRetry,
                icon: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Icon(Icons.refresh),
                label: Text(isLoading ? 'よみこみちゅう...' : 'もう一度'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  backgroundColor:
                      isLoading ? Colors.grey[400] : Colors.blue[600],
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
