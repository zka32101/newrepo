import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/profile/models/profile_model.dart';
import '../widgets/grade_advancement_celebration_dialog.dart';
import 'grade_advancement_service.dart';
import 'dart:developer' as developer;

/// アプリ起動時に学年進級をチェック・実行するヘルパー
///
/// 使用例:
/// ```dart
/// void main() {
///   runApp(
///     ProviderScope(
///       child: GradeAdvancementAppHook(
///         child: MyApp(),
///       ),
///     ),
///   );
/// }
/// ```
class GradeAdvancementAppHook extends StatefulWidget {
  final Widget child;

  const GradeAdvancementAppHook({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<GradeAdvancementAppHook> createState() =>
      _GradeAdvancementAppHookState();
}

class _GradeAdvancementAppHookState extends State<GradeAdvancementAppHook> {
  @override
  void initState() {
    super.initState();
    _initializeGradeAdvancementService();
  }

  Future<void> _initializeGradeAdvancementService() async {
    try {
      final service = GradeAdvancementService.instance;
      await service.initialize();
      developer.log('GradeAdvancementService initialized successfully');
    } catch (e) {
      developer.log('Error initializing GradeAdvancementService: $e', error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// 学年進級チェック用Riverpodウィジェット
/// プロフィール情報を受け取り、進級が必要かチェック・実行
class GradeAdvancementChecker extends ConsumerStatefulWidget {
  final ProfileModel userProfile;
  final Widget child;
  final VoidCallback? onAdvancementComplete;

  const GradeAdvancementChecker({
    Key? key,
    required this.userProfile,
    required this.child,
    this.onAdvancementComplete,
  }) : super(key: key);

  @override
  ConsumerState<GradeAdvancementChecker> createState() =>
      _GradeAdvancementCheckerState();
}

class _GradeAdvancementCheckerState
    extends ConsumerState<GradeAdvancementChecker> {
  bool _hasCheckedAdvancement = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkGradeAdvancement();
    });
  }

  Future<void> _checkGradeAdvancement() async {
    if (_hasCheckedAdvancement) return;
    _hasCheckedAdvancement = true;

    try {
      final service = GradeAdvancementService.instance;
      final result = await service.checkAndAdvanceGradeIfNeeded(
        widget.userProfile,
      );

      if (mounted) {
        // 進級が実施された場合はダイアログを表示
        if (result.didAdvance) {
          await showGradeAdvancementDialog(
            context,
            result,
            onDismiss: widget.onAdvancementComplete,
          );
        } else if (result.previousGrade != result.currentGrade) {
          // グレードが変わった場合（開始月初期化など）
          developer.log('Grade status updated: ${result.message}');
        }
      }
    } catch (e) {
      developer.log('Error checking grade advancement: $e', error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// 学年進級状態を監視してダイアログを表示するMixin
mixin GradeAdvancementMixin<T extends StatefulWidget> on State<T> {
  /// 指定したプロフィールの学年進級をチェック
  Future<void> checkGradeAdvancementAndShowDialog(
    ProfileModel profile,
  ) async {
    try {
      final service = GradeAdvancementService.instance;
      final result = await service.checkAndAdvanceGradeIfNeeded(profile);

      if (mounted && result.didAdvance) {
        await showGradeAdvancementDialog(context, result);
      }
    } catch (e) {
      developer.log('Error in checkGradeAdvancementAndShowDialog: $e',
          error: e);
    }
  }

  /// 進級が必要かどうかをチェック（ダイアログ表示なし）
  bool shouldShowGradeAdvancementPrompt(ProfileModel profile) {
    final now = DateTime.now();

    // 開始月が未設定の場合は初期化が必要
    if (profile.startMonth == null) {
      return true;
    }

    // 4月1日以降で、かつ今年度未進級で、最高学年でない場合
    if (now.month > 4 || (now.month == 4 && now.day >= 1)) {
      if (profile.lastGradeAdvancementDate != null) {
        final lastAdvancementYear =
            DateTime.parse(profile.lastGradeAdvancementDate!).year;
        return lastAdvancementYear != now.year && profile.gradeLevel < 6;
      }
      return profile.gradeLevel < 6;
    }

    return false;
  }
}

/// グローバルキー経由で進級ダイアログを表示するナビゲーター
class GradeAdvancementNavigator {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// 進級ダイアログを表示
  static Future<void> showAdvancementDialog(
    GradeAdvancementResult result,
  ) async {
    final context = navigatorKey.currentContext;
    if (context == null) {
      developer.log('Navigator context not available');
      return;
    }

    await showGradeAdvancementDialog(context, result);
  }
}
