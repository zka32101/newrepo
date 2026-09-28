import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/constants/app_colors.dart';
import '../../../shared/utils/experiment_pdf_generator.dart';
import '../../../shared/widgets/furigana_text.dart';
import '../data/experiment_guides_data.dart';
import '../models/experiment_guide.dart';

/// 実験ガイド詳細
class ExperimentGuideDetailScreen extends StatelessWidget {
  final String guideId;
  const ExperimentGuideDetailScreen({super.key, required this.guideId});

  @override
  Widget build(BuildContext context) {
    final guide = experimentGuidesData.firstWhere(
      (g) => g.id == guideId,
      orElse: () => experimentGuidesData.first,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: FuriganaText(guide.title, style: const TextStyle(fontSize: 16)),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.print_rounded),
            tooltip: '印刷する',
            onPressed: () => printExperiment(
              PrintableExperiment(
                title: FuriganaText.toPlainText(guide.title),
                grade: guide.grade,
                materials: guide.materials,
                steps: guide.steps,
                tips: FuriganaText.toPlainText(guide.description),
                safetyNote: guide.warningText,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInfoRow(guide),
          const SizedBox(height: 16),
          _sectionCard(
            context: context,
            title: '📦 用意するもの',
            color: Colors.blue[600]!,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: guide.materials
                  .map((m) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Text(m, style: const TextStyle(fontSize: 13)),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          _sectionCard(
            context: context,
            title: '🧪 実験の手順',
            color: Colors.green[600]!,
            child: Column(
              children: guide.steps.asMap().entries.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.green[600],
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${e.key + 1}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: FuriganaText(
                            e.value,
                            style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textDark,
                                height: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          _sectionCard(
            context: context,
            title: '⚠️ 安全上の注意',
            color: Colors.red[600]!,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: FuriganaText(
                guide.warningText,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textDark, height: 1.6),
              ),
            ),
          ),
          if (guide.youtubeLink != null) ...[
            const SizedBox(height: 12),
            _sectionCard(
              context: context,
              title: '🎬 参考動画',
              color: Colors.purple[600]!,
              child: TextButton.icon(
                onPressed: () => launchUrl(Uri.parse(guide.youtubeLink!)),
                icon: const Icon(Icons.play_circle_outline),
                label: const Text('動画を見る'),
              ),
            ),
          ],
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildInfoRow(ExperimentGuide guide) {
    return Row(
      children: [
        _infoChip('${guide.grade}年生', Icons.school_rounded, Colors.teal[700]!),
        const SizedBox(width: 8),
        _infoChip('⏱ 約${guide.estimatedTime}分', Icons.timer_rounded,
            Colors.grey[600]!),
      ],
    );
  }

  Widget _infoChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 13, color: color, fontWeight: FontWeight.bold)),
    );
  }

  Widget _sectionCard({
    required BuildContext context,
    required String title,
    required Color color,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
