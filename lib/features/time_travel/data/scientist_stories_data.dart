// ⑧ タイムトラベル拡張: 科学者のストーリーと歴史的背景

class ScientistStory {
  final String id;
  final String name; // 科学者の名前
  final String nameJp; // 日本語表記
  final String era; // 時代
  final String yearRange; // 年代範囲
  final String emoji; // 絵文字
  final String field; // 分野
  final String biography; // 生涯の説明
  final String majorWork; // 主な業績
  final String interestingFact; // 面白い事実
  final List<String> relatedExperiments; // 関連する実験ID
  final int grade; // 対象学年

  const ScientistStory({
    required this.id,
    required this.name,
    required this.nameJp,
    required this.era,
    required this.yearRange,
    required this.emoji,
    required this.field,
    required this.biography,
    required this.majorWork,
    required this.interestingFact,
    required this.relatedExperiments,
    required this.grade,
  });
}

// 学年別の科学者ストーリー
final scientistStories = <ScientistStory>[
  // ── 3年生向け ──
  ScientistStory(
    id: 'scientist_001',
    name: 'Galileo Galilei',
    nameJp: 'ガリレオ・ガリレイ',
    era: '近代科学の父',
    yearRange: '1564-1642年',
    emoji: '🔭',
    field: '天文学・物理学',
    biography:
        'イタリアの物理学者・天文学者。望遠鏡を使って木星の衛星を発見し、現代天文学の基礎を作りました。',
    majorWork: '「ふりこの等時性の法則」を発見。望遠鏡で月のクレーターを観察し、月が完璧ではなく山や谷があることを証明しました。',
    interestingFact:
        'ガリレオは片手でいろいろな重さの球を落として、重さに関係なく同じ速さで落ちることを確認しました。これが現代の「重力の法則」につながったんだよ！',
    relatedExperiments: ['exp_pendulum_001', 'exp_circuit_001'],
    grade: 3,
  ),
  ScientistStory(
    id: 'scientist_002',
    name: 'Isaac Newton',
    nameJp: 'アイザック・ニュートン',
    era: '科学革命の時代',
    yearRange: '1643-1727年',
    emoji: '🍎',
    field: '物理学・数学',
    biography:
        'イギリスの物理学者・数学者。リンゴが落ちるのを見て「万有引力の法則」を思いつき、物理学の基礎を確立しました。',
    majorWork: '「ニュートンの法則」で物の動き方を数学で説明。プリズムで白い光が7色に分かれることを発見しました。',
    interestingFact:
        'ニュートンがケンブリッジ大学にいた時代、ペスト（病気）で大学が休校に。その1年半で重力、光、数学の新しい理論を次々発見したんです！',
    relatedExperiments: ['exp_electromagnet_001', 'exp_lever_001'],
    grade: 3,
  ),
  ScientistStory(
    id: 'scientist_003',
    name: 'Marie Curie',
    nameJp: 'マリー・キュリー',
    era: '近代科学の開拓者',
    yearRange: '1867-1934年',
    emoji: '⚛️',
    field: '物理学・化学',
    biography:
        'ポーランド生まれの物理学者・化学者。女性で初めてノーベル賞を2度受賞。放射能の研究で現代科学に大きく貢献しました。',
    majorWork: '新しい元素「ポロニウム」と「ラジウム」を発見。放射能の性質を研究しました。',
    interestingFact:
        'キュリー夫人は自分の実験ノート（日記のようなもの）に放射能の物質に触れていて、その本は今でも放射能を放っています。科学への情熱がすごかったんだ！',
    relatedExperiments: ['exp_magnet_001', 'exp_combustion_001'],
    grade: 3,
  ),

  // ── 4年生向け ──
  ScientistStory(
    id: 'scientist_004',
    name: 'Benjamin Franklin',
    nameJp: 'ベンジャミン・フランクリン',
    era: '18世紀のアメリカ',
    yearRange: '1706-1790年',
    emoji: '⚡',
    field: '電気学',
    biography:
        'アメリカの科学者・発明家。凧に鍵をつけて落雷を引き寄せ、電気は普通の現象であることを証明しました。',
    majorWork: 'ライトニングロッド（避雷針）を発明して、建物を雷から守る方法を開発。',
    interestingFact:
        'フランクリンが1752年に凧で実験した時、実は危険だったんです。もし直撃していたら死んでいたかもしれません。でもその勇気で電気の秘密が解き明かされたんだよ！',
    relatedExperiments: ['exp_circuit_001', 'exp_electromagnet_001'],
    grade: 4,
  ),
  ScientistStory(
    id: 'scientist_005',
    name: 'Antoine Lavoisier',
    nameJp: 'アントワーヌ・ラボアジェ',
    era: '化学革命の時代',
    yearRange: '1743-1794年',
    emoji: '🔬',
    field: '化学',
    biography:
        'フランスの化学者。「化学の父」と呼ばれ、燃焼の原理を解き明かし、現代化学の基礎を築きました。',
    majorWork: '酸素を発見し、物質が燃える時に酸素と結合することを証明。元素周期表のもとになる考え方を作りました。',
    interestingFact:
        'ラボアジェは税関の職員もしていました。しかしフランス革命の時代に、政治的な理由で処刑されてしまいました。彼の研究ノートは今も大事に保管されています。',
    relatedExperiments: ['exp_combustion_001', 'exp_ph_001'],
    grade: 4,
  ),

  // ── 5年生向け ──
  ScientistStory(
    id: 'scientist_006',
    name: 'Charles Darwin',
    nameJp: 'チャールズ・ダーウィン',
    era: '19世紀の生物学',
    yearRange: '1809-1882年',
    emoji: '🦠',
    field: '生物学・進化論',
    biography:
        'イギリスの生物学者。世界一周の探検航海で集めた標本から「進化論」を発表し、生物学に革命をもたらしました。',
    majorWork: '「種の起源」を著し、全ての生き物が共通の祖先から進化したことを説明。自然選択による進化の仕組みを解明しました。',
    interestingFact:
        'ダーウィンは5年間も船で世界を旅しました。その時に見た様々な生き物と環境の関係から、進化のアイデアが浮かんだんです。旅は発見の源だったんだね！',
    relatedExperiments: ['exp_germination_001', 'exp_lever_001'],
    grade: 5,
  ),
  ScientistStory(
    id: 'scientist_007',
    name: 'Nikola Tesla',
    nameJp: 'ニコラ・テスラ',
    era: '電気時代の開拓者',
    yearRange: '1856-1943年',
    emoji: '🔌',
    field: '電気工学',
    biography:
        'セルビア生まれで主にアメリカで活動した発明家。交流電気のシステムを開発し、現代の電力供給の基礎を作りました。',
    majorWork: '交流電動機を発明。ワイヤレス通信の研究も行い、現在のラジオやWiFiの基礎となるアイデアを提案しました。',
    interestingFact:
        'テスラは完璧主義者で、毎日朝3時に起床して実験していました。彼は映像を頭の中で完全に想像してから実験を行ったんです。頭の中で何度も完璧な実験ができるまでやったんだよ！',
    relatedExperiments: ['exp_electromagnet_001', 'exp_circuit_001'],
    grade: 5,
  ),

  // ── 6年生向け ──
  ScientistStory(
    id: 'scientist_008',
    name: 'Albert Einstein',
    nameJp: 'アルベルト・アインシュタイン',
    era: '20世紀科学の革命者',
    yearRange: '1879-1955年',
    emoji: '🧠',
    field: '物理学',
    biography:
        'ドイツ生まれ（後にアメリカ）の理論物理学者。「相対性理論」を発表し、時間・空間・物質・エネルギーの関係を解き明かしました。',
    majorWork:
        '「E=mc²」という有名な方程式で、物質とエネルギーの等価性を証明。光の本質や重力の本質を新しい視点で説明しました。',
    interestingFact:
        'アインシュタインは「頭が普通と違う」と学校の先生に言われていました。でも実は、彼は物理の才能を見つけるため、学校の勉強は無視して自分の興味のあることをやっていただけ。自分の道を信じることの大切さを教えてくれます。',
    relatedExperiments: ['exp_metal_heat_001', 'exp_electromagnet_001'],
    grade: 6,
  ),
  ScientistStory(
    id: 'scientist_009',
    name: 'Rosalind Franklin',
    nameJp: 'ロザリンド・フランクリン',
    era: 'DNA研究の時代',
    yearRange: '1920-1958年',
    emoji: '🧬',
    field: '分子生物学・化学',
    biography:
        'イギリスの科学者。X線結晶学を使ってDNAの構造を研究。DNA二重らせんの発見に大きく貢献しました。',
    majorWork:
        'DNAのX線写真「Photo 51」を撮影し、DNAが二重らせん構造であることの証拠を提供。生命の秘密を解く鍵になりました。',
    interestingFact:
        'フランクリンはユダヤ系女性で、当時は女性科学者への差別が強かったです。それでも彼女は信じた道を進み、生命の謎を解くことに貢献しました。彼女の貢献なしにDNAの秘密は解けなかったんです。',
    relatedExperiments: ['exp_germination_001', 'exp_metal_heat_001'],
    grade: 6,
  ),
];

// IDから科学者ストーリーを取得
ScientistStory? getScientistStory(String id) {
  try {
    return scientistStories.firstWhere((s) => s.id == id);
  } catch (e) {
    return null;
  }
}

// 学年別の科学者ストーリー取得
List<ScientistStory> getStoriesByGrade(int grade) {
  return scientistStories.where((s) => s.grade == grade).toList();
}

// ランダムな科学者ストーリーを取得（学年指定）
ScientistStory? getRandomStoryForGrade(int grade) {
  final gradeStories = getStoriesByGrade(grade);
  if (gradeStories.isEmpty) return null;
  gradeStories.shuffle();
  return gradeStories.first;
}
