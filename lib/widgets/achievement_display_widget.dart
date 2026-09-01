import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/achievement_model.dart';
import '../shared/theme/app_theme.dart';
import '../shared/animations/page_transitions.dart';

/// アチーブメント一覧ウィジェット
class AchievementListWidget extends StatelessWidget {
  final List<Achievement> achievements;
  final Set<String> unlockedIds;
  final bool isLoading;

  const AchievementListWidget({
    Key? key,
    required this.achievements,
    required this.unlockedIds,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (achievements.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.card_giftcard_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'アチーブメントがまだありません',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.85,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        final isUnlocked = unlockedIds.contains(achievement.id);
        return ScaleFadeTransition(
          duration: Duration(milliseconds: 300 + (index * 30)),
          child: AchievementCard(
            achievement: achievement,
            isUnlocked: isUnlocked,
          ),
        );
      },
    );
  }
}

/// アチーブメントカード
class AchievementCard extends ConsumerWidget {
  final Achievement achievement;
  final bool isUnlocked;

  const AchievementCard({
    Key? key,
    required this.achievement,
    required this.isUnlocked,
  }) : super(key: key);

  Color _getRarityColor() {
    switch (achievement.rarity) {
      case AchievementRarity.common:
        return Colors.grey;
      case AchievementRarity.uncommon:
        return Colors.blue;
      case AchievementRarity.rare:
        return Colors.green;
      case AchievementRarity.epic:
        return Colors.purple;
      case AchievementRarity.legendary:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = AppColors.isDark(context);

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AchievementDetailDialog(
            achievement: achievement,
            isUnlocked: isUnlocked,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: _getRarityColor().withOpacity(0.5),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isUnlocked
              ? _getRarityColor().withOpacity(isDark ? 0.15 : 0.1)
              : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: _getRarityColor().withOpacity(0.3),
                    blurRadius: 8,
                  )
                ]
              : null,
        ),
        child: Stack(
          children: [
            // 背景（未達成時）
            if (!isUnlocked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
              ),
            // コンテンツ
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  achievement.emoji,
                  style: TextStyle(
                    fontSize: 40,
                    opacity: isUnlocked ? 1.0 : 0.3,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    achievement.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isUnlocked
                          ? Colors.black87
                          : Colors.grey.shade600,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getRarityColor().withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    achievement.rarity.label,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: _getRarityColor(),
                    ),
                  ),
                ),
              ],
            ),
            // 達成マーク
            if (isUnlocked)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// アチーブメント詳細ダイアログ
class AchievementDetailDialog extends StatelessWidget {
  final Achievement achievement;
  final bool isUnlocked;

  const AchievementDetailDialog({
    Key? key,
    required this.achievement,
    required this.isUnlocked,
  }) : super(key: key);

  Color _getRarityColor() {
    switch (achievement.rarity) {
      case AchievementRarity.common:
        return Colors.grey;
      case AchievementRarity.uncommon:
        return Colors.blue;
      case AchievementRarity.rare:
        return Colors.green;
      case AchievementRarity.epic:
        return Colors.purple;
      case AchievementRarity.legendary:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _getRarityColor().withOpacity(0.1),
                _getRarityColor().withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                achievement.emoji,
                style: const TextStyle(fontSize: 64),
              ),
              const SizedBox(height: 16),
              Text(
                achievement.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getRarityColor().withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  achievement.rarity.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _getRarityColor(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                achievement.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '達成条件',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      achievement.condition.description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '目標値: ${achievement.condition.targetValue}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (isUnlocked)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 20),
                      SizedBox(width: 8),
                      Text(
                        '達成済み',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock, color: Colors.grey, size: 20),
                      SizedBox(width: 8),
                      Text(
                        '達成していません',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getRarityColor(),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('閉じる'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// アチーブメント統計表示ウィジェット
class AchievementStatsWidget extends StatelessWidget {
  final AchievementStats stats;

  const AchievementStatsWidget({
    Key? key,
    required this.stats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade50,
              Colors.pink.shade50,
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'アチーブメント',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${stats.unlockedCount}/${stats.totalAchievements}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '達成率',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${stats.completionRate.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: stats.completionRate / 100,
                minHeight: 8,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation(
                  Colors.purple.shade400,
                ),
              ),
            ),
            if (stats.lastUnlocked != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '最新の達成',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stats.lastUnlocked!.achievementId,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// アチーブメント獲得通知ウィジェット
class AchievementUnlockedNotificationWidget extends StatelessWidget {
  final AchievementUnlockedNotification notification;

  const AchievementUnlockedNotificationWidget({
    Key? key,
    required this.notification,
  }) : super(key: key);

  Color _getRarityColor() {
    switch (notification.achievement.rarity) {
      case AchievementRarity.common:
        return Colors.grey;
      case AchievementRarity.uncommon:
        return Colors.blue;
      case AchievementRarity.rare:
        return Colors.green;
      case AchievementRarity.epic:
        return Colors.purple;
      case AchievementRarity.legendary:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getRarityColor().withOpacity(0.2),
            _getRarityColor().withOpacity(0.1),
          ],
        ),
        border: Border.all(color: _getRarityColor()),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: _getRarityColor().withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            notification.achievement.emoji,
            style: const TextStyle(fontSize: 48),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.achievement.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.message,
                  style: TextStyle(
                    fontSize: 12,
                    color: _getRarityColor(),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.achievement.description,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
