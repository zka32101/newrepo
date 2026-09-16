import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_core/shared_core.dart';

import '../../../shared/constants/app_colors.dart';
import '../providers/multiplayer_identity_provider.dart';

/// マルチプレイ対戦のトップ画面（自分のレーティング・対戦履歴・クイックマッチ）。
class MatchmakerScreen extends ConsumerWidget {
  const MatchmakerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final identity = ref.watch(multiplayerIdentityProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('理科たいせん'),
        backgroundColor: AppColors.sciencePrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard),
            tooltip: 'ランキング',
            onPressed: () => context.push('/multiplayer-leaderboard'),
          ),
        ],
      ),
      body: identity == null
          ? _buildUnavailable(context)
          : _MatchmakerBody(identity: identity),
    );
  }

  Widget _buildUnavailable(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off, size: 56, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              'オンライン対戦を利用するには\nインターネット接続とプロフィールが必要です',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: AppColors.textGray),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () => context.go('/home'),
              child: const Text('ホームへもどる'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MatchmakerBody extends ConsumerWidget {
  final MultiplayerIdentity identity;
  const _MatchmakerBody({required this.identity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ratingAsync = ref.watch(
      playerRatingProvider(
        (userId: identity.userId, displayName: identity.displayName),
      ),
    );
    final historyAsync = ref.watch(userMatchHistoryProvider(identity.userId));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(playerRatingProvider);
        ref.invalidate(userMatchHistoryProvider(identity.userId));
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ratingAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text('レーティングの取得に失敗しました: $e'),
            data: (rating) => PlayerRatingCard(
              rating: rating,
              avatar: Text(identity.avatarEmoji,
                  style: const TextStyle(fontSize: 36)),
              gradientStart: AppColors.sciencePrimary,
              gradientEnd: AppColors.scienceSecondary,
            ),
          ),
          const SizedBox(height: 24),
          const Text('最近の対戦',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          historyAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (e, _) => Text('対戦履歴の取得に失敗しました: $e',
                style: const TextStyle(color: Colors.grey)),
            data: (matches) {
              if (matches.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        Icon(Icons.science_outlined,
                            size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        Text('まだ対戦がありません',
                            style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                );
              }
              return Column(
                children: matches
                    .take(5)
                    .map((m) =>
                        MatchHistoryTile(match: m, userId: identity.userId))
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text(
                'クイックマッチ',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.sciencePrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => context.push('/matching-waiting'),
            ),
          ),
        ],
      ),
    );
  }
}
