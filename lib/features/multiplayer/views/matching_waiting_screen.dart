import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_core/shared_core.dart';

import '../providers/multiplayer_identity_provider.dart';

/// 対戦相手探索中の待機画面（shared_core の共通ウィジェットを使用）。
class MatchingWaitingScreen extends ConsumerStatefulWidget {
  const MatchingWaitingScreen({super.key});

  @override
  ConsumerState<MatchingWaitingScreen> createState() =>
      _MatchingWaitingScreenState();
}

class _MatchingWaitingScreenState
    extends ConsumerState<MatchingWaitingScreen> {
  double _myRating = 1500;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startSearch());
  }

  Future<void> _startSearch() async {
    final identity = ref.read(multiplayerIdentityProvider);
    if (identity == null) {
      context.go('/matchmaker');
      return;
    }
    final rating = await ref.read(playerRatingProvider(
      (userId: identity.userId, displayName: identity.displayName),
    ).future);
    if (!mounted) return;
    setState(() => _myRating = rating.rating);
    await ref.read(matchmakingProvider.notifier).startSearching(
      userId: identity.userId,
      displayName: identity.displayName,
      rating: rating.rating,
      metadata: {'gradeLevel': identity.gradeLevel},
    );
  }

  @override
  Widget build(BuildContext context) {
    final identity = ref.watch(multiplayerIdentityProvider);
    final matchmakingState = ref.watch(matchmakingProvider);

    ref.listen(matchmakingProvider, (prev, next) {
      if (next.status == MatchmakingStatus.matched && next.matchId != null) {
        final matchId = next.matchId!;
        ref.read(matchmakingProvider.notifier).reset();
        context.go('/multiplayer-quiz/$matchId');
      }
    });

    if (identity == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final cancel = await _showCancelDialog(context);
        if (cancel == true) {
          await ref
              .read(matchmakingProvider.notifier)
              .cancelSearch(identity.userId);
          if (context.mounted) context.go('/matchmaker');
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF3498DB),
        body: SafeArea(
          child: Center(
            child: matchmakingState.status == MatchmakingStatus.error
                ? _buildErrorView(
                    context, identity, matchmakingState.errorMessage)
                : MatchmakingSearchWidget(
                    avatar: Text(identity.avatarEmoji,
                        style: const TextStyle(fontSize: 48)),
                    displayName: identity.displayName,
                    rating: _myRating,
                    onCancel: () async {
                      final cancel = await _showCancelDialog(context);
                      if (cancel == true) {
                        await ref
                            .read(matchmakingProvider.notifier)
                            .cancelSearch(identity.userId);
                        if (context.mounted) context.go('/matchmaker');
                      }
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView(
    BuildContext context,
    MultiplayerIdentity identity,
    String? message,
  ) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, color: Colors.white60, size: 64),
          const SizedBox(height: 24),
          Text(
            message ?? '対戦相手が見つかりませんでした',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF3498DB),
              padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
            ),
            onPressed: () {
              ref.read(matchmakingProvider.notifier).reset();
              _startSearch();
            },
            child: const Text('もう一度探す',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              ref.read(matchmakingProvider.notifier).reset();
              context.go('/matchmaker');
            },
            child: const Text('戻る', style: TextStyle(color: Colors.white60)),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showCancelDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('検索をキャンセルしますか？'),
        content: const Text('対戦相手の検索を中止して戻ります。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('続ける'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('キャンセル', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
