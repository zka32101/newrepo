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

// Stage 3_002: 植物の育ち（種の発芽・成長）
final stage3002_images = [
  QuizImageMetadata(
    questionId: 'stage_3_002_q1',
    imageKeyword: 'seed_germination_three_conditions',
    imageType: 'diagram',
    imageDescription: '種が発芽するために必要な3つの条件（水・空気・温度）を示す図。各条件の役割を矢印と色で分かりやすく表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_002_q2',
    imageKeyword: 'plant_growth_three_elements',
    imageType: 'diagram',
    imageDescription: '植物の成長に必要な3つの要素（水・光・養分）と、それぞれが植物のどの部分に吸収されるかを示す図。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_002_q3',
    imageKeyword: 'water_management_seed_germination',
    imageType: 'experiment',
    imageDescription: '種に与える水の量を比較する実験。十分な水、少量の水、水なしの3つの条件で種を発芽させた結果を並べて表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_002_q4',
    imageKeyword: 'temperature_seed_germination',
    imageType: 'diagram',
    imageDescription: '温度が種の発芽に与える影響。温度計付きで暖かい環境・常温・冷たい環境での発芽速度の違いを示す。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_002_q5',
    imageKeyword: 'root_gravitropism_downward_growth',
    imageType: 'experiment',
    imageDescription: '根が常に下へ向かって成長する特性（重力屈性）を示す実験。横に置いた種の根が曲がって下へ向かう様子。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_002_q6',
    imageKeyword: 'seed_germination_without_light',
    imageType: 'experiment',
    imageDescription: '暗い場所と明るい場所で種を発芽させた比較。暗い場所でも発芽することを示す実験結果。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_002_q7',
    imageKeyword: 'plant_growth_light_requirement',
    imageType: 'diagram',
    imageDescription: '植物の成長段階と光の必要性。発芽時は光不要、その後の成長には光が必須という流れを示す。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_002_q8',
    imageKeyword: 'cotyledon_vs_true_leaves',
    imageType: 'diagram',
    imageDescription: 'タネの中に入っているの葉（子葉）と、その後出てくる本当の葉（本葉）の形と構造の違いを比較。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_002_q9',
    imageKeyword: 'germination_light_darkness',
    imageType: 'experiment',
    imageDescription: '発芽の速度が光と関係なく、温度と水が重要であることを示す実験。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_002_q10',
    imageKeyword: 'root_geotropism_water_tropism',
    imageType: 'experiment',
    imageDescription: '根が下へ向かい（重力屈性）、水のある方へ向かう（水屈性）性質を示す実験。',
    requiresAiGeneration: true,
  ),
];

// Stage 3_003: チョウの育ち・完全変態
final stage3003_images = [
  QuizImageMetadata(
    questionId: 'stage_3_003_q1',
    imageKeyword: 'butterfly_complete_metamorphosis_stages',
    imageType: 'diagram',
    imageDescription: 'チョウの完全変態の4段階（卵→幼虫→蛹→成虫）を図で表示。時間経過を矢印で示す。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_003_q2',
    imageKeyword: 'butterfly_eggs_observation',
    imageType: 'photo',
    imageDescription: 'チョウの卵の写真。非常に小さく、複雑な模様のある形を詳しく表示。葉の上に産み付けられた卵の配置。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_003_q3',
    imageKeyword: 'butterfly_caterpillar_feeding_growth',
    imageType: 'photo',
    imageDescription: 'チョウの幼虫（毛虫）が葉を食べている様子。幼虫が徐々に大きくなる過程（脱皮）を示す。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_003_q4',
    imageKeyword: 'butterfly_pupa_metamorphosis_inside',
    imageType: 'diagram',
    imageDescription: '蛹の中で起こっている変態の様子。器官が再構成されるプロセスを内部図で表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_003_q5',
    imageKeyword: 'butterfly_eclosion_wing_drying',
    imageType: 'photo',
    imageDescription: '蛹から羽化したばかりのチョウ。羽がまだ湿った状態から、翅が開いて乾く過程を段階的に表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_003_q6',
    imageKeyword: 'insect_metamorphosis_complete_incomplete',
    imageType: 'diagram',
    imageDescription: 'チョウ（完全変態）とバッタ（不完全変態）の違いを比較する図。段階数の違いを視覚的に示す。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_003_q7',
    imageKeyword: 'butterfly_adult_proboscis_nectar_feeding',
    imageType: 'photo',
    imageDescription: 'チョウの成虫が花の蜜を吸う様子。丸まった口（口吻）の構造を詳しく表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_003_q8',
    imageKeyword: 'butterfly_pupa_internal_transformation',
    imageType: 'diagram',
    imageDescription: '蛹の内部での組織再編成を示す。幼虫時代の器官が成虫の器官に変わるプロセス。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_003_q9',
    imageKeyword: 'monarch_caterpillar_host_plant_selection',
    imageType: 'photo',
    imageDescription: 'オオカバマダラの幼虫がトウワタの葉を食べる様子。チョウの幼虫が特定の食草を選ぶ習性。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_003_q10',
    imageKeyword: 'butterfly_wing_scales_microscopic_structure',
    imageType: 'diagram',
    imageDescription: 'チョウの翅の構造。微小な鱗粉（りんぷん）が並んでいる様子を拡大図で表示。',
    requiresAiGeneration: true,
  ),
];

// Stage 3_004: 物と重さ
final stage3004_images = [
  QuizImageMetadata(
    questionId: 'stage_3_004_q1',
    imageKeyword: 'balance_scale_weighing_method',
    imageType: 'experiment',
    imageDescription: 'はかりを使った物の重さ測定方法。砂や水、金属など異なる材質の物をはかりで測定。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_004_q2',
    imageKeyword: 'metal_density_comparison',
    imageType: 'photo',
    imageDescription: '同じ大きさの鉄と銅の重さを比較。密度の違いを視覚的に理解させる。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_004_q3',
    imageKeyword: 'mass_conservation_law_clay',
    imageType: 'experiment',
    imageDescription: '粘土をいろいろな形に変えても、重さは変わらないことを示す実験。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_004_q4',
    imageKeyword: 'accurate_measurement_balance_scale',
    imageType: 'diagram',
    imageDescription: 'はかりの正確な読み方。デジタルはかりと上皿はかりの使い方を示す図。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_004_q5',
    imageKeyword: 'mass_volume_distinction_cotton_iron',
    imageType: 'diagram',
    imageDescription: '同じ重さの綿と鉄の体積の違い。密度の概念を視覚的に表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_004_q6',
    imageKeyword: 'iron_aluminum_density_comparison',
    imageType: 'photo',
    imageDescription: '同じ体積の鉄とアルミニウム。重さの違いから密度の違いを理解する。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_004_q7',
    imageKeyword: 'mass_conservation_clay_shapes',
    imageType: 'experiment',
    imageDescription: 'いろいろな形に変形した粘土。形がどう変わっても質量は変わらないこと。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_004_q8',
    imageKeyword: 'mass_conservation_pulverization',
    imageType: 'experiment',
    imageDescription: '固い物を砕いた場合。粉々にしても全体の重さは変わらないことを実証。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_004_q9',
    imageKeyword: 'spider_insect_leg_count_comparison',
    imageType: 'diagram',
    imageDescription: 'クモ（8本）と昆虫（6本）の脚の本数比較。図解で分かりやすく表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_004_q10',
    imageKeyword: 'mass_conservation_law_fundamental',
    imageType: 'diagram',
    imageDescription: '物質の質量は変わらないという原理を示す。加熱・混合・分割など様々な変化を例に。',
    requiresAiGeneration: true,
  ),
];

// Stage 3_006: ゴムや風の力
final stage3006_images = [
  QuizImageMetadata(
    questionId: 'stage_3_006_q1',
    imageKeyword: 'rubber_band_elastic_force_distance',
    imageType: 'experiment',
    imageDescription: 'ゴム紐を引き伸ばす距離と、それに伴う弾む力（弾性力）の関係を示す。距離が長いほど力が大きい。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_006_q2',
    imageKeyword: 'wind_power_sail_force',
    imageType: 'experiment',
    imageDescription: '帆に当たる風の力を感じさせる実験。同じ風でも帆の面積が大きいほど力が強くなる。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_006_q3',
    imageKeyword: 'compressed_air_elastic_force_projectile',
    imageType: 'experiment',
    imageDescription: '圧縮した空気が放つ力。ストローや吹き矢で物を飛ばす実験。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_006_q4',
    imageKeyword: 'wind_force_sail_utilization',
    imageType: 'diagram',
    imageDescription: '風の力を帆で受けて、物や乗り物を動かす応用例。帆船やウィンドサーフィン、風車。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_006_q5',
    imageKeyword: 'elasticity_elastic_force_springs',
    imageType: 'diagram',
    imageDescription: 'ゴムやバネのような弾性力の性質。引き伸ばしたり圧縮したりするとエネルギーが蓄積される。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_006_q6',
    imageKeyword: 'rubber_band_car_distance_relationship',
    imageType: 'experiment',
    imageDescription: 'ゴム動力の車。ゴムを巻く回数（距離）と車が走る距離の関係を実測。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_006_q7',
    imageKeyword: 'wind_power_force_application',
    imageType: 'photo',
    imageDescription: '風の力を利用した実例。凧、帆、風車など日常の応用例を写真で表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_006_q8',
    imageKeyword: 'compressed_air_pressure_force',
    imageType: 'diagram',
    imageDescription: '空気を圧縮したときの圧力と力の関係。圧縮の度合いと力の大きさの比例関係。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_006_q9',
    imageKeyword: 'elasticity_elastic_vs_plastic_deformation',
    imageType: 'diagram',
    imageDescription: 'ゴムのような弾性変形と、粘土のような塑性変形の違いを示す。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_006_q10',
    imageKeyword: 'wind_power_generation_turbine',
    imageType: 'photo',
    imageDescription: '風力発電の風車。風の力を電気エネルギーに変える仕組みを示す。',
    requiresAiGeneration: true,
  ),
];

// Stage 3_007: 太陽と地面の様子
final stage3007_images = [
  QuizImageMetadata(
    questionId: 'stage_3_007_q1',
    imageKeyword: 'sun_movement_east_west_earth_rotation',
    imageType: 'diagram',
    imageDescription: '太陽が東から西へ移動して見える理由。地球の自転によるものであることを示す図。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_007_q2',
    imageKeyword: 'day_night_length_seasonal_variation',
    imageType: 'diagram',
    imageDescription: '季節による昼と夜の長さの変化。春分・夏至・秋分・冬至での日中の長さの違い。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_007_q3',
    imageKeyword: 'shadow_length_sun_angle_position',
    imageType: 'experiment',
    imageDescription: '影の長さと太陽の高さの関係。朝・昼・夕方で影の長さが変わる実験。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_007_q4',
    imageKeyword: 'shadow_direction_opposite_sun',
    imageType: 'diagram',
    imageDescription: '影が太陽と反対方向にできることを示す図。太陽の位置と影の方向の関係。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_007_q5',
    imageKeyword: 'solar_radiation_ground_heating_air',
    imageType: 'diagram',
    imageDescription: '太陽の熱放射が地面を温める→地面から熱が放射される→空気が温まるプロセス。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_007_q6',
    imageKeyword: 'angle_of_incidence_solar_heating',
    imageType: 'diagram',
    imageDescription: '太陽の入射角と地面の加熱効率の関係。垂直に当たるほど効率的に加熱される。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_007_q7',
    imageKeyword: 'winter_sun_low_angle_short_daylight',
    imageType: 'diagram',
    imageDescription: '冬の太陽が低い角度にあることで、昼が短く、地面を効率的に温められないことを示す。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_007_q8',
    imageKeyword: 'daytime_nighttime_temperature_solar_energy',
    imageType: 'diagram',
    imageDescription: '太陽が照っている間は地面が温まり、夜間は冷える温度変化。エネルギー源が太陽であることを示す。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_007_q9',
    imageKeyword: 'sand_surface_temperature_absorption',
    imageType: 'photo',
    imageDescription: '砂と石の表面温度の違い。砂が石より温まりやすく冷めやすい性質を比較。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_007_q10',
    imageKeyword: 'stone_heat_retention_thermal_capacity',
    imageType: 'photo',
    imageDescription: '石が砂より冷めにくい性質。熱容量の違いを示す実験。',
    requiresAiGeneration: true,
  ),
];

// Stage 3_008: むし（昆虫）・くもの特徴と行動
final stage3008_images = [
  QuizImageMetadata(
    questionId: 'stage_3_008_q1',
    imageKeyword: 'insect_body_three_parts_head_thorax_abdomen',
    imageType: 'diagram',
    imageDescription: '昆虫の体の3つの部分（頭・胸・腹）をカラフルに表示。複数の昆虫例（バッタ・トンボ）を横に並べて構造を比較。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_008_q2',
    imageKeyword: 'spider_vs_insect_body_legs_comparison',
    imageType: 'diagram',
    imageDescription: 'クモと昆虫の体の構造と脚の本数を比較する図。クモ8本、昆虫6本を色分けして明確に区別。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_008_q3',
    imageKeyword: 'insect_compound_eye_structure_ommatidia',
    imageType: 'diagram',
    imageDescription: '昆虫の複眼の拡大図。多くの小さなレンズ（個眼）が集まった構造を示す。単眼との違いも表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_008_q4',
    imageKeyword: 'insect_antenna_sensory_organ',
    imageType: 'diagram',
    imageDescription: '昆虫の触角の役割を示す図。におい・空気の流れ・振動を感じるセンサーとしての機能を矢印で表現。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_008_q5',
    imageKeyword: 'pollination_insect_flower_symbiosis',
    imageType: 'diagram',
    imageDescription: '昆虫が花を訪れて花粉を運ぶプロセス。蜜を吸う→花粉が体に付く→別の花へ移動という流れを矢印で示す。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_008_q6',
    imageKeyword: 'insect_hunting_defense_behavior',
    imageType: 'photo',
    imageDescription: 'カマキリやテントウムシなど、狩りや防御行動を示す昆虫の写真。捕食者と被食者の関係を視覚的に表現。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_008_q7',
    imageKeyword: 'seasonal_insect_behavior_cycles',
    imageType: 'diagram',
    imageDescription: '季節による昆虫の行動変化。春の活発な活動→夏の繁殖→秋の準備→冬の休眠というサイクルを時系列で表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_008_q8',
    imageKeyword: 'spider_web_structure_silk_properties',
    imageType: 'photo',
    imageDescription: 'クモの巣の複雑な構造と几何学的な美しさ。シルクの強度と伸縮性を示す写真と図解。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_008_q9',
    imageKeyword: 'insect_metamorphosis_lifecycle_stages',
    imageType: 'diagram',
    imageDescription: '昆虫の完全変態（卵→幼虫→蛹→成虫）の4段階を図で表示。段階ごとの特徴を色分けして示す。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_3_008_q10',
    imageKeyword: 'insect_behavior_instinct_learning',
    imageType: 'diagram',
    imageDescription: '昆虫の本能的行動と学習による行動の違いを示す比較図。例：蜜蜂の集団行動と学習。',
    requiresAiGeneration: true,
  ),
];

// Stage 4_001: 骨と筋肉
final stage4001_images = [
  QuizImageMetadata(
    questionId: 'stage_4_001_q1',
    imageKeyword: 'bone_structure_support_function',
    imageType: 'diagram',
    imageDescription: '骨の基本構造（皮質骨・海綿骨・骨髄）と支持機能を示す図。複数の骨の例を並べて比較。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_001_q2',
    imageKeyword: 'muscle_contraction_types',
    imageType: 'diagram',
    imageDescription: '筋肉の伸縮（収縮・弛緩）のプロセス。随意筋と不随意筋の違いを図で表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_001_q3',
    imageKeyword: 'joint_types_movement',
    imageType: 'diagram',
    imageDescription: '関節の種類（ヒンジ関節・球関節など）と可動域を示す図。各関節タイプの動き例。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_001_q4',
    imageKeyword: 'tendon_muscle_bone_connection',
    imageType: 'diagram',
    imageDescription: '腱が筋肉と骨をつなぐ構造。伸縮時の変化を矢印で表現。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_001_q5',
    imageKeyword: 'bone_growth_plate_development',
    imageType: 'diagram',
    imageDescription: '成長期の骨の成長板と成長プロセス。子どもと大人の骨の違い。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_001_q6',
    imageKeyword: 'vertebral_column_structure',
    imageType: 'diagram',
    imageDescription: '脊椎骨の構造と配列。各部位の名称と機能を色分けして表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_001_q7',
    imageKeyword: 'rib_cage_protection_breathing',
    imageType: 'diagram',
    imageDescription: '肋骨かごの構造と呼吸時の動き。保護機能を矢印で表現。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_001_q8',
    imageKeyword: 'brain_nerve_muscle_coordination',
    imageType: 'diagram',
    imageDescription: '脳→神経→筋肉という信号伝達のプロセス。情報経路を視覚的に示す。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_001_q9',
    imageKeyword: 'nutrition_bone_muscle_health',
    imageType: 'diagram',
    imageDescription: 'カルシウム・タンパク質など骨と筋肉に必要な栄養素。食べ物の例を示す。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_001_q10',
    imageKeyword: 'bone_muscle_injury_prevention',
    imageType: 'photo',
    imageDescription: '骨折予防・筋肉損傷予防の実践例。運動時の正しい姿勢と装具の使用。',
    requiresAiGeneration: true,
  ),
];

// Stage 4_002: 電気（豆電球・乾電池）
final stage4002_images = [
  QuizImageMetadata(
    questionId: 'stage_4_002_q1',
    imageKeyword: 'electric_current_electron_flow',
    imageType: 'diagram',
    imageDescription: '電流は電子の流れを示す図。導体内の電子の動きを矢印で表現。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_002_q2',
    imageKeyword: 'circuit_open_closed_path',
    imageType: 'diagram',
    imageDescription: '開いた回路と閉じた回路の違い。閉じた回路での電流の流れを矢印で示す。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_002_q3',
    imageKeyword: 'conductor_insulator_materials',
    imageType: 'diagram',
    imageDescription: '導体と絶縁体の物質例。銅・鉄などの導体とゴム・プラスチックの絶縁体を色分けして表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_002_q4',
    imageKeyword: 'voltage_current_ohm_law',
    imageType: 'diagram',
    imageDescription: '電圧・電流・抵抗の関係式（オームの法則）と具体例。グラフで視覚化。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_002_q5',
    imageKeyword: 'series_circuit_configuration',
    imageType: 'diagram',
    imageDescription: '直列回路の構成図。豆電球が順番に配置され、1つ切れると全部消えることを示す。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_002_q6',
    imageKeyword: 'parallel_circuit_configuration',
    imageType: 'diagram',
    imageDescription: '並列回路の構成図。豆電球が並んで配置され、1つ切れても他が点灯することを示す。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_002_q7',
    imageKeyword: 'switch_circuit_control',
    imageType: 'diagram',
    imageDescription: 'スイッチが開く・閉じるときの回路の状態変化。接点と切断を矢印で表現。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_002_q8',
    imageKeyword: 'electrical_resistance_heat_generation',
    imageType: 'diagram',
    imageDescription: '抵抗が電気エネルギーを熱に変える仕組み。ニクロム線の例。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_002_q9',
    imageKeyword: 'short_circuit_hazard_prevention',
    imageType: 'diagram',
    imageDescription: '短絡（ショート）の危険性を示す図。正しい接続と危険な接続を比較。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_002_q10',
    imageKeyword: 'energy_conversion_electricity',
    imageType: 'diagram',
    imageDescription: '電気エネルギーから他のエネルギーへの変換。光・熱・音などの例。',
    requiresAiGeneration: true,
  ),
];

// Stage 4_003: 空気（温度・空気の膨張）
final stage4003_images = [
  QuizImageMetadata(
    questionId: 'stage_4_003_q1',
    imageKeyword: 'air_composition_properties',
    imageType: 'diagram',
    imageDescription: '空気の組成（窒素・酸素・その他）を円グラフで表示。各成分の役割を説明。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_003_q2',
    imageKeyword: 'temperature_measurement_scale',
    imageType: 'diagram',
    imageDescription: '温度計の読み方と摂氏スケール。様々な温度計（液体温度計・デジタル）の使い方。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_003_q3',
    imageKeyword: 'air_thermal_expansion_volume',
    imageType: 'diagram',
    imageDescription: '気体の熱膨張。温めた空気が膨張し、冷めると縮む過程を矢印で示す。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_003_q4',
    imageKeyword: 'gas_molecular_motion_theory',
    imageType: 'diagram',
    imageDescription: 'ボイル・シャルルの法則。分子の動きと温度・圧力の関係を微視的に表現。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_003_q5',
    imageKeyword: 'atmospheric_pressure_altitude',
    imageType: 'diagram',
    imageDescription: '大気圧が高度によって変わることを示すグラフ。気圧計での測定例。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_003_q6',
    imageKeyword: 'convection_circulation_patterns',
    imageType: 'diagram',
    imageDescription: '対流のプロセス。温かい空気が上昇し、冷たい空気が降下する循環を矢印で表現。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_003_q7',
    imageKeyword: 'condensation_dew_point_formation',
    imageType: 'diagram',
    imageDescription: '結露のメカニズム。空気中の水蒸気が液体の水に変わるプロセス。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_003_q8',
    imageKeyword: 'humidity_water_vapor_measurement',
    imageType: 'diagram',
    imageDescription: '湿度と絶対湿度の概念。湿度計での測定方法を図で表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_003_q9',
    imageKeyword: 'wind_formation_pressure_difference',
    imageType: 'diagram',
    imageDescription: '風の発生原因。気圧差による空気の流れを等圧線図で表現。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_003_q10',
    imageKeyword: 'air_atmosphere_life_environment',
    imageType: 'diagram',
    imageDescription: '大気が生命を支える役割。温度調節・保護機能・呼吸などを示す。',
    requiresAiGeneration: true,
  ),
];

// Stage 4_004: 食べたものの移動と変化 (Food Digestion and Movement)
final stage4004_images = [
  QuizImageMetadata(
    questionId: 'stage_4_004_q1',
    imageKeyword: 'digestive_system_overview_organs',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_004_q2',
    imageKeyword: 'teeth_types_cutting_molars_grinding',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_004_q3',
    imageKeyword: 'saliva_enzyme_amylase_action',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_004_q4',
    imageKeyword: 'esophageal_peristalsis_muscle_wave',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_004_q5',
    imageKeyword: 'stomach_food_churning_gastric_juice',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_004_q6',
    imageKeyword: 'gastric_acid_protein_breakdown_hcl',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_004_q7',
    imageKeyword: 'small_intestine_villi_nutrient_absorption',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_004_q8',
    imageKeyword: 'large_intestine_water_reabsorption_stool',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_004_q9',
    imageKeyword: 'liver_pancreas_enzyme_bile_secretion',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_004_q10',
    imageKeyword: 'food_digestion_timeline_complete_journey',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
];

// Stage 4_005: 金属，水，空気と温度 (Metals, Water, Air and Temperature)
final stage4005_images = [
  QuizImageMetadata(
    questionId: 'stage_4_005_q1',
    imageKeyword: 'hot_metal_pot_handle_steam',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_005_q2',
    imageKeyword: 'metal_railway_tracks_expansion_gap',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_005_q3',
    imageKeyword: 'thermal_expansion_metal_ball_ring',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_005_q4',
    imageKeyword: 'water_convection_currents_pot_boiling',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_005_q5',
    imageKeyword: 'ice_cube_melting_to_liquid_water',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_005_q6',
    imageKeyword: 'hot_air_balloon_lifting_off_clouds',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_005_q7',
    imageKeyword: 'car_tire_pressure_gauge_heat',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_005_q8',
    imageKeyword: 'pressure_cooker_steam_cooking',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_005_q9',
    imageKeyword: 'thermometer_temperature_reading_liquid',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_005_q10',
    imageKeyword: 'building_expansion_joint_flexibility',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
];

// Stage 4_006: 月と星 (Moon and Stars)
final stage4006_images = [
  QuizImageMetadata(
    questionId: 'stage_4_006_q1',
    imageKeyword: 'moon_phases_cycle_lunar_calendar',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_006_q2',
    imageKeyword: 'earth_moon_sun_geometry_orbit',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_006_q3',
    imageKeyword: 'moon_surface_craters_maria_highlands',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_006_q4',
    imageKeyword: 'full_moon_night_sky_bright_silver',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_006_q5',
    imageKeyword: 'lunar_cycle_29_days_waxing_waning',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_006_q6',
    imageKeyword: 'stars_constellations_orion_big_dipper',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_006_q7',
    imageKeyword: 'moon_tides_ocean_gravity_effect',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_006_q8',
    imageKeyword: 'star_colors_temperature_blue_red_yellow',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_006_q9',
    imageKeyword: 'earth_rotation_night_sky_stars_movement',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_006_q10',
    imageKeyword: 'moon_crescent_phases_shadow_geometry',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
];

// Stage 4_007: 天気と季節 (Weather and Seasons)
final stage4007_images = [
  QuizImageMetadata(
    questionId: 'stage_4_007_q1',
    imageKeyword: 'temperature_thermometer_four_seasons_gradual_change',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_007_q2',
    imageKeyword: 'sunrise_sunset_sun_path_angle_seasonal_variation',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_007_q3',
    imageKeyword: 'cumulus_stratus_cirrus_cloud_types_sky',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_007_q4',
    imageKeyword: 'rain_formation_water_cycle_precipitation_drops',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_007_q5',
    imageKeyword: 'wind_formation_air_pressure_temperature_gradient',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_007_q6',
    imageKeyword: 'monsoon_seasonal_wind_patterns_weather_arrows',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_007_q7',
    imageKeyword: 'humidity_dew_condensation_water_vapor_droplets',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_007_q8',
    imageKeyword: 'animal_migration_hibernation_seasonal_behavior_nature',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_007_q9',
    imageKeyword: 'weather_map_high_pressure_low_pressure_symbols',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_007_q10',
    imageKeyword: 'spring_summer_autumn_winter_seasonal_landscape_changes',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
];

// Stage 4_008: 物の動きと力 (Motion and Force)
final stage4008_images = [
  QuizImageMetadata(
    questionId: 'stage_4_008_q1',
    imageKeyword: 'force_push_pull_action_examples',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_008_q2',
    imageKeyword: 'object_motion_velocity_direction_change',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_008_q3',
    imageKeyword: 'friction_surface_resistance_brake_force',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_008_q4',
    imageKeyword: 'weight_mass_scale_measurement_gravity',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_008_q5',
    imageKeyword: 'gravity_falling_object_earth_attraction',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_008_q6',
    imageKeyword: 'speed_velocity_speedometer_direction_vector',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_008_q7',
    imageKeyword: 'motion_acceleration_car_turning_elevator',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_008_q8',
    imageKeyword: 'lever_principle_seesaw_mechanical_advantage',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_008_q9',
    imageKeyword: 'pulley_system_rope_mechanical_load',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_008_q10',
    imageKeyword: 'collision_impact_momentum_ball_crash',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
];

// Stage 4_009: 光 (Light)
final stage4009_images = [
  QuizImageMetadata(
    questionId: 'stage_4_009_q1',
    imageKeyword: 'light_source_sun_fire_bulb_emission',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_009_q2',
    imageKeyword: 'light_travel_straight_line_path_rays',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_009_q3',
    imageKeyword: 'shadow_formation_light_blocking_object',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_009_q4',
    imageKeyword: 'shadow_length_change_sun_angle_time',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_009_q5',
    imageKeyword: 'mirror_reflection_plane_surface_angle',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_009_q6',
    imageKeyword: 'light_refraction_lens_bending_angle',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_009_q7',
    imageKeyword: 'lens_converging_diverging_focus_image',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_009_q8',
    imageKeyword: 'color_spectrum_prism_wavelength_visible',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_009_q9',
    imageKeyword: 'transparent_translucent_opaque_materials_light',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_4_009_q10',
    imageKeyword: 'eye_vision_light_pupil_retina_image',
    imageType: 'diagram',
    imageDescription: '',
    requiresAiGeneration: true,
  ),
];

/// 5年生（Grade 5）の画像メタデータ

// Stage 5_001: 花から実へ
final stage5_001_images = [
  QuizImageMetadata(
    questionId: 'stage_5_001_q1',
    imageKeyword: 'flower_parts_stamen_pistil',
    imageType: 'diagram',
    imageDescription: '花の構造：おしべ（雄性器官）とめしべ（雌性器官）を詳しく示す図。花粉の形成と子房の位置を色分けして表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_001_q2',
    imageKeyword: 'pollination_stigma_process',
    imageType: 'diagram',
    imageDescription: '受粉のプロセス：花粉が柱頭に付着する様子。虫と風による受粉の2つのパターンを比較表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_001_q3',
    imageKeyword: 'fruit_development_ovary',
    imageType: 'diagram',
    imageDescription: '受粉後から実への変化。子房が膨らんで実になる過程を時系列で表示。果皮の形成も示す。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_001_q4',
    imageKeyword: 'seed_embryo_structure',
    imageType: 'diagram',
    imageDescription: '種の内部構造：種皮、胚、胚乳を示す断面図。受精した胚珠が種になる過程。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_001_q5',
    imageKeyword: 'seed_reproduction_genetics',
    imageType: 'diagram',
    imageDescription: '種ができる意義：受精による遺伝情報の組み合わせ。親の特性が子に継承されることを矢印で表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_001_q6',
    imageKeyword: 'flower_pollination_strategies',
    imageType: 'diagram',
    imageDescription: '花の特性と受粉方法の関係。虫を引き寄せる花（色・香り・蜜）vs 風による受粉の花を比較。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_001_q7',
    imageKeyword: 'pollination_methods_insect_wind',
    imageType: 'diagram',
    imageDescription: '虫による受粉と風による受粉のメカニズム。虫が蜜を吸う時の花粉付着と風での花粉運搬を対比。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_001_q8',
    imageKeyword: 'fruit_structure_layers',
    imageType: 'diagram',
    imageDescription: '実の構造：果皮（外側）・果肉（中身）・種を層状に表示。様々な果実の例（スイカ、モモ、豆）を並べて比較。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_001_q9',
    imageKeyword: 'seed_dispersal_methods',
    imageType: 'diagram',
    imageDescription: '種の散布方法：風で運ばれる種（羽毛）、動物が食べて運ぶ種、水に浮かぶ種、粘着性で付着する種を図示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_001_q10',
    imageKeyword: 'seed_dispersal_adaptation',
    imageType: 'diagram',
    imageDescription: '種の形態と散布方法の適応。各種の形状（タンポポの羽毛、ココナッツの繊維など）と環境への最適化を示す。',
    requiresAiGeneration: true,
  ),
];

// Stage 5_002: 植物の発芽と成長
final stage5_002_images = [
  QuizImageMetadata(
    questionId: 'stage_5_002_q1',
    imageKeyword: 'seed_germination_conditions',
    imageType: 'diagram',
    imageDescription: '種の発芽に必要な条件（水・温度・空気）を3つのグループに分けて表示。各条件が揃わない場合との比較。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_002_q2',
    imageKeyword: 'germination_root_shoot',
    imageType: 'diagram',
    imageDescription: '発芽の過程：種から根と芽が出る様子。根が下へ、芽が上へ向かう性質（地性弾性・光性）を矢印で表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_002_q3',
    imageKeyword: 'root_shoot_development',
    imageType: 'diagram',
    imageDescription: '根と芽の成長：根が地中で伸び、根毛から水と栄養を吸収。茎が上に伸び、葉が展開する過程を時系列で表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_002_q4',
    imageKeyword: 'photosynthesis_leaf_process',
    imageType: 'diagram',
    imageDescription: '光合成の仕組み：葉が太陽光を受けて、水と二酸化炭素から栄養（デンプン）を作る過程を示す図。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_002_q5',
    imageKeyword: 'chlorophyll_green_leaf',
    imageType: 'diagram',
    imageDescription: '葉の緑色と光合成の関係。クロロフィル（葉緑体）が光を吸収する仕組み。様々な色の葉（黄、赤）との比較。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_002_q6',
    imageKeyword: 'plant_nutrition_water_minerals',
    imageType: 'diagram',
    imageDescription: '植物の栄養：根から吸収する水と無機塩類。光合成で作られた栄養との違いを示す流れ図。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_002_q7',
    imageKeyword: 'root_hair_absorption',
    imageType: 'diagram',
    imageDescription: '根毛による水と栄養の吸収：根毛の構造と吸収のメカニズム。土の中の水が根毛から吸い上げられる様子。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_002_q8',
    imageKeyword: 'phototropism_geotropism',
    imageType: 'diagram',
    imageDescription: '光性と地性：茎が光に向かう光性、根が土に向かう地性を示す。植物の生長の方向性を矢印で表現。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_002_q9',
    imageKeyword: 'plant_growth_stages_time',
    imageType: 'chart',
    imageDescription: '植物の成長段階：発芽 → 本葉展開 → 成長 → 開花 → 結実を時間軸で表示。季節ごとの成長の変化。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_002_q10',
    imageKeyword: 'plant_life_cycle_seasons',
    imageType: 'diagram',
    imageDescription: '植物のライフサイクル：種の休眠から発芽、成長、開花、種の形成、再び休眠までの完全な周期。',
    requiresAiGeneration: true,
  ),
];

// Stage 5_003: メダカの育ち方
final stage5_003_images = [
  QuizImageMetadata(
    questionId: 'stage_5_003_q1',
    imageKeyword: 'medaka_egg_laying_structure',
    imageType: 'diagram',
    imageDescription: 'メダカの卵：水草に産み付けられた卵。卵の大きさ（3-5mm）、透明性、粘着糸の構造を詳しく示す。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_003_q2',
    imageKeyword: 'egg_structure_internal',
    imageType: 'diagram',
    imageDescription: 'メダカの卵の内部構造：卵黄、胚、卵殻膜を示す断面図。受精卵の発育段階の違いを3段階で表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_003_q3',
    imageKeyword: 'egg_hatching_temperature',
    imageType: 'chart',
    imageDescription: '孵化までの時間と温度の関係。25℃で約10-14日、20℃で約3週間など、温度による孵化期間の変化をグラフ表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_003_q4',
    imageKeyword: 'fry_development_stages',
    imageType: 'diagram',
    imageDescription: '稚魚の発育段階：孵化直後（3-4mm）のヨークサック付き稚魚から、ヨークサック消失、鰭の発達までの時系列。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_003_q5',
    imageKeyword: 'medaka_sex_differences_fin',
    imageType: 'diagram',
    imageDescription: 'メダカのオスとメスの識別：背鰭と肛門周辺の違い。オスは背鰭が尖り、メスは丸い形状を図示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_003_q6',
    imageKeyword: 'fish_growth_juvenile_adult',
    imageType: 'diagram',
    imageDescription: '幼魚から成魚への成長：体長の増加（稚魚3mm → 幼魚1cm → 成魚3-4cm）と体形の変化を時系列で表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_003_q7',
    imageKeyword: 'medaka_spawning_season',
    imageType: 'chart',
    imageDescription: 'メダカの産卵時期：5月〜7月の産卵期間。水温25℃前後と日中の光周期（昼間時間の長さ）が産卵を促すことを図示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_003_q8',
    imageKeyword: 'failed_hatching_causes',
    imageType: 'diagram',
    imageDescription: '孵化に失敗する原因：未受精卵、低温、カビ感染、酸素不足。各原因による卵の状態（変色、分解など）の違い。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_003_q9',
    imageKeyword: 'fish_lifespan_aging',
    imageType: 'chart',
    imageDescription: 'メダカの寿命と年齢による変化：1〜3年の寿命。体色の変化、活動量の減少、エネルギー消費量を時系列で表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_003_q10',
    imageKeyword: 'medaka_lifecycle_complete',
    imageType: 'diagram',
    imageDescription: 'メダカの完全なライフサイクル：卵 → 孵化 → 稚魚 → 幼魚 → 成魚 → 産卵 → 老化 → 死亡。環状の図で示す。',
    requiresAiGeneration: true,
  ),
];

// Stage 5_004: 川の水の様子
final stage5_004_images = [
  QuizImageMetadata(
    questionId: 'stage_5_004_q1',
    imageKeyword: 'river_upstream_characteristics',
    imageType: 'diagram',
    imageDescription: '上流域の川の特徴：狭い幅、急な勾配、速い流れ、透明な水、大きな石を示す図。V字谷の形状。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_004_q2',
    imageKeyword: 'river_middle_course_features',
    imageType: 'diagram',
    imageDescription: '中流域の川：幅が広がり、勾配が緩くなり、流速は減少。砂利床が見られる。蛇行し始める様子。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_004_q3',
    imageKeyword: 'river_lower_course_delta',
    imageType: 'diagram',
    imageDescription: '下流域の川：広い幅、緩い勾配、遅い流速、濁った水。三角州の形成。河口への流れ。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_004_q4',
    imageKeyword: 'river_organisms_adaptation',
    imageType: 'diagram',
    imageDescription: '川に住む生き物の適応：上流（トビケラ、カワゲラ）から下流（ハマシジミ）までの生物分布。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_004_q5',
    imageKeyword: 'stream_organisms_zones',
    imageType: 'chart',
    imageDescription: '流速と生き物の関係：速い流速に適応した生き物と遅い流速に適応した生き物の違い。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_004_q6',
    imageKeyword: 'flow_velocity_erosion_power',
    imageType: 'chart',
    imageDescription: '流速と侵食力の関係：流速が2倍になると侵食力は4倍（二乗則）。グラフで表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_004_q7',
    imageKeyword: 'slow_flow_deposition',
    imageType: 'diagram',
    imageDescription: '流速が遅いときの堆積：砂や泥が底に落ちて積もる。下流域での平原形成を示す。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_004_q8',
    imageKeyword: 'sediment_particle_settling',
    imageType: 'diagram',
    imageDescription: '粒の大きさと沈むスピード：大きい粒は早く沈み、小さい粒はゆっくり沈む。ストークスの法則。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_004_q9',
    imageKeyword: 'grain_size_downstream',
    imageType: 'chart',
    imageDescription: '下流に向かての粒のサイズ変化：上流の大きな石から中流の砂利、下流の砂へ。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_004_q10',
    imageKeyword: 'river_system_integration',
    imageType: 'diagram',
    imageDescription: '川全体の統合的理解：侵食、運搬、堆積の3つのプロセスが上流から下流へ連続的に起こる。',
    requiresAiGeneration: true,
  ),
];

// Stage 5_005: 流水のはたらき
final stage5_005_images = [
  QuizImageMetadata(
    questionId: 'stage_5_005_q1',
    imageKeyword: 'water_erosion_velocity_relationship',
    imageType: 'diagram',
    imageDescription: '川の水による侵食：流速が速いほど侵食力が強い。崖の侵食、地面の削られる様子。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_005_q2',
    imageKeyword: 'water_transport_sediment',
    imageType: 'diagram',
    imageDescription: '川による運搬：岩石片や砂、泥が水に流されて下流へ運ばれる過程。濁流の形成。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_005_q3',
    imageKeyword: 'sediment_deposition_process',
    imageType: 'diagram',
    imageDescription: '堆積：流速が落ちると砂や泥が底に沈んで積もる。氾濫原での土壌形成。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_005_q4',
    imageKeyword: 'v_shaped_valley_erosion',
    imageType: 'diagram',
    imageDescription: 'V字谷の形成：上流域の急流が両岸を削って、V字形の谷を作る過程。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_005_q5',
    imageKeyword: 'river_delta_formation',
    imageType: 'diagram',
    imageDescription: '三角州の形成：下流で流速が落ちると、粒子が積もって平らな土地ができる。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_005_q6',
    imageKeyword: 'flow_velocity_erosion_power_law',
    imageType: 'chart',
    imageDescription: '流速の二乗則：流速が2倍になると侵食力は4倍。エネルギー効率の関係。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_005_q7',
    imageKeyword: 'deposition_low_velocity',
    imageType: 'diagram',
    imageDescription: '低流速での堆積：流速が遅い下流域で、細かい粒（砂・泥）が沈みやすい。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_005_q8',
    imageKeyword: 'stokes_law_settling_speed',
    imageType: 'diagram',
    imageDescription: 'ストークスの法則：粒の大きさと落ちる速度の関係。直径が小さいほど遅くなる。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_005_q9',
    imageKeyword: 'downstream_grain_reduction',
    imageType: 'chart',
    imageDescription: '下流への粒のサイズ減少：上流の巨礫から下流の砂泥へ段階的に変化。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_005_q10',
    imageKeyword: 'three_processes_integration',
    imageType: 'diagram',
    imageDescription: '3つのはたらきの統合：侵食・運搬・堆積が上流から下流へ連続して起こる景観。',
    requiresAiGeneration: true,
  ),
];

// Stage 5_006: 物の燃え方
final stage5_006_images = [
  QuizImageMetadata(
    questionId: 'stage_5_006_q1',
    imageKeyword: 'combustion_three_conditions',
    imageType: 'diagram',
    imageDescription: '燃焼の3つの条件：燃えるもの（可燃物）、酸素、加熱。3つ全て揃う必要。ベン図で表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_006_q2',
    imageKeyword: 'flammable_materials_examples',
    imageType: 'diagram',
    imageDescription: '燃えるもの（可燃物）の例：ろうそく、木、紙、石油、ガスなど。状態による違い。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_006_q3',
    imageKeyword: 'oxygen_role_combustion',
    imageType: 'diagram',
    imageDescription: '酸素の役割：燃焼に必要な酸素。空気中の酸素（約21%）が燃焼を支える。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_006_q4',
    imageKeyword: 'ignition_temperature_point',
    imageType: 'chart',
    imageDescription: '着火点（点火温度）：物質ごとに異なる。ろうの着火点、木の着火点、ガスの着火点。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_006_q5',
    imageKeyword: 'combustion_products_ash',
    imageType: 'diagram',
    imageDescription: '燃焼の生成物：灰、二酸化炭素、水蒸気。完全燃焼と不完全燃焼の違い。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_006_q6',
    imageKeyword: 'carbon_dioxide_emission',
    imageType: 'diagram',
    imageDescription: 'CO₂の発生：燃料が燃えると二酸化炭素が生成される。温暖化への影響。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_006_q7',
    imageKeyword: 'chemical_vs_physical_change',
    imageType: 'diagram',
    imageDescription: '化学変化：燃焼は化学変化。物質の成分が変わり、元に戻らない。物理変化との違い。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_006_q8',
    imageKeyword: 'combustion_reaction_principle',
    imageType: 'diagram',
    imageDescription: '燃焼の化学反応：可燃物＋酸素→熱＋灰＋ガス。エネルギー放出の化学反応。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_006_q9',
    imageKeyword: 'fire_extinguishing_methods',
    imageType: 'diagram',
    imageDescription: '消火方法：燃焼の3条件のいずれかを取り除く。冷却、酸素遮断、可燃物除去。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_006_q10',
    imageKeyword: 'combustion_environmental_impact',
    imageType: 'diagram',
    imageDescription: '燃焼と環境：化石燃料の燃焼によるCO₂増加と地球温暖化。持続可能なエネルギーの必要性。',
    requiresAiGeneration: true,
  ),
];

// Stage 5_007: 電流と磁石
final stage5_007_images = [
  QuizImageMetadata(
    questionId: 'stage_5_007_q1',
    imageKeyword: 'electromagnet_vs_permanent',
    imageType: 'diagram',
    imageDescription: '電磁石と常温磁石の違い：電池がある電磁石は電源で操作でき、常温磁石は電気なしで常に磁力を持つ。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_007_q2',
    imageKeyword: 'strengthen_electromagnet',
    imageType: 'diagram',
    imageDescription: '電磁石を強くする方法：電流を増やす、コイルの巻き数を増やす、鉄芯を使う。比較図で表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_007_q3',
    imageKeyword: 'electromagnet_applications',
    imageType: 'diagram',
    imageDescription: '電磁石の使われ方：スクラップクレーン、MRI機器、リニアモーターカー、電子レンジ。実例を図示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_007_q4',
    imageKeyword: 'magnetic_switches_circuits',
    imageType: 'diagram',
    imageDescription: '磁石の利用：スイッチ、制御回路。改札機、自動販売機、洗濯機での使用例。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_007_q5',
    imageKeyword: 'magnetic_field_visualization',
    imageType: 'diagram',
    imageDescription: '磁場の見える化：MRI、地磁気観測、スピーカーの磁場。磁力線図で表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_007_q6',
    imageKeyword: 'current_magnetic_force',
    imageType: 'diagram',
    imageDescription: '電流と磁力の関係：調光スイッチ、モーター制御、電動工具での応用。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_007_q7',
    imageKeyword: 'coil_systems_applications',
    imageType: 'diagram',
    imageDescription: '複数コイルの利用：変圧器、電動モーター、IH調理器。相互誘導の原理。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_007_q8',
    imageKeyword: 'dc_vs_ac_current',
    imageType: 'diagram',
    imageDescription: '直流と交流の違い：懐中電灯（直流）とコンセント（交流）。波形と用途の比較。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_007_q9',
    imageKeyword: 'radio_waves_electromagnets',
    imageType: 'diagram',
    imageDescription: 'ラジオと電磁波：ラジオ、テレビ、携帯電話、Wi-Fi。電磁波の種類と周波数。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_007_q10',
    imageKeyword: 'modern_technology_applications',
    imageType: 'diagram',
    imageDescription: '現代の応用：MRI、ICカード、ハイブリッド車、リニアモーターカー。電磁気技術の未来。',
    requiresAiGeneration: true,
  ),
];

// Stage 5_008: 電流と磁石（実験）
final stage5_008_images = [
  QuizImageMetadata(
    questionId: 'stage_5_008_q1',
    imageKeyword: 'circuit_basic_components',
    imageType: 'diagram',
    imageDescription: '基本的な電気回路：電池、導線、豆球、スイッチの接続。電流が流れる様子。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_008_q2',
    imageKeyword: 'series_vs_parallel_circuits',
    imageType: 'diagram',
    imageDescription: '直列と並列の違い：直列で豆球の明るさ、並列での分流。各接続方法の比較。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_008_q3',
    imageKeyword: 'conductor_insulator_materials',
    imageType: 'diagram',
    imageDescription: '導体と不導体：銅、アルミニウム（導体）とゴム、プラスチック（不導体）の分類。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_008_q4',
    imageKeyword: 'switch_mechanism_control',
    imageType: 'diagram',
    imageDescription: 'スイッチの仕組み：接点の開閉で電流の流れを制御。照明スイッチの構造。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_008_q5',
    imageKeyword: 'electric_resistance_heat',
    imageType: 'diagram',
    imageDescription: '電気抵抗と熱：抵抗の大きさと発熱量の関係。電熱線の赤熱を示す。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_008_q6',
    imageKeyword: 'circuit_power_consumption',
    imageType: 'diagram',
    imageDescription: '電力消費量：W = V × I。異なる機器の消費電力を比較表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_008_q7',
    imageKeyword: 'battery_types_specifications',
    imageType: 'chart',
    imageDescription: '電池の種類：アルカリ電池、充電電池。電圧と容量の違いを表で表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_008_q8',
    imageKeyword: 'safety_circuit_protection',
    imageType: 'diagram',
    imageDescription: '安全な電気：漏電遮断器、ヒューズ、アース。過電流保護の仕組み。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_008_q9',
    imageKeyword: 'electromagnetic_force_motor',
    imageType: 'diagram',
    imageDescription: '電磁力の利用：モーター、リレー、ベルの動作。電流と磁力の相互作用。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_008_q10',
    imageKeyword: 'circuit_design_problem_solving',
    imageType: 'diagram',
    imageDescription: '回路設計：条件に合わせた直列/並列の選択。実践的な問題解決。',
    requiresAiGeneration: true,
  ),
];

// Stage 5_009: 熱による変化
final stage5_009_images = [
  QuizImageMetadata(
    questionId: 'stage_5_009_q1',
    imageKeyword: 'thermal_expansion_principle',
    imageType: 'diagram',
    imageDescription: '熱による膨張：原子の振動が増え、物体が膨張する。温度と体積の関係。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_009_q2',
    imageKeyword: 'thermometer_operation',
    imageType: 'diagram',
    imageDescription: '温度計の仕組み：液体（水銀またはアルコール）の熱膨張を目盛りで表示。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_009_q3',
    imageKeyword: 'solid_material_expansion',
    imageType: 'diagram',
    imageDescription: '固体の膨張：鉄道のレール、建物の継ぎ目。膨張に備えた隙間。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_009_q4',
    imageKeyword: 'material_expansion_rates',
    imageType: 'chart',
    imageDescription: '材料による膨張率の違い：アルミニウム > 鉄 > ガラス。膨張係数の比較。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_009_q5',
    imageKeyword: 'cooling_contraction',
    imageType: 'diagram',
    imageDescription: '冷却と収縮：温度が下がるとき、物体は縮む。水の異常膨張の例外。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_009_q6',
    imageKeyword: 'bimetallic_strip_application',
    imageType: 'diagram',
    imageDescription: '二重金属片：膨張率の異なる2つの金属を貼り合わせた温度センサー。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_009_q7',
    imageKeyword: 'density_temperature_change',
    imageType: 'diagram',
    imageDescription: '密度の変化：温度が上がると同じ質量で体積が増え、密度が減少。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_009_q8',
    imageKeyword: 'thermal_stress_deformation',
    imageType: 'diagram',
    imageDescription: '熱応力による変形：制限された膨張が応力を生む。破裂や亀裂の例。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_009_q9',
    imageKeyword: 'water_anomalous_expansion',
    imageType: 'diagram',
    imageDescription: '水の異常膨張：4℃で最小密度。氷が浮く理由。生態系への影響。',
    requiresAiGeneration: true,
  ),
  QuizImageMetadata(
    questionId: 'stage_5_009_q10',
    imageKeyword: 'thermal_engineering_applications',
    imageType: 'diagram',
    imageDescription: '熱工学への応用：橋の伸縮継ぎ目、パイプラインの設計、精密機器。',
    requiresAiGeneration: true,
  ),
];

// ===============================
// 他のステージの画像メタデータもここに追加
// Stage 3_009 〜 3_012
// Stage 4_010 〜 4_011
// Stage 5_010 〜 5_012
// Stage 6_001 〜 6_012
// ===============================

/// 画像メタデータを全ステージから検索するヘルパー関数
Map<String, QuizImageMetadata> getQuizImageMetadata() {
  final allImages = <String, QuizImageMetadata>{};

  // 3年生
  for (final img in stage3_001_images) {
    allImages[img.questionId] = img;
  }
  for (final img in stage3_002_images) {
    allImages[img.questionId] = img;
  }
  for (final img in stage3_003_images) {
    allImages[img.questionId] = img;
  }
  for (final img in stage3_004_images) {
    allImages[img.questionId] = img;
  }
  for (final img in stage3_005_images) {
    allImages[img.questionId] = img;
  }
  for (final img in stage3_006_images) {
    allImages[img.questionId] = img;
  }
  for (final img in stage3_007_images) {
    allImages[img.questionId] = img;
  }
  for (final img in stage3_008_images) {
    allImages[img.questionId] = img;
  }

  // 4年生
  for (final img in stage4001_images) {
    allImages[img.questionId] = img;
  }
  for (final img in stage4002_images) {
    allImages[img.questionId] = img;
  }
  for (final img in stage4003_images) {
    allImages[img.questionId] = img;
  }
  for (final img in stage4004_images) {
    allImages[img.questionId] = img;
  }
  for (final img in stage4005_images) {
    allImages[img.questionId] = img;
  }
  for (final img in stage4006_images) {
    allImages[img.questionId] = img;
  }
  for (final img in stage4007_images) {
    allImages[img.questionId] = img;
  }
  for (final img in stage4008_images) {
    allImages[img.questionId] = img;
  }
  for (final img in stage4009_images) {
    allImages[img.questionId] = img;
  }

  // 5年生
  for (final img in stage5_001_images) {
    allImages[img.questionId] = img;
  }
  for (final img in stage5_002_images) {
    allImages[img.questionId] = img;
  }
  for (final img in stage5_003_images) {
    allImages[img.questionId] = img;
  }
  for (final img in stage5_004_images) {
    allImages[img.questionId] = img;
  }
  for (final img in stage5_005_images) {
    allImages[img.questionId] = img;
  }
  for (final img in stage5_006_images) {
    allImages[img.questionId] = img;
  }
  for (final img in stage5_007_images) {
    allImages[img.questionId] = img;
  }
  for (final img in stage5_008_images) {
    allImages[img.questionId] = img;
  }
  for (final img in stage5_009_images) {
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
