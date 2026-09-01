# Phase 1 画像実装チェックリスト

## 📥 Step 1: 画像ダウンロード

### ② AIはかせチャット（2枚）
- [ ] `claude_mascot.png` - Pixabay で "scientist character" 検索
- [ ] `chat_tutorial.png` - Unsplash で "chat interface" 検索

### ④ 今夜の空（5枚）
- [ ] `moon_phases.png` - Pixabay で "moon phases diagram" 検索
- [ ] `meteor_shower.png` - Unsplash で "meteor shower" 検索
- [ ] `orion_constellation.png` - Pixabay で "orion constellation" 検索
- [ ] `spring_triangle.png` - Pixabay で "spring star" 検索
- [ ] `night_sky_tutorial.png` - Unsplash で "stargazing guide" 検索

### ⑤ いきものカメラ（3枚）
- [ ] `camera_guide.png` - Pixabay で "nature photography camera" 検索
- [ ] `creature_collection.png` - Unsplash で "insect collection" 検索
- [ ] `specimen_example.png` - Pexels で "butterfly" または "insect" 検索

### ⑨ 親子バトル化（2枚）
- [ ] `vs_battle_icon.png` - Pixabay で "vs competition icon" 検索
- [ ] `win_celebration.png` - Unsplash で "celebration success" 検索

### ③ おうちラボ（3枚）
- [ ] `home_lab_intro.png` - Pixabay で "home experiment kids" 検索
- [ ] `experiment_setup.png` - Unsplash で "home science" 検索
- [ ] `result_success.png` - Pixabay で "success celebration" 検索

---

## 📋 Step 2: ライセンス確認

各画像について以下を確認：
- [ ] 商用利用OK（CC0 または CC-BY で「商用利用: OK」と明記）
- [ ] ライセンス情報をスプレッドシートに記録
- [ ] 日本語の説明文が付与可能か確認

**記録形式**:
```
画像名 | URL | ライセンス | 出典 | 確認日
```

---

## 🖼️ Step 3: 画像ファイル配置

```bash
# ディレクトリ構成確認
lib/assets/images/
├── features/
│   ├── ai_chat/
│   │   ├── claude_mascot.png        ✓
│   │   └── chat_tutorial.png        ✓
│   ├── tonight_sky/
│   │   ├── moon_phases.png          ✓
│   │   ├── meteor_shower.png        ✓
│   │   ├── orion_constellation.png  ✓
│   │   ├── spring_triangle.png      ✓
│   │   └── night_sky_tutorial.png   ✓
│   ├── creature_camera/
│   │   ├── camera_guide.png         ✓
│   │   ├── creature_collection.png  ✓
│   │   └── specimen_example.png     ✓
│   ├── battle/
│   │   ├── vs_battle_icon.png       ✓
│   │   └── win_celebration.png      ✓
│   └── home_lab/
│       ├── home_lab_intro.png       ✓
│       ├── experiment_setup.png     ✓
│       └── result_success.png       ✓
```

配置コマンド:
```bash
mv ~/Downloads/claude_mascot.png lib/assets/images/features/ai_chat/
# ... 他の画像も同様
```

---

## ⚙️ Step 4: pubspec.yaml 更新

```yaml
# pubspec.yaml に以下を追加
flutter:
  assets:
    - lib/assets/images/features/ai_chat/
    - lib/assets/images/features/tonight_sky/
    - lib/assets/images/features/creature_camera/
    - lib/assets/images/features/battle/
    - lib/assets/images/features/home_lab/
```

- [ ] assets セクションを追加
- [ ] `flutter pub get` 実行

---

## 🎨 Step 5: UI統合

### AIはかせチャット
```dart
// lib/features/ai_chat/views/ai_chat_screen.dart

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ... 既存コード ...
        leading: Image.asset(
          'lib/assets/images/features/ai_chat/claude_mascot.png',
          width: 40,
          height: 40,
        ),
      ),
    );
  }
}
```

- [ ] claude_mascot を AppBar に統合
- [ ] chat_tutorial を説明画面に統合

### 今夜の空
```dart
// lib/features/sky/views/tonight_sky_screen.dart

class _TonightSkyScreenState extends State<TonightSkyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'lib/assets/images/features/tonight_sky/moon_phases.png',
              width: 300,
              height: 300,
            ),
            // ... 他の天体イベント表示 ...
          ],
        ),
      ),
    );
  }
}
```

- [ ] moon_phases を月相説明に統合
- [ ] meteor_shower をイベント表示に統合
- [ ] constellation 画像を星座説明に統合

### いきものカメラ
```dart
// lib/features/creature/views/creature_camera_screen.dart

class _CreatureCameraScreenState extends State<CreatureCameraScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset(
            'lib/assets/images/features/creature_camera/camera_guide.png',
            width: 200,
            height: 200,
          ),
          // ... カメラウィジェット ...
        ],
      ),
    );
  }
}
```

- [ ] camera_guide を初期画面に統合
- [ ] creature_collection をギャラリー表示に統合
- [ ] specimen_example を結果表示に統合

### 親子バトル
```dart
// lib/features/battle/views/prediction_battle_screen.dart

class _PredictionBattleScreenState extends State<PredictionBattleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'lib/assets/images/features/battle/vs_battle_icon.png',
          width: 40,
          height: 40,
        ),
      ),
    );
  }
}
```

- [ ] vs_battle_icon をバトル開始画面に統合
- [ ] win_celebration を結果画面に統合

### おうちラボ
```dart
// lib/features/home_lab/views/home_lab_screen.dart

class _HomeLabScreenState extends State<HomeLabScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset(
            'lib/assets/images/features/home_lab/home_lab_intro.png',
            width: 300,
            height: 200,
          ),
          // ... ミッション表示 ...
        ],
      ),
    );
  }
}
```

- [ ] home_lab_intro を導入画面に統合
- [ ] experiment_setup をミッション画面に統合
- [ ] result_success を完了画面に統合

---

## ✅ Step 6: テスト・検証

### 機能テスト
- [ ] AIはかせチャット
  - [ ] 画像が正しく表示される
  - [ ] テキストとのレイアウトが崩れない
  - [ ] 各端末サイズで適切に表示

- [ ] 今夜の空
  - [ ] 月相図が正確に表示される
  - [ ] 流星群イベント画像が表示される
  - [ ] 星図が見やすい

- [ ] いきものカメラ
  - [ ] カメラUIが見やすい
  - [ ] コレクション画面が整然としている
  - [ ] 標本例が分かりやすい

- [ ] 親子バトル
  - [ ] VSアイコンが目立つ
  - [ ] 勝利画面が華やかに見える

- [ ] おうちラボ
  - [ ] 導入画像で機能が理解しやすい
  - [ ] ミッション画面が分かりやすい
  - [ ] 成功表示が励みになる

### ビジュアルテスト
- [ ] ライトテーマで見栄えが良い
- [ ] ダークテーマで見栄えが良い
- [ ] 小さい画面（5.5"）で適切
- [ ] 大きい画面（6.7"）で適切
- [ ] 画像が透過背景なら背景が透けている

### パフォーマンステスト
- [ ] アプリ起動時間が大幅に増加していない
- [ ] メモリ使用量が大幅に増加していない
- [ ] 画像をスクロールしてもカクつかない

---

## 📦 Step 7: PR作成・マージ

- [ ] ブランチを新規作成: `feature/phase1-images`
- [ ] 画像ファイルをコミット
- [ ] UI統合コードをコミット
- [ ] テスト結果をスクリーンショットで記録
- [ ] PR #23 を作成（ドラフト）
- [ ] テスト完了後に Ready for Review に変更
- [ ] レビュー・マージ

---

## 📝 ライセンス記録シート

| # | 画像名 | URL | ライセンス | 出典 | ダウンロード日 | 確認者 |
|----|--------|-----|-----------|-----|-------------|-------|
| 1 | claude_mascot.png | https://... | CC0 | Pixabay | YYYY-MM-DD | ✓ |
| 2 | chat_tutorial.png | https://... | CC0 | Unsplash | YYYY-MM-DD | ✓ |
| ... | ... | ... | ... | ... | ... | ... |

---

**状況**: 準備完了 🚀  
**開始日**: YYYY-MM-DD  
**予定完了日**: YYYY-MM-DD (7-14日後)

