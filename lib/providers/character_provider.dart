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
final characterProvider = NotifierProvider<CharacterNotifier, CharacterProfileMap>(
  CharacterNotifier.new,
);
