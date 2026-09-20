import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../providers/purchase_provider.dart';
import '../../../shared/constants/app_colors.dart';
import '../../trial/providers/trial_provider.dart';

/// プレミアム会員のプラン確認・購入・復元を行う画面。
class PremiumPlanScreen extends ConsumerWidget {
  const PremiumPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trialAsync = ref.watch(trialProvider);
    final offeringsAsync = ref.watch(offeringsProvider);
    final purchaseState = ref.watch(purchaseNotifierProvider);
    final isPurchasing = purchaseState.status == PurchaseStatus.loading;

    ref.listen(purchaseNotifierProvider, (prev, next) {
      if (next.status == PurchaseStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
      }
      if (next.status == PurchaseStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ありがとうございます！プレミアム会員になりました🎉')),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('プレミアム会員'),
        backgroundColor: AppColors.sciencePrimary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          trialAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Text('状態の取得に失敗しました'),
            data: (trial) => _StatusCard(trial: trial),
          ),
          const SizedBox(height: 24),
          const Text(
            'プランをえらぶ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          offeringsAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (_, __) => const _UnavailableNotice(),
            data: (offerings) {
              final packages = offerings?.current?.availablePackages ?? [];
              if (packages.isEmpty) return const _UnavailableNotice();
              return Column(
                children: [
                  for (final package in packages)
                    _PlanTile(
                      package: package,
                      enabled: !isPurchasing,
                      onTap: () => ref
                          .read(purchaseNotifierProvider.notifier)
                          .purchase(package),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: isPurchasing
                  ? null
                  : () => ref.read(purchaseNotifierProvider.notifier).restore(),
              child: const Text('購入を復元する'),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final TrialState trial;
  const _StatusCard({required this.trial});

  @override
  Widget build(BuildContext context) {
    final String title;
    final String subtitle;
    final Color color;
    if (trial.isPremium) {
      title = '✅ プレミアム会員です';
      subtitle = 'すべてのコンテンツをお楽しみいただけます';
      color = AppColors.success;
    } else if (trial.isTrialActive) {
      title = '🎁 無料トライアル中';
      subtitle = 'あと${trial.trialDaysRemaining}日で終了します';
      color = AppColors.sciencePrimary;
    } else {
      title = '無料プラン';
      subtitle = 'プレミアムに登録するとすべてのコンテンツが使えます';
      color = AppColors.textGray;
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: AppColors.textGray)),
        ],
      ),
    );
  }
}

class _PlanTile extends StatelessWidget {
  final Package package;
  final bool enabled;
  final VoidCallback onTap;

  const _PlanTile({
    required this.package,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final product = package.storeProduct;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(product.title.isNotEmpty ? product.title : package.identifier),
        subtitle: product.description.isNotEmpty
            ? Text(product.description)
            : null,
        trailing: Text(
          product.priceString,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.sciencePrimary,
          ),
        ),
        onTap: enabled ? onTap : null,
        enabled: enabled,
      ),
    );
  }
}

class _UnavailableNotice extends StatelessWidget {
  const _UnavailableNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.scienceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        '現在プランを取得できません。しばらくしてからもう一度お試しください。',
        style: TextStyle(color: AppColors.textGray),
      ),
    );
  }
}
