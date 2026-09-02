/// Quiz Questions 画像メタデータ
/// 各問題に対応する説明図解・図表の参照情報

/// 画像の種類：
/// - diagram: 図解・スキーマ図
/// - chart: グラフ・表
/// - photo: 写真（商用フリー）
/// - experiment: 実験の様子
/// - 3d_model: 3Dモデル・イラスト

class QuizImageMetadata {
  final String questionId; // e.g., "stage_3_001_q1"
  final String imageKeyword; // 画像タグ
  final String imageType; // diagram / chart / photo / experiment / 3d_model
  final String imageDescription; // AI生成用プロンプト説明
  final String? commercialImageUrl; // 商用フリー画像URL（あれば）
  final bool requiresAiGeneration; // AI生成が必要か

  QuizImageMetadata({
    required this.questionId,
    required this.imageKeyword,
    required this.imageType,
    required this.imageDescription,
    this.commercialImageUrl,
    required this.requiresAiGeneration,
  });
}

/// 3年生（Grade 3）の画像メタデータ

// Stage 3_001: 昆虫と植物
final stage3_001_images = [
  QuizImageMetadata(
    questionId: 'stage_3_001_q1',
    imageKeyword: 'insect_body_parts',
    imageType: 'diagram',
    imageDescription: '昆虫の体の3つの部分（頭・胸・腹）をカラフルに表示した図解。バッタやトンボなど複数の昆虫例を横に並べて、同じ構造を強調。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_001_q2',
    imageKeyword: 'plant_root_stem_leaf',
    imageType: 'diagram',
    imageDescription: '植物の構造：根・茎・葉が土の中と地上にどう配置されているかを示す図。色分けして、それぞれの役割を矢印で表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_001_q3',
    imageKeyword: 'dangling_bug_vs_insect',
    imageType: 'diagram',
    imageDescription: 'ダンゴムシと昆虫の脚の本数を比較する図。ダンゴムシ14本、昆虫6本を赤と青で区別して表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_001_q4',
    imageKeyword: 'spider_vs_insect',
    imageType: 'diagram',
    imageDescription: 'クモと昆虫の体の構造比較。クモ2部分（頭胸部・腹部）vs 昆虫3部分（頭・胸・腹）。脚の本数も同時表示（クモ8本、昆虫6本）。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_001_q5',
    imageKeyword: 'ant_colony_workers',
    imageType: 'diagram',
    imageDescription: 'アリの集団を表示。働きアリ（翅なし）と女王アリ・雄アリ（結婚飛行時のみ翅あり）を色分けして表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_001_q6',
    imageKeyword: 'insect_body_structure',
    imageType: 'diagram',
    imageDescription: '昆虫の体の基本構造。頭・胸・腹を明確に分けた側面図と、各部分のズームイン図。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_001_q7',
    imageKeyword: 'compound_eye_detail',
    imageType: 'diagram',
    imageDescription: '昆虫の複眼の詳細図。たくさんの小さなレンズ（個眼）が集まってできている構造を示す。単眼との比較も。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_001_q8',
    imageKeyword: 'ant_wing_behavior',
    imageType: 'diagram',
    imageDescription: 'アリの翅の状態変化：女王アリが結婚飛行で翅を持つ → 地面に降りた後に翅を落とす。プロセスを矢印で表現。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_001_q9',
    imageKeyword: 'pollination_process',
    imageType: 'diagram',
    imageDescription: '昆虫が花を訪れて花粉を運ぶ様子。蜜を吸う昆虫、花粉が体に付く、別の花へ移動して受粉という一連の流れ。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_001_q10',
    imageKeyword: 'antenna_sensor',
    imageType: 'diagram',
    imageDescription: '昆虫の触角の役割。においや空気の流れ、振動を感じるセンサーとして機能していることを示す図。',
    requiresAiGeneration: true,
  ),
];

// Stage 3_005: 磁石のはたらき
final stage3_005_images = [
  QuizImageMetadata(
    questionId: 'stage_3_005_q1',
    imageKeyword: 'magnet_attracts_metals',
    imageType: 'diagram',
    imageDescription: '磁石が引き付ける金属（鉄・ニッケル・コバルト）と引き付けない金属（銅・アルミ・金・銀）を分類して表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_005_q2',
    imageKeyword: 'magnet_poles_attract_repel',
    imageType: 'diagram',
    imageDescription: 'N極とS極：異なる極は引き合う矢印、同じ極は反発する矢印で視覚化。カラフルに、分かりやすく。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_005_q3',
    imageKeyword: 'magnet_interaction',
    imageType: 'diagram',
    imageDescription: '2つの磁石を近づけるシーン。引き合う場合（N-S）と反発する場合（N-N / S-S）を並べて比較。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_005_q4',
    imageKeyword: 'earth_magnetic_field',
    imageType: 'diagram',
    imageDescription: '地球全体が大きな磁石で、北極がS極、南極がN極という説明図。方位磁針のN極が北を向く理由を示す。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_005_q5',
    imageKeyword: 'magnetization_process',
    imageType: 'diagram',
    imageDescription: '鉄が磁石に触れて磁化される過程。その後、加熱や衝撃で磁力を失うプロセス。Before/Afterで表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_005_q6',
    imageKeyword: 'magnet_poles_interaction',
    imageType: 'diagram',
    imageDescription: 'N極・S極の相互作用。日常の応用例（コンパス・モーター・発電機）を小さいアイコンで示す。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_005_q7',
    imageKeyword: 'ferromagnetic_metals',
    imageType: 'diagram',
    imageDescription: '磁性金属（鉄・コバルト・ニッケル）と非磁性金属を元素周期表風に表示。強調色で目立たせる。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_005_q8',
    imageKeyword: 'magnet_cutting',
    imageType: 'diagram',
    imageDescription: '磁石を細かく切った場合。各断片にN極とS極が現れることを示す図。何度切ってもN極とS極は現れ続ける。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_005_q9',
    imageKeyword: 'magnet_metal_separation',
    imageType: 'diagram',
    imageDescription: '混合金属から磁石を使って鉄だけを分別するプロセス。古いアクセサリーや廃棄物の処理例を示す。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_005_q10',
    imageKeyword: 'magnet_field_concept',
    imageType: 'diagram',
    imageDescription: '磁石の周りに見えない力の場（磁場）が広がっていることを示すイメージ図。鉄粉パターンで磁場を可視化。',
    requiresAiGeneration: true,
  ),
];

// ===============================
// 他のステージの画像メタデータもここに追加
// Stage 3_002 〜 3_012
// Stage 4_001 〜 4_011
// Stage 5_001 〜 5_012
// Stage 6_001 〜 6_012
// ===============================

/// 画像メタデータを全ステージから検索するヘルパー関数
Map<String, QuizImageMetadata> getQuizImageMetadata() {
  final allImages = <String, QuizImageMetadata>{};

  // 3年生
  for (final img in stage3_001_images) {
    allImages[img.questionId] = img;
  }
  for (final img in stage3_005_images) {
    allImages[img.questionId] = img;
  }

  // TODO: 他のステージの画像メタデータを追加

  return allImages;
}

/// 特定の問題の画像メタデータを取得
QuizImageMetadata? getImageMetadataForQuestion(String questionId) {
  final all = getQuizImageMetadata();
  return all[questionId];
}
