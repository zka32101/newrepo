import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/grade_advancement_service.dart';
import '../features/profile/models/profile_model.dart';

/// 学年進級サービスプロバイダー
final gradeAdvancementServiceProvider = Provider<GradeAdvancementService>((ref) {
  return GradeAdvancementService.instance;
});

/// ユーザープロフィールプロバイダー（既存のものを参照）
/// 実装済みの場合はインポートして使用
/// final userProfileProvider = FutureProvider<ProfileModel>(...);

/// 進級チェック・実行プロバイダー
/// プロフィール情報を受け取り、進級が必要かチェックして実行
final checkAndAdvanceGradeProvider =
    FutureProvider.family<GradeAdvancementResult, ProfileModel>(
  (ref, profile) async {
    final service = ref.watch(gradeAdvancementServiceProvider);
    await service.initialize();
    return service.checkAndAdvanceGradeIfNeeded(profile);
  },
);

/// 進級チェックのみを行うプロバイダー（副作用なし）
final checkGradeAdvancementNeedProvider =
    Provider.family<bool, ProfileModel>((ref, profile) {
  final now = DateTime.now();

  // 開始月が未設定の場合は初期化が必要
  if (profile.startMonth == null) {
    return true;
  }

  // 4月1日以降で、かつ今年度未進級の場合
  if (now.month > 4 || (now.month == 4 && now.day >= 1)) {
    if (profile.lastGradeAdvancementDate != null) {
      final lastAdvancementYear =
          DateTime.parse(profile.lastGradeAdvancementDate!).year;
      return lastAdvancementYear != now.year && profile.gradeLevel < 6;
    }
    return profile.gradeLevel < 6;
  }

  return false;
});

/// 進級記録プロバイダー（分析用）
final recordGradeAdvancementProvider =
    FutureProvider.family<void, GradeAdvancementRecord>((ref, record) async {
  final service = ref.watch(gradeAdvancementServiceProvider);
  await service.recordGradeAdvancementEvent(
    userId: record.userId,
    previousGrade: record.previousGrade,
    newGrade: record.newGrade,
    advancementDate: record.advancementDate,
  );
});

/// 進級記録モデル
class GradeAdvancementRecord {
  final String userId;
  final int previousGrade;
  final int newGrade;
  final DateTime advancementDate;

  const GradeAdvancementRecord({
    required this.userId,
    required this.previousGrade,
    required this.newGrade,
    required this.advancementDate,
  });
}
