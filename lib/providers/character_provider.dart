import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart';

import '../data/rika_characters.dart';

// ─── Phase 4.1: CharacterProfile統合版 ────────────────────────────────────

/// 理科コレ！キャラクター管理（Phase 4.1: CharacterProfile対応）
class CharacterNotifier extends BaseCharacterProfileNotifier {
  @override
  List<BaseCharacter> get characterList => kRikaCharacters;

  @override
  String get storageKey => 'rika_character_profiles';

  @override
  Subject get appSubject => Subject.rika;
}

/// 統一キャラクタープロバイダー（Phase 4.1）
final characterProvider =
    NotifierProvider<CharacterNotifier, CharacterProfileMap>(
      CharacterNotifier.new,
    );

// ─── shared_core 旧キャラクターシステム（characterStateProvider）対応 ──────

/// shared_core の CoinShopPage / CharacterCollectionPage が内部で直接参照する
/// 旧キャラクターシステム（[characterStateProvider]、CharacterState ベース）
/// 用の実装。Phase 4.1 の [CharacterProfile] ベース（[characterProvider]）とは
/// 別物のため、両方を main.dart でオーバーライドする必要がある。
class LegacyCharacterNotifier extends BaseCharacterNotifier {
  @override
  List<BaseCharacter> get characterList => kRikaCharacters;

  @override
  String get storageKey => 'rika_character_states';
}
