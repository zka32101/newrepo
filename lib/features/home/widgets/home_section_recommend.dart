import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../progress/providers/user_progress_provider.dart';
import '../widgets/seasonal_recommendation_widget.dart';
import 'home_section_divider.dart';

/// ホーム画面セクション2: 🔬 おすすめ・キャラクター
class HomeSectionRecommend extends ConsumerWidget {
  const HomeSectionRecommend({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionDivider('🔬 おすすめ・キャラクター'),
        SeasonalRecommendationWidget(
          onTap: (stageId) => context.push('/quiz/$stageId'),
        ),
        _buildCharacterCard(context, ref),
      ],
    );
  }

  Widget _buildCharacterCard(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(userProgressProvider);
    final cleared = progressAsync.value?.clearedCount ?? 0;
    return GestureDetector(
      onTap: () => context.push('/characters'),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.teal[600]!, Colors.cyan[500]!]),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.teal.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
        child: Row(
          children: [
            const Text('🔬', style: TextStyle(fontSize: 26)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('理科博士コレクション',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                  Text('$cleared ステージクリア・16体のキャラを集めよう',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
