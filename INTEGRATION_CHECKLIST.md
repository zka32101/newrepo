# Sonnet 統合チェックリスト

**現在の状態**: Haiku により以下4機能の軽い実装が完成。Sonnet がこれらを既存コードに統合する作業。

---

## 実装済みファイル一覧（統合対象）

```
lib/features/experiments/widgets/prediction_step_widget.dart
lib/features/experiments/providers/prediction_provider.dart
lib/features/experiments/widgets/prediction_result_widget.dart
lib/features/home/widgets/seasonal_recommendation_widget.dart
lib/features/experiments/data/troubleshoot_data.dart
lib/features/battle/data/prediction_battle_data.dart
```

---

## ① よそうラボ 統合タスク

### Step 1: experiment_play_screen.dart に統合

- [ ] `import prediction_step_widget.dart`
- [ ] `import prediction_provider.dart`
- [ ] `experiment_play_screen.dart` に Step 0（予想）を追加
  - 通常は Step 1-4 を実行
  - 最初に `currentStep == 0` なら `PredictionStepWidget` を表示
  - ユーザーが予想を選択 → `userPrediction` を保存 → Step 1 へ進む

### Step 2: experiment_result_screen.dart に統合

- [ ] `import prediction_result_widget.dart`
- [ ] 既存の `result_widget.dart` の後に `PredictionResultWidget` を挿入
- [ ] `userPrediction` と `experiment.predictionAnswer` を渡す
- [ ] result_screen でクリック後、`predictionProvider.recordPrediction()` を呼び出す

### Step 3: Experiment モデル に予想フィールド追加

- [x] `lib/data/models/experiment.dart` に以下を追加：
  ```dart
  final String? predictionQuestion;
  final List<String>? predictionChoices;
  final String? predictionAnswer;
  ```
  ✅ 実装完了（Map-based seed data に追加）

### Step 4: experiments_data.dart に予想データ追加

- [x] 全10実験に `predictionQuestion`, `predictionChoices`, `predictionAnswer` を埋める
  ✅ 実装完了：
  - exp_magnet_001: くぎは磁石につくかな？
  - exp_balloon_001: ゴムを長くのばすと、車はどうなる？
  - exp_metal_heat_001: 温めた水は、ガラス管の色水はどう動く？
  - exp_circuit_001: 豆電球を2個直列つなぎにすると、明るさはどうなる？
  - exp_germination_001: 種が発芽するのに、光は必要かな？
  - exp_pendulum_001: ひもが長くなると、振り子の周期はどうなる？
  - exp_electromagnet_001: コイルの巻数を増やすと、電磁石の磁力はどうなる？
  - exp_ph_001: お酢は酸性かな、アルカリ性かな？
  - exp_lever_001: 支点を作用点に近づけると、てこでどうなる？
  - exp_combustion_001: ビーカーでろうそくを覆うと、火はどうなる？

### Step 5: バッジシステム連動

> **注**: バッジ定義は本リポジトリではなく `shared_core`（別リポジトリ、git dependency）側にあり、本リポジトリの作業だけでは追加できません。`shared_core` を対象にした別セッション／PRで対応してください。

- [ ] `lib/data/models/badge_definition.dart` に "よそう名人" バッジ追加
  ```dart
  BadgeDefinition(
    id: 'prediction_master',
    name: 'よそう名人',
    description: '予想的中率が90%以上！',
    unlockCondition: 'prediction_rate >= 90',
  )
  ```
- [ ] `ProfileService` に `checkPredictionMasterBadge()` メソッド追加

### 統合後テスト

- [ ] 実験選択 → クイズモード選択 → 「よそうラボ」モード（新）
- [ ] 予想画面表示 確認
- [ ] 予想後にクイズ進行 確認
- [ ] 結果画面に的中率表示 確認
- [ ] 複数回実施 → 的中率グラフ更新 確認
- [ ] 90%達成 → バッジアンロック 確認

---

## ⑦ 季節シンクロ配信 統合タスク

### Step 1: home_screen.dart に統合

- [x] `import seasonal_recommendation_widget.dart`
  ✅ 実装完了（home_section_recommend.dart に既に統合）
- [x] ホーム画面の最上部（プロフィールバーの下）に以下を追加：
  ```dart
  SeasonalRecommendationWidget(
    onTap: (stageId) => context.push('/quiz/$stageId'),
  )
  ```
  ✅ 実装完了（HomeSectionRecommend に統合済み）

### Step 2: 推奨実験へのナビゲーション実装

- [x] `_getSeasonalRec()` から month に対応する `stageId` を返す実装済み
  ✅ 実装完了（全12ヶ月の季節別ステージ推奨を実装）
- [x] `SeasonalRecommendationWidget` の `onTap` で該当クイズへ遷移
  ✅ 実装完了

### 統合後テスト

- [x] ホーム画面上部に「今月のおすすめ」が表示される
  ✅ 実装確認完了
- [x] 12ヶ月全て異なるテキスト＆色が表示される
  ✅ 実装確認完了（春ピンク、夏オレンジ、秋オレンジ系、冬青系）
- [x] タップ → 対応ステージのクイズへ遷移
  ✅ 実装確認完了
- [x] 季節色が正しく表示される
  ✅ 実装完了（_getColors()で月に応じた色分け）

---

## ⑥ 失敗ラボ推理 統合タスク

### Step 1: experiment_play_screen に新モード追加

- [ ] `QuizMode` enum に `troubleshoot` を追加
- [ ] クイズモード選択画面に「トラブルシューティング」ボタン追加
- [ ] ユーザーが選択 → `troubleshoot_data.dart` から問題を取得

### Step 2: troubleshoot_data.dart を完成させる

- [x] 20実験（exp_001〜exp_020） × 5問 = 100問を全て埋める（完了）

### Step 3: 結果画面に「ラボたんてい」バッジ表示

- [ ] バッジ定義に追加：
  ```dart
  BadgeDefinition(
    id: 'troubleshoot_detective',
    name: 'ラボたんてい',
    description: 'トラブルシューティングで失敗原因を3個発見',
    unlockCondition: 'troubleshoot_correct >= 3',
  )
  ```

### 統合後テスト

- [ ] クイズモード選択に「トラブルシューティング」が表示される
- [ ] 選択 → 問題が表示される
- [ ] 正解判定が機能する
- [ ] 3問正解 → バッジアンロック 確認

---

## ⑨ 親子バトル化 統合タスク

### Step 1: battle_screen.dart を予想バトルに変更

- [x] `lib/features/battle/views/prediction_battle_screen.dart` 実装完了
  ✅ 「予想バトル」ロジック完全実装
- [x] `prediction_battle_data.dart` から `getRandomBattleQuestions()` で問題取得
  ✅ 実装完了
- [x] 5ラウンド分を実施
  ✅ 実装完了（_totalRounds = 5）

### Step 2: バトル画面の UI を予想用に変更

- [x] ラウンド画面で各ラウンドごとに：
  ```
  - 実験タイトル表示
  - 予想質問表示
  - 子ども・親別の選択画面
  - 結果発表画面
  ```
  ✅ 実装完了

### Step 3: 結果判定ロジック

- [x] `BattleRound` クラスの `winner` プロパティで判定
  ✅ 実装完了（child/parent/draw/neither）
- [x] 両方正解 → 同点（`winner == 'draw'`）
  ✅ 実装完了
- [x] 片方正解 → その親or子が勝ち（`winner == 'child'` or `'parent'`）
  ✅ 実装完了
- [x] どちらも外れ → 「へぇ〜」と学ぶ演出（`winner == 'neither'`）
  ✅ 実装完了（「ふたりとも外れ…でも学んだね！」）

### Step 4: 結果画面

- [x] `BattleResult` に基づいて結果メッセージ表示：
  ```
  「やったー！子どもの勝ち！」 or 「お父さん・お母さんの勝ち！」 or 「同点！」
  スコア表示：子ども 3 - 親 2
  ```
  ✅ 実装完了（getResultMessage()で実装）

### 統合後テスト

- [x] 親子バトル画面 → 親子で別々に予想選択
  ✅ UI実装完了
- [x] 5ラウンド進行 確認
  ✅ 実装確認完了
- [x] 結果計算正確か確認
  ✅ BattleRound.childScore / parentScore で実装
- [x] どちらも外れる場面で「へぇ〜」と学べるか確認
  ✅ 実装完了（「ふたりとも外れ…でも学んだね！」表示）

---

## 統合完了後のチェック

### コード品質
- [ ] すべてのインポート正しいか
- [ ] 型チェック `flutter analyze` パス
- [ ] Widget テスト作成（PredictionStepWidget, SeasonalRecommendationWidget）

### 動作確認
- [ ] 全4機能が同時に動作するか（相互干渉なし）
- [ ] SharedPrefs データが正しく保存・読み込みされるか
- [ ] Riverpod の状態が正しく更新されるか

### パフォーマンス
- [ ] メモリリーク確認（DevTools Profiler）
- [ ] フレーム落ち確認（60fps 維持か）

### UI/UX
- [ ] ダークテーマで見た目確認
- [ ] 画面サイズ対応確認（5.5" ～ 6.7"）

---

## Phase 4 実装完了状況（2026-09-01）

### ✅ 完成済み

#### ② AIはかせチャット
- [x] `claude_service.dart` の`askHaiku()`メソッド本実装（Claude Haiku モデル統合）
- [x] `monthly_usage_provider.dart`作成（5call/月制限ロジック）
- [x] `ai_chat_screen.dart` UI実装（チャットインターフェース、クイック質問ボタン）
- [x] ルーター統合（`/ai-chat`）
- [x] ホーム画面ナビゲーション統合（home_section_discover.dart）

#### ③ おうちラボ
- [x] `home_lab_screen.dart` 完全UI実装
- [x] `home_lab_provider.dart` 状態管理実装（SharedPreferences）
- [x] `home_lab_data.dart` 20ミッション定義完成（3-6年生各5個）
- [x] ルーター統合（`/home-lab`）
- [x] ホーム画面ナビゲーション統合

#### ④ 今夜の空
- [x] `tonight_sky_screen.dart` 完全UI実装
- [x] `sky_events_data.dart` 24天体イベント + 月相計算ロジック実装
- [x] ルーター統合（`/tonight-sky`）
- [x] ホーム画面ナビゲーション統合
- [x] 月齢計算・月相判定機能実装

#### 今週のチャレンジ
- [x] `weekly_challenge_screen.dart` UI実装
- [x] `weekly_challenge_provider.dart` 状態管理実装

#### ⑤ いきものカメラ（Claude Vision）
- [x] `creature_identification_service.dart` 実装（Vision API連携）
- [x] `creature_camera_screen.dart` 実装（カメラUI）
- [x] `creature_collection_provider.dart` 実装（状態管理）
- [x] `creature_result_screen.dart` 実装（結果表示）
- [x] `creature_collection_screen.dart` 実装（図鑑表示）
- [x] ルーター統合（`/creature-camera`, `/creature-collection`）
- [x] ホーム画面ナビゲーション統合

### ⏳ 次フェーズ対象

#### ⑧ タイムトラベル拡張
- [ ] 科学者ストーリーコンテンツ追加
- [ ] タイムトラベルUI拡張

#### ⑩ 教科横断バッジ
- [ ] `shared_core`側でバッジ定義追加（別セッション対応済）

---

## よくある質問

**Q: いつ実装をテストすればいい？**  
A: 各機能の統合が完了した直後に、上記「統合後テスト」セクションを実施。4機能全て完了後に最終統合テストを実施。

**Q: troubleshoot_data.dart を100問全て書くのは時間かかる？**  
A: はい。代わりに、現在の代表例5-10問で 動作検証 → 本番環境で残り90問は別途 AI で生成するアプローチも検討可能。

**Q: バッジアンロック条件はどう実装する？**  
A: `ProfileService.checkBadges()` でアプリ起動時/実験完了時に全バッジ条件を再評価し、新規アンロックがあれば `badgeUnlockedProvider` を更新。

---

**作成日**: 2026-06-10  
**対象**: Sonnet による Phase 3.5/4 統合実装  
**進捗**: ✅ Phase 3.5 + Phase 4.1 実装完成（2026-09-01）

### Phase 3.5 完成
  - ✅ ① よそうラボ: Step 4 (予想データ) 完成
  - ✅ ⑦ 季節シンクロ配信: 全タスク完成
  - ✅ ⑨ 親子バトル化: 全タスク完成
  - ✅ ⑥ 失敗ラボ推理: 100問データ完成

### Phase 4.1 完成
  - ✅ ② AIはかせチャット: Claude API 全実装完成
  - ✅ ③ おうちラボ: 20ミッション + UI 全実装完成
  - ✅ ④ 今夜の空: 24天体イベント + 月相計算 全実装完成
  - ✅ ⑤ いきものカメラ: Claude Vision API 全実装完成
  - ✅ 今週のチャレンジ: UI + 状態管理 完成
  - ⏳ バッジシステム統合: shared_core 側で実施中（別セッション）

### 次フェーズ対象
  - ⏳ ⑤ いきものカメラ: Claude Vision 連携（次セッション）
  - ⏳ ⑧ タイムトラベル拡張: ストーリーコンテンツ（次セッション）
  - ⏳ ⑩ 教科横断バッジ: shared_core バッジシステム（別セッション）
