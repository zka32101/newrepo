import 'package:shared_core/shared_core.dart';

/// 理科コレ固有の装着中ショップアイテム（テーマ/フレーム等）ノティファイア。
/// main.dart で equippedItemsProvider をこれで上書きする:
/// ```dart
/// equippedItemsProvider.overrideWith(EquippedItemsNotifier.new)
/// ```
class EquippedItemsNotifier extends BaseEquippedItemsNotifier {
  @override
  String get storageKey => 'rika_equipped_items';
}
