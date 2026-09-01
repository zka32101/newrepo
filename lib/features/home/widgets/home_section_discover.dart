import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/constants/app_colors.dart';
import '../../progress/providers/daily_mystery_provider.dart';
import 'home_section_divider.dart';

/// ホーム画面セクション5: ✨ もっと理科をたのしむ
class HomeSectionDiscover extends ConsumerWidget {
  const HomeSectionDiscover({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionDivider('✨ もっと理科をたのしむ'),
        _buildDailyMysteryBadge(context, ref),
        _buildInnovationFeatures(context),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildDailyMysteryBadge(BuildContext context, WidgetRef ref) {
    final record = ref.watch(dailyMysteryNotifierProvider);
    final isRevealed = record != null;
    final isAnswered = record != null && record.answeredAt != null;

    return GestureDetector(
      onTap: () => context.push('/daily-mystery-omikuji'),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF6366F1).withOpacity(0.95),
                const Color(0xFF4F46E5).withOpacity(0.85),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withOpacity(0.25),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                ),
                child: Center(
                  child: Text(
                    isAnswered
                        ? '✨'
                        : isRevealed
                            ? '📖'
                            : '📿',
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '今日のふしぎ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isAnswered
                          ? '✅ 完了！'
                          : isRevealed
                              ? '🔍 答えを見よう'
                              : '未引',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInnovationFeatures(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '特別チャレンジ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.4,
            children: [
              _buildFeatureCard(
                context: context,
                emoji: '🔬',
                title: 'よそうラボ',
                subtitle: '実験前に予想しよう！',
                color: const Color(0xFF3498DB),
                onTap: () => context.push('/prediction-quiz/exp_magnet_001'),
              ),
              _buildFeatureCard(
                context: context,
                emoji: '🤖',
                title: 'りかハカセ',
                subtitle: 'AIに質問しよう！',
                color: const Color(0xFF5C6BC0),
                onTap: () => context.push('/ai-chat'),
              ),
              _buildFeatureCard(
                context: context,
                emoji: '🕵️',
                title: '失敗ラボ',
                subtitle: '失敗の原因を推理！',
                color: const Color(0xFFF57F17),
                onTap: () => context.push('/troubleshoot/exp_001'),
              ),
              _buildFeatureCard(
                context: context,
                emoji: '⚔️',
                title: '親子バトル',
                subtitle: '親子で予想対決！',
                color: const Color(0xFF6A1B9A),
                onTap: () => context.push('/prediction-battle'),
              ),
              _buildFeatureCard(
                context: context,
                emoji: '🏡',
                title: 'おうちラボ',
                subtitle: '週末リアル実験！',
                color: const Color(0xFF2E7D32),
                onTap: () => context.push('/home-lab'),
              ),
              _buildFeatureCard(
                context: context,
                emoji: '🌌',
                title: '今夜の空',
                subtitle: '星・月を観察しよう',
                color: const Color(0xFF0D1B4B),
                onTap: () => context.push('/tonight-sky'),
              ),
              _buildFeatureCard(
                context: context,
                emoji: '📷',
                title: 'いきものカメラ',
                subtitle: 'AIが生き物を特定！',
                color: const Color(0xFF0F4C3B),
                onTap: () => context.push('/creature-camera'),
              ),
              _buildFeatureCard(
                context: context,
                emoji: '🕰️',
                title: 'タイムトラベル',
                subtitle: '科学者の物語を読もう',
                color: const Color(0xFF6366F1),
                onTap: () => context.push('/scientist-collection'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required BuildContext context,
    required String emoji,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.75)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.35),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              right: -6,
              bottom: -12,
              child: Text(
                emoji,
                style: TextStyle(fontSize: 64, color: Colors.white.withOpacity(0.12)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.22),
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: Text(emoji, style: const TextStyle(fontSize: 20))),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
