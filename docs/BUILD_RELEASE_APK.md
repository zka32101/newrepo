# 本番用APKビルドガイド 📦

このガイドでは、小学コレ！理科アプリの本番環境用APK（Android Package）をビルドする手順を説明します。

---

## 📋 前提条件

### 環境セットアップ確認
```bash
# Flutter バージョン確認（3.13.0 以上推奨）
flutter --version

# Android SDK 確認
flutter doctor -v

# 必要な要件:
✅ Flutter SDK 3.13.0 以上
✅ Android SDK API 34 以上
✅ Android NDK
✅ Java Development Kit (JDK) 11 以上
```

### チェックリスト
- [ ] Flutter が正常にインストール
- [ ] `flutter doctor` で全て ✓
- [ ] `git` ブランチが `main`
- [ ] Working directory が clean

---

## 🔑 キーストア設定（初回のみ）

### ステップ1: キーストア生成

```bash
# キーストア生成（初回のみ必要）
keytool -genkey -v -keystore ~/yourwish-release.keystore \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias yourwish-key

# 対話形式で以下を入力:
# Keystore password: [任意のパスワード]
# Owner Name: [Your Name]
# Organization: [Your Organization]
# City/Locality: [City]
# State/Province: [State]
# Country Code: JP
```

### ステップ2: キー設定ファイル作成

`android/key.properties` を作成:

```properties
storePassword=[キーストアのパスワード]
keyPassword=[キーのパスワード]
keyAlias=yourwish-key
storeFile=[キーストアファイルのパス]
# 例: /Users/username/yourwish-release.keystore
```

**⚠️ 重要**: `key.properties` は .gitignore に追加
```bash
echo "android/key.properties" >> .gitignore
```

---

## 🚀 APK ビルド手順

### ステップ1: 依存関係を確認

```bash
cd /path/to/yourwish

# 依存関係をアップデート
flutter pub get

# Gradle キャッシュをクリア（初回または問題時）
flutter clean
```

### ステップ2: リリース版 APK をビルド

```bash
# 本番用（リリース版）APKをビルド
flutter build apk --release

# または、スプリット APK（各アーキテクチャ別）でビルド
flutter build apk --split-per-abi --release
```

### ステップ3: ビルド出力確認

```bash
# ビルド出力の確認
ls -lh build/app/outputs/apk/release/

# 出力ファイル:
# - app-release.apk （統合版、約50-80MB）
# - app-armeabi-v7a-release.apk （32bit）
# - app-arm64-v8a-release.apk （64bit）
# - app-x86-release.apk （x86）
# - app-x86_64-release.apk （x86_64）
```

---

## 📊 ビルド最適化オプション

### オプション1: ファイルサイズ最小化

```bash
# ProGuard/R8 による難読化と最適化を有効化
flutter build apk --release \
  --obfuscate \
  --split-debug-info=build/app/outputs/symbols

# ビルド結果: 約 30-40MB（最適化版）
```

### オプション2: パフォーマンス最適化

```bash
# 複数アーキテクチャ対応版（Google Play推奨）
flutter build apk --split-per-abi --release

# 結果:
# - arm64-v8a: 最新スマートフォン（推奨）
# - armeabi-v7a: 古いスマートフォン対応
# - x86/x86_64: エミュレータ対応
```

### オプション3: App Bundle 生成（Google Play配信推奨）

```bash
# Google Play向けの最適化されたバンドル
flutter build appbundle --release

# 出力: build/app/outputs/bundle/release/app-release.aab
# Google Play が自動で最適なAPKを配信
```

---

## ✅ APK検証

### ビルド後の検査

```bash
# APK情報確認
aapt dump badging build/app/outputs/apk/release/app-release.apk

# 署名確認
jarsigner -verify -verbose build/app/outputs/apk/release/app-release.apk

# ファイルサイズ確認
du -sh build/app/outputs/apk/release/app-release.apk

# APKアナライザ（Android Studio）
# Analyze > Analyze APK を使用してサイズ分析
```

### テストデバイスでの検証

```bash
# USB接続確認
adb devices

# APKをテストデバイスにインストール
adb install -r build/app/outputs/apk/release/app-release.apk

# アプリ起動確認
adb shell am start -n jp.example.yourwish/.MainActivity

# ログ確認
adb logcat
```

---

## 🐛 よくあるビルドエラーと解決策

### エラー1: "Keystore not found"
```bash
# 解決策:
# android/key.properties のパスが正しいか確認
# キーストアファイルが存在するか確認
ls -la ~/yourwish-release.keystore
```

### エラー2: "gradle build failed"
```bash
# 解決策:
flutter clean
flutter pub get
flutter build apk --release
```

### エラー3: "No connected devices"
```bash
# 解決策:
# 1. USB接続確認
adb devices

# 2. デバッグモード有効化（Androidで開発者向けオプション）
# 3. USB認証許可

# 4. エミュレータを起動
emulator -avd Pixel_5_API_33
```

### エラー4: "APK signature verification failed"
```bash
# 解決策:
# キーストアとパスワードが正しいか確認
keytool -list -v -keystore ~/yourwish-release.keystore
```

---

## 📈 ビルド性能メトリクス

### 期待されるビルド時間
| コマンド | 初回 | 2回目以降 | 環境 |
|---|---|---|---|
| `flutter build apk --release` | 3-5分 | 1-2分 | 標準PC |
| `flutter build appbundle --release` | 2-4分 | 1-2分 | 標準PC |
| `--split-per-abi` 版 | 4-6分 | 2-3分 | 複数APK |

### 出力ファイルサイズ
| ファイル | サイズ | 用途 |
|---|---|---|
| app-release.apk | 50-80MB | 全アーキテクチャ対応 |
| app-arm64-v8a-release.apk | 30-40MB | 最新スマートフォン |
| app-release.aab | 20-30MB | Google Play配信 |

---

## 🎯 Google Play Store へのアップロード

### ステップ1: Google Play Console アクセス
1. https://play.google.com/console にアクセス
2. プロジェクトを選択
3. アプリ情報 > リリース > 本番環境

### ステップ2: APK/App Bundle アップロード

```bash
# Android Studio の "App Bundles Upload" を使用
# または、Web から直接アップロード

# ファイル: build/app/outputs/bundle/release/app-release.aab
```

### ステップ3: リリース情報設定
- [ ] アプリ説明
- [ ] スクリーンショット
- [ ] アイコン・画像
- [ ] コンテンツレーティング
- [ ] プライバシーポリシー

### ステップ4: リリース
- [ ] テスト用にベータ版で公開（推奨）
- [ ] フィードバック確認
- [ ] 本番環境へ段階公開

---

## 🔒 セキュリティチェックリスト

APKリリース前の確認事項:

- [ ] **コード難読化**: `--obfuscate` フラグを使用
- [ ] **シンボル分離**: `--split-debug-info` で分離
- [ ] **API キー非埋め込み**: 環境変数化
- [ ] **デバッグログ削除**: Release ビルド確認
- [ ] **署名検証**: 正しいキーストア使用
- [ ] **バージョンコード**: インクリメント（pubspec.yaml）
- [ ] **権限確認**: AndroidManifest.xml で不要な権限削除
- [ ] **ネットワークセキュリティ**: HTTPS 使用確認

---

## 📝 ビルド自動化（GitHub Actions）

### CI/CD パイプライン設定例

`.github/workflows/build.yml`:

```yaml
name: Build Release APK

on:
  push:
    tags:
      - 'v*'

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      
      - run: flutter pub get
      
      - run: flutter build apk --split-per-abi --release
      
      - name: Upload to Release
        uses: softprops/action-gh-release@v1
        with:
          files: build/app/outputs/apk/release/*.apk
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### 使用方法
```bash
# リリースタグを作成
git tag v1.0.0
git push origin v1.0.0

# GitHub Actions が自動的にビルド・リリース
```

---

## 🎁 チェックリスト（ビルド前）

```
Pre-Build Checklist:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Flutter doctor: All passed
✅ Git branch: main
✅ Working tree: clean
✅ pubspec.yaml: version updated
✅ android/key.properties: configured
✅ Keystore: ~/yourwish-release.keystore exists
✅ Java/JDK: version 11+
✅ Android SDK: API 34+
✅ Tests: all passing
✅ Code review: completed
✅ Release notes: prepared
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Build Command:
$ flutter build apk --split-per-abi --release --obfuscate

Expected Output:
✅ build/app/outputs/apk/release/
   - app-arm64-v8a-release.apk (30-40MB) ✅
   - app-armeabi-v7a-release.apk (28-35MB) ✅
   - app-x86-release.apk (35-45MB) ✅
   - app-x86_64-release.apk (40-50MB) ✅
```

---

## 📞 サポート情報

### 参考リンク
- [Flutter Build APK](https://flutter.dev/docs/deployment/android)
- [Google Play Console](https://play.google.com/console)
- [Android Documentation](https://developer.android.com/)
- [ProGuard Configuration](https://www.guardsquare.com/proguard)

### トラブルシューティング
```bash
# ビルド詳細ログ表示
flutter build apk --release -v

# Gradle 出力の詳細
flutter build apk --release --profile

# キャッシュクリア
flutter clean
rm -rf build/
rm -rf .gradle/
```

---

**APK ビルド完了後は、Google Play Store へのアップロード手順を参照してください。** 🚀

---

最終更新: 2026-08-26  
ステータス: Ready for Production  
推奨ビルド環境: macOS/Linux/Windows with Flutter 3.13+
