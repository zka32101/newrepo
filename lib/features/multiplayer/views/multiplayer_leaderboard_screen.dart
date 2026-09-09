import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart';

import '../../../shared/constants/app_colors.dart';
import '../providers/multiplayer_identity_provider.dart';

/// 対戦レーティングのリーダーボード画面（shared_core の共通表示部品を使用）。
class MultiplayerLeaderboardScreen extends ConsumerWidget {
  const MultiplayerLeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(leaderboardProvider);
    final identity = ref.watch(multiplayerIdentityProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('対戦ランキング'),
        backgroundColor: AppColors.sciencePrimary,
        foregroundColor: Colors.white,
      ),
      body: leaderboardAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('取得に失敗しました: $e')),
        data: (ratings) => LeaderboardView(
          ratings: ratings,
          currentUserId: identity?.userId,
          accentColor: AppColors.sciencePrimary,
        ),
      ),
    );
  }
}
