import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../features/profile/models/profile_model.dart';
import '../models/ranking_model.dart';

/// 学年進級管理サービス
/// ユーザーの学年を自動進級し、学年度ベースの管理を行う
class GradeAdvancementService {
  static final GradeAdvancementService _instance =
      GradeAdvancementService._internal();
  static GradeAdvancementService get instance => _instance;

  factory GradeAdvancementService() {
    return _instance;
  }

  GradeAdvancementService._internal();

  late FirebaseFirestore _firestore;
  bool _isInitialized = false;

  /// 初期化
  Future<void> initialize() async {
    if (_isInitialized) return;
    _firestore = FirebaseFirestore.instance;
    _isInitialized = true;
    developer.log('GradeAdvancementService initialized');
  }

  /// 確実に初期化されているかチェック
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  /// ユーザーのプロフィールをチェックして、進級が必要かどうか判定
  /// 進級が必要な場合は自動進級を実行
  Future<GradeAdvancementResult> checkAndAdvanceGradeIfNeeded(
    ProfileModel profile,
  ) async {
    await _ensureInitialized();

    try {
      // 初期状態（未設定）の場合は開始月を設定して初期化
      if (profile.startMonth == null) {
        return await _initializeStartMonth(profile);
      }

      // 今年の4月1日かチェック
      final now = DateTime.now();
      if (!_isAprilFirstOrLater(now)) {
        return GradeAdvancementResult(
          didAdvance: false,
          previousGrade: profile.gradeLevel,
          currentGrade: profile.gradeLevel,
          message: '進級はまだです。4月に進級予定です。',
        );
      }

      // 最後に進級した日付をチェック（今年度すでに進級したか）
      if (profile.lastGradeAdvancementDate != null) {
        final lastAdvancementDate =
            DateTime.parse(profile.lastGradeAdvancementDate!);
        final lastAdvancementYear = lastAdvancementDate.year;

        // 今年度すでに進級済みの場合
        if (lastAdvancementYear == now.year) {
          return GradeAdvancementResult(
            didAdvance: false,
            previousGrade: profile.gradeLevel,
            currentGrade: profile.gradeLevel,
            message: '今年度は既に進級済みです。',
          );
        }
      }

      // 進級可能かチェック（最高学年は進級できない）
      if (profile.gradeLevel >= 6) {
        return GradeAdvancementResult(
          didAdvance: false,
          previousGrade: profile.gradeLevel,
          currentGrade: profile.gradeLevel,
          message: '最高学年です。進級できません。',
        );
      }

      // 進級を実行
      final newGrade = profile.gradeLevel + 1;
      final today =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      final updatedProfile = ProfileModel(
        id: profile.id,
        nickname: profile.nickname,
        avatarEmoji: profile.avatarEmoji,
        gradeLevel: newGrade,
        createdAt: profile.createdAt,
        startMonth: profile.startMonth,
        lastGradeAdvancementDate: today,
      );

      // Firestoreを更新
      await _firestore.collection('users').doc(profile.id).update({
        'gradeLevel': newGrade,
        'lastGradeAdvancementDate': today,
      });

      developer.log(
        'Grade advanced for user ${profile.id}: ${profile.gradeLevel} → $newGrade',
      );

      return GradeAdvancementResult(
        didAdvance: true,
        previousGrade: profile.gradeLevel,
        currentGrade: newGrade,
        message: '🎉 $newGrade年生に進級しました！',
        advancementDate: today,
      );
    } catch (e) {
      developer.log('Error checking/advancing grade: $e', error: e);
      return GradeAdvancementResult(
        didAdvance: false,
        previousGrade: profile.gradeLevel,
        currentGrade: profile.gradeLevel,
        message: 'エラーが発生しました: $e',
      );
    }
  }

  /// ユーザーの開始月を初期化（初回のみ）
  Future<GradeAdvancementResult> _initializeStartMonth(
    ProfileModel profile,
  ) async {
    try {
      final now = DateTime.now();
      final startMonth = now.month;

      // 開始月を設定
      await _firestore.collection('users').doc(profile.id).update({
        'startMonth': startMonth,
      });

      developer.log(
        'Start month initialized for user ${profile.id}: $startMonth月',
      );

      return GradeAdvancementResult(
        didAdvance: false,
        previousGrade: profile.gradeLevel,
        currentGrade: profile.gradeLevel,
        message: '${startMonth}月開始ユーザーとして登録されました。',
      );
    } catch (e) {
      developer.log('Error initializing start month: $e', error: e);
      return GradeAdvancementResult(
        didAdvance: false,
        previousGrade: profile.gradeLevel,
        currentGrade: profile.gradeLevel,
        message: 'エラーが発生しました: $e',
      );
    }
  }

  /// 指定した日付が4月1日以降かどうかチェック（年内）
  bool _isAprilFirstOrLater(DateTime date) {
    // 4月1日以降かどうか
    return date.month > 4 || (date.month == 4 && date.day >= 1);
  }

  /// ユーザーの学年度情報を取得
  /// 学年度は4月-3月の区切り
  /// 例: 2026年1月 → 2025-2026年度
  SchoolYear getUserSchoolYear(int? startMonth) {
    if (startMonth == null) {
      return SchoolYear.april;
    }
    return SchoolYear.fromMonthNumber(startMonth);
  }

  /// ユーザーが属すべき学年を計算（開始月ベース）
  /// 開始時に3年生で開始した場合、毎年4月に進級
  int calculateExpectedGrade({
    required int startingGrade,
    required int startingMonth,
  }) {
    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    // 開始年を計算（startingMonth がいつかで開始年が決まる）
    // 例: startingMonth=4 (4月開始) の場合、今年4月以降なら今年が開始年
    final isAfterStartMonth = currentMonth > startingMonth ||
        (currentMonth == startingMonth && currentMonth >= 4);

    // 4月時点でリセット: 4月以降は新年度
    final yearsSinceStart = isAfterStartMonth ? (currentYear - 2024) : 0;

    final expectedGrade = startingGrade + yearsSinceStart;
    return expectedGrade.clamp(3, 6);
  }

  /// 進級イベントを記録（オプション：分析用）
  Future<void> recordGradeAdvancementEvent({
    required String userId,
    required int previousGrade,
    required int newGrade,
    required DateTime advancementDate,
  }) async {
    await _ensureInitialized();

    try {
      await _firestore
          .collection('grade_advancement_events')
          .doc('${userId}_${advancementDate.year}')
          .set({
            'userId': userId,
            'previousGrade': previousGrade,
            'newGrade': newGrade,
            'advancementDate': Timestamp.fromDate(advancementDate),
            'recordedAt': FieldValue.serverTimestamp(),
          });

      developer.log('Grade advancement event recorded for user: $userId');
    } catch (e) {
      developer.log('Error recording grade advancement event: $e', error: e);
      // エラーが発生しても進級処理は継続
    }
  }
}

/// 進級結果モデル
class GradeAdvancementResult {
  /// 進級が実施されたかどうか
  final bool didAdvance;

  /// 進級前の学年
  final int previousGrade;

  /// 現在の学年
  final int currentGrade;

  /// ユーザーに表示するメッセージ
  final String message;

  /// 進級実施日（YYYY-MM-DD）
  /// didAdvance == true の場合のみ値を持つ
  final String? advancementDate;

  const GradeAdvancementResult({
    required this.didAdvance,
    required this.previousGrade,
    required this.currentGrade,
    required this.message,
    this.advancementDate,
  });

  /// 進級かどうかの判定
  bool get isPromotion => didAdvance && currentGrade > previousGrade;

  /// 表示用の学年文字列
  String get gradeDisplayText => '${currentGrade}年生';

  /// 進級前の学年文字列
  String get previousGradeDisplayText => '${previousGrade}年生';
}
