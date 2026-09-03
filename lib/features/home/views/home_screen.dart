import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../data/seeds/stages.dart';
import '../../../data/seeds/creatures.dart';
import '../../progress/providers/user_progress_provider.dart';
import '../../progress/views/progress_screen.dart';
import '../../encyclopedia/views/encyclopedia_screen.dart';
import '../../learn/views/learn_tab_screen.dart';
import '../../shop/views/shop_screen.dart';
import '../../trial/providers/trial_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../../daily/providers/daily_challenge_provider.dart';
import '../../settings/providers/theme_provider.dart';
import '../../../shared/widgets/doctor_character_widget.dart';
import '../../../shared/widgets/mission_card_widget.dart';
import '../widgets/seasonal_recommendation_widget.dart';
import '../../daily/widgets/daily_login_bonus_widget.dart';
import '../../parent/widgets/praise_received_widget.dart';
import '../../weekly_challenge/widgets/weekly_challenge_widget.dart';
import '../../../shared/widgets/furigana_text.dart';
import '../../progress/providers/daily_mystery_provider.dart';
import '../widgets/home_section_action.dart';
import '../widgets/home_section_recommend.dart';
import '../widgets/home_section_records.dart';
import '../widgets/home_section_learning.dart';
import '../widgets/home_section_discover.dart';
import '../../experiments/views/experiment_tab_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  int _selectedGrade = 3; // ステージリストの選択学年

  // 今日のステージ（本来は Firestore の学習進度から取得）
  final _todayStage = stagesData[0]; // stage_3_001 昆虫と植物
  final int _totalCreatures = 16;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildHomeTab(),
            const LearnTabScreen(),
            const EncyclopediaScreen(),
            const ShopScreen(),
            const ExperimentTabScreen(),
            const ProgressScreen(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ── ホームタブ ────────────────────────────────────────
  Widget _buildHomeTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAppBar(),

          // セクションの widget 化
          const HomeSectionAction(),      // 📅 今日のアクション
          const HomeSectionRecommend(),   // 🔬 おすすめ・キャラクター
          const HomeSectionRecords(),     // 🏆 がんばりの記録

          const HomeSectionLearning(),    // 📚 学習をすすめる
          const HomeSectionDiscover(),    // ✨ もっと理科をたのしむ
        ],
      ),
    );
  }


  // ── アプリバー ────────────────────────────────────────
  Widget _buildAppBar() {
    final progressAsync = ref.watch(userProgressProvider);
    final trialAsync = ref.watch(trialProvider);
    final profileAsync = ref.watch(profileProvider);
    final activeProfile = profileAsync.value?.activeProfile;
    final coins = progressAsync.value?.coins ?? 0;
    final isPremium = trialAsync.value?.isPremium ?? false;
    final trialRemaining = trialAsync.value?.trialDaysRemaining ?? 14;

    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
      Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
        gradient: AppColors.scienceGradient,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '小学コレ！',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    '理科',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // プロフィール切り替えボタン
              GestureDetector(
                onTap: () => context.push('/profile-select'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(activeProfile?.avatarEmoji ?? '🐻',
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 4),
                      Text(
                        activeProfile?.nickname ?? 'たろう',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // コイン残高
              GestureDetector(
                onTap: () => setState(() => _selectedIndex = 3),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Text('🪙',
                          style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 4),
                      Text(
                        '$coins',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // プレミアム / トライアル状態
              GestureDetector(
                onTap: () => setState(() => _selectedIndex = 3),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isPremium
                        ? Colors.amber.withOpacity(0.8)
                        : Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isPremium
                        ? '👑 プレミアム'
                        : '⏳ あと${trialRemaining}日',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              // ダークモード切り替え
              IconButton(
                onPressed: () => ref.read(themeProvider.notifier).toggle(),
                icon: Icon(
                  ref.watch(themeProvider) == ThemeMode.dark
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                tooltip: ref.watch(themeProvider) == ThemeMode.dark
                    ? 'ライトモードに切り替え'
                    : 'ダークモードに切り替え',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  shape: const CircleBorder(),
                  minimumSize: const Size(44, 44),
                ),
              ),
              const SizedBox(width: 6),
              // 保護者ダッシュボード
              IconButton(
                onPressed: () => context.push('/parent-dashboard'),
                icon: const Icon(Icons.shield_outlined, color: Colors.white, size: 18),
                tooltip: '保護者ダッシュボード',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  shape: const CircleBorder(),
                  minimumSize: const Size(44, 44),
                ),
              ),
            ],
          ),
          // トライアル期限切れバナー
          if (!isPremium && trialRemaining <= 0) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => setState(() => _selectedIndex = 3),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    vertical: 7, horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('⚠️ ', style: TextStyle(fontSize: 14)),
                    Text(
                      'トライアル終了！プレミアムにアップグレードしよう',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    ),
    const Positioned(
      right: 8,
      top: 4,
      child: IgnorePointer(
        child: Opacity(
          opacity: 0.10,
          child: Text('⚛️', style: TextStyle(fontSize: 56)),
        ),
      ),
    ),
    const Positioned(
      right: 76,
      bottom: 6,
      child: IgnorePointer(
        child: Opacity(
          opacity: 0.07,
          child: Text('🔭', style: TextStyle(fontSize: 30)),
        ),
      ),
    ),
    ],);
  }

  // ── ボトムナビ ────────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            blurRadius: 16,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.sciencePrimary,
        unselectedItemColor: Colors.grey[400],
        selectedFontSize: 10,
        unselectedFontSize: 10,
        backgroundColor: Colors.transparent,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book_rounded),
            label: 'まなぶ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.nature_outlined),
            activeIcon: Icon(Icons.nature_rounded),
            label: '図鑑',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront_outlined),
            activeIcon: Icon(Icons.storefront_rounded),
            label: 'ショップ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.science_outlined),
            activeIcon: Icon(Icons.science_rounded),
            label: 'じっけん',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_outlined),
            activeIcon: Icon(Icons.emoji_events_rounded),
            label: '記録',
          ),
        ],
      ),
    );
  }
}
