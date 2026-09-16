import 'dart:math';

import '../../quiz/models/question_model.dart';
import '../../../data/seeds/sample_questions.dart';

/// マルチプレイ対戦用の問題セット生成。
///
/// 両プレイヤーの端末で同じ [matchId] から同じ乱数シードを作るため、
/// サーバー（Firestore）を介さずに両者へ同一の問題セットを配信できる。
/// 対戦相手探索（マッチメイキング）は同じ [gradeLevel] のプレイヤー同士を
/// 優先的にマッチさせる（metadata フィルタ）ため、通常は出題学年も揃う。
class MultiplayerQuizGenerator {
  const MultiplayerQuizGenerator._();

  static const int questionsPerMatch = 10;

  /// [matchId] と [gradeLevel] から決定的に問題セットを生成する。
  /// 該当学年の問題が少ない場合は他学年の問題で補う。
  static List<QuestionModel> generate({
    required String matchId,
    required int gradeLevel,
  }) {
    final seed = matchId.hashCode;
    final random = Random(seed);

    final allQuestions = List<Map<String, dynamic>>.from(sampleQuestionsData);
    final sameGrade = allQuestions
        .where((q) => (q['stageId'] as String).contains('stage_${gradeLevel}_'))
        .toList();
    final pool = sameGrade.length >= questionsPerMatch ? sameGrade : allQuestions;

    final shuffled = List<Map<String, dynamic>>.from(pool)..shuffle(random);
    final picked = shuffled.take(questionsPerMatch).toList();

    return picked.map((q) {
      return QuestionModel(
        id: '${q['stageId']}_${q['questionNumber']}',
        stageId: q['stageId'] as String,
        questionNumber: q['questionNumber'] as int,
        question: q['question'] as String,
        answers: List<String>.from(q['answers'] as List),
        correctAnswerIndex: q['correctAnswerIndex'] as int,
        explanation: q['explanation'] as String,
        timeLimit: q['timeLimit'] as int,
        difficultyLevel: q['difficultyLevel'] as int,
      );
    }).toList();
  }
}
