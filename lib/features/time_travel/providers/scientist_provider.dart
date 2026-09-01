import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../data/scientist_stories_data.dart';

/// 科学者ストーリーの閲覧履歴
class ViewedStory {
  final String scientistId;
  final DateTime viewedAt;
  final int grade;

  const ViewedStory({
    required this.scientistId,
    required this.viewedAt,
    required this.grade,
  });

  Map<String, dynamic> toJson() => {
        'scientistId': scientistId,
        'viewedAt': viewedAt.toIso8601String(),
        'grade': grade,
      };

  factory ViewedStory.fromJson(Map<String, dynamic> json) => ViewedStory(
        scientistId: json['scientistId'] as String? ?? '',
        viewedAt:
            DateTime.tryParse(json['viewedAt'] as String? ?? '') ?? DateTime.now(),
        grade: json['grade'] as int? ?? 3,
      );
}

/// 科学者ストーリー管理の状態
class ScientistStoryState {
  final List<ViewedStory> viewedStories;
  final int totalStoriesViewed;

  const ScientistStoryState({
    this.viewedStories = const [],
    this.totalStoriesViewed = 0,
  });

  bool hasViewed(String scientistId) =>
      viewedStories.any((s) => s.scientistId == scientistId);

  int getViewedCountByGrade(int grade) =>
      viewedStories.where((s) => s.grade == grade).length;
}

/// 科学者ストーリー管理プロバイダー
class ScientistStoryNotifier extends StateNotifier<ScientistStoryState> {
  ScientistStoryNotifier() : super(const ScientistStoryState()) {
    _load();
  }

  /// SharedPreferences から読み込み
  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString('scientist_stories_viewed');
      if (jsonStr == null) return;

      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      final storiesJson = json['viewedStories'] as List? ?? [];

      final stories = storiesJson
          .map((s) {
            try {
              return ViewedStory.fromJson(s as Map<String, dynamic>);
            } catch (e) {
              return null;
            }
          })
          .whereType<ViewedStory>()
          .toList();

      state = ScientistStoryState(
        viewedStories: stories,
        totalStoriesViewed: stories.length,
      );
    } catch (e) {
      // エラー時は空の状態で初期化
      state = const ScientistStoryState();
    }
  }

  /// ストーリーを視聴済みにマーク
  Future<void> markStoryAsViewed(String scientistId, int grade) async {
    final now = DateTime.now();
    final newStory = ViewedStory(
      scientistId: scientistId,
      viewedAt: now,
      grade: grade,
    );

    // 既に閲覧済みなら上書き
    final updated = state.viewedStories
        .where((s) => s.scientistId != scientistId)
        .toList();
    updated.add(newStory);

    state = ScientistStoryState(
      viewedStories: updated,
      totalStoriesViewed: updated.length,
    );

    await _save();
  }

  /// 状態を保存
  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = {
        'viewedStories':
            state.viewedStories.map((s) => s.toJson()).toList(),
      };
      await prefs.setString('scientist_stories_viewed', jsonEncode(json));
    } catch (e) {
      // ログのみ
    }
  }

  /// 全ストーリー閲覧履歴をリセット（テスト用）
  Future<void> reset() async {
    state = const ScientistStoryState();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('scientist_stories_viewed');
  }
}

/// Riverpod プロバイダー
final scientistStoryProvider =
    StateNotifierProvider<ScientistStoryNotifier, ScientistStoryState>(
  (ref) => ScientistStoryNotifier(),
);

/// 特定の科学者ストーリーを取得
final getScientistStoryProvider =
    Provider.family<ScientistStory?, String>((ref, scientistId) {
  return getScientistStory(scientistId);
});

/// 学年別ストーリーを取得
final getStoriesByGradeProvider = Provider.family<List<ScientistStory>, int>(
  (ref, grade) => getStoriesByGrade(grade),
);

/// ランダムなストーリーを取得
final getRandomStoryProvider = Provider.family<ScientistStory?, int>(
  (ref, grade) => getRandomStoryForGrade(grade),
);
