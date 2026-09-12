import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_core/shared_core.dart'
    show NotificationSettingsPage, RetentionDashboard;

import '../../../shared/constants/app_colors.dart';
import '../providers/theme_provider.dart';

/// 設定画面。テーマ切り替えや各種設定・お問い合わせ導線をまとめる。
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
        backgroundColor: AppColors.sciencePrimary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
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
              final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
              if (userId.isNotEmpty) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => NotificationSettingsPage(userId: userId),
                  ),
                );
              }
            },
          ),
          const Divider(height: 24),
          _SectionHeader('分析'),
          ListTile(
            leading: const Icon(Icons.assessment_outlined, color: AppColors.sciencePrimary),
            title: const Text('ユーザーリテンション分析'),
            subtitle: const Text('あなたの活動パターンと継続性を分析'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const RetentionDashboard(),
              ),
            ),
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
