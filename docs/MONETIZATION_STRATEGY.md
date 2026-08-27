# マネタイゼーション戦略 💰

## 📊 ビジネスモデル概要

### ユーザーセグメント

```
┌─────────────────────────────────────────────────────┐
│ 1️⃣ トライアルユーザー（2週間）                      │
│ ├─ コンテンツ利用: 100% ✅                         │
│ ├─ 広告: なし                                     │
│ └─ 機能: 全機能利用可能                             │
├─────────────────────────────────────────────────────┤
│ 2️⃣ 無料ユーザー（トライアル終了後）                  │
│ ├─ コンテンツ利用: 10% のみ                        │
│ ├─ 広告: あり（セクション間・ボトム）               │
│ └─ 機能: 制限あり                                 │
├─────────────────────────────────────────────────────┤
│ 3️⃣ プレミアムユーザー（有料購読）                    │
│ ├─ コンテンツ利用: 100% ✅                         │
│ ├─ 広告: なし                                     │
│ └─ 機能: 全機能 + 優先サポート                     │
└─────────────────────────────────────────────────────┘
```

---

## 🎯 現在のホーム画面セクション分割

### セクション別の無料/有料コンテンツ割合

#### 📅 セクション1: 今日のアクション
```
総コンテンツ: 5つのウィジェット
├─ ストリークバナー .......... 10% ✅ 無料
├─ デイリーログインボーナス .. 無料化対象外（常に無料）
├─ 誉め称え受信 .............. 90% 有料
├─ 週間チャレンジ ............ 90% 有料
└─ デイリーチャレンジ ........ 90% 有料

無料コンテンツ: 10%（ストリークバナー）
有料コンテンツ: 90%（その他）
```

#### 🔬 セクション2: おすすめ・キャラクター
```
総コンテンツ: キャラクターコレクション
├─ コレクション進捗表示 ...... 10% ✅ 無料
├─ キャラクター図鑑 ......... 90% 有料
└─ 推奨学習順序 ............ 90% 有料

無料コンテンツ: 10%（進捗表示のみ）
有料コンテンツ: 90%（詳細情報）
```

#### 🏆 セクション3: がんばりの記録
```
総コンテンツ: 学習実績
├─ 週間レポートサマリー ...... 10% ✅ 無料
├─ 詳細統計分析 ............ 90% 有料
└─ 学年末まとめテスト ....... 90% 有料

無料コンテンツ: 10%（サマリーのみ）
有料コンテンツ: 90%（詳細機能）
```

#### 📚 セクション4: 学習をすすめる
```
総コンテンツ: 3年～6年のステージ（全300ステージ想定）
├─ 学年選択・表示 .......... 無料機能
├─ 利用可能ステージ ........ 最初の30ステージ（10%）✅ 無料
└─ プレミアムステージ ...... 残り270ステージ（90%）有料

無料コンテンツ: 10%（初心者向け：ステージ 001-030）
有料コンテンツ: 90%（応用・発展：ステージ 031-300）
```

#### ✨ セクション5: 特別チャレンジ（6機能）
```
総コンテンツ: 6つの特別機能
├─ よそうラボ .............. 有料
├─ りかハカセ（AI助手）...... 有料
├─ 失敗ラボ ................ 有料
├─ 親子バトル .............. 有料
├─ おうちラボ .............. 有料
└─ 今夜の空 ................ 有料

無料コンテンツ: 0%（全て有料）※1機能の試用版のみ
有料コンテンツ: 100%（フル機能）
```

---

## 🔧 実装方針

### ステップ1: 機能フラグシステム

```dart
// lib/providers/subscription_provider.dart

enum UserTier {
  trial,      // トライアル（2週間無制限）
  free,       // 無料（10%のみ）
  premium,    // 有料（100%利用可能）
}

final userSubscriptionProvider = 
  StateNotifierProvider<UserSubscriptionNotifier, UserSubscription>((ref) {
    return UserSubscriptionNotifier();
  });

class UserSubscription {
  final UserTier tier;
  final DateTime trialExpiryDate;
  final bool hasActiveSubscription;
  
  // 機能が利用可能かチェック
  bool canAccessFeature(String featureId) {
    switch (tier) {
      case UserTier.trial:
        return true; // 全機能利用可能
      case UserTier.free:
        return _isFreeFeature(featureId); // 10%のみ
      case UserTier.premium:
        return true; // 全機能利用可能
    }
  }
  
  bool _isFreeFeature(String featureId) {
    // コンテンツ制限リスト
    const freeFeatures = [
      'streak_banner',           // ストリークバナー
      'weekly_report_summary',   // 週間レポートサマリー
      'collection_progress',     // コレクション進捗
      'stage_001_030',           // ステージ1-30
    ];
    return freeFeatures.contains(featureId);
  }
}
```

### ステップ2: Paywall UIコンポーネント

```dart
// lib/features/paywall/widgets/paywall_overlay.dart

class PaywallOverlay extends StatelessWidget {
  final String featureName;
  final VoidCallback onSubscribe;
  
  const PaywallOverlay({
    required this.featureName,
    required this.onSubscribe,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🔒 プレミアム機能'),
              Text('$featureName はプレミアム会員のみ利用できます'),
              Text('2週間の無料トライアルを開始 →'),
              ElevatedButton(
                onPressed: onSubscribe,
                child: Text('プレミアムに登録（月額 \¥500）'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### ステップ3: セクション別の実装例

```dart
// lib/features/home/widgets/home_section_learning.dart

class HomeSectionLearning extends ConsumerStatefulWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscription = ref.watch(userSubscriptionProvider);
    
    return Column(
      children: [
        // 学年フィルタ（常に無料）
        _buildGradeFilter(),
        
        // ステージリスト（1-30は無料、31+は有料）
        if (subscription.canAccessFeature('stage_free_tier'))
          _buildStageListFree()  // ステージ 1-30
        else
          _buildStageLockOverlay(), // 有料版への誘導
      ],
    );
  }
}
```

---

## 📱 コンテンツ制限の詳細

### 無料版で利用可能なコンテンツ（10%）

```
✅ 無料で常に利用可能:
├─ ホーム画面の基本表示
├─ ストリークバナー（励励機能）
├─ 週間レポートの簡易表示
├─ コレクション進捗バー
├─ ステージ 1-30（初心者向け）
└─ デイリーログインボーナス

❌ 有料（トライアル終了後）:
├─ ステージ 31-300（全300ステージ中）
├─ 詳細統計分析
├─ キャラクター図鑑（フル）
├─ 誉め称え機能
├─ 週間チャレンジ
├─ デイリーチャレンジ（フル）
├─ 特別チャレンジ 6機能
│  ├─ よそうラボ（予測実験）
│  ├─ りかハカセ（AI助手）
│  ├─ 失敗ラボ（失敗分析）
│  ├─ 親子バトル
│  ├─ おうちラボ
│  └─ 今夜の空（天文情報）
└─ 広告なしオプション
```

### 広告配置（無料ユーザーのみ）

```
ホーム画面:
┌─────────────────────┐
│   AppBar            │ （常に表示）
├─────────────────────┤
│  📅 セクション1      │
├─ 広 告 バ ナ ー ─┤ （200x50 DP）
│  🔬 セクション2      │
├─ 広 告 バ ナ ー ─┤ （200x50 DP）
│  🏆 セクション3      │
├─ 広 告 バ ナ ー ─┤ （300x250 インタースティシャル）
│  📚 セクション4      │
├─ 広 告 バ ナ ー ─┤ （200x50 DP）
│  ✨ セクション5      │
├─────────────────────┤
│  BottomNav          │
└─────────────────────┘
```

---

## 💳 サブスクリプション設計

### 価格帯

| プラン | 価格 | トライアル | コンテンツ | 広告 |
|---|---|---|---|---|
| **無料** | ¥0 | 2週間 | 10% | あり |
| **プレミアム** | ¥500/月 | 2週間 | 100% | なし |
| **プレミアム** | ¥4,800/年 | 2週間 | 100% | なし |
| **買い切り** | ¥2,000 | なし | 100% | なし |

### トライアル管理

```dart
class TrialManager {
  static const TRIAL_DURATION = Duration(days: 14);
  
  bool isTrialActive(DateTime trialStartDate) {
    final now = DateTime.now();
    final trialEnd = trialStartDate.add(TRIAL_DURATION);
    return now.isBefore(trialEnd);
  }
  
  Duration getRemainingTrialTime(DateTime trialStartDate) {
    final now = DateTime.now();
    final trialEnd = trialStartDate.add(TRIAL_DURATION);
    return trialEnd.difference(now);
  }
}
```

---

## 🎯 実装ロードマップ

### Phase 2-A（優先）: マネタイゼーション基盤
```
Week 1:
  ✨ Feature Flags システム実装
  ✨ Subscription Provider 実装
  ✨ Trial 管理ロジック実装

Week 2:
  ✨ Paywall UI 実装
  ✨ コンテンツ制限ロジック実装
  ✨ テスト & QA
```

### Phase 2-B: 広告統合
```
Week 3:
  📱 Google AdMob 統合
  📱 広告配置の実装
  📱 広告パフォーマンス監視

Week 4:
  ✅ 全デバイス検証
  🚀 段階公開（25% → 50% → 100%）
```

### Phase 2-C: In-App Purchase
```
Week 5-6:
  💳 RevenueCat 統合 または StoreKit 2
  💳 サブスクリプション管理
  💳 領収書・レシート管理

Week 7:
  ✅ 決済処理 QA
  🚀 本番環境デプロイ
```

---

## 📊 収益化予測

### 想定シナリオ（100万ユーザー）

```
ユーザー分布（想定）:
├─ アクティブ無料ユーザー: 850,000人（85%）
│  ├─ トライアル中: 100,000人
│  └─ トライアル終了: 750,000人
│
├─ 有料サブスクライバー: 100,000人（10%）
│  ├─ 月額プラン: 70,000人（¥500/月 = ¥35,000,000）
│  ├─ 年額プラン: 25,000人（¥4,800/年 = ¥120,000,000）
│  └─ 買い切り: 5,000人（¥2,000 = ¥10,000,000）
│
└─ インストール済み: 50,000人（5%）

月間収益（想定）:
├─ サブスクリプション: ¥45,000,000
├─ 広告収入: ¥5,000,000（無料ユーザーベース）
├─ アプリ内購入: ¥1,000,000
└─ 合計: ¥51,000,000/月

年間収益（想定）: ¥600,000,000
```

---

## 🔒 セキュリティ考慮事項

### トークン管理
- JWT トークンで購読状態を検証
- サーバー側でコンテンツ制限を強制
- クライアント側の制限は UI/UX 用のみ

### 不正対策
```dart
// サーバーで常に検証
Future<bool> canAccessPremiumContent(String userId) async {
  final subscription = await fetchUserSubscription(userId);
  return subscription.tier == UserTier.premium;
}
```

---

## 📋 実装チェックリスト

```
マネタイゼーション実装:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Phase 2-A (基盤):
  ☐ Feature Flags システム
  ☐ Subscription Provider
  ☐ Trial 管理
  ☐ Paywall UI
  ☐ コンテンツ制限ロジック
  ☐ テスト実装

Phase 2-B (広告):
  ☐ Google AdMob 設定
  ☐ Banner 広告実装
  ☐ Interstitial 広告実装
  ☐ 広告配置最適化
  ☐ 広告パフォーマンス分析

Phase 2-C (決済):
  ☐ RevenueCat/StoreKit 統合
  ☐ サブスクリプション管理
  ☐ 支払い処理
  ☐ 領収書管理
  ☐ 決済セキュリティ検証

本番公開前:
  ☐ Google Play ポリシー確認
  ☐ 景品表示法対応
  ☐ セキュリティ監査
  ☐ パフォーマンステスト
  ☐ ユーザーテスト
```

---

## 📞 参考リンク

- [Google Play Billing Library](https://developer.android.com/google-play/billing)
- [App Store - In-App Purchase](https://developer.apple.com/in-app-purchase/)
- [RevenueCat - Cross-platform subscriptions](https://www.revenuecat.com/)
- [Google AdMob](https://admob.google.com/)
- [StoreKit 2 Documentation](https://developer.apple.com/documentation/storekit)

---

**マネタイゼーション戦略が確定しました！** 🎯

次は実装フェーズに進みます。 → Phase 2-A の実装開始準備

---

最終更新: 2026-08-26  
ステータス: 戦略確定 ✅  
推奨開始時期: デプロイ後 1-2 週間
