import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/constants/app_colors.dart';
import '../../../shared/widgets/profile_avatar_image.dart';
import '../../progress/providers/user_progress_provider.dart';
import '../models/profile_model.dart';
import '../providers/profile_provider.dart';

/// アバターの選択・購入画面。
///
/// 最初の4体（[ProfileModel.avatarFreeCount]）は無料で選べる。
/// 残りはアクティブなプロフィールが貯めたコインで購入する。
class AvatarShopScreen extends ConsumerWidget {
  const AvatarShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final progressAsync = ref.watch(userProgressProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: profileState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(child: Text('エラーが発生しました')),
          data: (state) {
            final profile = state.activeProfile;
            if (profile == null) {
              return const Center(child: Text('プロフィールがありません'));
            }
            final coins = progressAsync.value?.coins ?? 0;
            final purchasedItemIds =
                progressAsync.value?.purchasedItemIds ?? const [];

            return Column(
              children: [
                _header(context, coins),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: ProfileModel.avatarChoices.length,
                    itemBuilder: (context, index) {
                      final avatar = ProfileModel.avatarChoices[index];
                      final price = ProfileModel.avatarPrices[index];
                      final isFree = ProfileModel.isAvatarFree(index);
                      final isPurchased = purchasedItemIds
                          .contains(ProfileModel.purchaseIdFor(index));
                      final isUnlocked = isFree || isPurchased;
                      final isSelected = profile.avatarEmoji == avatar;

                      return _AvatarTile(
                        avatar: avatar,
                        price: price,
                        isUnlocked: isUnlocked,
                        isSelected: isSelected,
                        onTap: () => _onTap(
                          context,
                          ref,
                          profileId: profile.id,
                          avatar: avatar,
                          index: index,
                          price: price,
                          isUnlocked: isUnlocked,
                          coins: coins,
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _header(BuildContext context, int coins) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => context.pop(),
            tooltip: '戻る',
          ),
          const Expanded(
            child: Text(
              'アバターをえらぶ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.scienceLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🪙', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 4),
                Text(
                  '$coins',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.sciencePrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onTap(
    BuildContext context,
    WidgetRef ref, {
    required String profileId,
    required String avatar,
    required int index,
    required int price,
    required bool isUnlocked,
    required int coins,
  }) async {
    if (isUnlocked) {
      await ref.read(profileProvider.notifier).updateAvatar(profileId, avatar);
      return;
    }

    if (coins < price) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('コインが足りません（あと${price - coins}コイン）')),
        );
      }
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('このアバターを購入しますか？'),
        content: Text('$price コインを使います。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('やめる'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('購入する'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final purchased = await ref
        .read(userProgressProvider.notifier)
        .purchaseWithCoins(ProfileModel.purchaseIdFor(index), price);
    if (!context.mounted) return;
    if (purchased) {
      await ref.read(profileProvider.notifier).updateAvatar(profileId, avatar);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('購入に失敗しました')),
      );
    }
  }
}

class _AvatarTile extends StatelessWidget {
  final String avatar;
  final int price;
  final bool isUnlocked;
  final bool isSelected;
  final VoidCallback onTap;

  const _AvatarTile({
    required this.avatar,
    required this.price,
    required this.isUnlocked,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.sciencePrimary : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: isUnlocked ? 1 : 0.35,
              child: ProfileAvatarImage(avatar: avatar, size: 56),
            ),
            const SizedBox(height: 6),
            if (isUnlocked)
              if (isSelected)
                const Icon(Icons.check_circle,
                    color: AppColors.sciencePrimary, size: 18)
              else
                const SizedBox(height: 18)
            else
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock, size: 12, color: AppColors.textGray),
                  const SizedBox(width: 2),
                  Text(
                    '$price',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textGray,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
