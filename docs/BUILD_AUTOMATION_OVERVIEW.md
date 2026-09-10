# ビルド自動化システム全体概要

小学コレ！理科プロジェクトの統合ビルド自動化システムの完全ガイド

## 📊 全体アーキテクチャ

```
開発フロー
├─ 開発者: Feature ブランチで開発
│  └─ コミット・プッシュ
│
├─ PR作成・マージ
│  ├─ auto-bump-version.yml 実行
│  │  └─ pubspec.yaml ビルドナンバー自動インクリメント
│  │     例: 1.0.0+5 → 1.0.0+6
│  └─ main ブランチ更新
│
├─ 毎日 09:00 UTC
│  └─ daily-snapshot-build.yml 実行
│     ├─ main ブランチからデバッグAPKビルド
│     ├─ flutter analyze 実行
│     └─ APK を7日間保持
│
└─ リリース時: git tag v1.1.0
   └─ build-release-apk.yml 実行
      ├─ リリースAPK・AAB ビルド
      ├─ GitHub Release 作成
      └─ APK/AAB を自動アップロード
```

---

## 🔄 ワークフロー詳細

### 1️⃣ PR マージ時（自動バージョンバンプ）

| ステップ | 内容 | 時間 |
|---------|------|------|
| トリガー | PR を main にマージ | - |
| 実行 | auto-bump-version.yml | 30秒 |
| 処理 | pubspec.yaml を更新＋自動コミット | - |
| 結果 | ビルドナンバー +1 | - |

**例**:
```
開発者の pubspec.yaml:     1.0.0+5
  ↓ PR マージ
GitHub Actions 自動実行
  ↓
更新後の pubspec.yaml:     1.0.0+6
自動コミット: "chore: bump build number to 1.0.0+6"
```

**ファイル**: `.github/workflows/auto-bump-version.yml`

---

### 2️⃣ 毎日 09:00 UTC（日次スナップショットビルド）

| ステップ | 内容 | 時間 |
|---------|------|------|
| トリガー | cron: `0 9 * * *` | 毎日 09:00 UTC |
| 実行 | daily-snapshot-build.yml | 5-10分 |
| ビルド | flutter build apk --debug | - |
| 解析 | flutter analyze | - |
| アップロード | Artifacts (7日保持) | - |

**目的**:
- ✅ main ブランチの健全性確認
- ✅ リグレッション検知
- ✅ デイリーレポート

**ファイル**: `.github/workflows/daily-snapshot-build.yml`

---

### 3️⃣ リリース時（git tag で自動リリース）

| ステップ | 内容 | 時間 |
|---------|------|------|
| トリガー | `git tag v1.1.0` | - |
| 実行 | build-release-apk.yml | 10-15分 |
| ビルド | flutter build apk --release | - |
|  | flutter build appbundle | - |
| 署名 | Keystore で署名 | - |
| リリース | GitHub Release 作成 | - |
| アップロード | APK/AAB を自動添付 | - |

**例**:
```bash
# ローカルでタグ作成
git tag v1.1.0
git push origin v1.1.0

  ↓ GitHub Actions 自動実行
  
✅ リリースAPK生成
✅ App Bundle生成
✅ GitHub Release 作成
✅ APK/AAB を自動添付

# ユーザーはこちらからダウンロード:
https://github.com/zka32101/newrepo/releases
```

**ファイル**: `.github/workflows/build-release-apk.yml`

---

## 📅 タイムライン例

### シナリオ: v1.0.1 → v1.0.2 リリース

```
Monday (開発)
├─ Feature A PR マージ
│  └─ auto-bump: 1.0.0+20 → 1.0.0+21 ✅
│
├─ Feature B PR マージ
│  └─ auto-bump: 1.0.0+21 → 1.0.0+22 ✅
│
└─ Feature C PR マージ
   └─ auto-bump: 1.0.0+22 → 1.0.0+23 ✅

Tuesday 09:00 UTC (日次ビルド)
└─ daily-snapshot-build
   ├─ main からデバッグAPKビルド ✅
   └─ 解析実行・レポート生成 ✅

Wednesday (リリース準備)
├─ pubspec.yaml を手動編集: 1.0.0+23 → 1.0.2+23
│  (アプリバージョンを1.0.0 → 1.0.2に更新)
│
├─ コミット & PR マージ
│  └─ auto-bump: 1.0.2+23 → 1.0.2+24 ✅
│
└─ git tag v1.0.2 & push
   └─ build-release-apk
      ├─ 署名済みAPKビルド ✅
      ├─ App Bundle ビルド ✅
      └─ GitHub Release 作成 ✅
         （APK/AAB自動アップロード）
```

---

## 🔐 必須設定

### GitHub Secrets（Settings → Secrets and variables → Actions）

| シークレット | 用途 | 設定方法 |
|------------|------|--------|
| `KEYSTORE_FILE` | APK署名用キーストア | Base64エンコード |
| `KEYSTORE_PASSWORD` | キーストアのPW | テキスト直入力 |
| `KEY_PASSWORD` | キーのPW | テキスト直入力 |
| `KEY_ALIAS` | キーのエイリアス | テキスト直入力 |

**キーストア準備例**:
```bash
# Base64エンコード
base64 -i release-keystore.jks -o keystore.b64

# GitHub Secrets に登録
# Settings → Secrets → KEYSTORE_FILE に貼り付け
```

---

## 📊 ワークフロー状態確認

### GitHub UI での確認

```
https://github.com/zka32101/newrepo/actions

├─ Auto Bump Version
│  └─ PR マージ時のステータス
│
├─ Daily Snapshot Build
│  └─ 毎日09:00 UTC のビルド状況
│
└─ Build Release APK
   └─ リリース時のビルド状況
```

### 手動トリガー

```bash
# 日次ビルドを即座に実行
gh workflow run daily-snapshot-build.yml

# リリースビルドを手動実行
gh workflow run build-release-apk.yml --ref main
```

---

## ⚠️ トラブルシューティング

### auto-bump-version が実行されない

**原因**: PR の merge イベントが検出されていない

**対策**:
1. PR がマージ済みか確認（merged = true）
2. `.github/workflows/auto-bump-version.yml` の `on` 設定確認
3. Actions の実行権限確認（Settings → Actions → General）

### daily-snapshot-build が実行されない

**原因**: cron スケジュールが UTC 時間

**対策**:
1. GitHub Actions では常に UTC で実行
2. 日本時間18:00 = UTC 09:00 に設定済み
3. 手動実行: `gh workflow run daily-snapshot-build.yml`

### build-release-apk に失敗

**原因**: Secrets 未設定 / タグ形式エラー / ビルドエラー

**対策**:
```bash
# Secrets 確認
Settings → Secrets and variables → Actions
  ✅ KEYSTORE_FILE
  ✅ KEYSTORE_PASSWORD
  ✅ KEY_PASSWORD
  ✅ KEY_ALIAS

# タグ形式確認
git tag v1.1.0  # ✅ 正
git tag 1.1.0   # ❌ 誤（v プレフィックス必須）

# ローカルビルド確認
flutter pub get
flutter build apk --release
```

---

## 🎯 ベストプラクティス

### ✅ DO

- ✅ PR マージ時の自動バンプに頼る
- ✅ 毎日スナップショットビルドの結果を確認
- ✅ リリース時は `git tag v*` で統一
- ✅ Secrets は個別に設定・管理

### ❌ DON'T

- ❌ pubspec.yaml のビルドナンバーを手動編集（自動管理のため）
- ❌ タグ形式を混在（v1.0.0 に統一）
- ❌ Secrets をコード内に埋め込み
- ❌ build-release-apk 手動実行（タグプッシュ推奨）

---

## 📚 参考ドキュメント

- [AUTO_BUILD_GUIDE.md](./AUTO_BUILD_GUIDE.md) - 詳細な実装ガイド
- [.github/workflows/auto-bump-version.yml](../.github/workflows/auto-bump-version.yml) - 自動バンプ実装
- [.github/workflows/daily-snapshot-build.yml](../.github/workflows/daily-snapshot-build.yml) - 日次ビルド実装
- [.github/workflows/build-release-apk.yml](../.github/workflows/build-release-apk.yml) - リリースビルド実装

---

## 🚀 次のステップ

**実装完了**:
- ✅ AUTO_BUILD_GUIDE
- ✅ 自動バージョンバンプ
- ✅ 日次スナップショットビルド
- ✅ 本番リリースビルド

**今後の改善（検討中）**:
- [ ] Slack 通知統合（ビルド失敗時）
- [ ] リリースノート自動生成
- [ ] Performance メトリクス追跡
- [ ] iOS/App Store 自動配布

---

**最終更新**: 2026-09-10
**プロジェクト**: 小学コレ！理科 (shokollen_science)
**リポジトリ**: https://github.com/zka32101/newrepo
