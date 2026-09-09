# 小学コレ！理科 — Claude Code 開発メモ

## プロジェクト概要

- **アプリ名**: 小学コレ！理科 (shokollen_science)
- **対象**: 小学3〜6年生の理科学習
- **ソース**: `G:\マイドライブ\apps\shokollen_science`
- **shared_core**: git dependency（https://github.com/org-zka32101/shared_core, ref: main）。ローカルpath参照は廃止済み

## APKビルド手順

プロジェクトパスに日本語が含まれるため、`subst` で仮想ドライブを使う。

### 1. S: ドライブを割り当て（毎セッション初回のみ）

```powershell
subst S: "G:\マイドライブ\apps\shokollen_science"
```

### 2. ビルド実行（S: ドライブから）

```bash
cd S:/ && flutter pub get && flutter build apk --debug --no-pub
```

リリースビルドの場合:
```bash
cd S:/ && flutter pub get && flutter build apk --release --no-pub
```

> **注意1:** JAVA_HOME は環境変数に設定済みのため明示指定不要
> （`C:\Program Files\Microsoft\jdk-21.0.11.10-hotspot\`）
>
> **注意2:** `flutter clean` 後は必ず `flutter pub get` を先に実行すること
> （`.dart_tool/package_config.json` が削除されるため）

### 3. APKの出力先

- ビルド成果物: `S:\build\app\outputs\flutter-apk\app-debug.apk`
  （= `G:\マイドライブ\apps\shokollen_science\build\app\outputs\flutter-apk\app-debug.apk`）
- コピー先: `G:\マイドライブ\apk\`

### 4. APK手動コピー例

```powershell
Copy-Item "C:\rika-build\app\outputs\flutter-apk\app-debug.apk" "G:\マイドライブ\apk\小学コレ理科-vX.X.X-debug.apk"
```

## flutter pub get

```bash
cd S:/ && flutter pub get
```

> **注意:** JAVA_HOME は環境変数に設定済みのため明示指定不要

## 日本語パス問題の背景

- `G:\マイドライブ\` の日本語文字が Kotlin コンパイラ・CMake の JSON 生成時に壊れる
- `subst S:` による仮想ドライブ割り当てで回避
- `android/gradle.properties` に `android.overridePathCheck=true` 追加済み
- `android/settings.gradle.kts` でビルドディレクトリを `C:/rika-build/` に変更済み
- `pubspec.yaml` の shared_core は git dependency（`https://github.com/org-zka32101/shared_core.git`, ref: main）

## 実装済み機能（v1.0 リリース中）

### Phase 3 基本機能（完了）
| 機能 | 実装状況 | 詳細 |
|---|---|---|
| ステージ別クイズ（3〜6年） | ✅ | 全学年・全ステージ実装完了 |
| ふりがな表示（FuriganaText） | ✅ | 全問題対応済み |
| 進捗管理（UserProgress + SharedPreferences） | ✅ | ローカル永続化 |
| デイリーチャレンジ | ✅ | 毎日更新機構 |
| 週次レポート（棒グラフ） | ✅ | fl_chart 利用 |
| 学年末まとめテスト＋証明書 | ✅ | 生成・共有対応 |
| タイマークイズモード | ✅ | 制限時間クイズ |
| バッジシステム（shared_core） | ✅ | 16個バッジ実装 |
| キャラクターコレクション（16体） | ✅ | ティアシステム |
| コインショップ | ✅ | shared_core CoinShopPage |
| テーマ（ライト/ダーク） | ✅ | ThemeProvider 統合 |

### Phase 3.5 革新機能（2026-06-15 実装開始）

#### 実装済み（Haiku 実装、Sonnet 統合待ち）
| 機能 | ファイル | 状況 |
|---|---|---|
| ① よそうラボ | `lib/features/experiments/widgets/prediction_step_widget.dart` | ✅ UI完成 |
| | `lib/features/experiments/providers/prediction_provider.dart` | ✅ 状態管理完成 |
| | `lib/features/experiments/widgets/prediction_result_widget.dart` | ✅ 結果表示完成 |
| ⑦ 季節シンクロ配信 | `lib/features/home/widgets/seasonal_recommendation_widget.dart` | ✅ 12ヶ月対応完成 |
| ⑥ 失敗ラボ推理 | `lib/features/experiments/data/troubleshoot_data.dart` | ✅ 問題データ完成 |
| ⑨ 親子バトル化 | `lib/features/battle/data/prediction_battle_data.dart` | ✅ 予想バトルロジック完成 |

#### Phase 3.5 実装進捗（v1.0.0 → v1.1 開発中）
| 機能 | 実装状況 | ファイル |
|---|---|---|
| ② AIはかせチャット | ✅ CloudFunctions経由 | `lib/services/claude_api_service.dart` |
| ④ 今夜の空 | ⏳ 実装準備中 | - |
| ⑤ いきものカメラ | ⏳ 実装準備中 | - |
| ⑧ タイムトラベル拡張 | ✅ UI完成 | `lib/features/time_travel/` |
| ⑩ 教科横断バッジ | ⏳ shared_core統合予定 | - |

## キャラクター一覧（lib/data/rika_characters.dart）

| Tier | キャラ | テーマ | 解放条件 |
|---|---|---|---|
| 1 | コムシ🐛 マグネ🧲 ハナコ🌸 デンスケ💡 | 3年 | 0/3/5/8ステージ |
| 2 | カゼマル🌤️ ツキミ🌙 ホネタロウ🦴 ミズキチ💧 | 4年 | 12/16/20/24 |
| 3 | トケロー🧪 フリコ⏰ ビリカ⚡ タネキチ🌱 | 5年 | 28/32/36/40 |
| 4 | チソウン🗻 モエール🔥 タベルン🌿 理科マスター🔬 | 6年 | 44/48/52/56 |

## アーキテクチャ

```
lib/
├── app/           # router.dart, theme.dart
├── data/          # rika_characters.dart, quiz questions
├── features/
│   ├── home/      # home_screen.dart
│   ├── quiz/      # quiz_screen, timer_quiz_screen, result screens
│   ├── grade_test/ # grade_test_screen, certificate_screen
│   ├── weekly_report/ # weekly_report_screen
│   ├── character/ # character_screen (→ shared_core CharacterCollectionPage)
│   ├── shop/      # shop_screen (→ shared_core CoinShopPage)
│   ├── progress/  # models, providers
│   └── settings/  # theme_provider
├── providers/     # character_provider.dart (CharacterNotifier)
└── main.dart
```

## 課金・API セキュリティ

### Claude API 統合（v1.0.1 セキュリティ更新済み）
- **実装**: Firebase Cloud Functions プロキシ経由
- **ファイル**: `lib/services/claude_api_service.dart`
- **セキュリティ**: APIキーはサーバー側で管理（クライアントから非公開）
- **利用制限**: ユーザーあたり月50回までの AI相談可能
- **月額**: ¥120のプレミアム会員向け機能

### RevenueCat サブスクリプション（v1.0.1 新規対応）
```dart
// 実装ファイル: lib/services/revenue_cat_service.dart
// 商品ID: 'rika_premium_monthly' (¥120/月)

// サブスク確認
final isSubscribed = await revenueCatService.isSubscribed();

// 購入処理
await revenueCatService.purchaseMonthly();
```

### Google Play/App Store 連携
- 領収書検証: Google Play Billing Library + App Store Server API
- 自動更新管理: RevenueCat ダッシュボード
- キャンセル・復帰対応: 実装済み

### 環境変数管理
```bash
# .env ファイル（ローカルのみ、コミット禁止）
CLAUDE_API_KEY=sk-xxxx  # CloudFunctions で処理
REVENUE_CAT_API_KEY=appl_xxxx
ADMOB_ANDROID_ID=ca-app-pub-xxxx

# CI/CD でのシークレット設定
# GitHub Actions: Settings > Secrets and variables > Actions
# → CLAUDE_API_KEY, REVENUE_CAT_API_KEY など
```

## 注意事項

- `FuriganaText` の呼び方: `FuriganaText('テキスト', style: TextStyle(...))` ← 第1引数が位置引数
- shared_core のインポートで `progressProvider` 競合 → `hide progressProvider, LearningProgress, ProgressNotifier`
- `characterStateProvider` は `main.dart` で `CharacterNotifier.new` で上書き必須
- **⚠️ セキュリティ注意**: APIキー・商品ID は `pubspec.yaml` や `constants.dart` に直接記入しない。環境変数 or Firebase RemoteConfig で管理
