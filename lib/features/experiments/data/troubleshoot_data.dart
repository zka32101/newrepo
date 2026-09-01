// ⑥ 失敗ラボ推理拡張：トラブルシューティング問題データ
// 各実験の「失敗の原因を推理する」問題 20実験 × 5問 = 100問（完成）

class TroubleshootQuestion {
  final String id;
  final String experimentId;
  final int difficulty; // 1-5
  final String scenario; // 問題文
  final List<String> choices;
  final String correctAnswer;
  final String explanation; // 解説

  const TroubleshootQuestion({
    required this.id,
    required this.experimentId,
    required this.difficulty,
    required this.scenario,
    required this.choices,
    required this.correctAnswer,
    required this.explanation,
  });
}

final troubleshootQuestions = [
  // ========== 3年生 実験 ==========

  // exp_magnet_001: 磁石と鉄
  TroubleshootQuestion(
    id: 'ts_001_01',
    experimentId: 'exp_magnet_001',
    difficulty: 1,
    scenario: '磁石でくぎを持ち上げようとしたけど、くぎが落ちちゃった。なぜ？',
    choices: [
      '磁石の力が弱くなってた',
      '磁石の向きが反対だった',
      'くぎが磁石にくっつかない材質だった',
    ],
    correctAnswer: '磁石の力が弱くなってた',
    explanation: '磁石の力には限界があります。重いものはくぎが落ちちゃう。',
  ),
  TroubleshootQuestion(
    id: 'ts_001_02',
    experimentId: 'exp_magnet_001',
    difficulty: 2,
    scenario: 'アルミホイルを磁石に近づけたけど、くっつかない。なぜ？',
    choices: [
      '磁石が壊れてた',
      'アルミは磁石に吸いつかない材質',
      'アルミの方が強い',
    ],
    correctAnswer: 'アルミは磁石に吸いつかない材質',
    explanation: '磁石は鉄にはくっつくけど、アルミ・銀・金にはくっつかない。',
  ),
  TroubleshootQuestion(
    id: 'ts_001_03',
    experimentId: 'exp_magnet_001',
    difficulty: 2,
    scenario: 'きのう磁石がいっぱいくぎを持ち上げたのに、きょうは1個だけ。なぜ？',
    choices: [
      '磁石の向きが逆になった',
      '磁石の力が徐々に弱くなってた',
      'くぎの種類が違った',
    ],
    correctAnswer: '磁石の力が徐々に弱くなってた',
    explanation:
        '磁石は何度も使ったり、強くぶつけたりすると、だんだん弱くなる。',
  ),
  TroubleshootQuestion(
    id: 'ts_001_04',
    experimentId: 'exp_magnet_001',
    difficulty: 3,
    scenario: 'S極とN極を逆に重ねたら、磁石同士が反発した。これって磁石が壊れた？',
    choices: [
      'はい、磁石が壊れた',
      'いいえ、これが磁石の力です',
      '一時的に壊れてる',
    ],
    correctAnswer: 'いいえ、これが磁石の力です',
    explanation: '同じ極同士は反発する。これは磁力がちゃんと働いてる証拠！',
  ),
  TroubleshootQuestion(
    id: 'ts_001_05',
    experimentId: 'exp_magnet_001',
    difficulty: 3,
    scenario: '磁石を水に入れたら、くぎへの力が半分になった。なぜ？',
    choices: [
      '磁石が濡れると力が弱くなる',
      '水が磁力を弱くする',
      '水中では磁力が弱く見える（実際は変わってない）',
    ],
    correctAnswer: '水中では磁力が弱く見える（実際は変わってない）',
    explanation:
        '水の影響で見かけ上弱く見えるけど、磁力そのものは変わってない。',
  ),

  // exp_002: 光と影
  TroubleshootQuestion(
    id: 'ts_002_01',
    experimentId: 'exp_balloon_001',
    difficulty: 1,
    scenario: 'グラウンドで午前中に影の実験をしたけど、午後もやったら影の長さが違った。',
    choices: [
      '太陽が動いた',
      '物の向きが変わった',
      '光の速度が変わった',
    ],
    correctAnswer: '太陽が動いた',
    explanation: '太陽は1日の中で位置が変わる。だから影の長さも向きも変わる。',
  ),
  TroubleshootQuestion(
    id: 'ts_002_02',
    experimentId: 'exp_balloon_001',
    difficulty: 2,
    scenario: '懐中電灯で影を作ったけど、影がぼやけてて線がくっきり出ない。',
    choices: [
      '懐中電灯の電池が弱い',
      '光の源が大きすぎる',
      'スクリーンが曲がってる',
    ],
    correctAnswer: '光の源が大きすぎる',
    explanation: '懐中電灯の光が広がると、影の縁がぼやける。',
  ),
  TroubleshootQuestion(
    id: 'ts_002_03',
    experimentId: 'exp_balloon_001',
    difficulty: 2,
    scenario: '鏡で光をはね返してかべに当てたら、思っていた場所とは違う場所に光が当たった。',
    choices: [
      '鏡が汚れていた',
      '鏡のかたむきがずれていた',
      '光の速さが変わった',
    ],
    correctAnswer: '鏡のかたむきがずれていた',
    explanation: '光は鏡に当たった角度と同じ角度ではね返る。鏡の向きが変わると、光が届く場所も変わる。',
  ),
  TroubleshootQuestion(
    id: 'ts_002_04',
    experimentId: 'exp_balloon_001',
    difficulty: 3,
    scenario: '虫めがねで日光を集めて紙を焦がそうとしたけど、なかなか焦げない。',
    choices: [
      '虫めがねと紙のきょりが合っていない',
      '虫めがねが古い',
      '紙の色が悪い',
    ],
    correctAnswer: '虫めがねと紙のきょりが合っていない',
    explanation: '光が一番小さく集まるきょり（焦点）に合わせないと、熱が集中せず焦げにくい。',
  ),
  TroubleshootQuestion(
    id: 'ts_002_05',
    experimentId: 'exp_balloon_001',
    difficulty: 3,
    scenario: '同じ場所で午前と正午に自分の影の長さを比べたら、正午の方が短かった。なぜ？',
    choices: [
      '正午は太陽が高い位置にあるから',
      '正午は光が弱いから',
      '正午は気温が高いから',
    ],
    correctAnswer: '正午は太陽が高い位置にあるから',
    explanation: '太陽が高いほど影は短くなり、太陽が低いほど影は長くなる。',
  ),

  // exp_003: 音の振動
  TroubleshootQuestion(
    id: 'ts_003_01',
    experimentId: 'exp_metal_heat_001',
    difficulty: 1,
    scenario: 'スピーカーから出た音が聞こえなくなった。なぜ？',
    choices: [
      '電源が切れてた',
      '音量ボタンがゼロになってた',
      'スピーカーが壊れた',
    ],
    correctAnswer: '電源が切れてた',
    explanation: 'スピーカーが動いてなければ音も出ない。',
  ),
  TroubleshootQuestion(
    id: 'ts_003_02',
    experimentId: 'exp_metal_heat_001',
    difficulty: 2,
    scenario: 'ボール紙に砂をのせてスピーカーに置いたけど、砂が動かない。',
    choices: [
      '周波数が低すぎる',
      '音量が小さすぎる',
      '砂が重すぎる',
    ],
    correctAnswer: '音量が小さすぎる',
    explanation: '音の振動が砂を動かすには、十分な大きさの音が必要。',
  ),
  TroubleshootQuestion(
    id: 'ts_003_03',
    experimentId: 'exp_metal_heat_001',
    difficulty: 2,
    scenario: '糸電話を作ったけど、糸がたるんでいて相手の声が聞こえない。',
    choices: [
      '糸を強く張っていないから',
      'コップが小さすぎるから',
      '糸の色が悪いから',
    ],
    correctAnswer: '糸を強く張っていないから',
    explanation: '音の振動は糸がピンと張っているときによく伝わる。たるんでいると振動が伝わりにくい。',
  ),
  TroubleshootQuestion(
    id: 'ts_003_04',
    experimentId: 'exp_metal_heat_001',
    difficulty: 3,
    scenario: '太鼓を強くたたいたときと弱くたたいたとき、音の大きさは変わったけど高さは変わらなかった。なぜ？',
    choices: [
      'たたく強さは音の大きさを変えるが、高さは変えないから',
      'たたく強さが弱すぎたから',
      '太鼓の皮が破れかけていたから',
    ],
    correctAnswer: 'たたく強さは音の大きさを変えるが、高さは変えないから',
    explanation: '音の大きさは振動のはば（大きさ）で決まり、音の高さは振動の速さ（回数）で決まる。',
  ),
  TroubleshootQuestion(
    id: 'ts_003_05',
    experimentId: 'exp_metal_heat_001',
    difficulty: 3,
    scenario: '輪ゴムを強く張って弾いたら、ゆるく張ったときより高い音が出た。なぜ？',
    choices: [
      '強く張るほど速く振動するから',
      '強く張るほど振動が大きくなるから',
      '輪ゴムが伸びて長くなったから',
    ],
    correctAnswer: '強く張るほど速く振動するから',
    explanation: 'ぴんと張るほど振動が速くなり、音は高くなる。',
  ),

  // exp_004: 力のはたらき
  TroubleshootQuestion(
    id: 'ts_004_01',
    experimentId: 'exp_circuit_001',
    difficulty: 1,
    scenario: 'てこで重い石を持ち上げられなかった。なぜ？',
    choices: [
      '支点の位置が悪かった',
      '石が重すぎた',
      '木の棒が弱かった',
    ],
    correctAnswer: '支点の位置が悪かった',
    explanation:
        'てこの支点が持ち上げたい物に近いと、力が必要。支点を遠ざけるといい。',
  ),
  TroubleshootQuestion(
    id: 'ts_004_02',
    experimentId: 'exp_circuit_001',
    difficulty: 2,
    scenario: 'ゴムを強く伸ばして手を放したのに、車が思ったより進まなかった。',
    choices: [
      'ゴムの伸ばし方が足りなかった',
      '車が重すぎた',
      'どちらの可能性もある',
    ],
    correctAnswer: 'どちらの可能性もある',
    explanation:
        'ゴムを伸ばす長さと車の重さの両方が、進むきょりに関係する。原因を1つずつ確かめよう。',
  ),
  TroubleshootQuestion(
    id: 'ts_004_03',
    experimentId: 'exp_circuit_001',
    difficulty: 2,
    scenario: 'ばねばかりで同じ重さのおもりを2回はかったら、少し違う数字が出た。',
    choices: [
      'ばねばかりの持ち方や読み方がずれていた',
      'おもりの重さが変わった',
      '重力が変化した',
    ],
    correctAnswer: 'ばねばかりの持ち方や読み方がずれていた',
    explanation: '目盛りを読む角度がずれると誤差が出やすい。まっすぐ正面から読むことが大切。',
  ),
  TroubleshootQuestion(
    id: 'ts_004_04',
    experimentId: 'exp_circuit_001',
    difficulty: 3,
    scenario: '風で車を走らせる実験で、うちわであおいでも思ったより進まなかった。',
    choices: [
      '風を受ける面（帆）が小さかった',
      '車のタイヤが重すぎた',
      'うちわの色が悪かった',
    ],
    correctAnswer: '風を受ける面（帆）が小さかった',
    explanation: '風の力を受ける面が大きいほど、車を押す力も大きくなる。',
  ),
  TroubleshootQuestion(
    id: 'ts_004_05',
    experimentId: 'exp_circuit_001',
    difficulty: 3,
    scenario: '同じ強さで打ったのに、かたいゆかの上とじゅうたんの上でボールのはずみ方が違った。',
    choices: [
      'ゆかの材質でボールが受け返す力が違うから',
      'ボールの空気が抜けていたから',
      '打つ角度が毎回違ったから',
    ],
    correctAnswer: 'ゆかの材質でボールが受け返す力が違うから',
    explanation: 'やわらかい面は力を吸収してしまい、ボールはあまりはずまない。',
  ),

  // exp_005: 水の性質
  TroubleshootQuestion(
    id: 'ts_005_01',
    experimentId: 'exp_germination_001',
    difficulty: 1,
    scenario: 'ビーカーにこぼした水が床を濡らした。なぜ水は広がるの？',
    choices: [
      '水が自分で動いてる',
      '重力で流れて広がった',
      '風が吹いてた',
    ],
    correctAnswer: '重力で流れて広がった',
    explanation: '水は重力に従って、低い方へ流れ落ちる。',
  ),
  TroubleshootQuestion(
    id: 'ts_005_02',
    experimentId: 'exp_germination_001',
    difficulty: 2,
    scenario: '入れ物の形を変えて水を移しかえたのに、水の体積は変わらなかった。',
    choices: [
      '水は形を変えても体積は変わらないから',
      '水がこぼれたから',
      '水が蒸発したから',
    ],
    correctAnswer: '水は形を変えても体積は変わらないから',
    explanation: '水は入れ物によって形は変わるが、量（体積）は変わらない。',
  ),
  TroubleshootQuestion(
    id: 'ts_005_03',
    experimentId: 'exp_germination_001',
    difficulty: 2,
    scenario: 'コップにいっぱい水を入れたら、ふちより盛り上がって少しこぼれなかった。',
    choices: [
      '水がおたがいに引き合う力（表面張力）があるから',
      '水があたたかいから',
      'コップがゆがんでいるから',
    ],
    correctAnswer: '水がおたがいに引き合う力（表面張力）があるから',
    explanation: '水の表面には、水どうしが引き合う「表面張力」というはたらきがある。',
  ),
  TroubleshootQuestion(
    id: 'ts_005_04',
    experimentId: 'exp_germination_001',
    difficulty: 3,
    scenario: '氷が水にうかんだが、石は水にしずんだ。なぜ？',
    choices: [
      '氷は水より軽い（体積あたりの重さが小さい）から',
      '氷は冷たいから',
      '石が大きすぎたから',
    ],
    correctAnswer: '氷は水より軽い（体積あたりの重さが小さい）から',
    explanation: '同じ体積で比べると氷は水より軽いのでうくが、石は水より重いのでしずむ。',
  ),
  TroubleshootQuestion(
    id: 'ts_005_05',
    experimentId: 'exp_germination_001',
    difficulty: 3,
    scenario: '同じ量の水を広い皿と細長いコップに入れて外に置いたら、皿の水の方が早くなくなった。',
    choices: [
      '皿は水にふれる空気の面積が広く、蒸発が早いから',
      '皿の方が日かげにあったから',
      'コップの水は蒸発しないから',
    ],
    correctAnswer: '皿は水にふれる空気の面積が広く、蒸発が早いから',
    explanation: '水面の面積が広いほど、空気にふれる部分が多くなり蒸発が早く進む。',
  ),

  // ========== 4年生 実験 ==========

  // exp_006: 電気と回路
  TroubleshootQuestion(
    id: 'ts_006_01',
    experimentId: 'exp_pendulum_001',
    difficulty: 1,
    scenario: '豆電球の回路を作ったけど、豆電球がつかない。なぜ？',
    choices: [
      '電池の向きが反対',
      '導線が途中で切れてる',
      '豆電球のソケットがゆるい',
      '全部当てはまる可能性',
    ],
    correctAnswer: '全部当てはまる可能性',
    explanation:
        'つかない理由は複数ある。1つずつ確認する必要がある（トラブルシューティング！）',
  ),
  TroubleshootQuestion(
    id: 'ts_006_02',
    experimentId: 'exp_pendulum_001',
    difficulty: 2,
    scenario: '電池を2個直列につないだら、豆電球が明るくなりすぎてすぐに切れてしまった。',
    choices: [
      '電池を増やすと電流が強くなりすぎることがあるから',
      '豆電球の色が悪かったから',
      '導線が長すぎたから',
    ],
    correctAnswer: '電池を増やすと電流が強くなりすぎることがあるから',
    explanation: '直列につなぐ電池が増えると流れる電流が大きくなり、豆電球に負担がかかる。',
  ),
  TroubleshootQuestion(
    id: 'ts_006_03',
    experimentId: 'exp_pendulum_001',
    difficulty: 2,
    scenario: 'モーターに電池をつないだが、あまり速く回らなかった。',
    choices: [
      '電池の向きやつなぎ方を確認する必要がある',
      'モーターが大きすぎる',
      '導線の色が合っていない',
    ],
    correctAnswer: '電池の向きやつなぎ方を確認する必要がある',
    explanation: '電池のつなぎ方（直列・並列）や向きによって、モーターに流れる電流の大きさが変わる。',
  ),
  TroubleshootQuestion(
    id: 'ts_006_04',
    experimentId: 'exp_pendulum_001',
    difficulty: 3,
    scenario: '2個の豆電球を並列につないだ回路と直列につないだ回路で、明るさが違った。',
    choices: [
      'つなぎ方によって電流の流れ方が変わるから',
      '豆電球の種類が違ったから',
      '導線の長さが違ったから',
    ],
    correctAnswer: 'つなぎ方によって電流の流れ方が変わるから',
    explanation: '直列つなぎと並列つなぎでは、それぞれの豆電球に流れる電流の大きさが変わり、明るさも変わる。',
  ),
  TroubleshootQuestion(
    id: 'ts_006_05',
    experimentId: 'exp_pendulum_001',
    difficulty: 3,
    scenario: '検流計をつないで電流の向きを調べたら、はりが逆にふれた。',
    choices: [
      '電流が反対向きに流れているから',
      '検流計がこわれているから',
      '導線が細すぎるから',
    ],
    correctAnswer: '電流が反対向きに流れているから',
    explanation: '検流計のはりがふれる向きは、電流が流れる向きによって変わる。',
  ),

  // exp_007: 水溶液の性質
  TroubleshootQuestion(
    id: 'ts_007_01',
    experimentId: 'exp_electromagnet_001',
    difficulty: 2,
    scenario: '砂糖を水に入れたけど、全く溶けない。なぜ？',
    choices: [
      '砂糖が壊れてた',
      '水の温度が低い',
      '砂糖の粒が大きすぎる',
    ],
    correctAnswer: '水の温度が低い',
    explanation: 'あたたかい水ほど、砂糖がよく溶ける。',
  ),
  TroubleshootQuestion(
    id: 'ts_007_02',
    experimentId: 'exp_electromagnet_001',
    difficulty: 2,
    scenario: '食塩水をじょう発させたら、白いつぶが出てきた。水はどこへ行ったの？',
    choices: [
      '水は蒸発して空気中に出ていった',
      '水は食塩に変わった',
      '水は容器の下にしずんだ',
    ],
    correctAnswer: '水は蒸発して空気中に出ていった',
    explanation: '水は熱で蒸発して気体になり、とけていた食塩だけが結晶として残る。',
  ),
  TroubleshootQuestion(
    id: 'ts_007_03',
    experimentId: 'exp_electromagnet_001',
    difficulty: 2,
    scenario: 'かき混ぜてもミョウバンが底に残ったままだった。',
    choices: [
      'これ以上とけない量（限度）に達しているから',
      'ミョウバンが悪いものだから',
      'かき混ぜ方が下手だから',
    ],
    correctAnswer: 'これ以上とけない量（限度）に達しているから',
    explanation: '水の量や温度が決まると、とける量にも限りがある（飽和）。',
  ),
  TroubleshootQuestion(
    id: 'ts_007_04',
    experimentId: 'exp_electromagnet_001',
    difficulty: 3,
    scenario: '同じ量の水にとかしたミョウバンが、冷めたら底につぶになって出てきた。',
    choices: [
      '水の温度が下がるととける量も減るから',
      '水が減ったから',
      'ミョウバンが増えたから',
    ],
    correctAnswer: '水の温度が下がるととける量も減るから',
    explanation: '水の温度が下がると、とけていられる量が減り、余った分がつぶになって出てくる。',
  ),
  TroubleshootQuestion(
    id: 'ts_007_05',
    experimentId: 'exp_electromagnet_001',
    difficulty: 3,
    scenario: '2つのビーカーで同じ量の水に同じ重さの食塩とミョウバンを入れたら、とけ方が違った。',
    choices: [
      '物によって水にとける量（とけやすさ）が違うから',
      'ビーカーの形が違ったから',
      '入れる順番が違ったから',
    ],
    correctAnswer: '物によって水にとける量（とけやすさ）が違うから',
    explanation: 'とける物質によって、同じ水の量・温度でもとける量（溶解度）は異なる。',
  ),

  // exp_008: とじこめた空気と水（4年）
  TroubleshootQuestion(
    id: 'ts_008_01',
    experimentId: 'exp_ph_001',
    difficulty: 1,
    scenario: '空気でっぽうの後ろの玉を強く押したのに、前の玉があまり飛ばなかった。',
    choices: [
      '押す力が足りなかった',
      '筒の中に空気が入っていなかった',
      '玉の大きさが合っていなかった',
    ],
    correctAnswer: '玉の大きさが合っていなかった',
    explanation: '玉が筒にぴったり合っていないと、空気がもれて圧縮する力が伝わらない。',
  ),
  TroubleshootQuestion(
    id: 'ts_008_02',
    experimentId: 'exp_ph_001',
    difficulty: 2,
    scenario: '注射器に空気を閉じ込めて押したら縮んだが、水を閉じ込めて押しても縮まなかった。',
    choices: [
      '空気は押すと縮むが、水はほとんど縮まないから',
      '注射器がこわれていたから',
      '水の量が多すぎたから',
    ],
    correctAnswer: '空気は押すと縮むが、水はほとんど縮まないから',
    explanation: '空気は押し縮めることができるが、水はほとんど体積が変わらない。',
  ),
  TroubleshootQuestion(
    id: 'ts_008_03',
    experimentId: 'exp_ph_001',
    difficulty: 2,
    scenario: '空気でっぽうを強く押すほど、玉が勢いよく飛び出した。なぜ？',
    choices: [
      '空気が強く圧縮されるほど元に戻ろうとする力が強くなるから',
      '玉が軽くなるから',
      '筒が短くなるから',
    ],
    correctAnswer: '空気が強く圧縮されるほど元に戻ろうとする力が強くなるから',
    explanation: '閉じ込めた空気は押し縮められるほど、もとに戻ろうとする力が大きくなる。',
  ),
  TroubleshootQuestion(
    id: 'ts_008_04',
    experimentId: 'exp_ph_001',
    difficulty: 3,
    scenario: 'ペットボトルロケットに水を少しだけ入れて飛ばしたら、あまり高く飛ばなかった。',
    choices: [
      '水の量が適量でなかった（空気の圧縮できる量が変わる）',
      '空気入れの力が強すぎた',
      'ロケットが重すぎた',
    ],
    correctAnswer: '水の量が適量でなかった（空気の圧縮できる量が変わる）',
    explanation: '水と空気の量のバランスによって、押し出す力の伝わり方が変わる。',
  ),
  TroubleshootQuestion(
    id: 'ts_008_05',
    experimentId: 'exp_ph_001',
    difficulty: 3,
    scenario: '水を満タンに入れた注射器の先を指でふさいで押したが、ほとんど動かなかった。',
    choices: [
      '水は縮まないので、押す力がそのまま指に伝わっているから',
      '注射器がこわれているから',
      '指の力が弱すぎるから',
    ],
    correctAnswer: '水は縮まないので、押す力がそのまま指に伝わっているから',
    explanation: '水はほとんど圧縮されないため、押した力はそのまま伝わり体積は変わらない。',
  ),

  // exp_009: もののあたたまり方（4年）
  TroubleshootQuestion(
    id: 'ts_009_01',
    experimentId: 'exp_lever_001',
    difficulty: 1,
    scenario: '金属の棒の先をあたためたら、はしの方までだんだんあたたかくなった。',
    choices: [
      '熱が金属を伝わって広がったから',
      '金属が冷たくなったから',
      '棒が曲がったから',
    ],
    correctAnswer: '熱が金属を伝わって広がったから',
    explanation: '金属は熱をよく伝える性質があり、あたためた部分から順に熱が伝わる（伝導）。',
  ),
  TroubleshootQuestion(
    id: 'ts_009_02',
    experimentId: 'exp_lever_001',
    difficulty: 2,
    scenario: 'ビーカーの水を下からあたためたら、下の水だけでなく全体があたたまった。',
    choices: [
      'あたたまった水が上に動き、冷たい水が下に動いて入れかわるから',
      '水が全部下に集まったから',
      '容器が熱を吸収したから',
    ],
    correctAnswer: 'あたたまった水が上に動き、冷たい水が下に動いて入れかわるから',
    explanation: '水や空気は、あたたまると軽くなって上に動く「対流」という現象で全体があたたまる。',
  ),
  TroubleshootQuestion(
    id: 'ts_009_03',
    experimentId: 'exp_lever_001',
    difficulty: 2,
    scenario: '部屋の中で、エアコンから出たあたたかい空気がすぐに天じょう付近に集まった。',
    choices: [
      'あたたかい空気は軽くなって上に上がるから',
      'あたたかい空気は重いから',
      'エアコンの風が強すぎたから',
    ],
    correctAnswer: 'あたたかい空気は軽くなって上に上がるから',
    explanation: '空気はあたたまると膨張して軽くなり、上の方へ移動する。',
  ),
  TroubleshootQuestion(
    id: 'ts_009_04',
    experimentId: 'exp_lever_001',
    difficulty: 3,
    scenario: '金属・木・プラスチックの板を同時にあたためたら、金属だけ先に熱く感じた。',
    choices: [
      '金属は木やプラスチックより熱を伝えやすいから',
      '金属だけ日光が当たっていたから',
      '木とプラスチックは熱を吸収しないから',
    ],
    correctAnswer: '金属は木やプラスチックより熱を伝えやすいから',
    explanation: '物質によって熱の伝わりやすさは違い、金属は特に熱を伝えやすい。',
  ),
  TroubleshootQuestion(
    id: 'ts_009_05',
    experimentId: 'exp_lever_001',
    difficulty: 3,
    scenario: '示温インクを入れた水を熱したら、色の変化が下から上へと動いていった。',
    choices: [
      '対流によってあたたかい水が上へ移動していく様子が見えたから',
      'インクが熱で消えていったから',
      '容器の底だけが熱かったから',
    ],
    correctAnswer: '対流によってあたたかい水が上へ移動していく様子が見えたから',
    explanation: '示温インクの色の動きは、あたためられた水が対流で移動する様子を表している。',
  ),

  // exp_010: 季節と生き物（4年）
  TroubleshootQuestion(
    id: 'ts_010_01',
    experimentId: 'exp_combustion_001',
    difficulty: 1,
    scenario: '春に見つけたツバメの巣が、冬になったら見当たらなくなった。',
    choices: [
      'ツバメは冬になる前に暖かい地方へ渡っていくから',
      'ツバメが巣をこわしたから',
      '巣が消えてしまったから',
    ],
    correctAnswer: 'ツバメは冬になる前に暖かい地方へ渡っていくから',
    explanation: 'ツバメなどの渡り鳥は、季節によってすみやすい地域に移動する。',
  ),
  TroubleshootQuestion(
    id: 'ts_010_02',
    experimentId: 'exp_combustion_001',
    difficulty: 2,
    scenario: '夏に元気だったヘチマが、秋になると葉が茶色くなり枯れてきた。',
    choices: [
      '気温が下がり、植物の一生（成長の周期）が終わりに近づいたから',
      '水をやりすぎたから',
      '虫に食べられたから',
    ],
    correctAnswer: '気温が下がり、植物の一生（成長の周期）が終わりに近づいたから',
    explanation: 'ヘチマなどの一年草は、気温の変化に合わせて成長し、秋から冬にかけて枯れていく。',
  ),
  TroubleshootQuestion(
    id: 'ts_010_03',
    experimentId: 'exp_combustion_001',
    difficulty: 2,
    scenario: '冬になったら、庭にいたカエルが急に見当たらなくなった。',
    choices: [
      '寒くなると土の中などで冬眠するから',
      'カエルが死んでしまったから',
      '別の場所に引っこしたから',
    ],
    correctAnswer: '寒くなると土の中などで冬眠するから',
    explanation: 'カエルなどの変温動物は、冬になると活動をやめて冬眠する。',
  ),
  TroubleshootQuestion(
    id: 'ts_010_04',
    experimentId: 'exp_combustion_001',
    difficulty: 3,
    scenario: '同じ木を1年間観察したら、季節ごとに葉の色や量が大きく変わった。',
    choices: [
      '気温や日照時間の変化に合わせて木のようすが変わるから',
      '毎回別の木を見ていたから',
      '木が病気になっていたから',
    ],
    correctAnswer: '気温や日照時間の変化に合わせて木のようすが変わるから',
    explanation: '木や植物は、季節ごとの気温や日照の変化に応じて芽吹き・成長・落葉などの変化を見せる。',
  ),
  TroubleshootQuestion(
    id: 'ts_010_05',
    experimentId: 'exp_combustion_001',
    difficulty: 3,
    scenario: '秋にたくさん見られたオオカマキリの卵のうを、冬から春にかけて観察していたら中から幼虫が出てきた。',
    choices: [
      '暖かくなる季節に合わせて卵からかえるから',
      '卵のうが古くなったから',
      '毎日えさをあげていたから',
    ],
    correctAnswer: '暖かくなる季節に合わせて卵からかえるから',
    explanation: '昆虫の多くは、気温が上がる春先に卵からかえるよう成長のタイミングを合わせている。',
  ),

  // exp_011: 月と星（4年）
  TroubleshootQuestion(
    id: 'ts_011_01',
    experimentId: 'exp_011',
    difficulty: 1,
    scenario: '昨日見た月は満月に近い形だったのに、今日見たら少し欠けていた。',
    choices: [
      '月の形は日によって少しずつ変わって見えるから',
      '月が欠けてこわれたから',
      '見る場所が違ったから',
    ],
    correctAnswer: '月の形は日によって少しずつ変わって見えるから',
    explanation: '月は太陽の光の当たり方が変わることで、見える形（満ち欠け）が日ごとに変化する。',
  ),
  TroubleshootQuestion(
    id: 'ts_011_02',
    experimentId: 'exp_011',
    difficulty: 2,
    scenario: '夕方に見えた月が、時間がたつと空の違う位置に見えた。',
    choices: [
      '地球が自転しているため、月の見える位置が動くから',
      '月が急に移動したから',
      '目の錯覚だから',
    ],
    correctAnswer: '地球が自転しているため、月の見える位置が動くから',
    explanation: '月自体はほとんど動いていないが、地球が自転することで空を動いていくように見える。',
  ),
  TroubleshootQuestion(
    id: 'ts_011_03',
    experimentId: 'exp_011',
    difficulty: 2,
    scenario: '同じ星座を早い時刻と遅い時刻に観察したら、見える位置が違った。',
    choices: [
      '地球の自転によって星の見える位置が時間とともに変わるから',
      '星座の星が動いたから',
      '望遠鏡の向きがずれたから',
    ],
    correctAnswer: '地球の自転によって星の見える位置が時間とともに変わるから',
    explanation: '星も月と同じように、地球の自転によって東から西へ動くように見える。',
  ),
  TroubleshootQuestion(
    id: 'ts_011_04',
    experimentId: 'exp_011',
    difficulty: 3,
    scenario: '夏に見えた星座（さそり座など）が、冬には見えなくなっていた。',
    choices: [
      '地球が太陽の周りを回ることで、見える星座が季節ごとに変わるから',
      '星座が消えてしまったから',
      '望遠鏡が古くなったから',
    ],
    correctAnswer: '地球が太陽の周りを回ることで、見える星座が季節ごとに変わるから',
    explanation: '地球の公転によって、夜に見える方角の星座は季節ごとに移り変わる。',
  ),
  TroubleshootQuestion(
    id: 'ts_011_05',
    experimentId: 'exp_011',
    difficulty: 3,
    scenario: '同じ時刻に1週間続けて月を観察したら、毎日見える位置と形が少しずつずれていった。',
    choices: [
      '月が地球の周りを公転しているため、位置と形が日々変化するから',
      '観察する場所を毎日変えていたから',
      '雲の量が毎日違ったから',
    ],
    correctAnswer: '月が地球の周りを公転しているため、位置と形が日々変化するから',
    explanation: '月は約1か月かけて地球の周りを回っており、それにともなって位置や満ち欠けの形が変わる。',
  ),

  // exp_012: 雨水のゆくえ（4年）
  TroubleshootQuestion(
    id: 'ts_012_01',
    experimentId: 'exp_012',
    difficulty: 1,
    scenario: '校庭に降った雨水が、しばらくすると低い方へ流れて水たまりになった。',
    choices: [
      '水は高いところから低いところへ流れるから',
      '雨がやんだから',
      '土が水をはじいたから',
    ],
    correctAnswer: '水は高いところから低いところへ流れるから',
    explanation: '水は地面のかたむきにそって、高い場所から低い場所へ流れていく。',
  ),
  TroubleshootQuestion(
    id: 'ts_012_02',
    experimentId: 'exp_012',
    difficulty: 2,
    scenario: '砂の地面とアスファルトの地面で、雨がやんだあとの水たまりの残り方が違った。',
    choices: [
      '砂は水をしみこませやすいが、アスファルトはしみこみにくいから',
      '砂の方が雨が多く降ったから',
      'アスファルトの方が広かったから',
    ],
    correctAnswer: '砂は水をしみこませやすいが、アスファルトはしみこみにくいから',
    explanation: '地面の材質によって水のしみこみやすさが違い、水たまりの残りやすさも変わる。',
  ),
  TroubleshootQuestion(
    id: 'ts_012_03',
    experimentId: 'exp_012',
    difficulty: 2,
    scenario: '雨上がりに校庭を見たら、水たまりが数日たつと消えていた。',
    choices: [
      '水が蒸発して空気中に出ていったり、地面にしみこんだりしたから',
      '水たまりが自然にこわれたから',
      '誰かが水をすくったから',
    ],
    correctAnswer: '水が蒸発して空気中に出ていったり、地面にしみこんだりしたから',
    explanation: '水たまりの水は蒸発や地中への浸透によって、時間とともになくなっていく。',
  ),
  TroubleshootQuestion(
    id: 'ts_012_04',
    experimentId: 'exp_012',
    difficulty: 3,
    scenario: '校庭にみぞ（水路）を作って雨水を流す実験をしたら、思った方向に水が流れなかった。',
    choices: [
      'みぞのかたむきが正しくつけられていなかったから',
      '雨の量が少なすぎたから',
      '水の色が悪かったから',
    ],
    correctAnswer: 'みぞのかたむきが正しくつけられていなかったから',
    explanation: '水は低い方へ流れるため、みぞのかたむきの向きが目的の方向とずれると思う通りに流れない。',
  ),
  TroubleshootQuestion(
    id: 'ts_012_05',
    experimentId: 'exp_012',
    difficulty: 3,
    scenario: '雨の後、地面にしみこんだ水がどこへ行ったのか調べようとしたが、目で追えなかった。',
    choices: [
      '地下にしみこんだ水は地中を通って川や地下水になるため見えにくいから',
      '水が消えてなくなったから',
      '観察のしかたが間違っていたから',
    ],
    correctAnswer: '地下にしみこんだ水は地中を通って川や地下水になるため見えにくいから',
    explanation: '地面にしみこんだ水は地下水として土の中を移動し、やがて川や地下の水みちに合流する。',
  ),

  // exp_013: 人の体のつくり（4年）
  TroubleshootQuestion(
    id: 'ts_013_01',
    experimentId: 'exp_013',
    difficulty: 1,
    scenario: '運動した後、いつもより息がはやくなり、心臓の音も大きく感じた。',
    choices: [
      '体が多くの酸素を必要とし、心臓や肺がはたらきを強めるから',
      '運動で体温が下がったから',
      '心臓が疲れて止まりそうだから',
    ],
    correctAnswer: '体が多くの酸素を必要とし、心臓や肺がはたらきを強めるから',
    explanation: '運動をすると、酸素をたくさん取り入れて全身に送るため、呼吸や心臓のはたらきが活発になる。',
  ),
  TroubleshootQuestion(
    id: 'ts_013_02',
    experimentId: 'exp_013',
    difficulty: 2,
    scenario: 'うでを曲げのばししたとき、片方の筋肉がちぢみ、もう片方がゆるんでいるのがわかった。',
    choices: [
      '筋肉は対になっていて、一方がちぢむと他方がゆるんで関節が動くから',
      '筋肉が1つしかないから',
      '骨が勝手に動いているから',
    ],
    correctAnswer: '筋肉は対になっていて、一方がちぢむと他方がゆるんで関節が動くから',
    explanation: 'うでの筋肉は対になってはたらき、ちぢんだりゆるんだりすることで関節を曲げのばしする。',
  ),
  TroubleshootQuestion(
    id: 'ts_013_03',
    experimentId: 'exp_013',
    difficulty: 2,
    scenario: '聴診器で心臓の音を聞いたら、「ドクン、ドクン」と規則的に聞こえた。',
    choices: [
      '心臓が血液を送り出すために規則正しく動いているから',
      '聴診器がこわれているから',
      '体の中の空気の音だから',
    ],
    correctAnswer: '心臓が血液を送り出すために規則正しく動いているから',
    explanation: '心臓は全身に血液を送るポンプとして、規則的に収縮とかん張をくり返している。',
  ),
  TroubleshootQuestion(
    id: 'ts_013_04',
    experimentId: 'exp_013',
    difficulty: 3,
    scenario: '運動する前と後で脈はく数をはかったら、後の方が多かった。',
    choices: [
      '体が必要とする酸素の量が増え、心臓が血液を多く送るようになったから',
      '脈はくのはかり方を間違えたから',
      '運動で脈はくが止まりかけたから',
    ],
    correctAnswer: '体が必要とする酸素の量が増え、心臓が血液を多く送るようになったから',
    explanation: '運動時は筋肉が多くの酸素を必要とするため、心臓の動きが速くなり脈はく数が増える。',
  ),
  TroubleshootQuestion(
    id: 'ts_013_05',
    experimentId: 'exp_013',
    difficulty: 3,
    scenario: '関節の模型を作って動かしたら、骨だけでは曲げのばしができなかった。',
    choices: [
      '筋肉が骨を引っぱることで関節が動くから、筋肉の役割が必要だったから',
      '骨の形が間違っていたから',
      '模型が小さすぎたから',
    ],
    correctAnswer: '筋肉が骨を引っぱることで関節が動くから、筋肉の役割が必要だったから',
    explanation: '体を動かすには、骨・関節に加えて筋肉が骨を引っぱるはたらきが欠かせない。',
  ),

  // ========== 5年生 実験 ==========

  // exp_014: 植物の発芽と成長（5年）
  TroubleshootQuestion(
    id: 'ts_014_01',
    experimentId: 'exp_014',
    difficulty: 1,
    scenario: '水をあげたインゲンマメの種が、日の当たらない暗い場所に置いても発芽した。',
    choices: [
      '発芽には水・空気・適当な温度が必要で、光は発芽の条件ではないから',
      '光がないと発芽しないはずなので実験ミス',
      '種が特別な種類だったから',
    ],
    correctAnswer: '発芽には水・空気・適当な温度が必要で、光は発芽の条件ではないから',
    explanation: '種子の発芽に必要な条件は水・空気・温度であり、光は発芽そのものには必要ない。',
  ),
  TroubleshootQuestion(
    id: 'ts_014_02',
    experimentId: 'exp_014',
    difficulty: 2,
    scenario: '同じように水をあげたのに、日光の当たる場所と当たらない場所でインゲンマメの育ち方が違った。',
    choices: [
      '発芽後の成長には日光が必要だから',
      '水のあげすぎだったから',
      '種の質が違ったから',
    ],
    correctAnswer: '発芽後の成長には日光が必要だから',
    explanation: '発芽の条件と、発芽後に丈夫に育つための条件は異なり、成長には日光や肥料が関わる。',
  ),
  TroubleshootQuestion(
    id: 'ts_014_03',
    experimentId: 'exp_014',
    difficulty: 2,
    scenario: '肥料をあたえた植木と、あたえなかった植木を比べたら、育ち方に差が出た。',
    choices: [
      '肥料が植物の成長を助けるはたらきをするから',
      '肥料は関係なく、たまたま差が出ただけ',
      '水の量が違ったから',
    ],
    correctAnswer: '肥料が植物の成長を助けるはたらきをするから',
    explanation: '肥料には植物の成長に必要な養分が含まれており、与えることで生育がよくなることが多い。',
  ),
  TroubleshootQuestion(
    id: 'ts_014_04',
    experimentId: 'exp_014',
    difficulty: 3,
    scenario: '種を冷蔵庫に入れて冷やしたら、常温に置いた種より発芽が遅れた。',
    choices: [
      '発芽には適した温度があり、低すぎると発芽しにくいから',
      '冷蔵庫の光が悪かったから',
      '種が凍って死んでしまったから',
    ],
    correctAnswer: '発芽には適した温度があり、低すぎると発芽しにくいから',
    explanation: '種子の発芽には種類ごとに適した温度があり、低温すぎると発芽が進みにくくなる。',
  ),
  TroubleshootQuestion(
    id: 'ts_014_05',
    experimentId: 'exp_014',
    difficulty: 3,
    scenario: '水にひたしすぎた種は、かびが生えて発芽しなかった。',
    choices: [
      '水にひたりすぎると空気（酸素）が種に届かなくなるから',
      '水は発芽に関係がないから',
      '種の色が変わったから',
    ],
    correctAnswer: '水にひたりすぎると空気（酸素）が種に届かなくなるから',
    explanation: '発芽には空気（酸素）も必要で、水につかりすぎると酸素が不足し発芽しにくくなる。',
  ),

  // exp_015: 花から実へ（受粉）（5年）
  TroubleshootQuestion(
    id: 'ts_015_01',
    experimentId: 'exp_015',
    difficulty: 1,
    scenario: 'アサガオの花にふくろをかぶせて虫が入れないようにしたら、実ができなかった。',
    choices: [
      '受粉できなかったため実ができなかった',
      'ふくろが日光をさえぎったから',
      '花がしおれてしまったから',
    ],
    correctAnswer: '受粉できなかったため実ができなかった',
    explanation: 'めしべにおしべの花粉がつく「受粉」が行われないと、実や種ができない。',
  ),
  TroubleshootQuestion(
    id: 'ts_015_02',
    experimentId: 'exp_015',
    difficulty: 2,
    scenario: 'ふくろをかぶせた花に、人の手でめしべに花粉をつけたら実ができた。',
    choices: [
      '人工的に受粉させたことで、虫がいなくても実ができたから',
      '花粉は関係なく、たまたま実ができただけ',
      'ふくろが実を作る力になったから',
    ],
    correctAnswer: '人工的に受粉させたことで、虫がいなくても実ができたから',
    explanation: '受粉は虫や風だけでなく、人の手で花粉を運んでも成立させることができる。',
  ),
  TroubleshootQuestion(
    id: 'ts_015_03',
    experimentId: 'exp_015',
    difficulty: 2,
    scenario: 'ヘチマの花には、実ができる花とできない花があった。',
    choices: [
      'めばな（実ができる花）とおばな（花粉を出す花）の2種類があるから',
      '花の色によって決まっているから',
      '虫が来るか来ないかだけの問題',
    ],
    correctAnswer: 'めばな（実ができる花）とおばな（花粉を出す花）の2種類があるから',
    explanation: 'ヘチマなどはめばなとおばなが別々にさき、めばなが受粉すると実になる。',
  ),
  TroubleshootQuestion(
    id: 'ts_015_04',
    experimentId: 'exp_015',
    difficulty: 3,
    scenario: '虫がたくさん来る花壇と、虫が少ない花壇で、実のでき方に差があった。',
    choices: [
      '虫が花粉を運んで受粉を助けるはたらきをしているから',
      '花壇の土の質が違うだけ',
      '虫は関係なく、日当たりの差だけ',
    ],
    correctAnswer: '虫が花粉を運んで受粉を助けるはたらきをしているから',
    explanation: 'ミツバチなどの虫は花から花へ花粉を運び、受粉を助ける大切な役割をしている。',
  ),
  TroubleshootQuestion(
    id: 'ts_015_05',
    experimentId: 'exp_015',
    difficulty: 3,
    scenario: '顕微鏡で花粉を観察したら、植物によって形やもようが違っていた。',
    choices: [
      '花粉の形は植物の種類ごとに違いがあるから',
      '顕微鏡のピントがずれていただけ',
      '花粉はすべて同じ形のはずで観察ミス',
    ],
    correctAnswer: '花粉の形は植物の種類ごとに違いがあるから',
    explanation: '花粉の形や大きさは植物の種類によって異なり、顕微鏡で見分けることができる。',
  ),

  // exp_016: メダカのたんじょう（5年）
  TroubleshootQuestion(
    id: 'ts_016_01',
    experimentId: 'exp_016',
    difficulty: 1,
    scenario: 'めすのメダカだけを飼っていたら、卵を産んでも稚魚が生まれなかった。',
    choices: [
      'おすがいないと受精せず、卵から稚魚は生まれないから',
      '水温が低すぎたから',
      'えさが足りなかったから',
    ],
    correctAnswer: 'おすがいないと受精せず、卵から稚魚は生まれないから',
    explanation: 'メダカの卵はおすの精子と結びつく（受精する）ことで育ち始める。',
  ),
  TroubleshootQuestion(
    id: 'ts_016_02',
    experimentId: 'exp_016',
    difficulty: 2,
    scenario: '水そうの水温を低くしたままにしたら、卵がなかなかふ化しなかった。',
    choices: [
      '卵の成長には適した水温が必要だから',
      '卵は水温と関係なくふ化するはず',
      '水そうが暗すぎたから',
    ],
    correctAnswer: '卵の成長には適した水温が必要だから',
    explanation: 'メダカの卵は水温が高いほど育つのが早く、低いとふ化までの日数が長くなる。',
  ),
  TroubleshootQuestion(
    id: 'ts_016_03',
    experimentId: 'exp_016',
    difficulty: 2,
    scenario: '顕微鏡で観察していた卵の中に、日がたつにつれて黒い目や体の形が見えてきた。',
    choices: [
      '卵の中でメダカの体が少しずつ成長しているから',
      '卵にごみが入っただけ',
      '光の反射で見えているだけ',
    ],
    correctAnswer: '卵の中でメダカの体が少しずつ成長しているから',
    explanation: '受精した卵は日がたつにつれて養分を使いながら体のつくりができていく。',
  ),
  TroubleshootQuestion(
    id: 'ts_016_04',
    experimentId: 'exp_016',
    difficulty: 3,
    scenario: '生まれたばかりの稚魚に、すぐにえさをあげなくても数日間元気に泳いでいた。',
    choices: [
      '生まれた直後はお腹に養分（ふくろ）を持っていて、それを使って育つから',
      'えさは最初から必要ないから',
      '稚魚は食事をしない生き物だから',
    ],
    correctAnswer: '生まれた直後はお腹に養分（ふくろ）を持っていて、それを使って育つから',
    explanation: '生まれたばかりの稚魚は腹の下に養分のふくろを持っており、しばらくはえさなしで過ごせる。',
  ),
  TroubleshootQuestion(
    id: 'ts_016_05',
    experimentId: 'exp_016',
    difficulty: 3,
    scenario: '水そうの水草に、透明でつぶつぶのついた卵が産みつけられているのを見つけた。',
    choices: [
      'めすが産んだ卵がおすの精子と受精し、水草についているから',
      '水草が卵を作り出したから',
      '卵はメダカと関係のないものだから',
    ],
    correctAnswer: 'めすが産んだ卵がおすの精子と受精し、水草についているから',
    explanation: 'メダカはめすが産んだ卵をおすが受精させ、水草などに卵を付着させる。',
  ),

  // exp_017: 流れる水のはたらき（5年）
  TroubleshootQuestion(
    id: 'ts_017_01',
    experimentId: 'exp_017',
    difficulty: 1,
    scenario: '土の山に水を流したら、水の通り道が曲がりくねって深くなっていった。',
    choices: [
      '流れる水が土をけずる「しん食」のはたらきをしているから',
      '土がもともと曲がっていたから',
      '水の色が土に染みこんだから',
    ],
    correctAnswer: '流れる水が土をけずる「しん食」のはたらきをしているから',
    explanation: '流れる水には地面をけずる「しん食」、運ぶ「運ぱん」、積もらせる「たい積」のはたらきがある。',
  ),
  TroubleshootQuestion(
    id: 'ts_017_02',
    experimentId: 'exp_017',
    difficulty: 2,
    scenario: '同じ水の量でも、かたむきが急な場所とゆるやかな場所で、土のけずられ方が違った。',
    choices: [
      '流れが速いほど、しん食のはたらきが強くなるから',
      'かたむきは水のはたらきに関係しないから',
      '土の色が違っただけ',
    ],
    correctAnswer: '流れが速いほど、しん食のはたらきが強くなるから',
    explanation: '水の流れが速いところほどしん食・運ぱんのはたらきが強く、地面が大きくけずられる。',
  ),
  TroubleshootQuestion(
    id: 'ts_017_03',
    experimentId: 'exp_017',
    difficulty: 2,
    scenario: '川のカーブの外側の岸ががけのようにけずれていたが、内側には土や砂がたまっていた。',
    choices: [
      'カーブの外側は流れが速くしん食、内側は流れが遅くたい積が起こるから',
      'カーブの内側と外側で川の水が違う種類だから',
      '外側だけ雨が多く降ったから',
    ],
    correctAnswer: 'カーブの外側は流れが速くしん食、内側は流れが遅くたい積が起こるから',
    explanation: '川のカーブでは外側の流れが速くけずられ、内側の流れが遅く土砂がたまりやすい。',
  ),
  TroubleshootQuestion(
    id: 'ts_017_04',
    experimentId: 'exp_017',
    difficulty: 3,
    scenario: '大雨のあと、いつもより川の水が茶色くにごっていた。',
    choices: [
      '流れが強くなり、土や砂を多く運ぶ「運ぱん」のはたらきが増えたから',
      '川底の色が変わったから',
      '雨水そのものが茶色いから',
    ],
    correctAnswer: '流れが強くなり、土や砂を多く運ぶ「運ぱん」のはたらきが増えたから',
    explanation: '雨で水の量や勢いが増すと、しん食・運ぱんのはたらきが強まり、土砂を多く運ぶためにごる。',
  ),
  TroubleshootQuestion(
    id: 'ts_017_05',
    experimentId: 'exp_017',
    difficulty: 3,
    scenario: '川が海に流れこむ場所に、三角形に広がる土地（三角州）ができていた。',
    choices: [
      '流れがゆるやかになり、運んできた土砂がたい積してできたから',
      '海の波が土地を作ったから',
      '人がその土地を作ったから',
    ],
    correctAnswer: '流れがゆるやかになり、運んできた土砂がたい積してできたから',
    explanation: '川が海や湖に出て流れがゆるやかになると、運んできた土砂がたい積して地形をつくる。',
  ),

  // exp_018: 天気の変化（5年）
  TroubleshootQuestion(
    id: 'ts_018_01',
    experimentId: 'exp_018',
    difficulty: 1,
    scenario: '西の空に厚い雲が出てきたら、その数時間後に雨が降ってきた。',
    choices: [
      '日本付近では天気が西から東へ変わることが多いから',
      '雲は天気と関係がないから',
      'たまたま偶然雨が降っただけ',
    ],
    correctAnswer: '日本付近では天気が西から東へ変わることが多いから',
    explanation: '日本付近では上空の風の影響で、天気はおおよそ西から東へ変化していく。',
  ),
  TroubleshootQuestion(
    id: 'ts_018_02',
    experimentId: 'exp_018',
    difficulty: 2,
    scenario: '雲画像を毎日見比べたら、雲のかたまりが西から東へ少しずつ動いていた。',
    choices: [
      '雲は上空の風に流されて西から東へ動くことが多いから',
      '雲画像はいつも同じ写真だから',
      '雲は動かないはず',
    ],
    correctAnswer: '雲は上空の風に流されて西から東へ動くことが多いから',
    explanation: '日本付近の上空にはおおむね西から東へ吹く風（偏西風）があり、雲もそれに流されて動く。',
  ),
  TroubleshootQuestion(
    id: 'ts_018_03',
    experimentId: 'exp_018',
    difficulty: 2,
    scenario: '同じ日でも、朝は晴れていたのに夕方には雨になった。',
    choices: [
      '天気は雲の動きによって短い時間でも変わることがあるから',
      '朝と夕方は別の場所の天気だから',
      '天気予報が間違っていたから',
    ],
    correctAnswer: '天気は雲の動きによって短い時間でも変わることがあるから',
    explanation: '雲は絶えず動いており、天気は数時間の単位でも変化することがある。',
  ),
  TroubleshootQuestion(
    id: 'ts_018_04',
    experimentId: 'exp_018',
    difficulty: 3,
    scenario: '台風が近づいたとき、進む方向が天気図の雲の動きと似た向きだった。',
    choices: [
      '台風も上空の風の影響を受けて動くことが多いから',
      '台風は雲とは関係のない現象だから',
      '天気図が台風の形をまねて描かれているだけ',
    ],
    correctAnswer: '台風も上空の風の影響を受けて動くことが多いから',
    explanation: '台風の進路も周囲の風の流れの影響を受けており、雲の動きと関連が見られることがある。',
  ),
  TroubleshootQuestion(
    id: 'ts_018_05',
    experimentId: 'exp_018',
    difficulty: 3,
    scenario: 'アメダスの雨量情報を見たら、少しはなれた地域でも雨の降り方が大きくちがっていた。',
    choices: [
      '雲のかたまりの位置や動き方によって、雨の降る場所や量が変わるから',
      'アメダスの記録がまちがっているから',
      '雨は同じ地域なら必ず同じ量降るはずだから',
    ],
    correctAnswer: '雲のかたまりの位置や動き方によって、雨の降る場所や量が変わるから',
    explanation: '雨雲の分布には広がりがあり、少しはなれた地域でも降水量が大きく異なることがある。',
  ),

  // exp_019: ふりこの運動（5年）
  TroubleshootQuestion(
    id: 'ts_019_01',
    experimentId: 'exp_019',
    difficulty: 1,
    scenario: 'おもりを重くしてふりこをふらせたが、1往復する時間はほとんど変わらなかった。',
    choices: [
      'ふりこの周期はおもりの重さに関係しないから',
      'おもりが重いと必ず速く動くはずで実験ミス',
      '糸が切れかけていたから',
    ],
    correctAnswer: 'ふりこの周期はおもりの重さに関係しないから',
    explanation: 'ふりこが1往復する時間（周期）は、おもりの重さを変えてもほとんど変化しない。',
  ),
  TroubleshootQuestion(
    id: 'ts_019_02',
    experimentId: 'exp_019',
    difficulty: 2,
    scenario: 'ふれはば（ふる角度）を大きくしたのに、1往復の時間はほとんど変わらなかった。',
    choices: [
      'ふれはばが極端に大きくない限り、周期はほとんど変わらないから',
      'ふれはばが大きいほど必ず時間も長くなるはずで実験ミス',
      '糸の長さが変わってしまったから',
    ],
    correctAnswer: 'ふれはばが極端に大きくない限り、周期はほとんど変わらないから',
    explanation: 'ふりこの周期は、ふれはばを多少変えてもほとんど変化しない性質がある。',
  ),
  TroubleshootQuestion(
    id: 'ts_019_03',
    experimentId: 'exp_019',
    difficulty: 2,
    scenario: '糸の長さを長くしたら、ふりこが1往復する時間が長くなった。',
    choices: [
      '糸を長くするほど周期が長くなる性質があるから',
      '糸が長いと必ず速く動くはずで実験ミス',
      'おもりの重さが変わったから',
    ],
    correctAnswer: '糸を長くするほど周期が長くなる性質があるから',
    explanation: 'ふりこの周期は糸の長さに関係し、糸が長いほど1往復にかかる時間は長くなる。',
  ),
  TroubleshootQuestion(
    id: 'ts_019_04',
    experimentId: 'exp_019',
    difficulty: 3,
    scenario: '10往復の時間をはかって10で割ったら、1往復だけを何度もはかるより安定した値になった。',
    choices: [
      '複数回分をまとめてはかることで、1回ごとの誤差の影響を減らせるから',
      '10往復だけ特別に正確に動くから',
      '1往復のはかり方が間違っているから',
    ],
    correctAnswer: '複数回分をまとめてはかることで、1回ごとの誤差の影響を減らせるから',
    explanation: 'ストップウォッチの反応時間などの誤差は、多い往復数でまとめてはかり平均すると小さくできる。',
  ),
  TroubleshootQuestion(
    id: 'ts_019_05',
    experimentId: 'exp_019',
    difficulty: 3,
    scenario: '同じ糸の長さでも、おもりの形（丸い形と細長い形）を変えたら周期が少し違って見えた。',
    choices: [
      '空気の抵抗の受け方や、おもりの中心の位置が変わり測定に影響したから',
      'おもりの形は周期に絶対に影響しないので実験がまちがっている',
      '糸の長さが自動的に変わったから',
    ],
    correctAnswer: '空気の抵抗の受け方や、おもりの中心の位置が変わり測定に影響したから',
    explanation: '理想的にはおもりの形は周期に影響しないが、実際の実験では空気抵抗や重心のずれで測定値に差が出ることがある。',
  ),

  // exp_020: もののとけ方（5年）
  TroubleshootQuestion(
    id: 'ts_020_01',
    experimentId: 'exp_020',
    difficulty: 1,
    scenario: '食塩を水にとかしたら見えなくなったが、全体の重さは変わらなかった。',
    choices: [
      '食塩は水の中に小さくなって広がっているだけで、なくなったわけではないから',
      '食塩は水にとけると消えてしまうから',
      '重さをはかる道具がこわれていたから',
    ],
    correctAnswer: '食塩は水の中に小さくなって広がっているだけで、なくなったわけではないから',
    explanation: '物が水にとけても、その物質はなくなったわけではなく、全体の重さは変わらない。',
  ),
  TroubleshootQuestion(
    id: 'ts_020_02',
    experimentId: 'exp_020',
    difficulty: 2,
    scenario: '食塩水をろ紙でこしても、とけた食塩はろ紙に残らなかった。',
    choices: [
      'とけた食塩は水の粒の間に均一に広がっていて、ろ紙の目を通り抜けるから',
      'ろ紙が食塩をとかしてしまったから',
      'ろ紙の使い方が間違っていたから',
    ],
    correctAnswer: 'とけた食塩は水の粒の間に均一に広がっていて、ろ紙の目を通り抜けるから',
    explanation: '水にとけた物質はごく小さな粒になって水全体に均一に広がるため、ろ紙では取り出せない。',
  ),
  TroubleshootQuestion(
    id: 'ts_020_03',
    experimentId: 'exp_020',
    difficulty: 2,
    scenario: '同じ量の水でも、お湯の方が食塩をたくさんとかすことができた。',
    choices: [
      '水の温度が高いほど、とける量が増えることが多いから',
      '水の温度はとける量に関係しないから',
      'お湯は食塩と違う成分だから',
    ],
    correctAnswer: '水の温度が高いほど、とける量が増えることが多いから',
    explanation: '多くの物質は水の温度が高いほどとける量（溶解度）が増える。',
  ),
  TroubleshootQuestion(
    id: 'ts_020_04',
    experimentId: 'exp_020',
    difficulty: 3,
    scenario: '同じ重さの食塩を、水の量が多いビーカーと少ないビーカーに入れたら、とけ方に差が出た。',
    choices: [
      '水の量が多いほど、より多くの物質をとかすことができるから',
      '水の量はとける量に関係しないから',
      'ビーカーの形の違いが原因だから',
    ],
    correctAnswer: '水の量が多いほど、より多くの物質をとかすことができるから',
    explanation: '水の量が多いほど、とかすことができる物質の量（限度）も増える。',
  ),
  TroubleshootQuestion(
    id: 'ts_020_05',
    experimentId: 'exp_020',
    difficulty: 3,
    scenario: 'ろ過して取り出した食塩水を熱してじょう発させたら、白いつぶが残った。',
    choices: [
      '水だけが蒸発し、とけていた食塩が結晶になって出てきたから',
      'ろ過の際に食塩が新しく作られたから',
      '熱することで水が食塩に変化したから',
    ],
    correctAnswer: '水だけが蒸発し、とけていた食塩が結晶になって出てきたから',
    explanation: '水を蒸発させると、とけていた物質だけが結晶として残り、取り出すことができる。',
  ),
];

// 便利な関数
TroubleshootQuestion? getTroubleshootQuestion(String questionId) {
  try {
    return troubleshootQuestions.firstWhere((q) => q.id == questionId);
  } catch (e) {
    return null;
  }
}

List<TroubleshootQuestion> getTroubleshootQuestionsByExperiment(
    String experimentId) {
  return troubleshootQuestions
      .where((q) => q.experimentId == experimentId)
      .toList();
}

List<TroubleshootQuestion> getTroubleshootQuestionsByDifficulty(
    int difficulty) {
  return troubleshootQuestions.where((q) => q.difficulty == difficulty).toList();
}
