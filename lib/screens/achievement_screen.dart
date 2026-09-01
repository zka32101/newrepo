import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/achievement_model.dart';
import '../providers/achievement_provider.dart';
import '../widgets/achievement_display_widget.dart';
import '../shared/theme/app_theme.dart';
import '../shared/utils/responsive.dart';

/// アチーブメント画面
class AchievementScreen extends ConsumerWidget {
  const AchievementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allAchievementsAsync = ref.watch(allAchievementsProvider);
    final userAchievementsAsync = ref.watch(userAchievementsProvider);
    final statsAsync = ref.watch(achievementStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('アチーブメント'),
        centerTitle: true,
        elevation: 0,
      ),
      body: allAchievementsAsync.when(
        data: (allAchievements) {
          return userAchievementsAsync.when(
            data: (userAchievements) {
              final unlockedIds = {
                for (var a in userAchievements) a.achievementId
              };

              return statsAsync.when(
                data: (stats) {
                  final responsivePadding = Responsive.getPadding(context);
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        // 統計情報
                        AchievementStatsWidget(stats: stats),
                        SizedBox(height: responsivePadding.top),
                        // アチーブメント一覧
                        Padding(
                          padding: EdgeInsets.all(responsivePadding.left),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '🏆 アチーブメント一覧',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              SizedBox(height: responsivePadding.left * 0.67),
                              SizedBox(
                                height:
                                    allAchievements.length > 6 ? 600 : 400,
                                child: AchievementListWidget(
                                  achievements: allAchievements,
                                  unlockedIds: unlockedIds,
                                  isLoading: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: responsivePadding.top + 8),
                      ],
                    ),
                  );
                },
                loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
                error: (error, stack) {
                  return Center(
                    child: Text(
                      'エラー: $error',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                },
              );
            },
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            error: (error, stack) {
              return Center(
                child: Text(
                  'エラー: $error',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            },
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stack) {
          return Center(
            child: Text(
              'エラー: $error',
              style: const TextStyle(color: Colors.red),
            ),
          );
        },
      ),
    );
  }
}

/// アチーブメント詳細画面
class AchievementDetailScreen extends ConsumerWidget {
  final String achievementId;

  const AchievementDetailScreen({
    Key? key,
    required this.achievementId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allAchievementsAsync = ref.watch(allAchievementsProvider);
    final userAchievementsAsync = ref.watch(userAchievementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('アチーブメント詳細'),
        centerTitle: true,
      ),
      body: allAchievementsAsync.when(
        data: (allAchievements) {
          final achievement = allAchievements.firstWhere(
            (a) => a.id == achievementId,
            orElse: () => allAchievements.first,
          );

          return userAchievementsAsync.when(
            data: (userAchievements) {
              final isUnlocked =
                  userAchievements.any((a) => a.achievementId == achievementId);
              final responsivePadding = Responsive.getPadding(context);
              final isMobile = Responsive.isMobile(context);

              return SingleChildScrollView(
                padding: EdgeInsets.all(responsivePadding.left),
                child: Column(
                  children: [
                    Text(
                      achievement.emoji,
                      style: TextStyle(fontSize: isMobile ? 72 : 96),
                    ),
                    SizedBox(height: responsivePadding.top + 8),
                    Text(
                      achievement.title,
                      style: TextStyle(
                        fontSize: isMobile ? 24 : 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: responsivePadding.left * 0.67),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 12 : 16,
                        vertical: isMobile ? 6 : 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        achievement.category.label,
                        style: TextStyle(
                          fontSize: isMobile ? 12 : 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    SizedBox(height: responsivePadding.left),
                    Text(
                      achievement.description,
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        color: Colors.black87,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: responsivePadding.top + 8),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(isMobile ? 16 : 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '達成条件',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '条件の種類',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      achievement.condition.type.label,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '目標値',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${achievement.condition.targetValue}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              achievement.condition.description,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (isUnlocked)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 48,
                            ),
                            SizedBox(height: 12),
                            Text(
                              '達成済み',
                              style: TextStyle(
                                fontSize: 18,
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
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.lock,
                              color: Colors.grey,
                              size: 48,
                            ),
                            SizedBox(height: 12),
                            Text(
                              '未達成',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            error: (error, stack) {
              return Center(
                child: Text('エラー: $error'),
              );
            },
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stack) {
          return Center(
            child: Text('エラー: $error'),
          );
        },
      ),
    );
  }
}
