# デッドコード分析レポート - Phase 4

## 1. Freezed コード生成の不完全性

### 状態
複数のモデルが `@freezed` アノテーションを使用していますが、生成ファイル（`.freezed.dart`）が存在しません。

### 影響するファイル
| ファイル | 状態 | 依存先 | 対応 |
|---------|------|------|------|
| `lib/models/ranking_model.dart` | ❌ .freezed.dart なし | ranking service | build_runner 実行待ち |
| `lib/models/achievement_model.dart` | ❌ .freezed.dart なし | achievement service | build_runner 実行待ち |
| `lib/models/avatar_model.dart` | ❌ .freezed.dart なし | avatar providers | build_runner 実行待ち |
| `lib/models/streak_model.dart` | ❌ .freezed.dart なし | streak service | build_runner 実行待ち |
| `lib/models/privacy_settings_model.dart` | ✅ 手書き実装済み | privacy providers | 完了 |
| `lib/models/analytics_model.dart` | ✅ .freezed.dart あり | analytics | 完了 |

### 根本原因
- `build_runner` コマンドが実行されていないため、生成ファイルが作成されない
- 生成ファイルがリポジトリにコミットされていない
- Flutter 環境での `build_runner` 実行が必要

### 推奨対応
**優先度：高** → 別途 PR で Flutter 環境での build_runner 実行を実施

```bash
# 推奨コマンド
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 2. テーマファイル統一化（完了）

### 対応済み（PR #37）
- ✅ `lib/app/theme.dart` 削除
- ✅ `lib/shared/theme/app_theme.dart` に統一

### 結果
単一の情報源でテーマ定義を管理し、保守性向上

---

## 3. 使用状況確認結果

### 使用中のモデル
全てのモデルが実装完了または使用中

| モデル | 使用箇所 | 状態 |
|--------|---------|------|
| RankingModel | ranking service | 使用中 |
| AchievementModel | achievement service | 使用中 |
| AvatarModel | avatar provider, widgets | 使用中 |
| StreakModel | streak service, widgets | 使用中 |
| PrivacySettingsModel | privacy providers | 使用中 |

### 結論
**削除対象なし** - 全モデルが実装完了または使用中

---

## 4. 今後の改善予定

### Phase 4-2（次の PR）
- Freezed 生成ファイル再生成（Flutter 環境で実行）
- その他 UI コンポーネントのカラー統一

### Phase 5（将来）
- 未使用パッケージ監査
- テストカバレッジ拡大
- デッドコード定期監査

---

## 参考資料
- Freezed 公式: https://pub.dev/packages/freezed
- build_runner: https://pub.dev/packages/build_runner
