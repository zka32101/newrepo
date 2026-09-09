import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// RevenueCat 連携。
///
/// 【重要 / 既知の制約】
/// この実装は RevenueCat の **クライアントSDKが持つエンタイトルメント判定**
/// （ストアのレシート検証を RevenueCat 側で行った結果を SDK から取得する）
/// までしか行っていない。RevenueCat の Webhook を自前バックエンド
/// （例: Firebase Cloud Functions）で受けて Firestore 等に確定状態を
/// 保存し、アプリはそれを正とする「サーバー側検証」は実装していない。
///
/// このリポジトリには Cloud Functions の基盤がまだ薄く（本PRで
/// `functions/` を新設した段階）、Webhook 受信・署名検証・購読状態の
/// 一元管理まで含めた本格対応は本PRの範囲外とし、別タスクとする。
///
/// 現状でも、以前のようにローカルの SharedPreferences フラグだけで
/// プレミアム判定していた状態（フラグを直接書き換えれば無料で解放できる）
/// と比べれば、RevenueCat SDK が実ストアのレシート/購読情報を検証した上で
/// 返す `entitlements.active` を判定に使うため、大幅に改ざん耐性は上がる。
/// ただし「デバイス上で完結する検証」である以上、リバースエンジニアリング等
/// による完全な回避を理論上ゼロにはできない点は留意する。
class PurchaseService {
  PurchaseService._();
  static final PurchaseService instance = PurchaseService._();

  static const String premiumEntitlementId = 'premium';

  // TODO: RevenueCat ダッシュボードで発行した本番キーに差し替える。
  // 現状はプレースホルダのため、実機では isPremium が常に false 扱いになる
  // （初期化に失敗し _initialized=false のまま runs in local-only mode）。
  static const String _androidApiKey = 'goog_XXXXXXXXXXXXXXXXXXXXXXXXXX';
  static const String _iosApiKey = 'appl_XXXXXXXXXXXXXXXXXXXXXXXXXX';

  bool _initialized = false;
  bool get isAvailable => _initialized;

  final _customerInfoController = StreamController<CustomerInfo>.broadcast();
  Stream<CustomerInfo> get customerInfoStream => _customerInfoController.stream;

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      final apiKey = Platform.isIOS ? _iosApiKey : _androidApiKey;
      if (apiKey.contains('XXXX')) {
        // 本番キー未設定。SDK初期化はスキップし、購入機能なし・ローカル
        // モードで起動を継続する（クラッシュさせない）。
        debugPrint('[Purchase] RevenueCat APIキー未設定のため初期化をスキップ');
        return;
      }

      await Purchases.setLogLevel(kDebugMode ? LogLevel.debug : LogLevel.warn);
      await Purchases.configure(PurchasesConfiguration(apiKey));
      Purchases.addCustomerInfoUpdateListener((info) {
        if (!_customerInfoController.isClosed) {
          _customerInfoController.add(info);
        }
      });
      _initialized = true;
      debugPrint('[Purchase] RevenueCat 初期化成功');
    } catch (e) {
      debugPrint('[Purchase] RevenueCat 初期化失敗 (ローカルモードで継続): $e');
      _initialized = false;
    }
  }

  Future<bool> isPremium() async {
    if (!_initialized) return false;
    try {
      final info = await Purchases.getCustomerInfo();
      return info.entitlements.active.containsKey(premiumEntitlementId);
    } catch (e) {
      debugPrint('[Purchase] isPremium 取得失敗: $e');
      return false;
    }
  }

  Future<Offerings?> getOfferings() async {
    if (!_initialized) return null;
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      debugPrint('[Purchase] getOfferings 失敗: $e');
      return null;
    }
  }

  Future<CustomerInfo?> purchase(Package package) async {
    try {
      return await Purchases.purchasePackage(package);
    } on PurchasesErrorCode catch (e) {
      if (e == PurchasesErrorCode.purchaseCancelledError) return null;
      rethrow;
    }
  }

  Future<CustomerInfo> restorePurchases() => Purchases.restorePurchases();
}
