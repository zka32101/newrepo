import 'dart:developer' as developer;

import 'package:shared_core/shared_core.dart' show WeeklyReportNotificationScheduler;
import 'package:shared_preferences/shared_preferences.dart';

import 'notification_service.dart';

/// 保護者向け週次レポートのサマリー通知を管理するサービス。
///
/// 実際のスケジューリングロジックは shared_core の
/// [WeeklyReportNotificationScheduler] に委譲し、このクラスは
/// - 通知ID・文言などアプリ固有の設定
/// - 設定画面でのON/OFF状態の永続化
/// を担当する。`FlutterLocalNotificationsPlugin` の初期化・パーミッション管理は
/// 既存の [NotificationService] が担うため、ここではそのインスタンスを再利用する。
class WeeklyReportNotificationService {
  WeeklyReportNotificationService._internal();

  static final WeeklyReportNotificationService _instance =
      WeeklyReportNotificationService._internal();
  static WeeklyReportNotificationService get instance => _instance;

  /// 通知ID。他の通知（デイリーミステリー: 0, 1）と衝突しない値を使う。
  static const int notificationId = 9001;

  static const String _prefsEnabledKey = 'weeklyReportNotificationEnabled';
  static const String _title = '📊 週次レポートが届きました';
  static const String _body = '今週のがんばりをチェックしてみましょう✨';

  WeeklyReportNotificationScheduler get _scheduler =>
      WeeklyReportNotificationScheduler(
        NotificationService.instance.localNotificationsPlugin,
      );

  /// 設定のON/OFF状態を取得（デフォルトはON）。
  Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefsEnabledKey) ?? true;
  }

  /// 保存済みのON/OFF設定に従って通知をスケジュール（またはOFFなら解除）する。
  /// アプリ起動時の初期化に使う。
  Future<void> applySavedPreference() async {
    if (await isEnabled()) {
      await _schedule();
    } else {
      await _cancel();
    }
  }

  /// 設定画面からのON/OFF切り替え。
  Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsEnabledKey, enabled);
    if (enabled) {
      await _schedule();
    } else {
      await _cancel();
    }
  }

  Future<void> _schedule() async {
    try {
      await _scheduler.scheduleWeeklyReport(
        notificationId: notificationId,
        title: _title,
        body: _body,
        // 毎週日曜 19:00 に配信
        weekday: DateTime.sunday,
        hour: 19,
        minute: 0,
      );
    } catch (e) {
      developer.log('Error scheduling weekly report notification: $e', error: e);
    }
  }

  Future<void> _cancel() async {
    try {
      await _scheduler.cancelWeeklyReport(notificationId);
    } catch (e) {
      developer.log('Error cancelling weekly report notification: $e', error: e);
    }
  }
}
