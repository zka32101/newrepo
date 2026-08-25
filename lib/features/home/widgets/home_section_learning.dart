import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../data/seeds/stages.dart';
import '../../../data/seeds/creatures.dart';
import '../../progress/providers/user_progress_provider.dart';
import '../../../shared/widgets/furigana_text.dart';
import 'home_section_divider.dart';

/// ホーム画面セクション4: 📚 学習をすすめる
/// 複雑な依存性を持つため ConsumerStatefulWidget で実装
class HomeSectionLearning extends ConsumerStatefulWidget {
  const HomeSectionLearning({super.key});

  @override
  ConsumerState<HomeSectionLearning> createState() => _HomeSectionLearningState();
}

class _HomeSectionLearningState extends ConsumerState<HomeSectionLearning> {
  int _selectedGrade = 3; // ステージリスト選択学年
  final _todayStage = stagesData[0]; // stage_3_001 昆虫と植物
  final int _totalCreatures = 16;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionDivider('📚 学習をすすめる'),
        _buildReviewCard(),
        _buildTodayThemeCard(),
        _buildEncyclopediaSection(),
        _buildStageListSection(),
        _buildCollectionAndTestSection(),
      ],
    );
  }

  // ── にがて問題カード ──────────────────────────────────
  Widget _buildReviewCard() {
    final progressAsync = ref.watch(userProgressProvider);
    final wrongCount = progressAsync.value?.wrongAnswers.values
        .fold(0, (sum, list) => sum + list.length) ?? 0;
    if (wrongCount == 0) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => context.push('/review'),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          children: [
            const Text('📝', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'にがて問題 $wrongCount問 — やり直してみよう！',
                style: TextStyle(fontSize: 13, color: Colors.red[700], fontWeight: FontWeight.bold),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.red[400]),
          ],
        ),
      ),
    );
  }

  // ── 今日のテーマカード ────────────────────────────────
  Widget _buildTodayThemeCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF0D47A1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.sciencePrimary.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 12,
            top: 8,
            child: Text(
              '🔬',
              style: TextStyle(
                fontSize: 72,
                color: Colors.white.withOpacity(0.15),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '📅 今日のテーマ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                FuriganaText(
                  _todayStage['stageName'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _todayStage['description'] as String,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _Badge(
                      '${_todayStage['gradeLevel']}年生',
                      const Color(0xFF42A5F5),
                    ),
                    const SizedBox(width: 6),
                    _Badge(
                      _diffLabel(_todayStage['difficultyLevel'] as String),
                      const Color(0xFF26C6DA),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: () => context
                        .go('/quiz/${_todayStage['id']}'),
                    icon: const Icon(Icons.play_arrow_rounded,
                        size: 22),
                    label: const Text(
                      '探索を開始 →',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.sciencePrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── 図鑑セクション ────────────────────────────────────
  Widget _buildEncyclopediaSection() {
    final progressAsync = ref.watch(userProgressProvider);
    final clearedCount = progressAsync.value?.clearedCount ?? 0;
    final completedCreatures = clearedCount.clamp(0, _totalCreatures);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🌿', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              const Text(
                '生き物図鑑',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => setState(() {}),
                child: const Text(
                  'すべて見る →',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.sciencePrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                '$completedCreatures / $_totalCreatures 発見',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textGray,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: completedCreatures / _totalCreatures,
                    backgroundColor: AppColors.borderGray,
                    valueColor: const AlwaysStoppedAnimation(
                        AppColors.success),
                    minHeight: 6,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.85,
            ),
            itemCount: 8,
            itemBuilder: (_, i) {
              final unlocked = i < completedCreatures;
              return _CreatureCell(
                creatureData: creaturesData[i],
                unlocked: unlocked,
              );
            },
          ),
        ],
      ),
    );
  }

  // ── ステージリストセクション ──────────────────────────────────
  Widget _buildStageListSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📚', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              const Text(
                'ステージ一覧',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => context.push('/learn'),
                child: const Text(
                  'すべて →',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.sciencePrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Grade tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [3, 4, 5, 6].map((grade) {
                final isSelected = _selectedGrade == grade;
                return GestureDetector(
                  onTap: () => setState(() => _selectedGrade = grade),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.sciencePrimary
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$grade 年生',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textDark,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          // Stage preview for selected grade
          ...(stagesData.where((s) => s['gradeLevel'] == _selectedGrade)
                  .take(3)
                  as Iterable<Map<String, dynamic>>)
              .map((stage) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GestureDetector(
                      onTap: () => context.push('/quiz/${stage['id']}'),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Colors.grey[300]!,
                              width: 0.5),
                        ),
                        child: Row(
                          children: [
                            Text(stage['icon'] as String,
                                style: const TextStyle(fontSize: 18)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    stage['stageName'] as String,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    stage['description'] as String,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textGray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                                Icons.chevron_right_rounded,
                                size: 20),
                          ],
                        ),
                      ),
                    ),
                  ))
              .toList(),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.push('/learn'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                    color: AppColors.sciencePrimary,
                    width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'ステージ一覧を見る',
                style: TextStyle(
                  color: AppColors.sciencePrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── コレクション＆テストセクション ────────────────────────────────
  Widget _buildCollectionAndTestSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '👨‍🏫 準備中の機能',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ComingSoonCard(
                  emoji: '📖',
                  title: '実験ノート',
                  subtitle: '観察記録を保存',
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ComingSoonCard(
                  emoji: '🏅',
                  title: '成績表',
                  subtitle: 'スキルを確認',
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── ヘルパーメソッド ────────────────────────────────────
  String _diffLabel(String level) {
    return switch (level) {
      'easy' => '🟢 かんたん',
      'normal' => '🟡 ふつう',
      'hard' => '🔴 むずかしい',
      _ => '不明',
    };
  }
}

// ── _Badge ウィジェット ────────────────────────────────────
class _Badge extends StatelessWidget {
  final String text;
  final Color color;

  const _Badge(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}

// ── _CreatureCell ウィジェット ────────────────────────────────────
class _CreatureCell extends StatelessWidget {
  final Map<String, dynamic> creatureData;
  final bool unlocked;

  const _CreatureCell({
    required this.creatureData,
    required this.unlocked,
  });

  static const _categoryEmoji = {
    'insect': '🦋',
    'bird': '🐦',
    'mammal': '🐾',
    'plant': '🌿',
    'other': '🐌',
  };

  @override
  Widget build(BuildContext context) {
    final emoji = _categoryEmoji[creatureData['category']] ?? '🔬';
    return Container(
      decoration: BoxDecoration(
        color: unlocked
            ? AppColors.scienceLight
            : const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: unlocked
              ? AppColors.sciencePrimary.withOpacity(0.3)
              : Colors.transparent,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          unlocked
              ? Text(emoji, style: const TextStyle(fontSize: 24))
              : const Icon(Icons.lock, color: Colors.grey, size: 20),
          const SizedBox(height: 2),
          Text(
            unlocked
                ? (creatureData['name'] as String).substring(0, 3)
                : '？',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: unlocked ? AppColors.textDark : Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── _ComingSoonCard ウィジェット ────────────────────────────────────
class _ComingSoonCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ComingSoonCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textGray,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.amber[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '準備中',
                style: TextStyle(
                  fontSize: 9,
                  color: Color(0xFFF57F17),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
