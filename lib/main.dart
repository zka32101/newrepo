import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart'
    hide progressProvider, LearningProgress, ProgressNotifier, FirebaseService;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'app/router.dart';
import 'app/theme.dart';
import 'features/progress/data/repositories/incorrect_monster_repository.dart';
import 'features/progress/data/repositories/review_time_capsule_repository.dart';
import 'features/progress/providers/incorrect_monster_provider.dart';
import 'features/progress/providers/review_time_capsule_provider.dart';
import 'features/settings/providers/theme_provider.dart';
import 'providers/character_provider.dart';
import 'providers/locale_provider.dart';
import 'services/firebase_service.dart';
import 'services/notification_service.dart';
import 'services/streak_service.dart';
import 'services/ranking_service.dart';
import 'services/achievement_service.dart';
import 'features/progress/services/daily_mystery_notification_service.dart';
import 'shared/theme/app_theme.dart';
import 'shared/localization/app_localizations.dart';

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

  // アチーブメントサービス初期化
  try {
    await AchievementService.instance.initialize();
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
        // まちがい図鑑・復習タイムカプセルの永続化リポジトリを注入
        incorrectMonsterRepositoryProvider
            .overrideWithValue(IncorrectMonsterRepositoryImpl(prefs)),
        reviewTimeCapsuleRepositoryProvider
            .overrideWithValue(ReviewTimeCapsuleRepositoryImpl(prefs)),
        // 保存されたロケール設定を注入
        localeProvider.overrideWithValue(
          StateNotifierProvider((ref) => LocaleNotifier(savedLocale)),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: '小学コレ！理科',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
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
