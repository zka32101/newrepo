import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/constants/app_colors.dart';
import '../../progress/providers/user_progress_provider.dart';
import '../../daily/providers/daily_challenge_provider.dart';
import '../../daily/widgets/daily_login_bonus_widget.dart';
import '../../parent/widgets/praise_received_widget.dart';
import '../../weekly_challenge/widgets/weekly_challenge_widget.dart';
import 'home_section_divider.dart';

/// ホーム画面セクション1: 📅 今日のアクション
class HomeSectionAction extends ConsumerWidget {
  const HomeSectionAction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionDivider('📅 今日のアクション'),
        _buildStreakBanner(context, ref),
        const DailyLoginBonusWidget(),
        const PraiseReceivedWidget(),
        const WeeklyChallengeWidget(),
        _buildDailyChallengeCard(context, ref),
      ],
    );
  }

  Widget _buildStreakBanner(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(userProgressProvider);
    final streakDays = progressAsync.value?.streakDays ?? 0;
    final totalPoints = progressAsync.value?.totalPoints ?? 0;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFD54F), width: 1.5),
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: streakDays > 0 ? '$streakDays日 ' : '今日から ',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE65100),
                        ),
                      ),
                      TextSpan(
                        text: streakDays > 0 ? '連続学習中！' : '学習を始めよう！',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '累計 $totalPoints pt',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textGray),
                ),
                const SizedBox(height: 6),
                Row(
                  children: List.generate(7, (i) {
                    final weekFilled = streakDays > 0 &&
                        i < (streakDays % 7 == 0 ? 7 : streakDays % 7);
                    return Container(
                      margin: const EdgeInsets.only(right: 4),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: weekFilled
                            ? const Color(0xFFE65100)
                            : const Color(0xFFFFD54F).withOpacity(0.35),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: weekFilled
                              ? const Color(0xFFE65100)
                              : const Color(0xFFFFD54F),
                          width: 1.5,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8F00),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '⭐',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyChallengeCard(BuildContext context, WidgetRef ref) {
    final dailyAsync = ref.watch(dailyChallengeProvider);
    final daily = dailyAsync.value;
    final completed = daily?.completed ?? false;

    return GestureDetector(
      onTap: completed ? null : () => context.push('/daily-challenge'),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: completed
              ? LinearGradient(colors: [Colors.grey[300]!, Colors.grey[200]!])
              : LinearGradient(colors: [Colors.amber[700]!, Colors.orange[500]!]),
          borderRadius: BorderRadius.circular(16),
          boxShadow: completed
              ? []
              : [BoxShadow(color: Colors.amber.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Text(completed ? '✅' : '⚡', style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    completed ? 'デイリーチャレンジ 完了！' : '今日のデイリーチャレンジ',
                    style: TextStyle(
                      color: completed ? Colors.grey[600] : Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    completed ? 'また明日チャレンジしよう' : '3問クリアで 🪙 +30 コイン！',
                    style: TextStyle(
                      color: completed ? Colors.grey[500] : Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (!completed)
              const Icon(Icons.chevron_right_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
