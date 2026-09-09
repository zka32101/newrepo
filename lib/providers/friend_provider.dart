import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/friend_service.dart';
import '../models/friend_model.dart';

/// 友達サービスプロバイダー
final friendServiceProvider = Provider<FriendService>((ref) {
  return FriendService.instance;
});

/// 自分の友達一覧プロバイダー
final friendsListProvider = StreamProvider<List<Friend>>((ref) {
  final service = ref.watch(friendServiceProvider);
  return service.watchFriends();
});

/// 友達のユーザーIDのみ抽出したプロバイダー（ランキング取得用）
final friendUserIdsProvider = FutureProvider<List<String>>((ref) async {
  final friends = await ref.watch(friendsListProvider.future);
  return friends.map((f) => f.userId).toList();
});

/// 自分の招待コード（= 自分のユーザーID）
final myInviteCodeProvider = Provider<String?>((ref) {
  final service = ref.watch(friendServiceProvider);
  return service.myInviteCode;
});

/// 友達追加・削除操作用の StateNotifier
class FriendActionNotifier extends StateNotifier<AsyncValue<void>> {
  final FriendService _service;

  FriendActionNotifier(this._service) : super(const AsyncValue.data(null));

  Future<Friend> addFriend(String inviteCode) async {
    state = const AsyncValue.loading();
    try {
      final friend = await _service.addFriendByCode(inviteCode);
      state = const AsyncValue.data(null);
      return friend;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> removeFriend(String friendUserId) async {
    state = const AsyncValue.loading();
    try {
      await _service.removeFriend(friendUserId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final friendActionProvider =
    StateNotifierProvider<FriendActionNotifier, AsyncValue<void>>((ref) {
  final service = ref.watch(friendServiceProvider);
  return FriendActionNotifier(service);
});
