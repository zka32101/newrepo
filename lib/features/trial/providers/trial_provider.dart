import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../providers/purchase_provider.dart';

const int kTrialDays = 14;

class TrialState {
  final DateTime installDate;
  final int trialDaysRemaining;
  final bool isPremium;

  const TrialState({
    required this.installDate,
    required this.trialDaysRemaining,
    required this.isPremium,
  });

  /// コンテンツにアクセス可能か（トライアル中 or プレミアム）
  bool get hasAccess => isPremium || trialDaysRemaining > 0;

  /// トライアル期間中か
  bool get isTrialActive => trialDaysRemaining > 0;

  /// トライアル終了・未プレミアム
  bool get isExpired => !isPremium && trialDaysRemaining <= 0;
}

/// トライアル期間の管理 + プレミアム判定。
///
/// 【セキュリティ上の変更点】
/// 以前は `isPremium` を SharedPreferences の真偽値フラグ（`is_premium_v1`）
/// に持たせており、`activatePremium()` を呼ぶだけで（＝端末のローカル
/// ストレージを直接書き換えるだけで）誰でも無料でプレミアム相当の
/// アクセスを得られる状態だった。RevenueCat が pubspec に宣言されているのに
/// 実際には接続されておらず、この呼び出しがどこからも発火していなかった
/// （つまりレシート検証もされないまま放置されていた）ことも判明している。
///
/// 現在は `premiumStatusProvider`（RevenueCat SDK の
/// `entitlements.active` を参照）を `ref.watch` してそのまま `isPremium`
/// に使う。RevenueCatが実ストアのレシートを検証した結果をSDK経由で
/// 取得しているため、ローカルの値を直接書き換えるだけでは解放できない。
/// サーバー側（Webhook）検証までは未実装（`lib/services/purchase_service.dart`
/// のコメント参照）。
class TrialNotifier extends AsyncNotifier<TrialState> {
  static const _installKey = 'install_timestamp_v1';

  @override
  Future<TrialState> build() async {
    final prefs = await SharedPreferences.getInstance();

    // インストール日を記録（初回のみ）
    var ts = prefs.getInt(_installKey);
    if (ts == null) {
      ts = DateTime.now().millisecondsSinceEpoch;
      await prefs.setInt(_installKey, ts);
    }

    final installDate = DateTime.fromMillisecondsSinceEpoch(ts);
    final daysSince = DateTime.now().difference(installDate).inDays;
    final remaining = (kTrialDays - daysSince).clamp(0, kTrialDays);

    // RevenueCat のエンタイトルメント状態を購読する。値が変わるたびに
    // このプロバイダも再評価され、TrialState.isPremium が追従する。
    final premiumAsync = ref.watch(premiumStatusProvider);
    final isPremium = premiumAsync.valueOrNull ?? false;

    return TrialState(
      installDate: installDate,
      trialDaysRemaining: remaining,
      isPremium: isPremium,
    );
  }

  /// デバッグ用：トライアル日数のリセットのみ行う（プレミアム状態は
  /// RevenueCat 側が真実の情報源のため、ここでは一切操作しない）。
  Future<void> debugResetTrial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_installKey);
    ref.invalidateSelf();
  }
}

final trialProvider =
    AsyncNotifierProvider<TrialNotifier, TrialState>(TrialNotifier.new);
