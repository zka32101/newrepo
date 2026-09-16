import 'package:shared_core/shared_core.dart';

/// 理科コレ！のマルチプレイ対戦（レートマッチング）用 Firestore サービス。
///
/// shared_core の [FirestoreMatchmakingService] をそのまま使うが、コレクション名は
/// 他アプリ（kokugo-kore / sansu-kore / social_quiz_app 等）と衝突しないよう
/// `rika_` プレフィックスを付ける。
class MultiplayerService {
  static final FirestoreMatchmakingService instance =
      FirestoreMatchmakingService(
    matchmakingQueueCollection: 'rika_matchmaking_queue',
    matchesCollection: 'rika_matches',
    playerRatingsCollection: 'rika_player_ratings',
  );
}
