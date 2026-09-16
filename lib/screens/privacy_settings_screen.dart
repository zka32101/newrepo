import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shokollen_science/models/privacy_settings_model.dart';
import 'package:shokollen_science/providers/privacy_settings_provider.dart';

/// プライバシー設定画面
///
/// ユーザーのプライバシー設定を管理する画面
/// - ランキング名前公表
/// - 親向けダッシュボード公表
/// - 通知許可
/// - マーケティング通知
/// - データ分析
class PrivacySettingsScreen extends ConsumerStatefulWidget {
  const PrivacySettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PrivacySettingsScreen> createState() =>
      _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends ConsumerState<PrivacySettingsScreen> {
  late bool _showNameInRanking;
  late bool _showProgressToParents;
  late bool _allowNotifications;
  late bool _allowMarketingNotifications;
  late bool _allowAnalytics;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final settings =
          await ref.read(userPrivacySettingsProvider.future);
      if (settings != null && mounted) {
        setState(() {
          _showNameInRanking = settings.showNameInRanking;
          _showProgressToParents = settings.showProgressToParents;
          _allowNotifications = settings.allowNotifications;
          _allowMarketingNotifications =
              settings.allowMarketingNotifications;
          _allowAnalytics = settings.allowAnalytics;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'プライバシー設定の読み込みに失敗しました';
        });
      }
    }
  }

  Future<void> _updateSetting(
    String settingName,
    bool newValue,
    Future<void> Function(bool) updateFunction,
  ) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await updateFunction(newValue);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$settingName を更新しました')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = '更新に失敗しました: $e';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(privacySettingsNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('プライバシー設定'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // プライバシーレベル表示
          if (_errorMessage == null)
            _buildPrivacyLevelCard(),

          const SizedBox(height: 16),

          // ランキング名前公表
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ランキング名前公表',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'オフの場合、ランキングでは匿名表示されます',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '🔒 プレイヤー ★1234 のように表示',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.orange,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _showNameInRanking,
                    onChanged: _isLoading
                        ? null
                        : (value) {
                            setState(
                                () => _showNameInRanking = value);
                            _updateSetting(
                              'ランキング名前公表',
                              value,
                              notifier.setShowNameInRanking,
                            );
                          },
                  ),
                ],
              ),
            ),
          ),

          // 親向けダッシュボード公表
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '親向けダッシュボード公表',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '保護者が進捗確認ページから学習状況を確認できます',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _showProgressToParents,
                    onChanged: _isLoading
                        ? null
                        : (value) {
                            setState(() =>
                                _showProgressToParents = value);
                            _updateSetting(
                              '親向けダッシュボード公表',
                              value,
                              notifier.setShowProgressToParents,
                            );
                          },
                  ),
                ],
              ),
            ),
          ),

          // 通知設定セクション
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              '📬 通知設定',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),

          // アプリ通知
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'アプリ通知',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'クイズや学習に関する通知',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _allowNotifications,
                    onChanged: _isLoading
                        ? null
                        : (value) {
                            setState(
                                () => _allowNotifications = value);
                            _updateSetting(
                              'アプリ通知',
                              value,
                              notifier.setAllowNotifications,
                            );
                          },
                  ),
                ],
              ),
            ),
          ),

          // マーケティング通知
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'マーケティング通知',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'キャンペーンや新機能のお知らせ',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _allowMarketingNotifications,
                    onChanged: _isLoading
                        ? null
                        : (value) {
                            setState(() =>
                                _allowMarketingNotifications = value);
                            _updateSetting(
                              'マーケティング通知',
                              value,
                              notifier
                                  .setAllowMarketingNotifications,
                            );
                          },
                  ),
                ],
              ),
            ),
          ),

          // データ分析設定セクション
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              '📊 データ設定',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),

          // データ分析への参加
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'データ分析への参加',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'ユーザー行動分析と学習効果測定に参加',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _allowAnalytics,
                    onChanged: _isLoading
                        ? null
                        : (value) {
                            setState(
                                () => _allowAnalytics = value);
                            _updateSetting(
                              'データ分析への参加',
                              value,
                              notifier.setAllowAnalytics,
                            );
                          },
                  ),
                ],
              ),
            ),
          ),

          // プライバシーポリシー情報
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ℹ️ プライバシー情報',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '• あなたのランクは常に表示されます\n'
                  '• 設定はいつでも変更できます\n'
                  '• デフォルトはプライベートな設定です',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// プライバシーレベルカード
  Widget _buildPrivacyLevelCard() {
    final privacySettings = UserPrivacySettings(
      userId: '',
      showNameInRanking: _showNameInRanking,
      showProgressToParents: _showProgressToParents,
      allowNotifications: _allowNotifications,
      allowMarketingNotifications: _allowMarketingNotifications,
      allowAnalytics: _allowAnalytics,
      updatedAt: DateTime.now(),
    );

    final label =
        PrivacyUtils.getPrivacyLevelLabel(privacySettings);
    final enabledCount = [
      _showNameInRanking,
      _showProgressToParents,
      _allowNotifications,
      _allowMarketingNotifications,
      _allowAnalytics,
    ].where((e) => e).length;

    Color cardColor;
    if (enabledCount <= 1) {
      cardColor = Colors.green.withOpacity(0.1);
    } else if (enabledCount <= 2) {
      cardColor = Colors.yellow.withOpacity(0.1);
    } else if (enabledCount <= 4) {
      cardColor = Colors.orange.withOpacity(0.1);
    } else {
      cardColor = Colors.red.withOpacity(0.1);
    }

    return Card(
      color: cardColor,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'あなたのプライバシーレベル',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '有効な設定: $enabledCount/5',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
