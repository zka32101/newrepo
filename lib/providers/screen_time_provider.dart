import 'package:shared_core/shared_core.dart';

/// 理科コレ固有の利用時間制限（スクリーンタイム管理）ノティファイア。
/// main.dart で screenTimeProvider をこれで上書きする:
/// ```dart
/// screenTimeProvider.overrideWith(ScreenTimeNotifier.new)
/// ```
class ScreenTimeNotifier extends BaseScreenTimeNotifier {
  @override
  String get storageKey => 'rika_screen_time';
}
