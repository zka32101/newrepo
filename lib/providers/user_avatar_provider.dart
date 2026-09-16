import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shokollen_science/data/avatars_data.dart';
import 'package:shokollen_science/models/avatar_model.dart';

// ============== Providers ==============

/// 現在のユーザー ID プロバイダ
final currentUserIdProvider = Provider<String?>((ref) {
  return FirebaseAuth.instance.currentUser?.uid;
});

/// ユーザーのアバター選択情報（Firestore から読み込み）
final userAvatarProfileProvider = StreamProvider<UserAvatarProfile?>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value(null);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('profile')
      .doc('avatar')
      .snapshots()
      .map((snapshot) {
    if (!snapshot.exists) {
      // デフォルト値
      return UserAvatarProfile(
        userId: userId,
        selectedAvatarId: 1,
        ownedAvatarIds: const [1, 2, 3, 4],
        updatedAt: DateTime.now(),
      );
    }
    return UserAvatarProfile.fromJson({
      ...snapshot.data()!,
      'userId': userId,
    });
  });
});

/// 現在選択中のアバター ID プロバイダ
final selectedAvatarIdProvider = FutureProvider<int>((ref) async {
  final profile = await ref.watch(userAvatarProfileProvider.future);
  return profile?.selectedAvatarId ?? 1;
});

/// 現在選択中のアバターアイコン情報
final selectedAvatarProvider = FutureProvider<AvatarIcon?>((ref) async {
  final selectedId = await ref.watch(selectedAvatarIdProvider.future);
  return getAvatarById(selectedId);
});

/// ユーザーが所有しているアバターのリスト
final ownedAvatarsProvider = FutureProvider<List<AvatarIcon>>((ref) async {
  final profile = await ref.watch(userAvatarProfileProvider.future);
  if (profile == null) return getDefaultAvatars();

  return allAvatars
      .where((avatar) => profile.ownedAvatarIds.contains(avatar.id))
      .toList();
});

/// ユーザーが未購入のアバターリスト
final availableAvatarsForPurchaseProvider =
    FutureProvider<List<AvatarIcon>>((ref) async {
  final profile = await ref.watch(userAvatarProfileProvider.future);
  if (profile == null) return getShopAvatars();

  return allAvatars
      .where((avatar) =>
          !avatar.isDefault && !profile.ownedAvatarIds.contains(avatar.id))
      .toList();
});

// ============== StateNotifiers ==============

/// アバター選択状態を管理する StateNotifier
class UserAvatarNotifier extends StateNotifier<AsyncValue<void>> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserAvatarNotifier() : super(const AsyncValue.data(null));

  /// アバターを選択
  Future<void> selectAvatar(int avatarId) async {
    state = const AsyncValue.loading();
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final profile = await _firestore
          .collection('users')
          .doc(userId)
          .collection('profile')
          .doc('avatar')
          .get();

      final currentData = profile.data() ?? {};
      final ownedIds = List<int>.from(currentData['ownedAvatarIds'] ?? [1, 2, 3, 4]);

      // アバターが所有していない場合はエラー
      if (!ownedIds.contains(avatarId)) {
        throw Exception('Avatar not owned');
      }

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('profile')
          .doc('avatar')
          .set({
        'selectedAvatarId': avatarId,
        'ownedAvatarIds': ownedIds,
        'updatedAt': Timestamp.now(),
      });

      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  /// アバターを購入
  Future<void> purchaseAvatar(int avatarId, int cost) async {
    state = const AsyncValue.loading();
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final avatar = getAvatarById(avatarId);
      if (avatar == null || avatar.isDefault) {
        throw Exception('Invalid avatar');
      }

      // Firestore トランザクション: コイン減少 + アバター追加
      await _firestore.runTransaction((transaction) async {
        // ユーザーの coins を取得
        final userDoc =
            await transaction.get(_firestore.collection('users').doc(userId));
        final currentCoins = (userDoc.data()?['coins'] as num?)?.toInt() ?? 0;

        if (currentCoins < cost) {
          throw Exception('Insufficient coins');
        }

        // プロフィール取得
        final profileDoc = await transaction.get(
          _firestore
              .collection('users')
              .doc(userId)
              .collection('profile')
              .doc('avatar'),
        );

        final profileData = profileDoc.data() ?? {};
        final ownedIds = List<int>.from(profileData['ownedAvatarIds'] ?? [1, 2, 3, 4]);

        if (ownedIds.contains(avatarId)) {
          throw Exception('Avatar already owned');
        }

        ownedIds.add(avatarId);

        // coins を減少
        transaction.update(_firestore.collection('users').doc(userId), {
          'coins': currentCoins - cost,
        });

        // アバターリストを更新
        transaction.set(
          _firestore
              .collection('users')
              .doc(userId)
              .collection('profile')
              .doc('avatar'),
          {
            'selectedAvatarId': profileData['selectedAvatarId'] ?? 1,
            'ownedAvatarIds': ownedIds,
            'updatedAt': Timestamp.now(),
          },
        );
      });

      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }
}

/// ユーザーアバター操作用プロバイダ
final userAvatarNotifierProvider =
    StateNotifierProvider<UserAvatarNotifier, AsyncValue<void>>((ref) {
  return UserAvatarNotifier();
});
