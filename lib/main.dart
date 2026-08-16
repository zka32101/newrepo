import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart'
    hide progressProvider, LearningProgress, ProgressNotifier, FirebaseService;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'app/router.dart';
import 'app/theme.dart';
import 'features/settings/providers/theme_provider.dart';
import 'providers/character_provider.dart';
import 'services/firebase_service.dart';
import 'features/progress/services/daily_mystery_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize(); // google-services.json 未配置時はローカルモードで継続

  tz.initializeTimeZones();

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
