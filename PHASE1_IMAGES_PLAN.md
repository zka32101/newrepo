# Phase 1: 教育的画像追加計画

**目標**: 15-20枚の商用フリー画像をアプリに統合  
**期間**: 1-2週間  
**優先度**: 高

---

## 📁 ディレクトリ構造

```
lib/assets/images/
├── features/
│   ├── ai_chat/              # ② AIはかせチャット（2枚）
│   ├── tonight_sky/          # ④ 今夜の空（5枚）
│   ├── creature_camera/      # ⑤ いきものカメラ（3枚）
│   ├── battle/               # ⑨ 親子バトル（2枚）
│   └── home_lab/             # ③ おうちラボ（3枚）
└── common/
    └── icons/                # 共通アイコン
```

---

## 🎯 必要な画像一覧

### ② AIはかせチャット（2枚）

| # | 画像名 | 説明 | サイズ | 用途 |
|----|--------|------|--------|------|
| 1 | `claude_mascot.png` | りかハカセキャラクター | 300×300 | チャット画面ヘッダー |
| 2 | `chat_tutorial.png` | チャット機能説明 | 600×400 | 初回説明画面 |

**推奨ソース**:
- Pixabay: "scientist character", "robot mascot"
- Unsplash: "chat interface"

---

### ④ 今夜の空（5枚）

| # | 画像名 | 説明 | サイズ | 用途 |
|----|--------|------|--------|------|
| 1 | `moon_phases.png` | 月の満ち欠け図解 | 600×400 | 月相説明 |
| 2 | `meteor_shower.png` | 流星群イラスト | 600×600 | 流星群イベント |
| 3 | `orion_constellation.png` | オリオン座星図 | 600×600 | 冬の星座 |
| 4 | `spring_triangle.png` | 春の大三角説明 | 600×600 | 春の星座 |
| 5 | `night_sky_tutorial.png` | 観察ガイド | 800×400 | チュートリアル |

**推奨ソース**:
- Pixabay: "moon phases", "constellation diagram"
- Unsplash: "night sky", "stars"
- FreePik: "astronomy illustration" (商用OKライセンスのみ)

---

### ⑤ いきものカメラ（3枚）

| # | 画像名 | 説明 | サイズ | 用途 |
|----|--------|------|--------|------|
| 1 | `camera_guide.png` | カメラ機能説明 | 600×600 | 初期画面 |
| 2 | `creature_collection.png` | 生き物図鑑表示例 | 600×800 | コレクション画面 |
| 3 | `specimen_example.png` | 標本例（昆虫など） | 400×400 | 結果表示例 |

**推奨ソース**:
- Pixabay: "insects", "butterfly", "bee"
- Unsplash: "nature photography", "close-up"
- Pexels: "nature", "animals"

---

### ⑨ 親子バトル化（2枚）

| # | 画像名 | 説明 | サイズ | 用途 |
|----|--------|------|--------|------|
| 1 | `vs_battle_icon.png` | VS バトルアイコン | 300×300 | バトル開始画面 |
| 2 | `win_celebration.png` | 勝利イラスト | 600×400 | 結果画面 |

**推奨ソース**:
- Pixabay: "competition", "trophy"
- Unsplash: "celebration", "success"

---

### ③ おうちラボ（3枚）

| # | 画像名 | 説明 | サイズ | 用途 |
|----|--------|------|--------|------|
| 1 | `home_lab_intro.png` | おうちラボ説明 | 600×400 | 初期画面 |
| 2 | `experiment_setup.png` | 実験セットアップ例 | 600×600 | ミッション画面 |
| 3 | `result_success.png` | 成功表示イラスト | 600×400 | 完了画面 |

**推奨ソース**:
- Pixabay: "home experiment", "DIY"
- Unsplash: "home laboratory", "kids experimenting"

---

## 🔗 実装手順

### Step 1: 画像の取得（1-2日）

```bash
# 商用フリー画像サイトから画像をダウンロード
# 推奨フォーマット: PNG（透過背景）または JPG
# 解像度: 上記サイズで十分（最大1200px以下推奨）
```

**取得チェックリスト**:
- [ ] AIはかせチャット（2枚）
- [ ] 今夜の空（5枚）
- [ ] いきものカメラ（3枚）
- [ ] 親子バトル（2枚）
- [ ] おうちラボ（3枚）

### Step 2: 画像配置（1日）

```bash
# lib/assets/images/ 以下に画像を配置
cp downloaded_images/* lib/assets/images/features/
```

### Step 3: pubspec.yaml 更新

```yaml
flutter:
  assets:
    - lib/assets/images/features/ai_chat/
    - lib/assets/images/features/tonight_sky/
    - lib/assets/images/features/creature_camera/
    - lib/assets/images/features/battle/
    - lib/assets/images/features/home_lab/
```

### Step 4: UI統合（3-4日）

各画面に画像を統合：

**② AIはかせチャット**:
```dart
// lib/features/ai_chat/views/ai_chat_screen.dart
Image.asset('lib/assets/images/features/ai_chat/claude_mascot.png')
```

**④ 今夜の空**:
```dart
// lib/features/sky/views/tonight_sky_screen.dart
Image.asset('lib/assets/images/features/tonight_sky/moon_phases.png')
```

同様に他の機能も実装。

### Step 5: テスト・調整（1-2日）

- [ ] 各画面で画像が正しく表示される
- [ ] 解像度がデバイスで適切に表示される
- [ ] ダークテーマでの見栄え確認
- [ ] 異なる画面サイズで動作確認

---

## 📋 推奨ダウンロード方法

### **1. Pixabay（推奨）**
```
https://pixabay.com/
- 完全フリー・商用OK
- 登録不要
- 高品質の画像多数
```

### **2. Unsplash**
```
https://unsplash.com/
- 完全フリー・商用OK
- 登録推奨（ダウンロード数無制限）
```

### **3. Pexels**
```
https://www.pexels.com/
- 完全フリー・商用OK
- 登録不要
```

---

## 🎨 画像選定のポイント

✅ **必須要件**:
- 商用利用可能（明記されているもの）
- 小学生向け（明るい・分かりやすい）
- 透過背景（PNG推奨）
- 日本語対応（日本の教育基準に合致）

✅ **推奨スタイル**:
- イラスト系（写真より図解が分かりやすい）
- 色が鮮やかで子どもに親しみやすい
- シンプルで理解しやすい構図

❌ **避けるべき**:
- 複雑すぎる画像
- 暗い・陰気な色調
- ライセンスが曖昧なもの

---

## 📊 進捗トラッキング

| 機能 | 画像数 | 取得 | 配置 | UI統合 | テスト | 完了 |
|-----|------|------|------|--------|--------|------|
| AIはかせ | 2 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| 今夜の空 | 5 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| いきもの | 3 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| 親子バトル | 2 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| おうちラボ | 3 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| **合計** | **15** | | | | | |

---

## 🚀 次のステップ

1. **画像ダウンロード開始**
   - Pixabay / Unsplash にアクセス
   - 上記リストの画像を検索・ダウンロード

2. **ライセンス確認**
   - 各画像が商用利用OKか確認
   - ライセンス情報を記録

3. **画像の整理**
   - ファイル名を上記のリストに統一
   - 解像度調整（必要に応じて）

4. **PR作成**
   - 画像の配置と UI 統合を別 PR にまとめる
   - テスト結果とスクリーンショットを添付

---

**準備完了です！画像ダウンロードを開始しましょう 🎨**
