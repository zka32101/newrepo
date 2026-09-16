import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../services/purchase_service.dart';

final purchaseServiceProvider = Provider((ref) => PurchaseService.instance);

/// RevenueCat のエンタイトルメント（`premium`）が有効かどうか。
/// SDK未初期化（キー未設定・オフライン等）の場合は false を返す
/// （＝機能はロックされたまま。誤って無料開放される方向には倒さない）。
final premiumStatusProvider = StreamProvider<bool>((ref) async* {
  final service = ref.watch(purchaseServiceProvider);

  yield await service.isPremium();

  await for (final info in service.customerInfoStream) {
    yield info.entitlements.active
        .containsKey(PurchaseService.premiumEntitlementId);
  }
});

final offeringsProvider = FutureProvider<Offerings?>((ref) async {
  final service = ref.watch(purchaseServiceProvider);
  return service.getOfferings();
});

enum PurchaseStatus { idle, loading, success, error }

class PurchaseState {
  final PurchaseStatus status;
  final String? errorMessage;

  const PurchaseState({this.status = PurchaseStatus.idle, this.errorMessage});
}

final purchaseNotifierProvider =
    StateNotifierProvider<PurchaseNotifier, PurchaseState>((ref) {
  return PurchaseNotifier(ref.watch(purchaseServiceProvider), ref);
});

class PurchaseNotifier extends StateNotifier<PurchaseState> {
  PurchaseNotifier(this._service, this._ref) : super(const PurchaseState());

  final PurchaseService _service;
  final Ref _ref;

  Future<bool> purchase(Package package) async {
    state = const PurchaseState(status: PurchaseStatus.loading);
    try {
      final info = await _service.purchase(package);
      if (info == null) {
        // ユーザーによるキャンセル
        state = const PurchaseState(status: PurchaseStatus.idle);
        return false;
      }
      state = const PurchaseState(status: PurchaseStatus.success);
      _ref.invalidate(premiumStatusProvider);
      return info.entitlements.active
          .containsKey(PurchaseService.premiumEntitlementId);
    } catch (e) {
      state = PurchaseState(
        status: PurchaseStatus.error,
        errorMessage: '購入に失敗しました: $e',
      );
      return false;
    }
  }

  Future<bool> restore() async {
    state = const PurchaseState(status: PurchaseStatus.loading);
    try {
      final info = await _service.restorePurchases();
      final isPremium = info.entitlements.active
          .containsKey(PurchaseService.premiumEntitlementId);
      state = const PurchaseState(status: PurchaseStatus.success);
      _ref.invalidate(premiumStatusProvider);
      return isPremium;
    } catch (e) {
      state = PurchaseState(
        status: PurchaseStatus.error,
        errorMessage: '復元に失敗しました: $e',
      );
      return false;
    }
  }

  void reset() {
    state = const PurchaseState();
  }
}
