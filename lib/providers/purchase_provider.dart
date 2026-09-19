import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_core/shared_core.dart'
    show PurchaseService, SharedCoreInitializer;

import 'package:shokollen_science/providers/user_avatar_provider.dart';

final purchaseServiceProvider = Provider<PurchaseService?>(
  (ref) => SharedCoreInitializer.getPurchaseService(),
);

/// RevenueCat のエンタイトルメント（`premium`）が有効かどうか。
/// SDK未初期化（キー未設定・オフライン等）やユーザー未ログインの場合は
/// false を返す（＝機能はロックされたまま。誤って無料開放される方向には倒さない）。
final premiumStatusProvider = StreamProvider<bool>((ref) async* {
  final service = ref.watch(purchaseServiceProvider);
  final userId = ref.watch(currentUserIdProvider);
  if (service == null || userId == null) {
    yield false;
    return;
  }

  yield await service.isSubscribed(userId);

  await for (final info in service.customerInfoStream) {
    yield info.entitlements.active
        .containsKey(service.config.premiumEntitlementId);
  }
});

final offeringsProvider = FutureProvider<Offerings?>((ref) async {
  final service = ref.watch(purchaseServiceProvider);
  return service?.getOfferings();
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

  final PurchaseService? _service;
  final Ref _ref;

  Future<bool> purchase(Package package) async {
    final service = _service;
    if (service == null) {
      state = const PurchaseState(
        status: PurchaseStatus.error,
        errorMessage: '課金サービスが初期化されていません',
      );
      return false;
    }
    state = const PurchaseState(status: PurchaseStatus.loading);
    try {
      final info = await service.purchase(package);
      if (info == null) {
        // ユーザーによるキャンセル
        state = const PurchaseState(status: PurchaseStatus.idle);
        return false;
      }
      state = const PurchaseState(status: PurchaseStatus.success);
      _ref.invalidate(premiumStatusProvider);
      return info.entitlements.active
          .containsKey(service.config.premiumEntitlementId);
    } catch (e) {
      state = PurchaseState(
        status: PurchaseStatus.error,
        errorMessage: '購入に失敗しました: $e',
      );
      return false;
    }
  }

  Future<bool> restore() async {
    final service = _service;
    if (service == null) {
      state = const PurchaseState(
        status: PurchaseStatus.error,
        errorMessage: '課金サービスが初期化されていません',
      );
      return false;
    }
    state = const PurchaseState(status: PurchaseStatus.loading);
    try {
      final info = await service.restorePurchases();
      final isPremium = info.entitlements.active
          .containsKey(service.config.premiumEntitlementId);
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
