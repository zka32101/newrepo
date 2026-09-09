import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;
import '../models/friend_model.dart';

/// 友達管理サービス
///
/// 招待コード（= 自分のユーザーID）をお互いに入力し合うことで、
/// `users/{uid}/friends/{friendUserId}` サブコレクションに相互登録する。
/// 相手を検索できるよう、`users/{uid}` 直下に最小限の公開プロフィール
/// （userName / avatarUrl）を保持する。
class FriendService {
  static final FriendService _instance = FriendService._internal();
  static FriendService get instance => _instance;

  factory FriendService() {
    return _instance;
  }

  FriendService._internal();

  late FirebaseFirestore _firestore;
  late FirebaseAuth _auth;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    _firestore = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;
    _isInitialized = true;
    developer.log('FriendService initialized');
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  CollectionReference<Map<String, dynamic>> _friendsCollection(String uid) {
    return _firestore.collection('users').doc(uid).collection('friends');
  }

  /// 自分の招待コード（= 自分のユーザーID）
  String? get myInviteCode => _auth.currentUser?.uid;

  /// 自分の友達一覧を購読
  Stream<List<Friend>> watchFriends() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value(const []);

    return _friendsCollection(uid)
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Friend.fromJson({
                  ...doc.data(),
                  'userId': doc.id,
                }))
            .toList());
  }

  /// 自分の公開プロフィール（userName / avatarUrl）を最新化
  ///
  /// 招待コードで検索してもらうために、他ユーザーが読み取れる
  /// `users/{uid}` に最小限の情報を書き込む。
  Future<void> syncOwnProfile() async {
    await _ensureInitialized();
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).set({
      'userName': user.displayName ?? '匿名ユーザー',
      'avatarUrl': user.photoURL,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// 招待コード（相手のユーザーID）から友達を相互登録する
  Future<Friend> addFriendByCode(String inviteCode) async {
    await _ensureInitialized();

    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    final code = inviteCode.trim();
    if (code.isEmpty) {
      throw Exception('招待コードを入力してください');
    }
    if (code == currentUser.uid) {
      throw Exception('自分自身は友達に追加できません');
    }

    // 自分のプロフィールを最新化しておく（相手側から検索されるため）
    await syncOwnProfile();

    final targetDoc = await _firestore.collection('users').doc(code).get();
    if (!targetDoc.exists) {
      throw Exception('ユーザーが見つかりません。招待コードを確認してください');
    }
    final targetData = targetDoc.data() ?? <String, dynamic>{};
    final targetName = targetData['userName'] as String? ?? '匿名ユーザー';
    final targetAvatar = targetData['avatarUrl'] as String?;

    final myDoc =
        await _firestore.collection('users').doc(currentUser.uid).get();
    final myData = myDoc.data() ?? <String, dynamic>{};
    final myName = myData['userName'] as String? ??
        currentUser.displayName ??
        '匿名ユーザー';
    final myAvatar = myData['avatarUrl'] as String? ?? currentUser.photoURL;

    final now = FieldValue.serverTimestamp();
    final batch = _firestore.batch();

    // 自分の友達リストに相手を追加
    batch.set(
      _friendsCollection(currentUser.uid).doc(code),
      {
        'userName': targetName,
        'avatarUrl': targetAvatar,
        'addedAt': now,
      },
      SetOptions(merge: true),
    );

    // 相手の友達リストにも自分を追加（相互登録）
    batch.set(
      _friendsCollection(code).doc(currentUser.uid),
      {
        'userName': myName,
        'avatarUrl': myAvatar,
        'addedAt': now,
      },
      SetOptions(merge: true),
    );

    await batch.commit();

    return Friend(
      userId: code,
      userName: targetName,
      avatarUrl: targetAvatar,
      addedAt: DateTime.now(),
    );
  }

  /// 友達を削除（双方から解除）
  Future<void> removeFriend(String friendUserId) async {
    await _ensureInitialized();
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    final batch = _firestore.batch();
    batch.delete(_friendsCollection(currentUser.uid).doc(friendUserId));
    batch.delete(_friendsCollection(friendUserId).doc(currentUser.uid));
    await batch.commit();
  }
}
