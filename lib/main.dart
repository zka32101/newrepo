import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart'
    hide progressProvider, LearningProgress, ProgressNotifier, FirebaseService;
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
import 'services/firebase_service.dart';
import 'services/firestore_feedback_service.dart';
import 'services/multiplayer_service.dart';
import 'services/notification_service.dart';
import 'services/weekly_report_notification_service.dart';
import 'services/streak_service.dart';
import 'services/ranking_service.dart';
import 'features/progress/services/daily_mystery_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize(); // google-services.json 未配置時はローカルモードで継続

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

  runApp(
    ProviderScope(
      overrides: [
        // 理科コレのキャラクターノティファイアを注入
        characterStateProvider.overrideWith(CharacterNotifier.new),
        // 理科コレのショップアイテム装着状態ノティファイアを注入
        equippedItemsProvider.overrideWith(EquippedItemsNotifier.new),
        // まちがい図鑑・復習タイムカプセルの永続化リポジトリを注入
        incorrectMonsterRepositoryProvider
            .overrideWithValue(IncorrectMonsterRepositoryImpl(prefs)),
        reviewTimeCapsuleRepositoryProvider
            .overrideWithValue(ReviewTimeCapsuleRepositoryImpl(prefs)),
        // 保存されたロケール設定を注入
        localeProvider.overrideWith((ref) => LocaleNotifier(savedLocale)),
        // マルチプレイ対戦（レートマッチング）: shared_core のハンドラ注入方式に
        // Firestore デフォルト実装（rika_ プレフィックス付きコレクション）を接続
        matchmakingHandlersProvider
            .overrideWithValue(MultiplayerService.instance.matchmakingHandlers),
        matchHandlersProvider
            .overrideWithValue(MultiplayerService.instance.matchHandlers),
      ],
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
