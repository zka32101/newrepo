import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/creature_identification_service.dart';

/// 生き物コレクション状態
class CreatureCollectionState {
  final List<CreatureCollectionItem> discoveredCreatures;
  final int totalPoints;

  const CreatureCollectionState({
    this.discoveredCreatures = const [],
    this.totalPoints = 0,
  });

  bool hasDiscovered(String creatureName) =>
      discoveredCreatures.any((c) => c.name == creatureName);

  int getDiscoveredCount() => discoveredCreatures.length;
}

/// 生き物コレクション管理
class CreatureCollectionNotifier
    extends StateNotifier<CreatureCollectionState> {
  CreatureCollectionNotifier() : super(const CreatureCollectionState()) {
    _load();
  }

  /// SharedPreferences から読み込み
  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString('creature_collection');
      if (jsonStr == null) return;

      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      final creaturesJson = json['creatures'] as List? ?? [];
      final totalPoints = json['totalPoints'] as int? ?? 0;

      final creatures = creaturesJson
          .map((c) {
            try {
              final data = c as Map<String, dynamic>;
              return CreatureCollectionItem(
                id: data['id'] as String? ?? '',
                name: data['name'] as String? ?? '',
                emoji: data['emoji'] as String? ?? '🐛',
                discoveredAt:
                    DateTime.tryParse(data['discoveredAt'] as String? ?? '') ??
                        DateTime.now(),
                photoPath: data['photoPath'] as String?,
                points: data['points'] as int? ?? 50,
              );
            } catch (e) {
              return null;
            }
          })
          .whereType<CreatureCollectionItem>()
          .toList();

      state = CreatureCollectionState(
        discoveredCreatures: creatures,
        totalPoints: totalPoints,
      );
    } catch (e) {
      // エラー時は空のコレクションで初期化
      state = const CreatureCollectionState();
    }
  }

  /// 生き物を追加
  Future<void> addCreature({
    required String id,
    required String name,
    required String emoji,
    required int points,
    String? photoPath,
  }) async {
    final now = DateTime.now();
    final newCreature = CreatureCollectionItem(
      id: id,
      name: name,
      emoji: emoji,
      discoveredAt: now,
      photoPath: photoPath,
      points: points,
    );

    final updated = [
      ...state.discoveredCreatures,
      newCreature,
    ];
    final newTotalPoints = state.totalPoints + points;

    state = CreatureCollectionState(
      discoveredCreatures: updated,
      totalPoints: newTotalPoints,
    );

    await _save();
  }

  /// コレクションを保存
  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = {
        'creatures': state.discoveredCreatures
            .map((c) => {
                  'id': c.id,
                  'name': c.name,
                  'emoji': c.emoji,
                  'discoveredAt': c.discoveredAt.toIso8601String(),
                  'photoPath': c.photoPath,
                  'points': c.points,
                })
            .toList(),
        'totalPoints': state.totalPoints,
      };
      await prefs.setString('creature_collection', jsonEncode(json));
    } catch (e) {
      // ログのみ
    }
  }

  /// コレクションをリセット（テスト用）
  Future<void> reset() async {
    state = const CreatureCollectionState();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('creature_collection');
  }
}

/// Riverpod Provider
final creatureCollectionProvider = StateNotifierProvider<
    CreatureCollectionNotifier,
    CreatureCollectionState>((ref) => CreatureCollectionNotifier());

/// 識別中の状態管理
final creatureIdentificationProvider =
    StateNotifierProvider<_CreatureIdentificationNotifier, AsyncValue<void>>(
  (ref) => _CreatureIdentificationNotifier(),
);

class _CreatureIdentificationNotifier extends StateNotifier<AsyncValue<void>> {
  _CreatureIdentificationNotifier() : super(const AsyncValue.data(null));

  /// 画像から生き物を特定
  Future<CreatureIdentificationResult> identifyFromImage({
    required Uint8List imageBytes,
    required String apiKey,
  }) async {
    state = const AsyncValue.loading();
    try {
      final service = CreatureIdentificationService(apiKey: apiKey);
      final result = await service.identifyCreature(imageBytes: imageBytes);
      state = const AsyncValue.data(null);
      return result;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }
}
