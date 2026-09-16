# Freezed コード生成復旧計画

**ステータス**: 🔄 実行待ち（Flutter 環境必要）  
**優先度**: 🥇 高（Compiler Errors 修正に必須）

## 概要

複数のモデルが `@freezed` アノテーション使用していますが、生成ファイルが存在しないため、ビルドが失敗しています。

---

## 対象ファイル一覧

### ❌ 生成ファイル不足（修正必要）

| モデル | ファイル | 使用箇所 | 優先度 |
|--------|---------|---------|------|
| RankingEntry | `lib/models/ranking_model.dart` | ranking service | 🥇 高 |
| AchievementData | `lib/models/achievement_model.dart` | achievement service | 🥇 高 |
| AvatarItem | `lib/models/avatar_model.dart` | avatar providers | 🥇 高 |
| StreakData | `lib/models/streak_model.dart` | streak service | 🥇 高 |

### ✅ 生成ファイル完備（OK）

| モデル | ファイル | 生成ファイル | 状態 |
|--------|---------|-----------|------|
| AnalyticsEvent | `lib/models/analytics_model.dart` | ✅ .freezed.dart | 完了 |
| UserPrivacySettings | `lib/models/privacy_settings_model.dart` | 手書き実装 | 完了 |

---

## 実行手順

### 方法 A: build_runner 使用（推奨）

**環境**: Flutter SDK 3.5.0+ が必要

```bash
# 1. 依存関係確認
flutter pub get

# 2. コード生成実行
flutter pub run build_runner build --delete-conflicting-outputs

# 3. 生成ファイル確認
ls -la lib/models/*.freezed.dart
```

**期待結果**:
```
lib/models/ranking_model.freezed.dart
lib/models/achievement_model.freezed.dart
lib/models/avatar_model.freezed.dart
lib/models/streak_model.freezed.dart
lib/models/ranking_model.g.dart
lib/models/achievement_model.g.dart
lib/models/avatar_model.g.dart
lib/models/streak_model.g.dart
```

### 方法 B: 手書き実装（代替案）

`lib/models/privacy_settings_model.dart` のパターンを参考に、各モデルを手書き実装。

**実施例**:
```dart
// @freezed ← 削除
class RankingEntry {
  // 手動で copyWith, toJson, fromJson, ==, hashCode を実装
  
  const factory RankingEntry({
    required String userId,
    // ... other fields
  }) = _RankingEntry;
  
  factory RankingEntry.fromJson(Map<String, dynamic> json) => ...
  Map<String, dynamic> toJson() => ...
  RankingEntry copyWith({...}) => ...
  @override
  bool operator == (Object other) => ...
  @override
  int get hashCode => ...
}
```

**利点**: Flutter 環境不要  
**欠点**: 実装量が大きい、バグリスク高い

---

## 修正後の検証

### コンパイル確認

```bash
flutter pub get
flutter analyze
flutter build apk --debug --no-pub 2>&1 | head -50
```

### CI 確認

- Unit & Widget Tests ✅ 成功
- Lint & Format Check ✅ 成功
- Build Debug APK ✅ 成功
- Android Emulator Tests ✅ 成功（実装待ち）

---

## スケジュール

| フェーズ | 内容 | 所要時間 |
|---------|------|---------|
| **今** | ドキュメント作成（完了） | ✅ |
| **次** | Flutter 環境セットアップ | 5-10 分 |
| **次々** | build_runner 実行 | 2-5 分 |
| **検証** | CI green 確認 | 10-15 分 |

---

## リスク & 対策

| リスク | 対策 |
|--------|------|
| 生成ファイルの不完全性 | `--delete-conflicting-outputs` で初期化 |
| 既存コードとの競合 | Git diff で修正内容確認してから commit |
| CI タイムアウト | キャッシュ活用（既に .github/workflows で設定済み） |

---

## 関連ドキュメント

- `.claude/DEAD_CODE_ANALYSIS.md` - デッドコード分析
- `.claude/PHASE4_RECOMMENDATIONS.md` - 改善計画
- `HANDOFF.md` - セッション引き継ぎ
