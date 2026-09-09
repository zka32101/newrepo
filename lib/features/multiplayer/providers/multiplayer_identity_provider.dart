import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/firebase_service.dart';
import '../../profile/providers/profile_provider.dart';

/// マルチプレイ対戦で使う「自分」の情報（ユーザーID・表示名・アバター・学年）。
class MultiplayerIdentity {
  final String userId;
  final String displayName;
  final String avatarEmoji;
  final int gradeLevel;

  const MultiplayerIdentity({
    required this.userId,
    required this.displayName,
    required this.avatarEmoji,
    required this.gradeLevel,
  });
}

/// オンライン対戦にはFirebase匿名認証によるユーザーIDとプロフィールが必要。
/// どちらか欠けている場合は null（呼び出し側は「対戦できません」表示にする）。
final multiplayerIdentityProvider = Provider<MultiplayerIdentity?>((ref) {
  final userId = FirebaseService.userId;
  if (!FirebaseService.isAvailable || userId == null) return null;

  final profileState = ref.watch(profileProvider).value;
  final activeProfile = profileState?.activeProfile;
  if (activeProfile == null) return null;

  return MultiplayerIdentity(
    userId: userId,
    displayName: activeProfile.nickname,
    avatarEmoji: activeProfile.avatarEmoji,
    gradeLevel: activeProfile.gradeLevel,
  );
});
