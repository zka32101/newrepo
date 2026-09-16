import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ② AIはかせチャット: 月ごとの利用回数制限 (無料: 5回/月)
//
// 【重要】実際の上限判定はサーバー側（Cloud Functions `askScience` /
// Firestore の月次カウンタ）で行われる。ここに保持する状態はあくまで
// サーバーから返ってきた最新の「残り回数」をUI表示用にキャッシュしたもので、
// クライアント側だけで完結する判定・カウントアップは行わない
// （旧実装は SharedPreferences にローカルでカウントしていたため、
// アプリのデータ削除・端末変更・ローカル改ざんで無制限に使えてしまっていた）。
const int kFreeMonthlyLimit = 5;

class MonthlyUsageState {
  final int usedCount;
  final int remaining;
  final bool isLoaded;

  const MonthlyUsageState({
    required this.usedCount,
    required this.remaining,
    this.isLoaded = false,
  });

  bool get isLimitReached => isLoaded && remaining <= 0;

  static const initial = MonthlyUsageState(
    usedCount: 0,
    remaining: kFreeMonthlyLimit,
    isLoaded: false,
  );
}

class MonthlyUsageNotifier extends StateNotifier<MonthlyUsageState> {
  MonthlyUsageNotifier({FirebaseFunctions? functions})
      : _functions = functions ??
            FirebaseFunctions.instanceFor(region: 'asia-northeast1'),
        super(MonthlyUsageState.initial) {
    refresh();
  }

  final FirebaseFunctions _functions;

  /// サーバーから現在の利用状況を取得する（消費しない）。
  /// 画面表示の初期化・チャット送信前の事前表示更新に使う。
  Future<void> refresh() async {
    try {
      final callable = _functions.httpsCallable('getAiChatUsageStatus');
      final response = await callable.call<Map<String, dynamic>>();
      final data = response.data;
      state = MonthlyUsageState(
        usedCount: (data['usedCount'] as int?) ?? 0,
        remaining: (data['remaining'] as int?) ?? 0,
        isLoaded: true,
      );
    } catch (_) {
      // オフライン等で取得できない場合は「未ロード」のまま扱い、
      // 送信ボタン自体は塞がない（実際の可否はサーバー側で判定されるため）。
    }
  }

  /// `askScience` の応答に含まれる remaining をそのまま反映する
  /// （わざわざもう一度 getAiChatUsageStatus を呼び直さないための最適化）。
  void applyServerRemaining(int remaining) {
    state = MonthlyUsageState(
      usedCount: kFreeMonthlyLimit - remaining,
      remaining: remaining,
      isLoaded: true,
    );
  }
}

final monthlyUsageProvider =
    StateNotifierProvider<MonthlyUsageNotifier, MonthlyUsageState>(
  (ref) => MonthlyUsageNotifier(),
);
