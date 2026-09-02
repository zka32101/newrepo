import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;
import '../models/ranking_model.dart';

/// ランキング管理サービス
class RankingService {
  static final RankingService _instance = RankingService._internal();
  static RankingService get instance => _instance;

  factory RankingService() {
    return _instance;
  }

  RankingService._internal();

  late FirebaseFirestore _firestore;
  late FirebaseAuth _auth;
  bool _isInitialized = false;

  /// 初期化
  Future<void> initialize() async {
    if (_isInitialized) return;
    _firestore = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;
    _isInitialized = true;
    developer.log('RankingService initialized');
  }

  /// ランキングを取得（期間指定）
  Future<RankingList> getRanking({
    required RankingPeriod period,
    int limit = 50,
  }) async {
    await _ensureInitialized();

    try {
      final collectionName = _getCollectionName(period);
      final query = _firestore
          .collection(collectionName)
          .orderBy('score', descending: true)
          .limit(limit);

      final snapshot = await query.get();
      final entries = snapshot.docs
          .asMap()
          .entries
          .map((e) {
            final rank = e.key + 1;
            final data = e.value.data();
            return RankingEntry(
              userId: e.value.id,
              userName: data['userName'] as String? ?? '匿名ユーザー',
              avatarUrl: data['avatarUrl'] as String?,
              score: data['score'] as int? ?? 0,
              rank: rank,
              correctAnswers: data['correctAnswers'] as int? ?? 0,
              totalQuestions: data['totalQuestions'] as int? ?? 0,
              correctRate:
                  (data['correctRate'] as num?)?.toDouble() ?? 0.0,
              streak: data['streak'] as int? ?? 0,
              lastScoreDate: (data['lastScoreDate'] as Timestamp?)
                      ?.toDate() ??
                  DateTime.now(),
              isCurrentUser: e.value.id == _auth.currentUser?.uid,
            );
          })
          .toList();

      return RankingList(
        period: period,
        entries: entries,
        lastUpdatedAt: DateTime.now(),
        refreshIntervalSeconds: _getRefreshInterval(period),
      );
    } catch (e) {
      developer.log('Error getting ranking: $e', error: e);
      return RankingList(
        period: period,
        entries: [],
        lastUpdatedAt: DateTime.now(),
        refreshIntervalSeconds: _getRefreshInterval(period),
      );
    }
  }

  /// ユーザーのスコアを更新
  Future<void> updateUserScore({
    required int score,
    required int correctAnswers,
    required int totalQuestions,
    GradeLevel? gradeLevel,
    SchoolYear? startMonth,
  }) async {
    await _ensureInitialized();

    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    try {
      final correctRate = totalQuestions > 0
          ? (correctAnswers / totalQuestions * 100)
          : 0.0;

      final userData = {
        'userId': currentUser.uid,
        'userName': currentUser.displayName ?? '匿名ユーザー',
        'avatarUrl': currentUser.photoURL,
        'score': score,
        'correctAnswers': correctAnswers,
        'totalQuestions': totalQuestions,
        'correctRate': correctRate,
        'lastScoreDate': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'gradeLevel': gradeLevel?.toGradeNumber() ?? 3,
        'startMonth': startMonth?.toMonthNumber() ?? 4,
      };

      // 日別ランキングを更新
      final today = DateTime.now();
      final dateKey =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      await _firestore
          .collection('rankings_daily')
          .doc(dateKey)
          .collection('users')
          .doc(currentUser.uid)
          .set(userData, SetOptions(merge: true));

      // 週別ランキングを更新
      final weekKey = _getWeekKey(today);
      await _firestore
          .collection('rankings_weekly')
          .doc(weekKey)
          .collection('users')
          .doc(currentUser.uid)
          .set(userData, SetOptions(merge: true));

      // 月別ランキングを更新
      final monthKey =
          '${today.year}-${today.month.toString().padLeft(2, '0')}';
      await _firestore
          .collection('rankings_monthly')
          .doc(monthKey)
          .collection('users')
          .doc(currentUser.uid)
          .set(userData, SetOptions(merge: true));

      developer.log('Score updated for user: ${currentUser.uid}');
    } catch (e) {
      developer.log('Error updating score: $e', error: e);
      rethrow;
    }
  }

  /// ユーザーのランキング統計を取得
  Future<RankingStats> getUserStats({
    required RankingPeriod period,
  }) async {
    await _ensureInitialized();

    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    try {
      final collectionName = _getCollectionName(period);

      // 全ユーザーのランキングを取得
      final allUsersSnapshot = await _firestore
          .collection(collectionName)
          .orderBy('score', descending: true)
          .get();

      final totalParticipants = allUsersSnapshot.docs.length;

      // ユーザーのランクを取得
      int userRank = totalParticipants + 1;
      int userScore = 0;

      for (int i = 0; i < allUsersSnapshot.docs.length; i++) {
        if (allUsersSnapshot.docs[i].id == currentUser.uid) {
          userRank = i + 1;
          userScore = allUsersSnapshot.docs[i]['score'] as int? ?? 0;
          break;
        }
      }

      // ランキング内のパーセンテージを計算
      final percentile =
          totalParticipants > 0 ? ((userRank / totalParticipants) * 100) : 100;

      // 1位のスコアと平均スコアを計算
      int topScore = 0;
      double averageScore = 0;

      if (allUsersSnapshot.docs.isNotEmpty) {
        topScore = allUsersSnapshot.docs[0]['score'] as int? ?? 0;

        final totalScore = allUsersSnapshot.docs.fold<int>(
          0,
          (sum, doc) => sum + (doc['score'] as int? ?? 0),
        );
        averageScore = totalScore / allUsersSnapshot.docs.length;
      }

      // スコア推移を取得（過去7日間）
      final scoreHistory = await _getUserScoreHistory(currentUser.uid);

      return RankingStats(
        period: period,
        totalParticipants: totalParticipants,
        currentUserRank: userRank,
        currentUserScore: userScore,
        percentile: percentile,
        topScore: topScore,
        averageScore: averageScore,
        scoreHistory: scoreHistory,
      );
    } catch (e) {
      developer.log('Error getting user stats: $e', error: e);
      rethrow;
    }
  }

  /// ランク変動を検知して通知データを生成
  Future<RankingChangeNotification?> detectRankChange({
    required int previousRank,
    required int currentRank,
  }) async {
    if (previousRank == currentRank) {
      return RankingChangeNotification(
        previousRank: previousRank,
        currentRank: currentRank,
        direction: RankChangeDirection.same,
        delta: 0,
        message: 'ランクは変わりません',
        notifiedAt: DateTime.now(),
      );
    }

    final isUp = currentRank < previousRank;
    final delta = (previousRank - currentRank).abs();

    final message = isUp
        ? 'おめでとう！$delta位 上昇して $currentRank 位になりました！'
        : '$delta位 下降して $currentRank 位になりました。頑張りましょう！';

    return RankingChangeNotification(
      previousRank: previousRank,
      currentRank: currentRank,
      direction: isUp ? RankChangeDirection.up : RankChangeDirection.down,
      delta: delta,
      message: message,
      notifiedAt: DateTime.now(),
    );
  }

  /// トップ 3 入賞者を取得
  Future<List<RankingEntry>> getTopThree({
    required RankingPeriod period,
  }) async {
    await _ensureInitialized();

    try {
      final collectionName = _getCollectionName(period);
      final snapshot = await _firestore
          .collection(collectionName)
          .orderBy('score', descending: true)
          .limit(3)
          .get();

      return snapshot.docs
          .asMap()
          .entries
          .map((e) {
            final data = e.value.data();
            return RankingEntry(
              userId: e.value.id,
              userName: data['userName'] as String? ?? '匿名ユーザー',
              avatarUrl: data['avatarUrl'] as String?,
              score: data['score'] as int? ?? 0,
              rank: e.key + 1,
              correctAnswers: data['correctAnswers'] as int? ?? 0,
              totalQuestions: data['totalQuestions'] as int? ?? 0,
              correctRate:
                  (data['correctRate'] as num?)?.toDouble() ?? 0.0,
              streak: data['streak'] as int? ?? 0,
              lastScoreDate: (data['lastScoreDate'] as Timestamp?)
                      ?.toDate() ??
                  DateTime.now(),
              isCurrentUser: e.value.id == _auth.currentUser?.uid,
            );
          })
          .toList();
    } catch (e) {
      developer.log('Error getting top three: $e', error: e);
      return [];
    }
  }

  /// 学年別ランキングを取得
  Future<RankingList> getRankingByGrade({
    required GradeLevel grade,
    required RankingPeriod period,
    int limit = 50,
  }) async {
    await _ensureInitialized();

    try {
      final currentUser = _auth.currentUser;
      final collectionName = _getCollectionName(period);

      // 学年別サブコレクションからランキングを取得
      final query = _firestore
          .collection(collectionName)
          .where('gradeLevel', isEqualTo: grade.toGradeNumber())
          .orderBy('score', descending: true)
          .limit(limit);

      final snapshot = await query.get();
      final entries = _convertSnapshotToEntries(
        snapshot,
        gradeLevel: grade,
        rankingTier: RankingTier.byGrade,
      );

      // ユーザーの統計情報を取得
      final userTierInfo = currentUser != null
          ? await _getUserTierRankingInfo(
              currentUser.uid,
              RankingTier.byGrade,
              collectionName,
              gradeFilter: grade,
            )
          : null;

      return RankingList(
        period: period,
        entries: entries,
        lastUpdatedAt: DateTime.now(),
        refreshIntervalSeconds: _getRefreshInterval(period),
        rankingTier: RankingTier.byGrade,
        tierDescription: grade.label,
        userTierInfo: userTierInfo,
      );
    } catch (e) {
      developer.log('Error getting ranking by grade: $e', error: e);
      return RankingList(
        period: period,
        entries: [],
        lastUpdatedAt: DateTime.now(),
        refreshIntervalSeconds: _getRefreshInterval(period),
        rankingTier: RankingTier.byGrade,
        tierDescription: grade.label,
      );
    }
  }

  /// 開始月別ランキングを取得
  Future<RankingList> getRankingByStartMonth({
    required SchoolYear startMonth,
    required RankingPeriod period,
    int limit = 50,
  }) async {
    await _ensureInitialized();

    try {
      final currentUser = _auth.currentUser;
      final collectionName = _getCollectionName(period);

      // 開始月別サブコレクションからランキングを取得
      final query = _firestore
          .collection(collectionName)
          .where('startMonth', isEqualTo: startMonth.toMonthNumber())
          .orderBy('score', descending: true)
          .limit(limit);

      final snapshot = await query.get();
      final entries = _convertSnapshotToEntries(
        snapshot,
        startMonth: startMonth,
        rankingTier: RankingTier.byStartMonth,
      );

      // ユーザーの統計情報を取得
      final userTierInfo = currentUser != null
          ? await _getUserTierRankingInfo(
              currentUser.uid,
              RankingTier.byStartMonth,
              collectionName,
              startMonthFilter: startMonth,
            )
          : null;

      return RankingList(
        period: period,
        entries: entries,
        lastUpdatedAt: DateTime.now(),
        refreshIntervalSeconds: _getRefreshInterval(period),
        rankingTier: RankingTier.byStartMonth,
        tierDescription: '${startMonth.label}開始',
        userTierInfo: userTierInfo,
      );
    } catch (e) {
      developer.log('Error getting ranking by start month: $e', error: e);
      return RankingList(
        period: period,
        entries: [],
        lastUpdatedAt: DateTime.now(),
        refreshIntervalSeconds: _getRefreshInterval(period),
        rankingTier: RankingTier.byStartMonth,
        tierDescription: '${startMonth.label}開始',
      );
    }
  }

  /// 複合グループランキングを取得（学年 + 開始月のフィルタ組み合わせ）
  Future<RankingList> getRankingComposite({
    required RankingPeriod period,
    GradeLevel? gradeFilter,
    SchoolYear? startMonthFilter,
    bool applyBothFilters = false,
    int limit = 50,
  }) async {
    await _ensureInitialized();

    try {
      final currentUser = _auth.currentUser;
      final collectionName = _getCollectionName(period);

      var query = _firestore.collection(collectionName).orderBy('score', descending: true);

      // グレードフィルターを適用
      if (gradeFilter != null) {
        query = query.where('gradeLevel', isEqualTo: gradeFilter.toGradeNumber())
            as Query<Map<String, dynamic>>;
      }

      // 開始月フィルターを適用
      if (startMonthFilter != null && applyBothFilters) {
        query = query.where('startMonth', isEqualTo: startMonthFilter.toMonthNumber())
            as Query<Map<String, dynamic>>;
      }

      final snapshot = await query.limit(limit).get();
      final entries = _convertSnapshotToEntries(
        snapshot,
        gradeLevel: gradeFilter,
        startMonth: startMonthFilter,
        rankingTier: RankingTier.composite,
      );

      // ユーザーの統計情報を取得
      final userTierInfo = currentUser != null
          ? await _getUserTierRankingInfo(
              currentUser.uid,
              RankingTier.composite,
              collectionName,
              gradeFilter: gradeFilter,
              startMonthFilter: startMonthFilter,
              applyBothFilters: applyBothFilters,
            )
          : null;

      final compositeFilter = CompositeGroupFilter(
        gradeFilter: gradeFilter,
        startMonthFilter: startMonthFilter,
        applyBothFilters: applyBothFilters,
      );

      return RankingList(
        period: period,
        entries: entries,
        lastUpdatedAt: DateTime.now(),
        refreshIntervalSeconds: _getRefreshInterval(period),
        rankingTier: RankingTier.composite,
        tierDescription: compositeFilter.getFilterDescription(),
        userTierInfo: userTierInfo,
        compositeFilter: compositeFilter,
      );
    } catch (e) {
      developer.log('Error getting composite ranking: $e', error: e);
      return RankingList(
        period: period,
        entries: [],
        lastUpdatedAt: DateTime.now(),
        refreshIntervalSeconds: _getRefreshInterval(period),
        rankingTier: RankingTier.composite,
        tierDescription: '複合グループ',
      );
    }
  }

  /// Firestore スナップショットを RankingEntry リストに変換
  List<RankingEntry> _convertSnapshotToEntries(
    QuerySnapshot<Map<String, dynamic>> snapshot, {
    GradeLevel? gradeLevel,
    SchoolYear? startMonth,
    required RankingTier rankingTier,
  }) {
    return snapshot.docs
        .asMap()
        .entries
        .map((e) {
          final rank = e.key + 1;
          final data = e.value.data();
          return RankingEntry(
            userId: e.value.id,
            userName: data['userName'] as String? ?? '匿名ユーザー',
            avatarUrl: data['avatarUrl'] as String?,
            score: data['score'] as int? ?? 0,
            rank: rank,
            correctAnswers: data['correctAnswers'] as int? ?? 0,
            totalQuestions: data['totalQuestions'] as int? ?? 0,
            correctRate: (data['correctRate'] as num?)?.toDouble() ?? 0.0,
            streak: data['streak'] as int? ?? 0,
            lastScoreDate: (data['lastScoreDate'] as Timestamp?)?.toDate() ??
                DateTime.now(),
            isCurrentUser: e.value.id == _auth.currentUser?.uid,
            userGradeLevel: gradeLevel,
            userStartMonth: startMonth,
            rankingTier: rankingTier,
          );
        })
        .toList();
  }

  /// ユーザーのティア別ランキング情報を取得
  Future<TierRankingInfo?> _getUserTierRankingInfo(
    String userId,
    RankingTier tier,
    String collectionName, {
    GradeLevel? gradeFilter,
    SchoolYear? startMonthFilter,
    bool applyBothFilters = false,
  }) async {
    try {
      var query = _firestore.collection(collectionName).orderBy('score', descending: true);

      // フィルターを適用
      if (gradeFilter != null && tier == RankingTier.byGrade) {
        query = query.where('gradeLevel', isEqualTo: gradeFilter.toGradeNumber())
            as Query<Map<String, dynamic>>;
      }

      if (startMonthFilter != null && tier == RankingTier.byStartMonth) {
        query = query.where('startMonth', isEqualTo: startMonthFilter.toMonthNumber())
            as Query<Map<String, dynamic>>;
      }

      if (tier == RankingTier.composite) {
        if (gradeFilter != null) {
          query = query.where('gradeLevel', isEqualTo: gradeFilter.toGradeNumber())
              as Query<Map<String, dynamic>>;
        }
        if (startMonthFilter != null && applyBothFilters) {
          query = query.where('startMonth', isEqualTo: startMonthFilter.toMonthNumber())
              as Query<Map<String, dynamic>>;
        }
      }

      final snapshot = await query.get();
      final totalParticipants = snapshot.docs.length;

      // ユーザーのランク情報を取得
      int userRank = totalParticipants + 1;
      int correctRateRank = totalParticipants + 1;

      for (int i = 0; i < snapshot.docs.length; i++) {
        if (snapshot.docs[i].id == userId) {
          userRank = i + 1;
          correctRateRank = i + 1;
          break;
        }
      }

      // ティア内の平均スコアと最高スコアを計算
      int tierTopScore = 0;
      double tierAverageScore = 0;

      if (snapshot.docs.isNotEmpty) {
        tierTopScore = snapshot.docs[0]['score'] as int? ?? 0;
        final totalScore = snapshot.docs.fold<int>(
          0,
          (sum, doc) => sum + (doc['score'] as int? ?? 0),
        );
        tierAverageScore = totalScore / snapshot.docs.length;
      }

      // ティア説明を生成
      String tierDescription;
      switch (tier) {
        case RankingTier.byGrade:
          tierDescription = gradeFilter?.label ?? '全学年';
        case RankingTier.byStartMonth:
          tierDescription = '${startMonthFilter?.label ?? '全月'}開始';
        case RankingTier.composite:
          tierDescription =
              '${gradeFilter?.label ?? '全学年'} & ${startMonthFilter?.label ?? '全月'}';
        case RankingTier.allTime:
          tierDescription = '全体';
      }

      return TierRankingInfo(
        tier: tier,
        tierDescription: tierDescription,
        totalParticipants: totalParticipants,
        userRankInTier: userRank,
        correctRateRank: correctRateRank,
        tierAverageScore: tierAverageScore,
        tierTopScore: tierTopScore,
        isActiveTier: tier == RankingTier.allTime, // 全体が常にアクティブ
      );
    } catch (e) {
      developer.log('Error getting user tier ranking info: $e', error: e);
      return null;
    }
  }

  /// 過去7日間のスコア推移を取得
  Future<List<DailyScoreData>> _getUserScoreHistory(String userId) async {
    try {
      final history = <DailyScoreData>[];
      final now = DateTime.now();

      for (int i = 6; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final dateKey =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

        final doc = await _firestore
            .collection('rankings_daily')
            .doc(dateKey)
            .collection('users')
            .doc(userId)
            .get();

        if (doc.exists) {
          history.add(
            DailyScoreData(
              date: date,
              score: doc['score'] as int? ?? 0,
              questionsCompleted: doc['totalQuestions'] as int? ?? 0,
            ),
          );
        } else {
          history.add(
            DailyScoreData(
              date: date,
              score: 0,
              questionsCompleted: 0,
            ),
          );
        }
      }

      return history;
    } catch (e) {
      developer.log('Error getting score history: $e', error: e);
      return [];
    }
  }

  /// コレクション名を取得
  String _getCollectionName(RankingPeriod period) {
    final now = DateTime.now();
    switch (period) {
      case RankingPeriod.daily:
        final dateKey =
            '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
        return 'rankings_daily/$dateKey/users';
      case RankingPeriod.weekly:
        final weekKey = _getWeekKey(now);
        return 'rankings_weekly/$weekKey/users';
      case RankingPeriod.monthly:
        final monthKey =
            '${now.year}-${now.month.toString().padLeft(2, '0')}';
        return 'rankings_monthly/$monthKey/users';
    }
  }

  /// 週キーを取得（例: 2026-W36）
  String _getWeekKey(DateTime date) {
    final jan4 = DateTime(date.year, 1, 4);
    final dayOfWeek = jan4.weekday;
    final weekOne = jan4.subtract(Duration(days: dayOfWeek - 1));
    final week =
        ((date.difference(weekOne).inDays) / 7).ceil();
    return '${date.year}-W${week.toString().padLeft(2, '0')}';
  }

  /// リフレッシュ間隔を取得（秒）
  int _getRefreshInterval(RankingPeriod period) {
    switch (period) {
      case RankingPeriod.daily:
        return 60; // 1分
      case RankingPeriod.weekly:
        return 300; // 5分
      case RankingPeriod.monthly:
        return 600; // 10分
    }
  }

  /// 初期化確認
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }
}
