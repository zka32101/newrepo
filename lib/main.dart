import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderContainer, UncontrolledProviderScope;
import 'package:shared_core/shared_core.dart'
    hide progressProvider, LearningProgress, ProgressNotifier, FirebaseService;
import 'package:shared_core/shared_core.dart'
    show
        badgeProvider,
        unifiedBadges,
        BadgeNotifier,
        rankingProvider,
        friendProvider,
        feedbackProvider,
        missionProvider,
        coinProvider,
        premiumProvider,
        PremiumNotifier,
        PushNotificationService,
        adaptiveDifficultyNotifierProvider;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'app/router.dart';
import 'shared/theme/app_theme.dart';
import 'shared/localization/app_localizations.dart';
import 'features/progress/data/repositories/incorrect_monster_repository.dart';
import 'features/progress/data/repositories/review_time_capsule_repository.dart';
import 'features/progress/providers/incorrect_monster_provider.dart';
import 'features/progress/providers/review_time_capsule_provider.dart';
import 'features/settings/providers/theme_provider.dart';
import 'providers/character_provider.dart';
import 'providers/equipped_items_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/lesson_provider.dart' show LessonNotifier, lessonProvider;
import 'providers/screen_time_provider.dart';
import 'services/firebase_service.dart';
import 'services/purchase_service.dart';
import 'services/firestore_feedback_service.dart';
import 'services/multiplayer_service.dart';
import 'services/notification_service.dart';
import 'services/weekly_report_notification_service.dart';
import 'services/streak_service.dart';
import 'services/ranking_service.dart';
import 'services/firestore_ranking_service.dart';
import 'services/firestore_friend_service.dart';
import 'services/firestore_mission_service.dart';
import 'features/progress/services/daily_mystery_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize(); // google-services.json 未配置時はローカルモードで継続

  // Phase 4.18: プッシュ通知サービス初期化
  final pushService = PushNotificationService();
  try {
    await pushService.initialize(
      onMessageHandler: (RemoteMessage message) {
        debugPrint('Received message: ${message.notification?.title}');
      },
    );
  } catch (e) {
    // PushNotificationService initialization failed, continue anyway
  }

  // FCM トークンを取得・保存
  try {
    final fcmToken = await pushService.getFCMToken();
    if (fcmToken != null) {
      debugPrint('FCM Token obtained: ${fcmToken.substring(0, 20)}...');
      // 将来: await updateUserFCMToken(userId, fcmToken);
    }
  } catch (e) {
    // FCM token retrieval failed, continue anyway
  }

  // Phase 4.19: 適応難易度エンジン初期化
  // 注: ユーザーID取得後（プロフィール画面後）に各ユーザーごとに initializeAdaptiveDifficulty() を呼ぶこと
  debugPrint('Phase 4.19 Retention Optimization Engine: Initialized');

  // 課金基盤（RevenueCat）初期化。APIキー未設定時はローカルモードで継続。
  final purchaseService = PurchaseService.instance;
  try {
    await purchaseService.initialize();
  } catch (e) {
    // エラーでも起動は継続（プレミアム判定は false 扱いになる）
  }

  final prefs = await SharedPreferences.getInstance();

  // 保存されたロケール設定を読み込み
  final savedLocale = await LocaleNotifier.loadSavedLocale();

  tz.initializeTimeZones();

  // プッシュ通知サービス初期化
  try {
    await NotificationService.instance.initialize();
    await NotificationService.instance.requestPermissionAndGetToken();
  } catch (e) {
    // 通知権限拒否・端末の通知機能未対応などでも起動は継続する
  }

  // 保護者向け週次レポートのサマリー通知（設定でON/OFF可能、毎週日曜19時）
  try {
    await WeeklyReportNotificationService.instance.applySavedPreference();
  } catch (e) {
    // 通知権限拒否・端末の通知機能未対応などでも起動は継続する
  }

  // ストリークサービス初期化
  try {
    await StreakService.instance.initialize();
  } catch (e) {
    // エラーでも起動は継続
  }

  // ランキングサービス初期化
  try {
    await RankingService.instance.initialize();
  } catch (e) {
    // エラーでも起動は継続
  }

  try {
    await DailyMysteryNotificationService.initialize();
    await DailyMysteryNotificationService.scheduleDailyNotifications();
  } catch (e) {
    // 通知権限拒否・端末の通知機能未対応などでも起動は継続する
  }

  final container = ProviderContainer(
    overrides: [
      // 理科コレのキャラクターノティファイアを注入
      characterStateProvider.overrideWith(CharacterNotifier.new),
      // 理科コレのショップアイテム装着状態ノティファイアを注入
      equippedItemsProvider.overrideWith(EquippedItemsNotifier.new),
      // 統一バッジシステム（Phase 4.1）: 理科コレ用バッジを主題タグで初期化
      badgeProvider.overrideWith(() => BadgeNotifier()),
      // 理科コレの利用時間制限（スクリーンタイム管理）ノティファイアを注入
      screenTimeProvider.overrideWith(ScreenTimeNotifier.new),
      // 理科コレの学習コンテンツ（解説記事）ノティファイアを注入
      lessonProvider.overrideWith(LessonNotifier.new),
      // まちがい図鑑・復習タイムカプセルの永続化リポジトリを注入
      incorrectMonsterRepositoryProvider
          .overrideWithValue(IncorrectMonsterRepositoryImpl(prefs)),
      reviewTimeCapsuleRepositoryProvider
          .overrideWithValue(ReviewTimeCapsuleRepositoryImpl(prefs)),
      // 保存されたロケール設定を注入
      localeProvider.overrideWith((ref) => LocaleNotifier(savedLocale)),
      // Phase 4.7: 統一サブスクリプション管理（PremiumProvider）
      premiumProvider.overrideWith(PremiumNotifier.new),
      // マルチプレイ対戦（レートマッチング）: shared_core のハンドラ注入方式に
      // Firestore デフォルト実装（rika_ プレフィックス付きコレクション）を接続
      matchmakingHandlersProvider
          .overrideWithValue(MultiplayerService.instance.matchmakingHandlers),
      matchHandlersProvider
          .overrideWithValue(MultiplayerService.instance.matchHandlers),
    ],
  );

  // バッジシステム初期化: 統一バッジを主題タグで初期化
  container.read(badgeProvider.notifier).setBadgeDefinitions(unifiedBadges, subject: 'rika');

  // Firestore ランキング・フレンド・ミッション サービスの初期化
  final rankingService = FirestoreRankingService();
  final friendService = FirestoreFriendService();
  final missionService = FirestoreMissionService();

  // Handler を shared_core provider に注入
  container.read(rankingProvider.notifier).setFetchHandler(rankingService.fetchRankings);
  container.read(globalRankingProvider.notifier).setFetchHandler(rankingService.fetchGlobalRankings);
  container.read(friendProvider.notifier)
    ..setFetchHandler(friendService.fetchFriends)
    ..setAddFriendHandler(friendService.addFriend)
    ..setRemoveFriendHandler(friendService.removeFriend);

  // Phase 4.7: 統一サブスクリプション初期化
  final currentUserId = missionService.getCurrentUserId();
  if (currentUserId != null) {
    container.read(premiumProvider.notifier)
      ..setCheckHandler((userId) => purchaseService.isSubscribed(userId))
      ..setExpiryHandler((userId) => purchaseService.getSubscriptionExpirationDate(userId));
    unawaited(container.read(premiumProvider.notifier).checkSubscription(currentUserId));
  }

  // Phase 4.5: デイリーミッション統一
  // ミッション初期化: 現在のユーザー ID で初期化
  if (currentUserId != null) {
    unawaited(container.read(missionProvider.notifier).initializeMissions(currentUserId));
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // バグ報告・改善要望フォーム（shared_core）: Firestoreの feedback コレクションへの
    // 書き込みハンドラをアプリ側から注入し、起動時に未送信分の再送信を試みる。
    ref
        .read(feedbackProvider.notifier)
        .setSubmitHandler(FirestoreFeedbackService.submit);
    ref.read(feedbackProvider.notifier).retryPendingReports();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: '小学コレ！理科',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ja'),
        Locale('en'),
      ],
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
