import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/api_response_model.dart';
import 'chat_provider.dart';

/// レート制限情報を管理するプロバイダー
final rateLimitProvider =
    StateNotifierProvider<RateLimitNotifier, RateLimitInfo>((ref) {
  return RateLimitNotifier();
});

/// レート制限用のStateNotifier
class RateLimitNotifier extends StateNotifier<RateLimitInfo> {
  RateLimitNotifier()
      : super(
          const RateLimitInfo(
            monthlyUsed: 0,
            monthlyLimit: 50,
            monthlyRemaining: 50,
            requestsThisMinute: 0,
            minuteLimit: 5,
          ),
        ) {
    _initializeFromPreferences();
  }

  static const String _prefKeyMonthlyUsed = 'claude_monthly_used';
  static const String _prefKeyMonthlyResetDate = 'claude_monthly_reset_date';
  static const String _prefKeyMinuteRequests = 'claude_minute_requests';
  static const String _prefKeyLastRequestTime = 'claude_last_request_time';

  /// SharedPreferencesから初期化
  Future<void> _initializeFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final monthlyUsed = prefs.getInt(_prefKeyMonthlyUsed) ?? 0;
      final resetDateStr = prefs.getString(_prefKeyMonthlyResetDate);
      DateTime? resetDate;

      if (resetDateStr != null) {
        try {
          resetDate = DateTime.parse(resetDateStr);
        } catch (e) {
          // パース失敗時はnull
        }
      }

      // 月の変更をチェック
      final now = DateTime.now();
      if (resetDate != null &&
          (now.year != resetDate.year || now.month != resetDate.month)) {
        // 新しい月なのでリセット
        await prefs.setInt(_prefKeyMonthlyUsed, 0);
        await prefs.setString(_prefKeyMonthlyResetDate, now.toString());
        state = const RateLimitInfo(
          monthlyUsed: 0,
          monthlyLimit: 50,
          monthlyRemaining: 50,
          requestsThisMinute: 0,
          minuteLimit: 5,
        );
      } else {
        state = state.copyWith(
          monthlyUsed: monthlyUsed,
          monthlyRemaining: 50 - monthlyUsed,
          monthlyResetDate: resetDate ?? now,
        );
      }
    } catch (e) {
      // エラーでも続行
    }
  }

  /// リクエスト使用を記録
  Future<void> recordRequest() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now();

      // 月間使用数を更新
      int monthlyUsed = prefs.getInt(_prefKeyMonthlyUsed) ?? 0;
      monthlyUsed++;
      await prefs.setInt(_prefKeyMonthlyUsed, monthlyUsed);

      // リセット日を更新
      final resetDateStr = prefs.getString(_prefKeyMonthlyResetDate);
      DateTime resetDate;

      if (resetDateStr == null) {
        resetDate = now;
        await prefs.setString(_prefKeyMonthlyResetDate, now.toString());
      } else {
        resetDate = DateTime.parse(resetDateStr);

        // 月が変わった場合はリセット
        if (now.year != resetDate.year || now.month != resetDate.month) {
          monthlyUsed = 1;
          resetDate = now;
          await prefs.setInt(_prefKeyMonthlyUsed, 1);
          await prefs.setString(_prefKeyMonthlyResetDate, now.toString());
        }
      }

      // 状態を更新
      state = state.copyWith(
        monthlyUsed: monthlyUsed,
        monthlyRemaining: 50 - monthlyUsed,
        monthlyResetDate: resetDate,
      );
    } catch (e) {
      // エラー処理
    }
  }

  /// 月間リクエスト数を取得
  int getMonthlyUsed() => state.monthlyUsed;

  /// 月間残数を取得
  int getMonthlyRemaining() => state.monthlyRemaining;

  /// クォータ内かをチェック
  bool isWithinQuota() => state.monthlyRemaining > 0;

  /// リセットまでの日数を取得
  int daysUntilReset() {
    if (state.monthlyResetDate == null) {
      return 0;
    }
    final now = DateTime.now();
    final nextMonth = DateTime(
      now.year + (now.month == 12 ? 1 : 0),
      now.month == 12 ? 1 : now.month + 1,
      1,
    );
    return nextMonth.difference(now).inDays;
  }

  /// 進捗を取得（0-1）
  double getProgress() {
    return state.monthlyUsed / state.monthlyLimit;
  }

  /// 使用状況の説明を取得
  String getStatusMessage() {
    if (!isWithinQuota()) {
      return '月間クエリ上限に達しました。来月をお待ちください。';
    }
    return '${state.monthlyUsed} / ${state.monthlyLimit} 使用済み';
  }
}

/// レート制限ステータスのプロバイダー
final rateLimitStatusProvider = FutureProvider((ref) async {
  final rateLimit = ref.watch(rateLimitProvider);
  return {
    'monthlyUsed': rateLimit.monthlyUsed,
    'monthlyLimit': rateLimit.monthlyLimit,
    'monthlyRemaining': rateLimit.monthlyRemaining,
    'isWithinQuota': rateLimit.monthlyRemaining > 0,
    'progressPercent': (rateLimit.monthlyUsed / rateLimit.monthlyLimit * 100).toStringAsFixed(1),
  };
});
