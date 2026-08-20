# 学習画面（stage_4/5/6） 欠落イラスト 生成ツール

`tools/rika_monster_image_gen/` の構成を移植。`lib/data/seeds/learn_content_data.dart`
（および `learn_content_data_merged.dart`）が `imagePath` として参照しているが、
`assets/` に実ファイルが存在しない33枚を生成し、`assets/illustrations/stage_{4,5,6}/`
に直接保存する。

各プロンプトの主題・カテゴリ分類（診断図タイプA / 観察イラストタイプB）の詳細は
リポジトリ直下の `AI_IMAGE_PROMPTS_LEONARDO_STAGE_4_5_6.md` を参照。

## 実行前の準備

1. Leonardo.ai の APIキーを取得（cloud.leonardo.ai にログイン → Platform > API Access）
2. PowerShellで環境変数に設定（**このターミナルセッション限り**）
   ```powershell
   $env:LEONARDO_API_KEY="xxxx"
   ```
3. Node.js が使えること（`node --version` で確認）

## 実行手順

```bash
cd "H:\マイドライブ\apps\shokollen_science\tools\learn_illustration_gen"

# Step 1: サンプル2枚だけ生成してプロンプト品質を確認
node generate_leonardo.js --count 2

# Step 2: assets/illustrations/stage_4/ に生成された画像を確認
#         気に入らなければ prompt_builder.js の subject を調整して --force で再生成

# Step 3: 問題なければ残り全部（33枚）を一括生成
node generate_leonardo.js --all
```

特定のファイルだけ再生成したい場合:
```bash
node generate_leonardo.js --ids stage_4_007_skeleton,stage_6_004_ph --force
```

## 生成される33ファイル

`assets/illustrations/stage_4/`（6枚）、`assets/illustrations/stage_5/`（15枚）、
`assets/illustrations/stage_6/`（12枚）。ファイル名一覧は
`AI_IMAGE_PROMPTS_LEONARDO_STAGE_4_5_6.md` のプロンプト一覧表を参照。

## 生成後に必須の対応

### 1. pubspec.yaml にフォルダを追加

現状 `assets:` セクションには `assets/illustrations/stage_3/` しか登録されていない。
**画像ファイルの配置と同じコミットで**以下を追加すること
（ファイルが無い状態でフォルダだけ登録するとビルドエラーになるため）:

```yaml
  assets:
    - assets/icon/
    - assets/illustrations/stage_3/
    - assets/illustrations/stage_4/
    - assets/illustrations/stage_5/
    - assets/illustrations/stage_6/
    - assets/images/monsters/
```

### 2. 動作確認

```bash
cd "H:\マイドライブ\apps\shokollen_science"
flutter pub get
flutter analyze
```

`lib/features/learn/views/learn_screen.dart` の学習画面で該当ステージを開き、
画像が正しく表示されることを確認する。

## モデルについて

デフォルトの `modelId`（`de7d3faf-762f-48e0-b3b7-9d0ac3a3fcf3`）は
`tools/rika_monster_image_gen` で実績のある **Leonardo Phoenix 1.0** をそのまま流用している。
`AI_IMAGE_PROMPTS_LEONARDO_STAGE_4_5_6.md` では Kino XL を推奨しているが、
API経由での modelId をこちらでは検証できていないため、確実に動作する Phoenix 1.0 を
デフォルトにした。Kino XL を使いたい場合は Leonardo の `GET /platformModels` API で
modelId を調べ、環境変数で上書きすること:

```powershell
$env:LEONARDO_MODEL_ID="（調べたKino XLのmodelId）"
```

## コスト目安

- 1360×768 / alchemy:off: モンスター画像（512×512）より解像度が高い分、1枚あたりのクレジット
  消費も多くなる。**必ず `--count 2` などの少数サンプルで確認してから `--all` を実行すること**
- 既存ファイルは自動スキップされるため、`--all` を何度実行しても未生成分のみ課金される

## ライセンス・著作権メモ

- Leonardo.AIで生成した画像は商用利用可（利用規約要確認）
- Wikipedia等の外部画像を使わずAI生成のみで完結する場合、`ATTRIBUTION.md`は不要
