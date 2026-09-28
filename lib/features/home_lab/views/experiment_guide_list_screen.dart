import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/constants/app_colors.dart';
import '../../../shared/widgets/furigana_text.dart';
import '../data/experiment_guides_data.dart';

/// 実験ガイド一覧
class ExperimentGuideListScreen extends StatefulWidget {
  const ExperimentGuideListScreen({super.key});

  @override
  State<ExperimentGuideListScreen> createState() =>
      _ExperimentGuideListScreenState();
}

class _ExperimentGuideListScreenState
    extends State<ExperimentGuideListScreen> {
  int _selectedGrade = 0; // 0=すべて

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedGrade == 0
        ? experimentGuidesData
        : experimentGuidesData.where((g) => g.grade == _selectedGrade).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('実験ガイド'),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                _filterChip(0, 'すべて'),
                const SizedBox(width: 6),
                _filterChip(3, '3年'),
                const SizedBox(width: 6),
                _filterChip(4, '4年'),
                const SizedBox(width: 6),
                _filterChip(5, '5年'),
                const SizedBox(width: 6),
                _filterChip(6, '6年'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              physics: const BouncingScrollPhysics(),
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final guide = filtered[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    title: FuriganaText(
                      guide.title,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: FuriganaText(
                        guide.description,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded,
                        color: AppColors.textGray),
                    onTap: () =>
                        context.push('/experiment-guide/${guide.id}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(int grade, String label) {
    final selected = _selectedGrade == grade;
    return GestureDetector(
      onTap: () => setState(() => _selectedGrade = grade),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.teal[700] : Colors.teal[50],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.teal[700]! : Colors.teal[200]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: selected ? Colors.white : Colors.teal[800],
          ),
        ),
      ),
    );
  }
}
