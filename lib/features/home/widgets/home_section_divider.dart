import 'package:flutter/material.dart';
import '../../../shared/constants/app_colors.dart';

/// ホーム画面のセクション見出し
class HomeSectionDivider extends StatelessWidget {
  final String title;

  const HomeSectionDivider(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
          color: isDark ? Colors.grey[400] : AppColors.textGray,
        ),
      ),
    );
  }
}
