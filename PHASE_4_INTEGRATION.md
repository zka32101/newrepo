# Phase 4 統合完了 - 小学コレ！理科

shared_core の Phase 4.15-4.17（A/B テスト・Analytics・Cloud Functions）を統合しました。

## Firebase RemoteConfig 設定

以下 3 つのパラメータを Firebase Console で設定：
- **ab_tests_config** (JSON)
- **analytics_config** (JSON)
- **cloud_functions_config** (JSON)

## メトリクス記録

```dart
import 'package:shared_core/providers/analytics_notifier.dart';

await ref.read(analyticsNotifierProvider.notifier).recordMetric(
  userId: userId,
  type: LearningMetricType.quizCompleted,
  value: 1,
  appId: 'rika',
);
```

---

**最終更新**: 2026-09-11
