import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/streak_model.dart';
import '../services/streak_service.dart';
import '../shared/theme/app_theme.dart';

final streakDataProvider = FutureProvider<StreakData>((ref) async {
  await StreakService.instance.initialize();
  return await StreakService.instance.getStreakData();
});

final streakStatusProvider = FutureProvider<void>((ref) async {
  await StreakService.instance.initialize();
});

/// ストリーク情報表示ウィジェット（メインホーム用）
class StreakDisplayWidget extends ConsumerWidget {
  const StreakDisplayWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakData = ref.watch(streakDataProvider);

    return streakData.when(
      data: (streak) => _buildStreakCard(context, streak),
      loading: () => _buildLoadingState(),
      error: (error, stack) => _buildErrorState(),
    );
  }

  Widget _buildStreakCard(BuildContext context, StreakData streak) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.shade300,
            Colors.red.shade300,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🔥 連続学習',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${streak.currentStreak}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                '日間',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '最高: ${streak.maxStreak}日',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (streak.completedToday)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '✅ 今日完了',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '⏳ 今日未実施',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const SizedBox(
        height: 100,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text(
        'ストリーク情報の読み込みに失敗しました',
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}

/// マイルストーン表示ウィジェット
class MilestoneDisplayWidget extends ConsumerWidget {
  const MilestoneDisplayWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakData = ref.watch(streakDataProvider);

    return streakData.when(
      data: (streak) => _buildMilestonesList(streak),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildMilestonesList(StreakData streak) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🏆 マイルストーン',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...predefinedMilestones.asMap().entries.map((entry) {
            final milestone = entry.value;
            final isUnlocked = streak.currentStreak >= milestone.days;
            final daysRemaining = milestone.days - streak.currentStreak;

            return _buildMilestoneItem(
              milestone: milestone,
              isUnlocked: isUnlocked,
              daysRemaining: daysRemaining,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMilestoneItem({
    required StreakMilestone milestone,
    required bool isUnlocked,
    required int daysRemaining,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUnlocked ? Colors.blue.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnlocked ? Colors.blue.shade300 : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Text(
            milestone.iconPath,
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  milestone.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isUnlocked ? Colors.blue : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  milestone.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          if (isUnlocked)
            const Text(
              '✅',
              style: TextStyle(fontSize: 24),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.orange.shade200,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'あと ${daysRemaining > 0 ? daysRemaining : 0} 日',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// ストリーク状態バッジ（ホーム画面のヘッダー用）
class StreakStatusBadge extends ConsumerWidget {
  const StreakStatusBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakData = ref.watch(streakDataProvider);

    return streakData.when(
      data: (streak) {
        if (streak.currentStreak == 0) {
          return const SizedBox.shrink();
        }

        final color = streak.currentStreak >= 30
            ? Colors.red
            : streak.currentStreak >= 7
                ? Colors.orange
                : Colors.yellow;

        return Chip(
          avatar: Text(
            '🔥',
            style: TextStyle(fontSize: 18),
          ),
          label: Text('${streak.currentStreak}日間'),
          backgroundColor: color.withOpacity(0.2),
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }
}
