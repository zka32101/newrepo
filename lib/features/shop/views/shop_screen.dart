import 'package:flutter/material.dart';
import 'package:shared_core/shared_core.dart';
import '../../../data/rika_characters.dart';

// ── 理科コレ 交換所アイテム ──────────────────────────────────────────────────
// 未実装機能のため、交換所アイテムは無効化
const _rikaExchangeItems = <AppShopItem>[];

// ── 理科コレ 期間限定アイテム ──────────────────────────────────────────────
// 未実装機能のため、期間限定アイテムは無効化
const _rikaSeasonalItems = <String, List<AppShopItem>>{};

/// 理科コレ コインショップ。
/// 表示ロジックはすべて [CoinShopPage] に委譲する。
class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CoinShopPage(
      characters: kRikaCharacters,
      exchangeItems: _rikaExchangeItems,
      seasonalItems: _rikaSeasonalItems,
    );
  }
}
