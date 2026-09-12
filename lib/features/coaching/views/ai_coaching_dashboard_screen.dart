import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart'
    show CoachingDashboard;

import '../../../shared/constants/app_colors.dart';
import '../../profile/providers/profile_provider.dart';

/// AI コーチング ダッシュボード画面
///
/// ユーザーの学習パターンを分析し、個別のコーチングアドバイスを表示します。
class AiCoachingDashboardScreen extends ConsumerWidget {
  const AiCoachingDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final activeProfile = profileAsync.value?.activeProfile;
    final userId = activeProfile?.id;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('AI コーチング'),
          backgroundColor: AppColors.sciencePrimary,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_outline,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'プロフィールが未選択です',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('🤖 AI コーチング'),
        backgroundColor: AppColors.sciencePrimary,
        elevation: 0,
      ),
      body: CoachingDashboard(
        userId: userId,
        primaryColor: AppColors.sciencePrimary,
      ),
    );
  }
}
