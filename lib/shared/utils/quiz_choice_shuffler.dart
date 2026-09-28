import 'dart:math';

/// クイズの選択肢の並び順・正解位置をシャッフルするユーティリティ。
///
/// 問題データ(sample_questions.dart等)は正解が特定のインデックス(特に0番目)
/// に偏って作成されているため、表示のたびに元データを変更せず並び順を
/// シャッフルすることで実質的な偏りを解消する。
///
/// シャッフルは questionId から決定的に導出したシード値を使うため、
/// 同じ問題であれば端末やセッションが違っても常に同じ並び順になる。
/// これにより対戦モード(マルチプレイ)でも参加者間の同期処理なしに
/// 全員へ同一の選択肢順を提示できる。
class ShuffledChoices {
  final List<String> answers;
  final int correctAnswerIndex;

  const ShuffledChoices(this.answers, this.correctAnswerIndex);
}

/// [answers] と [correctAnswerIndex] を [questionId] から決定的にシャッフルする。
ShuffledChoices shuffleChoicesForQuestion(
  List<String> answers,
  int correctAnswerIndex,
  String questionId,
) {
  if (answers.isEmpty) {
    return ShuffledChoices(answers, correctAnswerIndex);
  }
  final order = List<int>.generate(answers.length, (i) => i);
  // `String.hashCode` はプラットフォーム/バージョンで値が変わり得るため、
  // シード生成には自前の安定ハッシュ [_stableStringHash] を使う。
  order.shuffle(Random(_stableStringHash(questionId)));
  final shuffledAnswers = order.map((i) => answers[i]).toList();
  final newCorrectIndex = order.indexOf(correctAnswerIndex);
  return ShuffledChoices(shuffledAnswers, newCorrectIndex);
}

/// `sample_questions.dart` 由来の生の問題 Map(`answers`/`correctAnswerIndex`/
/// `stageId`/`questionNumber` を持つ)を受け取り、選択肢をシャッフルした
/// 新しい Map を返す。元の Map は書き換えない
/// (sampleQuestionsData はアプリ全体で共有されるグローバルなリストのため、
/// 直接書き換えると他の画面のクイズにも影響してしまう)。
Map<String, dynamic> shuffleQuestionMap(Map<String, dynamic> question) {
  final answers = List<String>.from(question['answers'] as List);
  final correctAnswerIndex = question['correctAnswerIndex'] as int;
  final questionId = '${question['stageId']}_${question['questionNumber']}';
  final shuffled = shuffleChoicesForQuestion(
    answers,
    correctAnswerIndex,
    questionId,
  );
  return {
    ...question,
    'answers': shuffled.answers,
    'correctAnswerIndex': shuffled.correctAnswerIndex,
  };
}

/// プラットフォーム・Dartバージョンに依存しない安定した文字列ハッシュ
/// (Jenkins one-at-a-time hash)。
int _stableStringHash(String input) {
  var hash = 0;
  for (final unit in input.codeUnits) {
    hash = (hash + unit) & 0x1fffffff;
    hash = (hash + (hash << 10)) & 0x1fffffff;
    hash ^= (hash >> 6);
  }
  hash = (hash + (hash << 3)) & 0x1fffffff;
  hash ^= (hash >> 11);
  hash = (hash + (hash << 15)) & 0x1fffffff;
  return hash;
}
