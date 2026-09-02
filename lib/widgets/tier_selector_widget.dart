import 'package:flutter/material.dart';
import '../models/ranking_model.dart';

/// ランキングティア選択ウィジェット
/// 4つのティア（全体、学年別、開始月別、複合）を選択可能にする
class TierSelectorWidget extends StatelessWidget {
  /// 現在選択中のティア
  final RankingTier selectedTier;

  /// ティア選択時のコールバック
  final Function(RankingTier) onTierChanged;

  /// 選択肢に表示するティアのリスト（デフォルト：全て）
  final List<RankingTier>? availableTiers;

  const TierSelectorWidget({
    Key? key,
    required this.selectedTier,
    required this.onTierChanged,
    this.availableTiers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tiers = availableTiers ?? RankingTier.values;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: tiers.map((tier) {
          final isSelected = tier == selectedTier;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Text(tier.displayLabel),
              selected: isSelected,
              onSelected: (_) => onTierChanged(tier),
              backgroundColor:
                  isSelected ? Theme.of(context).primaryColor : null,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : null,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[400]!,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
