// ⑨ 親子バトル化：予想バトル問題（5ラウンド用）
// 親子が同じ実験の結果を予想し、当たった方が勝ち

class PredictionBattleQuestion {
  final String id;
  final int round; // 1-5
  final String experimentId;
  final String title; // 「磁石と鉄」
  final String predictionQuestion; // 「くぎは磁石につくかな？」
  final List<String> choices;
  final String correctAnswer;
  final String explanation;

  const PredictionBattleQuestion({
    required this.id,
    required this.round,
    required this.experimentId,
    required this.title,
    required this.predictionQuestion,
    required this.choices,
    required this.correctAnswer,
    required this.explanation,
  });
}

final predictionBattleQuestions = [
  PredictionBattleQuestion(
    id: 'pb_001',
    round: 1,
    experimentId: 'exp_magnet_001',
    title: '磁石と鉄',
    predictionQuestion: 'くぎは磁石につくかな？',
    choices: ['つく', 'つかない', 'わからない'],
    correctAnswer: 'つく',
    explanation:
        '磁石には見えない力があって、くぎなどの鉄をひきつけるんだよ。',
  ),
  PredictionBattleQuestion(
    id: 'pb_002',
    round: 2,
    experimentId: 'exp_metal_heat_001',
    title: 'ガラス管の色水の動き',
    predictionQuestion: '温度が変わると、ガラス管の色水はどう動く？',
    choices: ['上がる', '下がる', 'わからない'],
    correctAnswer: '上がる',
    explanation:
        '温度が高くなると、物質が膨張するから、色水は上に上がるんだよ。',
  ),
  PredictionBattleQuestion(
    id: 'pb_003',
    round: 3,
    experimentId: 'exp_electromagnet_001',
    title: '電磁石の力',
    predictionQuestion: 'コイルの巻数を増やすと、電磁石の力はどうなる？',
    choices: ['強くなる', '弱くなる', 'わからない'],
    correctAnswer: '強くなる',
    explanation:
        'コイルの巻数が多いほど、磁力が強くなるんだよ。',
  ),
  PredictionBattleQuestion(
    id: 'pb_004',
    round: 4,
    experimentId: 'exp_lever_001',
    title: '力のはたらき',
    predictionQuestion: 'てこで重い石を持ち上げるには、どこに支点を置く？',
    choices: [
      '石に近い位置',
      '力を入れる場所に近い位置',
      'わからない',
    ],
    correctAnswer: '力を入れる場所に近い位置',
    explanation:
        '支点が力の場所に近いほど、大きな力が出せるんだね。',
  ),
  PredictionBattleQuestion(
    id: 'pb_005',
    round: 5,
    experimentId: 'exp_ph_001',
    title: '水溶液の性質',
    predictionQuestion: 'お酢は何性かな？',
    choices: [
      '酸性',
      'アルカリ性',
      'わからない',
    ],
    correctAnswer: '酸性',
    explanation:
        'お酢には酸っぱい成分が含まれているから、酸性なんだよ。',
  ),

  // ========== 以降もスケール追加（5問のセットを複数用意）
  // 親子バトル用に、5ラウンドごとに異なる問題セットを準備

  PredictionBattleQuestion(
    id: 'pb_006',
    round: 1,
    experimentId: 'exp_circuit_001',
    title: '電気と回路',
    predictionQuestion: '豆電球を二つつなぐと、電気はどうなるかな？',
    choices: [
      '二つとも通常に光る',
      '二つとも薄く光る',
      'わからない',
    ],
    correctAnswer: '二つとも薄く光る',
    explanation:
        '電気が二つに分かれるから、一つあたりの電気が弱くなるんだね。',
  ),
  PredictionBattleQuestion(
    id: 'pb_007',
    round: 2,
    experimentId: 'exp_metal_heat_001',
    title: '物体の膨張',
    predictionQuestion: 'あたたかくなると、物体は？',
    choices: [
      '膨張する',
      '縮む',
      'わからない',
    ],
    correctAnswer: '膨張する',
    explanation:
        'あたたかいほど、物質の粒子が動きやすくなって、物体が膨張するんだよ。',
  ),
];

// バトル用の便利な関数
List<PredictionBattleQuestion> getBattleQuestionsForRound(int round) {
  return predictionBattleQuestions
      .where((q) => q.round == round)
      .toList();
}

PredictionBattleQuestion? getBattleQuestion(String questionId) {
  try {
    return predictionBattleQuestions
        .firstWhere((q) => q.id == questionId);
  } catch (e) {
    return null;
  }
}

List<PredictionBattleQuestion> getRandomBattleQuestions(int count) {
  final shuffled = List.of(predictionBattleQuestions);
  shuffled.shuffle();
  return shuffled.take(count).toList();
}

// バトル結果判定
class BattleRound {
  final int round;
  final String questionId;
  final String childPrediction;
  final String parentPrediction;
  final String correctAnswer;

  BattleRound({
    required this.round,
    required this.questionId,
    required this.childPrediction,
    required this.parentPrediction,
    required this.correctAnswer,
  });

  bool get childCorrect => childPrediction == correctAnswer;
  bool get parentCorrect => parentPrediction == correctAnswer;

  String get winner {
    if (childCorrect && !parentCorrect) return 'child';
    if (parentCorrect && !childCorrect) return 'parent';
    if (childCorrect && parentCorrect) return 'draw';
    return 'neither'; // どちらも外れ
  }

  int get childScore => childCorrect ? 1 : 0;
  int get parentScore => parentCorrect ? 1 : 0;
}

class BattleResult {
  final List<BattleRound> rounds;
  final int childTotal;
  final int parentTotal;

  BattleResult({
    required this.rounds,
    required this.childTotal,
    required this.parentTotal,
  });

  String get battleWinner =>
      childTotal > parentTotal
          ? 'child'
          : parentTotal > childTotal
          ? 'parent'
          : 'draw';

  String getResultMessage() {
    if (battleWinner == 'child') {
      return 'やったー！子どもの勝ち！🎉';
    } else if (battleWinner == 'parent') {
      return 'お父さん・お母さんの勝ち！さすが！👏';
    } else {
      return '同点！親子で力を合わせた証拠だね！💪';
    }
  }
}
