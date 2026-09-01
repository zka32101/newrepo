import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/notification_service.dart';

final notificationPreferencesProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return await NotificationService.instance.getNotificationPreferences();
});

class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen> {
  late bool _dailyChallengeEnabled;
  late bool _streakWarningEnabled;
  late bool _achievementEnabled;
  late bool _rankingAlertEnabled;

  late TimeOfDay _morningTime;
  late TimeOfDay _afternoonTime;
  late TimeOfDay _eveningTime;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await NotificationService.instance.getNotificationPreferences();
    if (mounted) {
      setState(() {
        _dailyChallengeEnabled = prefs['dailyChallengeEnabled'] as bool? ?? true;
        _streakWarningEnabled = prefs['streakWarningEnabled'] as bool? ?? true;
        _achievementEnabled = prefs['achievementEnabled'] as bool? ?? true;
        _rankingAlertEnabled = prefs['rankingAlertEnabled'] as bool? ?? true;

        _morningTime = _parseTimeOfDay(prefs['morningTime'] as String? ?? '07:00');
        _afternoonTime = _parseTimeOfDay(prefs['afternoonTime'] as String? ?? '12:00');
        _eveningTime = _parseTimeOfDay(prefs['eveningTime'] as String? ?? '19:00');
      });
    }
  }

  TimeOfDay _parseTimeOfDay(String time) {
    try {
      final parts = time.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    } catch (e) {
      return TimeOfDay.now();
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _saveSettings() async {
    await NotificationService.instance.saveNotificationPreferences(
      dailyChallengeEnabled: _dailyChallengeEnabled,
      streakWarningEnabled: _streakWarningEnabled,
      achievementEnabled: _achievementEnabled,
      rankingAlertEnabled: _rankingAlertEnabled,
      morningTime: _formatTimeOfDay(_morningTime),
      afternoonTime: _formatTimeOfDay(_afternoonTime),
      eveningTime: _formatTimeOfDay(_eveningTime),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('設定を保存しました')),
      );
    }
  }

  Future<void> _selectTime(
    BuildContext context,
    TimeOfDay currentTime,
    Function(TimeOfDay) onTimeSelected,
  ) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );
    if (selectedTime != null) {
      setState(() {
        onTimeSelected(selectedTime);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('通知設定'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 毎日の問題配信
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '毎日の問題配信',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'その日のクイズ問題を通知',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: _dailyChallengeEnabled,
                        onChanged: (value) {
                          setState(() => _dailyChallengeEnabled = value);
                          _saveSettings();
                        },
                      ),
                    ],
                  ),
                  if (_dailyChallengeEnabled) ...[
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    _buildTimeSelector(
                      label: '朝の配信時刻',
                      time: _morningTime,
                      onTap: () => _selectTime(
                        context,
                        _morningTime,
                        (time) => _morningTime = time,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTimeSelector(
                      label: '昼の配信時刻',
                      time: _afternoonTime,
                      onTap: () => _selectTime(
                        context,
                        _afternoonTime,
                        (time) => _afternoonTime = time,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTimeSelector(
                      label: '夜の配信時刻',
                      time: _eveningTime,
                      onTap: () => _selectTime(
                        context,
                        _eveningTime,
                        (time) => _eveningTime = time,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // ストリーク途絶予告
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ストリーク途絶予告',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '連続学習が途切れそうな時に警告',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: _streakWarningEnabled,
                    onChanged: (value) {
                      setState(() => _streakWarningEnabled = value);
                      _saveSettings();
                    },
                  ),
                ],
              ),
            ),
          ),

          // 実績・バッジ通知
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '実績・バッジ通知',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '新しいバッジ獲得時に通知',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: _achievementEnabled,
                    onChanged: (value) {
                      setState(() => _achievementEnabled = value);
                      _saveSettings();
                    },
                  ),
                ],
              ),
            ),
          ),

          // ランキング変動通知
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ランキング変動',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'ランキング順位が変わった時に通知',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: _rankingAlertEnabled,
                    onChanged: (value) {
                      setState(() => _rankingAlertEnabled = value);
                      _saveSettings();
                    },
                  ),
                ],
              ),
            ),
          ),

          // 情報
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
                  'ℹ️ お知らせ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '通知設定はいつでも変更できます。デバイスの設定でアプリ通知をオフにすることもできます。',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector({
    required String label,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 14)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
