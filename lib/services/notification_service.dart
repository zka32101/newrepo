import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

/// グローバル通知ハンドラー
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await NotificationService.instance._handleBackgroundMessage(message);
}

/// プッシュ通知サービス
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  static NotificationService get instance => _instance;

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  late FirebaseMessaging _firebaseMessaging;
  late FlutterLocalNotificationsPlugin _localNotifications;
  late StreamSubscription<RemoteMessage> _onMessageSubscription;

  bool _isInitialized = false;

  /// 初期化
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _firebaseMessaging = FirebaseMessaging.instance;
      _localNotifications = FlutterLocalNotificationsPlugin();

      // ローカル通知の初期化（Android）
      const androidInitSettings = AndroidInitializationSettings('app_icon');
      const iosInitSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      final initSettings = InitializationSettings(
        android: androidInitSettings,
        iOS: iosInitSettings,
      );

      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _handleNotificationTap,
      );

      // FCM バックグラウンドハンドラー登録
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // フォアグラウンド通知リスナー
      _onMessageSubscription = FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // アプリ起動状態での通知タップ処理
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      // 初期メッセージ確認（アプリが完全に閉じていた状態での起動）
      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageOpenedApp(initialMessage);
      }

      // タイムゾーン初期化
      tz.initializeTimeZones();

      _isInitialized = true;
      developer.log('NotificationService initialized successfully');
    } catch (e) {
      developer.log('Error initializing NotificationService: $e', error: e);
      rethrow;
    }
  }

  /// ユーザー許可をリクエスト + FCM Token 取得
  Future<bool> requestPermissionAndGetToken() async {
    try {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carryForward: true,
        criticalAlert: true,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        // FCM Token 取得
        final token = await _firebaseMessaging.getToken();
        if (token != null) {
          await _saveFCMToken(token);
          developer.log('FCM Token: $token');
          return true;
        }
      }
      return false;
    } catch (e) {
      developer.log('Error requesting notification permission: $e', error: e);
      return false;
    }
  }

  /// FCM Token をローカル保存
  Future<void> _saveFCMToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', token);
    } catch (e) {
      developer.log('Error saving FCM token: $e', error: e);
    }
  }

  /// 保存されている FCM Token を取得
  Future<String?> getSavedFCMToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('fcm_token');
    } catch (e) {
      developer.log('Error getting saved FCM token: $e', error: e);
      return null;
    }
  }

  /// フォアグラウンド通知処理
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    developer.log('Foreground notification received: ${message.notification?.title}');
    await _showLocalNotification(message);
  }

  /// バックグラウンド通知処理
  Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    developer.log('Background notification received: ${message.notification?.title}');
    // バックグラウンドではローカル通知は自動的に表示される
  }

  /// ローカル通知を表示
  Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      final notification = message.notification;
      final android = message.android;

      if (notification == null) return;

      const androidDetails = AndroidNotificationDetails(
        'science_app_channel',
        '理科学習通知',
        channelDescription: '学習関連の通知',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        details,
        payload: _encodePayload(message.data),
      );
    } catch (e) {
      developer.log('Error showing local notification: $e', error: e);
    }
  }

  /// ローカル通知タップ時の処理
  void _handleNotificationTap(NotificationResponse response) {
    final data = _decodePayload(response.payload ?? '');
    _routeToNotificationScreen(data);
  }

  /// アプリオープン時の通知処理
  void _handleMessageOpenedApp(RemoteMessage message) {
    developer.log('Message opened from app: ${message.notification?.title}');
    _routeToNotificationScreen(message.data);
  }

  /// 通知タイプに応じた画面ルーティング
  void _routeToNotificationScreen(Map<String, dynamic> data) {
    final type = data['type'] as String?;

    switch (type) {
      case 'challenge':
        // 問題詳細画面へ遷移
        _navigateToChallenge(data['question_id'] as String?);
        break;

      case 'ranking':
        // ランキング画面へ遷移
        _navigateToRanking();
        break;

      case 'achievement':
        // 実績画面へ遷移
        _navigateToAchievements(data['badge_id'] as String?);
        break;

      case 'warning':
        // ホーム画面へ（ストリーク警告）
        _navigateToHome();
        break;

      case 'event':
        // イベント詳細画面へ
        _navigateToEvent(data['event_id'] as String?);
        break;

      default:
        _navigateToHome();
    }
  }

  // ナビゲーション関数（実装は別途Router設定で行う）
  void _navigateToChallenge(String? questionId) {
    developer.log('Navigate to challenge: $questionId');
    // GoRouter 経由でナビゲーション
  }

  void _navigateToRanking() {
    developer.log('Navigate to ranking');
  }

  void _navigateToAchievements(String? badgeId) {
    developer.log('Navigate to achievements: $badgeId');
  }

  void _navigateToHome() {
    developer.log('Navigate to home');
  }

  void _navigateToEvent(String? eventId) {
    developer.log('Navigate to event: $eventId');
  }

  /// データペイロード エンコード
  String _encodePayload(Map<String, dynamic> data) {
    return Uri(queryParameters: data.cast<String, String>()).query;
  }

  /// データペイロード デコード
  Map<String, dynamic> _decodePayload(String payload) {
    if (payload.isEmpty) return {};
    return Uri.splitQueryString(payload).cast<String, dynamic>();
  }

  /// 通知設定を保存
  Future<void> saveNotificationPreferences({
    required bool dailyChallengeEnabled,
    required bool streakWarningEnabled,
    required bool achievementEnabled,
    required bool rankingAlertEnabled,
    required String morningTime,      // "07:00"
    required String afternoonTime,    // "12:00"
    required String eveningTime,      // "19:00"
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('dailyChallengeEnabled', dailyChallengeEnabled);
      await prefs.setBool('streakWarningEnabled', streakWarningEnabled);
      await prefs.setBool('achievementEnabled', achievementEnabled);
      await prefs.setBool('rankingAlertEnabled', rankingAlertEnabled);
      await prefs.setString('morningTime', morningTime);
      await prefs.setString('afternoonTime', afternoonTime);
      await prefs.setString('eveningTime', eveningTime);
    } catch (e) {
      developer.log('Error saving notification preferences: $e', error: e);
    }
  }

  /// 通知設定を取得
  Future<Map<String, dynamic>> getNotificationPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'dailyChallengeEnabled': prefs.getBool('dailyChallengeEnabled') ?? true,
        'streakWarningEnabled': prefs.getBool('streakWarningEnabled') ?? true,
        'achievementEnabled': prefs.getBool('achievementEnabled') ?? true,
        'rankingAlertEnabled': prefs.getBool('rankingAlertEnabled') ?? true,
        'morningTime': prefs.getString('morningTime') ?? '07:00',
        'afternoonTime': prefs.getString('afternoonTime') ?? '12:00',
        'eveningTime': prefs.getString('eveningTime') ?? '19:00',
      };
    } catch (e) {
      developer.log('Error getting notification preferences: $e', error: e);
      return {};
    }
  }

  /// アプリ終了時のクリーンアップ
  Future<void> dispose() async {
    await _onMessageSubscription.cancel();
    _isInitialized = false;
  }
}
