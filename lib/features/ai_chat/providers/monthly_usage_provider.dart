import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ② AIはかせチャット: 月ごとの利用回数制限 (無料: 5回/月)
const int kFreeMonthlyLimit = 5;

class MonthlyUsageState {
  final int usedCount;
  final String yearMonth; // "2026-06"

  const MonthlyUsageState({
    required this.usedCount,
    required this.yearMonth,
  });

  bool get isLimitReached => usedCount >= kFreeMonthlyLimit;
  int get remaining => (kFreeMonthlyLimit - usedCount).clamp(0, kFreeMonthlyLimit);
}

class MonthlyUsageNotifier extends StateNotifier<MonthlyUsageState> {
  MonthlyUsageNotifier()
      : super(MonthlyUsageState(usedCount: 0, yearMonth: _currentYearMonth())) {
    _loadFuture = load();
  }

  /// SharedPreferences からの読み込み完了を表す Future。
  /// state の初期値（usedCount: 0）は読み込みが終わるまでの仮値でしかないため、
  /// 制限判定を行うメソッドは必ずこれを待ってから state を参照する。
  late final Future<void> _loadFuture;

  static String _currentYearMonth() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final ym = _currentYearMonth();
    final key = 'ai_chat_usage_$ym';
    final count = prefs.getInt(key) ?? 0;
    state = MonthlyUsageState(usedCount: count, yearMonth: ym);
  }

  /// 送信可否だけを確認する（カウントは消費しない）。
  Future<bool> canSend() async {
    await _loadFuture;
    return !state.isLimitReached;
  }

  /// 実際にAIから応答を得られたときにだけ呼び、利用回数を1消費する。
  Future<bool> recordUsage() async {
    await _loadFuture;
    if (state.isLimitReached) return false;

    final prefs = await SharedPreferences.getInstance();
    final ym = _currentYearMonth();
    final key = 'ai_chat_usage_$ym';
    final newCount = (prefs.getInt(key) ?? 0) + 1;
    await prefs.setInt(key, newCount);
    state = MonthlyUsageState(usedCount: newCount, yearMonth: ym);
    return true;
  }
}

final monthlyUsageProvider =
    StateNotifierProvider<MonthlyUsageNotifier, MonthlyUsageState>(
  (ref) => MonthlyUsageNotifier(),
);
