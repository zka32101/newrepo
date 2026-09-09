import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_core/shared_core.dart' show FeedbackReport;

import 'firebase_service.dart';

/// shared_core の FeedbackNotifier に注入する送信ハンドラ。
///
/// バグ報告・改善要望を Firestore の `feedback` コレクションに書き込む。
/// `users/{uid}/data/progress` に進捗を保存する [FirestoreProgressService] と
/// 同じ構成に倣うが、フィードバックは運営側で横断的に確認できるよう
/// トップレベルの `feedback` コレクションにフラットに保存する。
class FirestoreFeedbackService {
  static final _db = FirebaseFirestore.instance;

  /// [FeedbackNotifier.setSubmitHandler] に渡す送信処理本体。
  ///
  /// Firebase が未初期化の場合は例外を投げ、呼び出し元（shared_core側）が
  /// ローカルの再送信キューに積むようにする。
  static Future<void> submit(FeedbackReport report) async {
    if (!FirebaseService.isAvailable) {
      throw StateError('Firebase未初期化のため送信できません');
    }
    try {
      await _db.collection('feedback').doc(report.id).set(report.toJson());
      debugPrint('[Firestore] フィードバック送信完了: ${report.id}');
    } catch (e) {
      debugPrint('[Firestore] フィードバック送信失敗: $e');
      rethrow;
    }
  }
}
