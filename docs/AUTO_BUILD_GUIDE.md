# 自動APKビルド・リリースガイド

小学コレ！理科プロジェクトの自動ビルド・デプロイメント手順書

## 概要

GitHub Actionsを使用した自動APKビルド・リリースシステムです。タグプッシュ時の自動リリース、またはworkflow_dispatchによる手動トリガーに対応しています。

---

## 1️⃣ ワークフロー構成

### 実装済みワークフロー

| ファイル | トリガー | 機能 |
|---------|---------|------|
| `build-release-apk.yml` | タグプッシュ（v*）/ workflow_dispatch / リリース作成 | リリースAPKビルド + GitHub Release自動作成 |
| `auto-bump-version.yml` | PR マージ（main） | ビルドナンバー自動インクリメント |
| `daily-snapshot-build.yml` | 毎日 09:00 UTC / workflow_dispatch | デバッグAPK日次スナップショットビルド |
| `deploy.yml` | タグプッシュ（v*） | 基本的なAPKビルド |

### ワークフロー活用例

**本番リリース**: `build-release-apk.yml`（タグプッシュ時）
```
git tag v1.1.0 → 署名付きAPK + GitHub Release
```

**日次健全性確認**: `daily-snapshot-build.yml`（毎日 9:00 UTC）
```
毎日 main をビルド → デバッグAPK生成 → 問題早期発見
```

**開発フロー**: `auto-bump-version.yml`（PR マージ時）
```
PR マージ → ビルドナンバー自動インクリメント → 1.0.0+5 → 1.0.0+6
```

---

## 2️⃣ APKビルド手順

### ローカル環境でのビルド確認

**前提条件**:
- Flutter 3.34.0以上がインストール済み
- Android SDK がセットアップ済み
- キーストア（release-keystore.jks）が存在

**デバッグビルド**:
```bash
flutter pub get
flutter build apk --debug
# 出力: build/app/outputs/flutter-apk/app-debug.apk
```

**リリースビルド**（ローカル、署名なし）:
```bash
flutter pub get
flutter build apk --release
# 出力: build/app/outputs/apk/release/app-release.apk
```

**Windows環境での注意**:
プロジェクトパスに日本語が含まれるため、仮想ドライブ(S:)を割り当てしてビルドします：

```powershell
# 毎セッション初回のみ
subst S: "G:\マイドライブ\apps\shokollen_science"

# ビルド実行
cd S:/
flutter pub get
flutter build apk --release
```

詳細は CLAUDE.md の「APKビルド手順」を参照してください。

---

## 3️⃣ GitHub Actions 自動ビルド

### 3-1. タグ推進によるリリース

リリースバージョンで新しいタグを作成・プッシュします：

```bash
# ローカルでバージョンを更新
# pubspec.yaml: version: 1.0.1+2 → version: 1.1.0+3

git add pubspec.yaml
git commit -m "chore: bump version to 1.1.0+3"
git tag v1.1.0
git push origin main --tags
```

**自動実行内容**:
1. ✅ Flutter環境セットアップ
2. ✅ 依存パッケージ取得（flutter pub get）
3. ✅ リリースAPKビルド（split-per-abi, obfuscate）
4. ✅ App Bundle(AAB)ビルド
5. ✅ GitHubリリース自動作成（APK/AAB同梱）

**リリース結果**:
- GitHub Releases: https://github.com/zka32101/newrepo/releases
- APKファイル:
  - `app-arm64-v8a-release.apk` - 64-bit ARM（最新デバイス向け）
  - `app-armeabi-v7a-release.apk` - 32-bit ARM（旧デバイス向け）
  - `app-x86-release.apk` - x86デバイス向け
  - `app-x86_64-release.apk` - x86-64デバイス向け
- App Bundle:
  - `app-release.aab` - Google Play Store用

### 3-2. workflow_dispatch（手動トリガー）

GitHub UI から手動でビルド・リリースを開始できます：

**GitHub UIでの実行**:
1. https://github.com/zka32101/newrepo/actions → `Build Release APK`
2. `Run workflow` ボタンをクリック
3. `app_version` を入力（例：1.0.0）
4. `Run workflow` を実行

**GitHub CLIでの実行**:
```bash
gh workflow run build-release-apk.yml --ref main
```

**Claude Code MCP ツールでの実行**:
```javascript
mcp__github__actions_run_trigger({
  owner: "zka32101",
  repo: "newrepo",
  workflow_id: "build-release-apk.yml",
  ref: "main"
})
```

---

## 4️⃣ 必須シークレット設定

GitHub Actions がビルド・署名・デプロイを行うために、以下のシークレットをリポジトリに設定します：

### 設定方法

**GitHub UI**: Settings → Secrets and variables → Actions → New repository secret

| シークレット名 | 説明 | 例 |
|---|---|---|
| `KEYSTORE_FILE` | リリース用キーストア（Base64エンコード済み） | base64形式の .jks ファイル |
| `KEYSTORE_PASSWORD` | キーストアのパスワード | your-keystore-password |
| `KEY_PASSWORD` | キーのパスワード | your-key-password |
| `KEY_ALIAS` | キーのエイリアス | release-key |

### キーストアの準備（Base64エンコード）

```bash
# release-keystore.jks を Base64 エンコード
base64 -i release-keystore.jks -o keystore.b64

# Windows PowerShell の場合
[Convert]::ToBase64String([IO.File]::ReadAllBytes("release-keystore.jks")) | Set-Clipboard
```

エンコード済みテキストを `KEYSTORE_FILE` シークレットに登録します。

---

## 5️⃣ バージョン管理

### pubspec.yaml フォーマット

```yaml
version: 1.1.3+14
```

- **1.1.3** = アプリバージョン（ユーザー向け表示）
- **+14** = ビルドナンバー（内部用、自動インクリメント）

### 自動バージョンバンプ機構

PR が main にマージされるたびに、ビルドナンバーが自動でインクリメントされます。

**自動実行フロー**:
```
PR をマージ → GitHub Actions 自動実行
  ↓
pubspec.yaml のビルドナンバーを +1
例: 1.1.3+14 → 1.1.3+15
  ↓
自動コミット & プッシュ
```

**ワークフロー**: `.github/workflows/auto-bump-version.yml`

### 手動リリース手順（アプリバージョン更新時）

**例**: v1.1.3 → v1.1.4 にアップグレード

1. **pubspec.yaml を編集** - アプリバージョンのみ更新:
   ```yaml
   version: 1.1.3+14  →  version: 1.1.4+14
   ```
   > 注意: ビルドナンバーは手動で変更しないこと（自動管理）

2. **コミット**:
   ```bash
   git add pubspec.yaml
   git commit -m "chore: bump app version to 1.1.4"
   git push origin main
   ```

3. **PR マージ → 自動バンプ**:
   - マージ後、自動で `1.1.4+15` に更新されます

4. **タグ作成・リリース** - ビルドナンバー確認後:
   ```bash
   git pull origin main  # 最新版を取得
   git tag v1.1.4
   git push origin v1.1.4
   ```
   > GitHub Actions が自動でリリースAPKをビルド・デプロイします

---

## 6️⃣ リリースノート生成

### 自動生成ルール

GitHub Release の本文は以下のテンプレートで自動生成されます：

```markdown
# Release 1.1.4

## Build Information
- **Build Date**: 2026-09-10T12:34:56Z
- **Flutter Version**: 3.34.0
- **Build Type**: Release (Optimized & Obfuscated)
- **APK Format**: Split-per-ABI

## APK Files (Direct Distribution)
- `app-arm64-v8a-release.apk` - For modern devices (64-bit ARM)
- `app-armeabi-v7a-release.apk` - For older devices (32-bit ARM)
- `app-x86-release.apk` - For x86 devices
- `app-x86_64-release.apk` - For x86-64 devices

## App Bundle (Google Play Store)
- `app-release.aab` - For Google Play Store submission

## Installation
**APK**: Download the APK file matching your device, enable "Unknown Sources", and install directly
**AAB**: Upload to Google Play Console for automated device-specific APK delivery
```

### カスタマイズ

`build-release-apk.yml` の `body:` セクションを編集して、リリースノートを カスタマイズします。

---

## 6️⃣ 日次スナップショットビルド

毎日 **09:00 UTC**（日本時間 18:00）に main ブランチの自動ビルドが実行されます。

**ワークフロー**: `.github/workflows/daily-snapshot-build.yml`

### 実行内容

1. ✅ main ブランチをチェックアウト
2. ✅ Flutter 依存をインストール
3. ✅ デバッグAPKをビルド（高速）
4. ✅ ビルド解析（flutter analyze）
5. ✅ 成果物を7日間保持

### スナップショットの確認

GitHub Actions → `Daily Snapshot Build` タブで確認可能

- ビルド成功・失敗ログ
- APK サイズ
- 解析警告

### 手動実行

開発中に即座にビルドをテストしたい場合：

```bash
# GitHub CLI
gh workflow run daily-snapshot-build.yml

# または GitHub UI → Actions → Daily Snapshot Build → Run workflow
```

### スナップショットAPK のダウンロード

GitHub Actions Artifacts から 7 日以内なら直接ダウンロード可能

```
Actions → Daily Snapshot Build
  → snapshot-apk-YYYYMMDD_HHMMSSZ
  → app-debug.apk をダウンロード
```

---

## 7️⃣ トラブルシューティング

### ビルド失敗時

| エラー | 原因 | 解決策 |
|-------|------|------|
| `Keystore file not found` | `KEYSTORE_FILE` シークレット未設定 | Settings → Secrets で `KEYSTORE_FILE` を登録 |
| `STORE_PASSWORD is not set` | パスワード系シークレット未設定 | `KEYSTORE_PASSWORD`, `KEY_PASSWORD`, `KEY_ALIAS` を登録 |
| `Flutter version not found` | Flutter SDK が見つからない | ワークフローのFlutterバージョンを確認（現在: 3.34.0） |
| `APK build failed` | Dart/Flutter コンパイルエラー | ローカルで `flutter build apk --release` を実行してエラーを確認 |

### GitHub Release 作成失敗

- `GITHUB_TOKEN` が正しく設定されているか確認
- リポジトリの権限を確認（read, write が必要）

---

## 8️⃣ デプロイメントチェックリスト

リリース前に以下を確認してください：

- [ ] ローカルで `flutter build apk --release` を実行し、エラーなくビルドできることを確認
- [ ] `pubspec.yaml` のアプリバージョンのみ更新（ビルドナンバーは自動管理）
- [ ] Git にコミット・プッシュ済みか確認
- [ ] PR がマージされたか確認（自動バンプが実行される）
- [ ] `git pull origin main` で最新版を確認（ビルドナンバー自動更新）
- [ ] `KEYSTORE_FILE` が GitHub Secrets に登録されているか確認
- [ ] `KEYSTORE_PASSWORD`, `KEY_PASSWORD`, `KEY_ALIAS` が登録されているか確認
- [ ] タグ形式が正しいか確認（`v1.1.4` 形式）
- [ ] GitHub Actions のワークフロー実行ログを確認
- [ ] GitHub Release に APK/AAB が正しく添付されているか確認
- [ ] APK ファイルをダウンロード、デバイスでインストール・動作確認できるか確認

---

## 9️⃣ 追加リソース

- [Flutter Build APK ドキュメント](https://flutter.dev/docs/deployment/android#building-the-app-for-release)
- [GitHub Actions: Android Build & Release](https://github.com/marketplace/actions/android-build)
- [GitHub Secrets 管理](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [Google Play Store 登録ガイド](https://play.google.com/console/about/)

---

## 🔟 今後の改善案

- [x] **自動バージョンバンプ機構**（PR マージ時に build number インクリメント）✅ 実装済み
- [x] **スナップショット中間テスト**（毎日 main ブランチの自動ビルド）✅ 実装済み
- [ ] リリースノート自動生成（PRタイトル/ラベルから）
- [ ] App Store への自動配布（iOS 対応時）
- [ ] Beta ビルド自動配布（TestFlight / Firebase App Distribution）
- [ ] Windows CI 環境での日本語パス対応（仮想ドライブ割り当て自動化）
- [ ] デスクトップ UI から GitHub Release への直接ダウンロードリンク表示
- [ ] 自動バージョンバンプのスキップオプション（`[skip-bump]` コミットメッセージ）
- [ ] Slack 通知統合（ビルド失敗時）
- [ ] Performance メトリクス追跡（APK サイズ、ビルド時間）

---

**最終更新**: 2026-09-10
**プロジェクト**: 小学コレ！理科 (shokollen_science)
**リポジトリ**: https://github.com/zka32101/newrepo
