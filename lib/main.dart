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
import 'services/firebase_service.dart';
import 'services/notification_service.dart';
import 'features/progress/services/daily_mystery_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize(); // google-services.json 未配置時はローカルモードで継続

  final prefs = await SharedPreferences.getInstance();

  tz.initializeTimeZones();

  // プッシュ通知サービス初期化
  try {
    await NotificationService.instance.initialize();
    await NotificationService.instance.requestPermissionAndGetToken();
  } catch (e) {
    // 通知権限拒否・端末の通知機能未対応などでも起動は継続する
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
    return MaterialApp.router(
      title: '小学コレ！理科',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
