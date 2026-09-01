import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shokollen_science/models/privacy_settings_model.dart';

// ============== Providers ==============

/// ユーザーのプライバシー設定（Firestore から読み込み）
final userPrivacySettingsProvider = StreamProvider<UserPrivacySettings?>((ref) {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) return Stream.value(null);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('settings')
      .doc('privacy')
      .snapshots()
      .map((snapshot) {
    if (!snapshot.exists) {
      // デフォルト設定
      return UserPrivacySettings.defaultSettings(userId);
    }
    return UserPrivacySettings.fromJson({
      ...snapshot.data()!,
      'userId': userId,
    });
  });
});

/// ランキング名前公表フラグのみ取得（高速アクセス用）
final showNameInRankingProvider = FutureProvider<bool>((ref) async {
  final settings = await ref.watch(userPrivacySettingsProvider.future);
  return settings?.showNameInRanking ?? false;
});

/// 親向けダッシュボード公表フラグのみ取得
final showProgressToParentsProvider = FutureProvider<bool>((ref) async {
  final settings = await ref.watch(userPrivacySettingsProvider.future);
  return settings?.showProgressToParents ?? false;
});

// ============== StateNotifiers ==============

/// プライバシー設定を管理する StateNotifier
class PrivacySettingsNotifier extends StateNotifier<AsyncValue<void>> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  PrivacySettingsNotifier() : super(const AsyncValue.data(null));

  /// ランキング名前公表設定を更新
  Future<void> setShowNameInRanking(bool value) async {
    state = const AsyncValue.loading();
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('settings')
          .doc('privacy')
          .update({
        'showNameInRanking': value,
        'updatedAt': Timestamp.now(),
      }).onError((error, stackTrace) async {
        // ドキュメントが存在しない場合は作成
        if (error is FirebaseException && error.code == 'not-found') {
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('settings')
              .doc('privacy')
              .set({
            'userId': userId,
            'showNameInRanking': value,
            'showProgressToParents': false,
            'allowNotifications': true,
            'allowMarketingNotifications': false,
            'allowAnalytics': false,
            'updatedAt': Timestamp.now(),
          });
        } else {
          throw error;
        }
      });

      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  /// 親向けダッシュボード公表設定を更新
  Future<void> setShowProgressToParents(bool value) async {
    state = const AsyncValue.loading();
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('settings')
          .doc('privacy')
          .update({
        'showProgressToParents': value,
        'updatedAt': Timestamp.now(),
      }).onError((error, stackTrace) async {
        if (error is FirebaseException && error.code == 'not-found') {
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('settings')
              .doc('privacy')
              .set({
            'userId': userId,
            'showNameInRanking': false,
            'showProgressToParents': value,
            'allowNotifications': true,
            'allowMarketingNotifications': false,
            'allowAnalytics': false,
            'updatedAt': Timestamp.now(),
          });
        } else {
          throw error;
        }
      });

      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  /// 通知許可設定を更新
  Future<void> setAllowNotifications(bool value) async {
    state = const AsyncValue.loading();
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('settings')
          .doc('privacy')
          .update({
        'allowNotifications': value,
        'updatedAt': Timestamp.now(),
      }).onError((error, stackTrace) async {
        if (error is FirebaseException && error.code == 'not-found') {
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('settings')
              .doc('privacy')
              .set({
            'userId': userId,
            'showNameInRanking': false,
            'showProgressToParents': false,
            'allowNotifications': value,
            'allowMarketingNotifications': false,
            'allowAnalytics': false,
            'updatedAt': Timestamp.now(),
          });
        } else {
          throw error;
        }
      });

      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  /// マーケティング通知許可設定を更新
  Future<void> setAllowMarketingNotifications(bool value) async {
    state = const AsyncValue.loading();
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('settings')
          .doc('privacy')
          .update({
        'allowMarketingNotifications': value,
        'updatedAt': Timestamp.now(),
      }).onError((error, stackTrace) async {
        if (error is FirebaseException && error.code == 'not-found') {
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('settings')
              .doc('privacy')
              .set({
            'userId': userId,
            'showNameInRanking': false,
            'showProgressToParents': false,
            'allowNotifications': true,
            'allowMarketingNotifications': value,
            'allowAnalytics': false,
            'updatedAt': Timestamp.now(),
          });
        } else {
          throw error;
        }
      });

      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  /// データ分析許可設定を更新
  Future<void> setAllowAnalytics(bool value) async {
    state = const AsyncValue.loading();
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('settings')
          .doc('privacy')
          .update({
        'allowAnalytics': value,
        'updatedAt': Timestamp.now(),
      }).onError((error, stackTrace) async {
        if (error is FirebaseException && error.code == 'not-found') {
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('settings')
              .doc('privacy')
              .set({
            'userId': userId,
            'showNameInRanking': false,
            'showProgressToParents': false,
            'allowNotifications': true,
            'allowMarketingNotifications': false,
            'allowAnalytics': value,
            'updatedAt': Timestamp.now(),
          });
        } else {
          throw error;
        }
      });

      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }
}

/// プライバシー設定操作用プロバイダ
final privacySettingsNotifierProvider =
    StateNotifierProvider<PrivacySettingsNotifier, AsyncValue<void>>((ref) {
  return PrivacySettingsNotifier();
});
