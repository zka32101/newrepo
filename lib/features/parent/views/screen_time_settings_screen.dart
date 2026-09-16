import 'package:flutter/material.dart';
import 'package:shared_core/shared_core.dart' show ScreenTimeSettingsWidget;

import '../../../shared/constants/app_colors.dart';

/// 利用時間制限（スクリーンタイム管理）の設定画面。
///
/// 保護者ダッシュボードから遷移する想定（ダッシュボード自体が
/// `requireParentalGate` 済みのため、このスクリーン単体ではゲートを掛けない）。
class ScreenTimeSettingsScreen extends StatelessWidget {
  const ScreenTimeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('利用時間の設定'),
        backgroundColor: AppColors.sciencePrimary,
        foregroundColor: Colors.white,
      ),
      body: const ScreenTimeSettingsWidget(
        primaryColor: AppColors.sciencePrimary,
      ),
    );
  }
}
