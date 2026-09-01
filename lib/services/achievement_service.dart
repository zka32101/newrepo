import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;
import '../models/achievement_model.dart';

/// アチーブメント管理サービス
class AchievementService {
  static final AchievementService _instance = AchievementService._internal();
  static AchievementService get instance => _instance;

  factory AchievementService() {
    return _instance;
  }

  AchievementService._internal();

  late FirebaseFirestore _firestore;
  late FirebaseAuth _auth;
  bool _isInitialized = false;

  // プリセットアチーブメント
  static const List<Achievement> _presetAchievements = [
    // クイズ関連
    Achievement(
      id: 'quiz_first',
      title: '最初のクイズ',
      description: '初めてクイズに挑戦しました',
      emoji: '📝',
      category: AchievementCategory.quiz,
      condition: AchievementCondition(
        type: ConditionType.quizzesClosed,
        targetValue: 1,
        description: 'クイズ1問完了',
      ),
      rarity: AchievementRarity.common,
      order: 1,
    ),
    Achievement(
      id: 'quiz_10',
      title: 'クイズマスター',
      description: '10問のクイズを完了しました',
      emoji: '🎓',
      category: AchievementCategory.quiz,
      condition: AchievementCondition(
        type: ConditionType.quizzesClosed,
        targetValue: 10,
        description: 'クイズ10問完了',
      ),
      rarity: AchievementRarity.uncommon,
      order: 2,
    ),
    Achievement(
      id: 'quiz_50',
      title: 'クイズエキスパート',
      description: '50問のクイズを完了しました',
      emoji: '👨‍🎓',
      category: AchievementCategory.quiz,
      condition: AchievementCondition(
        type: ConditionType.quizzesClosed,
        targetValue: 50,
        description: 'クイズ50問完了',
      ),
      rarity: AchievementRarity.rare,
      order: 3,
    ),
    Achievement(
      id: 'quiz_100',
      title: 'クイズ博士',
      description: '100問のクイズを完了しました',
      emoji: '🧑‍🔬',
      category: AchievementCategory.quiz,
      condition: AchievementCondition(
        type: ConditionType.quizzesClosed,
        targetValue: 100,
        description: 'クイズ100問完了',
      ),
      rarity: AchievementRarity.epic,
      order: 4,
    ),

    // ストリーク関連
    Achievement(
      id: 'streak_3',
      title: '3日連続学習',
      description: '3日間連続で学習しました',
      emoji: '🔥',
      category: AchievementCategory.streak,
      condition: AchievementCondition(
        type: ConditionType.streakDays,
        targetValue: 3,
        description: '3日連続ストリーク',
      ),
      rarity: AchievementRarity.uncommon,
      order: 5,
    ),
    Achievement(
      id: 'streak_7',
      title: '1週間学習王',
      description: '7日間連続で学習しました',
      emoji: '👑',
      category: AchievementCategory.streak,
      condition: AchievementCondition(
        type: ConditionType.streakDays,
        targetValue: 7,
        description: '7日連続ストリーク',
      ),
      rarity: AchievementRarity.rare,
      order: 6,
    ),
    Achievement(
      id: 'streak_30',
      title: '1ヶ月の継続者',
      description: '30日間連続で学習しました',
      emoji: '💪',
      category: AchievementCategory.streak,
      condition: AchievementCondition(
        type: ConditionType.streakDays,
        targetValue: 30,
        description: '30日連続ストリーク',
      ),
      rarity: AchievementRarity.epic,
      order: 7,
    ),
    Achievement(
      id: 'streak_100',
      title: '伝説の継続者',
      description: '100日間連続で学習しました',
      emoji: '🌟',
      category: AchievementCategory.streak,
      condition: AchievementCondition(
        type: ConditionType.streakDays,
        targetValue: 100,
        description: '100日連続ストリーク',
      ),
      rarity: AchievementRarity.legendary,
      order: 8,
    ),

    // 完璧なスコア
    Achievement(
      id: 'perfect_1',
      title: '完璧な回答',
      description: '全問正解を1回達成しました',
      emoji: '⭐',
      category: AchievementCategory.quiz,
      condition: AchievementCondition(
        type: ConditionType.perfectScores,
        targetValue: 1,
        description: '全問正解1回',
      ),
      rarity: AchievementRarity.uncommon,
      order: 9,
    ),
    Achievement(
      id: 'perfect_5',
      title: 'パーフェクト職人',
      description: '全問正解を5回達成しました',
      emoji: '✨',
      category: AchievementCategory.quiz,
      condition: AchievementCondition(
        type: ConditionType.perfectScores,
        targetValue: 5,
        description: '全問正解5回',
      ),
      rarity: AchievementRarity.rare,
      order: 10,
    ),

    // ランキング関連
    Achievement(
      id: 'ranking_top10',
      title: 'トップ10入り',
      description: 'ランキングトップ10に入りました',
      emoji: '🥉',
      category: AchievementCategory.ranking,
      condition: AchievementCondition(
        type: ConditionType.rankingTop,
        targetValue: 10,
        description: 'ランキング10位以内',
      ),
      rarity: AchievementRarity.uncommon,
      order: 11,
    ),
    Achievement(
      id: 'ranking_top3',
      title: 'トップ3達成',
      description: 'ランキングトップ3に入りました',
      emoji: '🥇',
      category: AchievementCategory.ranking,
      condition: AchievementCondition(
        type: ConditionType.rankingTop,
        targetValue: 3,
        description: 'ランキング3位以内',
      ),
      rarity: AchievementRarity.epic,
      order: 12,
    ),

    // SNS共有
    Achievement(
      id: 'sharing_first',
      title: 'シェアデビュー',
      description: '初めてスコアをシェアしました',
      emoji: '📤',
      category: AchievementCategory.sharing,
      condition: AchievementCondition(
        type: ConditionType.sharesCount,
        targetValue: 1,
        description: 'SNS共有1回',
      ),
      rarity: AchievementRarity.common,
      order: 13,
    ),
    Achievement(
      id: 'sharing_5',
      title: 'シェア大使',
      description: 'スコアを5回以上シェアしました',
      emoji: '📲',
      category: AchievementCategory.sharing,
      condition: AchievementCondition(
        type: ConditionType.sharesCount,
        targetValue: 5,
        description: 'SNS共有5回',
      ),
      rarity: AchievementRarity.rare,
      order: 14,
    ),
  ];

  /// 初期化
  Future<void> initialize() async {
    if (_isInitialized) return;
    _firestore = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;
    _isInitialized = true;
    developer.log('AchievementService initialized');
  }

  /// 全アチーブメントを取得
  Future<List<Achievement>> getAllAchievements() async {
    await _ensureInitialized();
    return _presetAchievements;
  }

  /// ユーザーが達成したアチーブメントを取得
  Future<List<UserAchievement>> getUserAchievements() async {
    await _ensureInitialized();

    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    try {
      final doc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('achievements')
          .get();

      return doc.docs
          .map((e) => UserAchievement.fromJson({
                'achievementId': e.id,
                ...e.data(),
              }))
          .toList();
    } catch (e) {
      developer.log('Error getting user achievements: $e', error: e);
      return [];
    }
  }

  /// アチーブメント統計を取得
  Future<AchievementStats> getAchievementStats() async {
    await _ensureInitialized();

    final allAchievements = await getAllAchievements();
    final userAchievements = await getUserAchievements();

    final unlockedIds = {for (var a in userAchievements) a.achievementId};
    final completionRate =
        (unlockedIds.length / allAchievements.length) * 100;

    // カテゴリー別統計
    final categoryStats = <String, int>{};
    for (final achievement in allAchievements) {
      final category = achievement.category.label;
      categoryStats[category] = (categoryStats[category] ?? 0) +
          (unlockedIds.contains(achievement.id) ? 1 : 0);
    }

    // 最新の達成
    UserAchievement? lastUnlocked;
    if (userAchievements.isNotEmpty) {
      userAchievements.sort((a, b) => b.unlockedAt.compareTo(a.unlockedAt));
      lastUnlocked = userAchievements.first;
    }

    return AchievementStats(
      totalAchievements: allAchievements.length,
      unlockedCount: unlockedIds.length,
      completionRate: completionRate,
      lastUnlocked: lastUnlocked,
      categoryStats: categoryStats,
    );
  }

  /// クイズ完了時にアチーブメントを確認・記録
  Future<List<AchievementUnlockedNotification>> checkQuizCompletion({
    required int totalQuizzes,
    required int correctCount,
    required int totalQuestions,
  }) async {
    await _ensureInitialized();

    final notifications = <AchievementUnlockedNotification>[];
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    try {
      final userAchievements = await getUserAchievements();
      final unlockedIds = {for (var a in userAchievements) a.achievementId};

      // クイズ完了アチーブメント
      for (final achievement in _presetAchievements) {
        if (achievement.category != AchievementCategory.quiz) continue;
        if (unlockedIds.contains(achievement.id)) continue;

        if (achievement.condition.type == ConditionType.quizzesClosed &&
            totalQuizzes >= achievement.condition.targetValue) {
          await _unlockAchievement(currentUser.uid, achievement);
          notifications.add(
            AchievementUnlockedNotification(
              achievement: achievement,
              userAchievement: UserAchievement(
                achievementId: achievement.id,
                unlockedAt: DateTime.now(),
              ),
              message: '🎉 ${achievement.title}を達成しました！',
              notifiedAt: DateTime.now(),
            ),
          );
        }
      }

      // 全問正解アチーブメント
      if (correctCount == totalQuestions && totalQuestions > 0) {
        for (final achievement in _presetAchievements) {
          if (achievement.condition.type != ConditionType.perfectScores) {
            continue;
          }
          if (unlockedIds.contains(achievement.id)) continue;

          // 達成回数を確認
          final count = await _getPerfectScoreCount(currentUser.uid);
          if (count >= achievement.condition.targetValue) {
            await _unlockAchievement(currentUser.uid, achievement);
            notifications.add(
              AchievementUnlockedNotification(
                achievement: achievement,
                userAchievement: UserAchievement(
                  achievementId: achievement.id,
                  unlockedAt: DateTime.now(),
                ),
                message: '✨ ${achievement.title}を達成しました！',
                notifiedAt: DateTime.now(),
              ),
            );
          }
        }
      }

      return notifications;
    } catch (e) {
      developer.log('Error checking quiz achievements: $e', error: e);
      return [];
    }
  }

  /// ストリーク更新時にアチーブメントを確認・記録
  Future<List<AchievementUnlockedNotification>> checkStreakAchievements({
    required int currentStreak,
  }) async {
    await _ensureInitialized();

    final notifications = <AchievementUnlockedNotification>[];
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    try {
      final userAchievements = await getUserAchievements();
      final unlockedIds = {for (var a in userAchievements) a.achievementId};

      for (final achievement in _presetAchievements) {
        if (achievement.category != AchievementCategory.streak) continue;
        if (unlockedIds.contains(achievement.id)) continue;

        if (achievement.condition.type == ConditionType.streakDays &&
            currentStreak >= achievement.condition.targetValue) {
          await _unlockAchievement(currentUser.uid, achievement);
          notifications.add(
            AchievementUnlockedNotification(
              achievement: achievement,
              userAchievement: UserAchievement(
                achievementId: achievement.id,
                unlockedAt: DateTime.now(),
              ),
              message: '🔥 ${achievement.title}を達成しました！',
              notifiedAt: DateTime.now(),
            ),
          );
        }
      }

      return notifications;
    } catch (e) {
      developer.log('Error checking streak achievements: $e', error: e);
      return [];
    }
  }

  /// ランキング更新時にアチーブメントを確認・記録
  Future<List<AchievementUnlockedNotification>> checkRankingAchievements({
    required int currentRank,
  }) async {
    await _ensureInitialized();

    final notifications = <AchievementUnlockedNotification>[];
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    try {
      final userAchievements = await getUserAchievements();
      final unlockedIds = {for (var a in userAchievements) a.achievementId};

      for (final achievement in _presetAchievements) {
        if (achievement.category != AchievementCategory.ranking) continue;
        if (unlockedIds.contains(achievement.id)) continue;

        if (achievement.condition.type == ConditionType.rankingTop &&
            currentRank <= achievement.condition.targetValue) {
          await _unlockAchievement(currentUser.uid, achievement);
          notifications.add(
            AchievementUnlockedNotification(
              achievement: achievement,
              userAchievement: UserAchievement(
                achievementId: achievement.id,
                unlockedAt: DateTime.now(),
              ),
              message: '🥇 ${achievement.title}を達成しました！',
              notifiedAt: DateTime.now(),
            ),
          );
        }
      }

      return notifications;
    } catch (e) {
      developer.log('Error checking ranking achievements: $e', error: e);
      return [];
    }
  }

  /// SNS共有時にアチーブメントを確認・記録
  Future<List<AchievementUnlockedNotification>> checkSharingAchievements() async {
    await _ensureInitialized();

    final notifications = <AchievementUnlockedNotification>[];
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    try {
      final userAchievements = await getUserAchievements();
      final unlockedIds = {for (var a in userAchievements) a.achievementId};
      final shareCount = await _getShareCount(currentUser.uid);

      for (final achievement in _presetAchievements) {
        if (achievement.category != AchievementCategory.sharing) continue;
        if (unlockedIds.contains(achievement.id)) continue;

        if (achievement.condition.type == ConditionType.sharesCount &&
            shareCount >= achievement.condition.targetValue) {
          await _unlockAchievement(currentUser.uid, achievement);
          notifications.add(
            AchievementUnlockedNotification(
              achievement: achievement,
              userAchievement: UserAchievement(
                achievementId: achievement.id,
                unlockedAt: DateTime.now(),
              ),
              message: '📤 ${achievement.title}を達成しました！',
              notifiedAt: DateTime.now(),
            ),
          );
        }
      }

      return notifications;
    } catch (e) {
      developer.log('Error checking sharing achievements: $e', error: e);
      return [];
    }
  }

  /// プライベートメソッド

  /// アチーブメントをアンロック（Firestore に記録）
  Future<void> _unlockAchievement(String userId, Achievement achievement) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('achievements')
          .doc(achievement.id)
          .set({
        'unlockedAt': FieldValue.serverTimestamp(),
        'isFirstTime': true,
        'count': 1,
      }, SetOptions(merge: true));

      developer.log('Achievement unlocked: ${achievement.id}');
    } catch (e) {
      developer.log('Error unlocking achievement: $e', error: e);
      rethrow;
    }
  }

  /// 全問正解の回数を取得
  Future<int> _getPerfectScoreCount(String userId) async {
    try {
      final collection = await _firestore
          .collectionGroup('users')
          .where(FieldPath.documentId, isEqualTo: userId)
          .get();

      // ここでは簡略化して、クイズプログレスから全問正解の回数を取得する
      // 実装は他のサービスと連携が必要
      return 1; // プレースホルダー
    } catch (e) {
      developer.log('Error getting perfect score count: $e', error: e);
      return 0;
    }
  }

  /// SNS共有の回数を取得
  Future<int> _getShareCount(String userId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      return doc.data()?['shareCount'] as int? ?? 0;
    } catch (e) {
      developer.log('Error getting share count: $e', error: e);
      return 0;
    }
  }

  /// 初期化確認
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }
}
