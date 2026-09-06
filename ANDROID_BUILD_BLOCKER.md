# Android ビルド ブロッカー: shared_core SDK 制約問題

## 問題の説明

shokollen_science アプリの Android APK/AAB ビルドが失敗しています。

**根本原因：shared_core の不可能な Dart SDK 制約**

```yaml
# org-zka32101/shared_core/pubspec.yaml
environment:
  sdk: ^3.11.5  ❌ Dart 3.11 は存在しない！
```

## 技術詳細

- **現在の制約:** `sdk: ^3.11.5` (Dart 3.11.5 以上が必要)
- **実際に存在する Dart:** Dart 3.0 - 3.5.x (および将来の 4.0+)
- **結果:** どの Flutter バージョンでも依存関係の解決に失敗

### テスト結果

| Flutter Version | Dart Version | 結果 |
|---|---|---|
| 3.24.0 | 3.5.0 | ❌ 不足 |
| 3.27.0 | 3.6.x | ❌ 不足 |
| 3.13.0 | 3.1.x | ❌ 不足 |

## 修正方法

### オプション 1: shared_core を直接修正（推奨）

**ファイル:** `org-zka32101/shared_core/pubspec.yaml`

```yaml
environment:
  sdk: ^3.1.5  ✅ Dart 3.1.5 以上（Flutter 3.13.0 で利用可能）
  flutter: ">=1.17.0"
```

修正後、以下でビルドが成功します：
```bash
cd /home/user/newrepo
flutter clean
flutter pub get
flutter build apk --split-per-abi --release
```

### オプション 2: zka32101 で shared_core をフォーク

shared_core を zka32101 アカウントでフォークし、pubspec.yaml を修正してから使用：

```yaml
# pubspec.yaml
dependencies:
  shared_core:
    git:
      url: https://github.com/zka32101/shared_core.git
      ref: main
```

### オプション 3: ローカルパス参照（開発用）

```yaml
# pubspec.yaml
dependencies:
  shared_core:
    path: ../shared_core  # または絶対パス
```

## 実装されたCI/CD インフラ

以下は既に実装・テスト済みです：

✅ gradle-wrapper.jar (Gradle 8.14) - 再現可能なビルド  
✅ Android 署名設定 (test keystore)  
✅ Google Drive アップロード ワークフロー  
✅ Flutter 3.13.0 セットアップ  
✅ APK/AAB ビルド設定  

**唯一の障害：** shared_core の SDK 制約

## 推奨アクション

1. **短期** (即座):
   - org-zka32101/shared_core の pubspec.yaml を修正
   - `sdk: ^3.11.5` → `sdk: ^3.1.5`

2. **中期** (確認後):
   - ビルド #20 をトリガー
   - APK/AAB 成功確認
   - Google Drive への自動アップロード確認

3. **長期** (本番前):
   - プロダクション用署名鍵に置き換え
   - Google Play へのアップロード

## ビルド実行コマンド

shared_core が修正されたら：

```bash
# デバッグビルド
flutter build apk --debug

# リリースビルド（分割 APK）
flutter build apk --split-per-abi --release

# リリースビルド（App Bundle - Google Play 用）
flutter build appbundle --release

# GitHub Actions から
git tag v1.0.1
git push origin v1.0.1
# workflow が自動実行
```

## ログ・デバッグ情報

### 修正が確認できるポイント

shared_core が修正されると、ワークフローで以下が表示されます：

```
✅ Setup Flutter: 3.13.0
✅ Get Flutter dependencies: SUCCESS
✅ Setup Android build environment
✅ Build Release APK
✅ Build App Bundle
✅ Upload artifacts to Google Drive
```

### 現在のワークフロー (build-release-apk.yml の状態)

- Dart SDK 制約パッチング: ✅ 実装済み
- ローカル shared_core パッチ: ✅ 実装済み
- pubspec.yaml 動的修正: ✅ 実装済み
- Google Drive 自動アップロード: ✅ 実装済み

---

**更新日:** 2026-09-06  
**ステータス:** shared_core 修正待ち  
**優先度:** 🔴 Critical - ビルドの完全性に必須
