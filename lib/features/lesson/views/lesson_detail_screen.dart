import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart'
    hide progressProvider, LearningProgress, ProgressNotifier;
import '../../../data/lesson_data.dart';

/// 「学ぶ」の詳細ページ
/// 個別の lesson コンテンツを表示し、ふりがな対応テキストで本文を描画する
class LessonDetailScreen extends ConsumerWidget {
  final String lessonId;

  const LessonDetailScreen({
    required this.lessonId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // lesson_id に対応するコンテンツを探す
    final lesson = kLessons.firstWhere(
      (l) => l.id == lessonId,
      orElse: () => kLessons.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================
            // ① ヘッダー（emoji + 分類 + 学年）
            // =====================
            _buildHeader(context, lesson),
            const SizedBox(height: 24),

            // =====================
            // ② メインコンテンツ（セクション別）
            // =====================
            ...lesson.sections.map((section) {
              return _buildSection(context, section);
            }).toList(),

            const SizedBox(height: 24),

            // =====================
            // ③ 関連ステージへのリンク
            // =====================
            if (lesson.relatedStageId.isNotEmpty)
              _buildRelatedStage(context, lesson),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// 헤더를 구성합니다（emoji, カテゴリ, 学年, 読了時間）
  Widget _buildHeader(BuildContext context, LessonContent lesson) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // emoji + title
          Row(
            children: [
              Text(
                lesson.emoji,
                style: const TextStyle(fontSize: 36),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FuriganaText(
                  lesson.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // category + grade + readTime
          Row(
            children: [
              // カテゴリタグ
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getCategoryColor(lesson.category, theme).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  lesson.category,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getCategoryColor(lesson.category, theme),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // 学年バッジ
              _buildGradeBadge(context, lesson.grade),
              const SizedBox(width: 12),

              // 読了時間
              if (lesson.estimatedReadMinutes > 0)
                Text(
                  '${lesson.estimatedReadMinutes} 分',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// セクションを描画
  Widget _buildSection(BuildContext context, LessonSection section) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // セクション見出し
          FuriganaText(
            section.heading,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),

          // セクション本文（ふりがな対応）
          FuriganaText(
            section.body,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  /// 関連ステージへのリンク
  Widget _buildRelatedStage(BuildContext context, LessonContent lesson) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '関連するステージ',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              // ステージへのナビゲーション
              // context.go('/quiz/${lesson.relatedStageId}');
            },
            icon: const Icon(Icons.play_arrow),
            label: Text('${lesson.relatedStageId} を学習する'),
          ),
        ],
      ),
    );
  }

  /// 学年バッジ
  Widget _buildGradeBadge(BuildContext context, int grade) {
    final theme = Theme.of(context);
    final color = _getGradeColor(grade, theme);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${grade}年生',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  /// カテゴリに応じた色を取得
  Color _getCategoryColor(String category, ThemeData theme) {
    switch (category) {
      case '植物のふしぎ':
        return const Color(0xFF2E7D32); // 緑
      case '電気のふしぎ':
        return const Color(0xFFFFA500); // オレンジ
      case '天気のふしぎ':
        return const Color(0xFF1976D2); // 青
      case '物のすがた':
        return const Color(0xFF7B1FA2); // 紫
      case '生き物のふしぎ':
        return const Color(0xFFD32F2F); // 赤
      default:
        return theme.colorScheme.primary;
    }
  }

  /// 学年に応じた色を取得
  Color _getGradeColor(int grade, ThemeData theme) {
    switch (grade) {
      case 3:
        return const Color(0xFFFF9800); // オレンジ
      case 4:
        return const Color(0xFF2196F3); // 青
      case 5:
        return const Color(0xFF9C27B0); // 紫
      case 6:
        return const Color(0xFFE91E63); // ピンク
      default:
        return theme.colorScheme.primary;
    }
  }
}
