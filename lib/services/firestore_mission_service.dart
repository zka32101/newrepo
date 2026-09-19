import 'package:flutter/material.dart';
import 'package:shared_core/models/mission_model.dart';

/// Phase 4.5: ゲーミフィケーション統一工事（ミッション機能）
/// 簡略実装: shared_core の ALL_MISSIONS リストから取得・フィルタリング
class FirestoreMissionService {
  static const String appId = 'rika'; // アプリID

  /// ミッション取得（簡略実装）
  /// shared_core の ALL_MISSIONS リストから対応するミッションを取得
  ///
  /// [userId] は shared_core の `FetchMissionsHandler` インターフェースに
  /// 合わせるために受け取るが、この簡略実装では使用しない。
  Future<List<Mission>> fetchMissions(String userId, String subject) async {
    try {
      var missions = List<Mission>.from(ALL_MISSIONS);

      // 教科でフィルタリング
      if (subject.isNotEmpty) {
        missions = missions.where((mission) {
          if (mission.subject == null) return true;
          return mission.subject == subject;
        }).toList();
      }

      // 無効なミッションを除外
      missions = missions.where((m) => m.enabled).toList();

      debugPrint('Fetched ${missions.length} missions for subject: $subject');
      return missions;
    } catch (e) {
      debugPrint('Error fetching missions: $e');
      rethrow;
    }
  }
}
