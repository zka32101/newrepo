import 'package:flutter/material.dart';
import '../models/ranking_model.dart';

/// 学年レベルバッジウィジェット
/// ユーザーの現在の学年を視覚的に表示
class GradeLevelBadge extends StatelessWidget {
  /// 学年（3, 4, 5, 6）
  final int gradeLevel;

  /// バッジのサイズ
  final BadgeSize size;

  /// バッジのスタイル
  final BadgeStyle style;

  /// タップ時のコールバック
  final VoidCallback? onTap;

  const GradeLevelBadge({
    Key? key,
    required this.gradeLevel,
    this.size = BadgeSize.medium,
    this.style = BadgeStyle.filled,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final grade = GradeLevel.fromGradeNumber(gradeLevel);
    final colors = _getGradeColors(grade);

    Widget badge;

    if (style == BadgeStyle.filled) {
      badge = Container(
        padding: _getPadding(),
        decoration: BoxDecoration(
          color: colors.backgroundColor,
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          border: Border.all(color: colors.borderColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: colors.backgroundColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              colors.emoji,
              style: TextStyle(fontSize: _getEmojiSize()),
            ),
            const SizedBox(width: 4),
            Text(
              grade.label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: _getTextSize(),
                color: colors.textColor,
              ),
            ),
          ],
        ),
      );
    } else {
      badge = Container(
        padding: _getPadding(),
        decoration: BoxDecoration(
          border: Border.all(color: colors.borderColor, width: 2),
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              colors.emoji,
              style: TextStyle(fontSize: _getEmojiSize()),
            ),
            const SizedBox(width: 4),
            Text(
              grade.label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: _getTextSize(),
                color: colors.borderColor,
              ),
            ),
          ],
        ),
      );
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: badge,
      );
    }

    return badge;
  }

  EdgeInsets _getPadding() {
    return switch (size) {
      BadgeSize.small => const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      BadgeSize.medium => const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      BadgeSize.large => const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    };
  }

  double _getBorderRadius() {
    return switch (size) {
      BadgeSize.small => 6,
      BadgeSize.medium => 8,
      BadgeSize.large => 10,
    };
  }

  double _getTextSize() {
    return switch (size) {
      BadgeSize.small => 10,
      BadgeSize.medium => 12,
      BadgeSize.large => 14,
    };
  }

  double _getEmojiSize() {
    return switch (size) {
      BadgeSize.small => 14,
      BadgeSize.medium => 16,
      BadgeSize.large => 18,
    };
  }

  _GradeColors _getGradeColors(GradeLevel grade) {
    return switch (grade) {
      GradeLevel.grade3 => _GradeColors(
        emoji: '🟢',
        backgroundColor: Colors.green[50]!,
        borderColor: Colors.green[600]!,
        textColor: Colors.green[800]!,
      ),
      GradeLevel.grade4 => _GradeColors(
        emoji: '🔵',
        backgroundColor: Colors.blue[50]!,
        borderColor: Colors.blue[600]!,
        textColor: Colors.blue[800]!,
      ),
      GradeLevel.grade5 => _GradeColors(
        emoji: '🟡',
        backgroundColor: Colors.amber[50]!,
        borderColor: Colors.amber[600]!,
        textColor: Colors.amber[800]!,
      ),
      GradeLevel.grade6 => _GradeColors(
        emoji: '🔴',
        backgroundColor: Colors.red[50]!,
        borderColor: Colors.red[600]!,
        textColor: Colors.red[800]!,
      ),
    };
  }
}

class _GradeColors {
  final String emoji;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  _GradeColors({
    required this.emoji,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  });
}

enum BadgeSize { small, medium, large }
enum BadgeStyle { filled, outline }
