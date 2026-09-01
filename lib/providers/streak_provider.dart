import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/streak_model.dart';
import '../services/streak_service.dart';

/// ストリークデータプロバイダー
final streakProvider = FutureProvider<StreakData>((ref) async {
  await StreakService.instance.initialize();
  return StreakService.instance.getStreakData();
});

/// ストリークマイルストーンプロバイダー
final streakMilestonesProvider = FutureProvider<List<StreakMilestone>>((ref) async {
  await StreakService.instance.initialize();
  return StreakService.instance.getMilestones();
});

/// 次のマイルストーンまでの残り日数
final daysUntilNextMilestoneProvider = FutureProvider<int?>((ref) async {
  await StreakService.instance.initialize();
  return StreakService.instance.daysUntilNextMilestone();
});

/// 学習完了時にストリークを記録するプロバイダー
final recordStreakProvider = FutureProvider.family<StreakData, void>((ref, _) async {
  await StreakService.instance.initialize();
  final streak = await StreakService.instance.recordDailyActivity();

  // ストリークデータを更新
  ref.invalidate(streakProvider);
  ref.invalidate(streakMilestonesProvider);
  ref.invalidate(daysUntilNextMilestoneProvider);

  return streak;
});

/// 日次フラグリセットプロバイダー（毎日 00:00 に呼び出す）
final resetDailyFlagProvider = FutureProvider<void>((ref) async {
  await StreakService.instance.initialize();
  await StreakService.instance.resetDailyFlag();

  // ストリークデータを更新
  ref.invalidate(streakProvider);
});
