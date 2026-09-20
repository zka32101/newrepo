import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_core/shared_core.dart'
    show NotificationSettingsPage, RetentionDashboard, AddFriendDialog;

import '../../../shared/constants/app_colors.dart';
import '../../trial/providers/trial_provider.dart';
import '../providers/theme_provider.dart';

/// 設定画面。テーマ切り替えや各種設定・お問い合わせ導線をまとめる。
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    final trial = ref.watch(trialProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
        backgroundColor: AppColors.sciencePrimary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _SectionHeader('プレミアム会員'),
          ListTile(
            leading: Icon(
              trial?.isPremium == true
                  ? Icons.workspace_premium
                  : Icons.workspace_premium_outlined,
              color: AppColors.sciencePrimary,
            ),
            title: Text(
              trial?.isPremium == true
                  ? 'プレミアム会員です'
                  : (trial?.isTrialActive == true
                      ? '無料トライアル中（あと${trial!.trialDaysRemaining}日）'
                      : 'プレミアムプランを見る'),
            ),
            subtitle: const Text('プラン確認・登録・購入の復元'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/premium'),
          ),
          const Divider(height: 24),
          _SectionHeader('表示'),
          SwitchListTile(
            secondary: Icon(
              isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: AppColors.sciencePrimary,
            ),
            title: const Text('ダークモード'),
            value: isDark,
            onChanged: (_) => ref.read(themeProvider.notifier).toggle(),
          ),
          const Divider(height: 24),
          _SectionHeader('プライバシー・通知'),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.sciencePrimary),
            title: const Text('プライバシー設定'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/privacy-settings'),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined, color: AppColors.sciencePrimary),
            title: const Text('通知設定'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const NotificationSettingsPage(),
                ),
              );
            },
          ),
          const Divider(height: 24),
          _SectionHeader('ソーシャル'),
          ListTile(
            leading: const Icon(Icons.person_add, color: AppColors.sciencePrimary),
            title: const Text('フレンドを探す'),
            subtitle: const Text('ユーザーを検索してフレンド申請する'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showDialog(
              context: context,
              builder: (context) => const AddFriendDialog(),
            ),
          ),
          const Divider(height: 24),
          _SectionHeader('分析'),
          ListTile(
            leading: const Icon(Icons.assessment_outlined, color: AppColors.sciencePrimary),
            title: const Text('ユーザーリテンション分析'),
            subtitle: const Text('あなたの活動パターンと継続性を分析'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              final userId = FirebaseAuth.instance.currentUser?.uid;
              if (userId == null) return;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RetentionDashboard(userId: userId),
                ),
              );
            },
          ),
          const Divider(height: 24),
          _SectionHeader('サポート'),
          ListTile(
            leading: const Icon(Icons.feedback_outlined, color: AppColors.sciencePrimary),
            title: const Text('バグ報告・ご意見'),
            subtitle: const Text('不具合の報告や改善のご要望はこちらから'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/feedback'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.textGray,
        ),
      ),
    );
  }
}
