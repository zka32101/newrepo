import 'package:flutter_test/flutter_test.dart';
import 'package:shokollen_science/shared/utils/quiz_choice_shuffler.dart';

void main() {
  group('shuffleChoicesForQuestion', () {
    test('正解の内容は常に一致する', () {
      final answers = ['りんご', 'みかん', 'ぶどう', 'もも'];
      final result = shuffleChoicesForQuestion(answers, 2, 'stage_5_003_5');
      expect(result.answers[result.correctAnswerIndex], 'ぶどう');
      expect(result.answers.toSet(), answers.toSet());
    });

    test('同じquestionIdなら常に同じ結果になる(決定的)', () {
      final r1 = shuffleChoicesForQuestion(['A', 'B', 'C', 'D'], 1, 'stage_3_001_1');
      final r2 = shuffleChoicesForQuestion(['A', 'B', 'C', 'D'], 1, 'stage_3_001_1');
      expect(r1.answers, r2.answers);
      expect(r1.correctAnswerIndex, r2.correctAnswerIndex);
    });

    test('正解インデックスの分布が偏らない', () {
      final counts = <int, int>{0: 0, 1: 0, 2: 0, 3: 0};
      for (var stage = 0; stage < 47; stage++) {
        for (var q = 1; q <= 15; q++) {
          final result = shuffleChoicesForQuestion(
            ['A', 'B', 'C', 'D'],
            0,
            'stage_${stage}_$q',
          );
          counts[result.correctAnswerIndex] =
              (counts[result.correctAnswerIndex] ?? 0) + 1;
        }
      }
      final total = counts.values.reduce((a, b) => a + b);
      for (final count in counts.values) {
        expect(count / total, closeTo(0.25, 0.1));
      }
    });

    test('空の選択肢でも例外を投げない', () {
      final result = shuffleChoicesForQuestion([], 0, 'stage_x_1');
      expect(result.answers, isEmpty);
    });
  });

  group('shuffleQuestionMap', () {
    test('元のMapを書き換えない', () {
      final original = {
        'stageId': 'stage_3_001',
        'questionNumber': 1,
        'answers': ['A', 'B', 'C', 'D'],
        'correctAnswerIndex': 0,
      };
      final originalAnswersRef = original['answers'];
      shuffleQuestionMap(original);
      expect(original['answers'], same(originalAnswersRef));
      expect(original['correctAnswerIndex'], 0);
    });

    test('シャッフル後も正解の内容が一致する', () {
      final q = {
        'stageId': 'stage_3_001',
        'questionNumber': 1,
        'answers': ['りんご', 'みかん', 'ぶどう', 'もも'],
        'correctAnswerIndex': 2,
      };
      final shuffled = shuffleQuestionMap(q);
      final answers = shuffled['answers'] as List<String>;
      final correctIndex = shuffled['correctAnswerIndex'] as int;
      expect(answers[correctIndex], 'ぶどう');
    });
  });
}
