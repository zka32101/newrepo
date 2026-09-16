// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 学習画面（stage_4/5/6）欠落イラスト プロンプト組み立てモジュール
// tools/rika_monster_image_gen/prompt_builder.js の設計を継承。
// 対象は lib/data/seeds/learn_content_data.dart / learn_content_data_merged.dart に
// imagePath として定義済みだが、assets/ に実ファイルが無い33枚。
// 詳細な方針は AI_IMAGE_PROMPTS_LEONARDO_STAGE_4_5_6.md を参照。
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// 共通スタイル・サフィックス（全プロンプト末尾に付与）
const STYLE_SUFFIX =
  'Semi-realistic anime-influenced educational illustration for a Japanese elementary school ' +
  'science learning app (grades 4-6). Clean, uncluttered composition. Warm, soft natural ' +
  'lighting, vibrant but not oversaturated colors. Friendly and encouraging atmosphere, ' +
  'never scary or grotesque. No embedded text, no labels, no letters, no numbers, no ' +
  'watermark, no signature — this illustration will have captions added separately by the ' +
  'app. High quality, 4K, professional educational illustration.';

// 共通ネガティブプロンプト
const NEGATIVE_PROMPT =
  'blurry, low quality, dark, scary, grotesque, gore, overly realistic internal organs, ' +
  'distorted proportions, bad anatomy, extra limbs, text, watermark, signature, letters, ' +
  'words, japanese text, english text, captions, labels, arrows with text, jpeg artifacts, ' +
  'oversaturated, cluttered background, photorealistic gore';

// file: assets/illustrations/{grade}/{file} に保存するファイル名（拡張子込み）
// subject: 主題プロンプト（英語）。STYLE_SUFFIX と結合して最終プロンプトになる。
const ILLUSTRATIONS = [
  // ── stage_4（4年生） ──────────────────────────────
  {
    grade: 'stage_4',
    file: 'stage_4_007_skeleton.jpg',
    subject:
      'A friendly, clear diagram-style illustration of a human skeleton and major muscle groups viewed from the front, bones in soft ivory-white tone, muscles in gentle translucent red overlay, simple standing pose, plain light background',
  },
  {
    grade: 'stage_4',
    file: 'stage_4_007_organs.jpg',
    subject:
      'A friendly, clear diagram-style illustration of the human torso showing major internal organs (heart, lungs, stomach, intestines) in soft pastel colors, simplified anatomical style (not graphic/gory), front view silhouette, plain light background',
  },
  {
    grade: 'stage_4',
    file: 'stage_4_008_digestive.jpg',
    subject:
      'A friendly diagram-style illustration of the human digestive tract pathway from mouth through esophagus, stomach, and intestines, shown as a smooth flowing tube inside a simplified body silhouette, soft pastel colors, plain light background',
  },
  {
    grade: 'stage_4',
    file: 'stage_4_009_stars.jpg',
    subject:
      'A dreamy night sky illustration showing four seasonal star constellations arranged softly across a gradient dark-blue sky, twinkling stars, faint Milky Way, warm and magical but scientifically accurate constellation shapes, no ground clutter',
  },
  {
    grade: 'stage_4',
    file: 'stage_4_010_moon_phases.jpg',
    subject:
      "A clear diagram-style illustration of the moon's phase cycle, showing 5 moon phases (new moon, crescent, first quarter, full moon, last quarter) arranged in a gentle arc against a soft night-sky gradient background, each moon rendered with soft realistic shading",
  },
  {
    grade: 'stage_4',
    file: 'stage_4_011_weather_map.jpg',
    subject:
      'A friendly, simplified weather map illustration of Japan from above, showing soft blue high-pressure swirl and soft gray low-pressure swirl over a stylized map, gentle cloud illustrations, clean and simple cartographic style, no text',
  },

  // ── stage_5（5年生） ──────────────────────────────
  {
    grade: 'stage_5',
    file: 'stage_5_001_flower_structure.jpg',
    subject:
      'A detailed, friendly botanical illustration of a cross-section of a large flower (like a lily or tulip) clearly showing petals, stamen, and pistil in natural vivid colors, soft studio lighting, plain light background',
  },
  {
    grade: 'stage_5',
    file: 'stage_5_002_germination.jpg',
    subject:
      'A gentle illustration showing a seed germinating in soil across three growth stages side by side (seed, sprouting root and shoot, small seedling with leaves), warm earthy tones, soft natural lighting',
  },
  {
    grade: 'stage_5',
    file: 'stage_5_003_medaka_lifecycle.jpg',
    subject:
      'A cute, gentle illustration of the life cycle of Japanese medaka fish (killifish) shown as a circular sequence: egg, hatching, young fry, adult fish swimming, set in a soft blue aquatic watercolor-style background',
  },
  {
    grade: 'stage_5',
    file: 'stage_5_004_river_flow.jpg',
    subject:
      'A wide landscape illustration of a river flowing from steep rocky mountains (upstream) through a winding valley (midstream) into a calm wide flat plain (downstream), showing the changing terrain and water speed naturally, soft painterly style',
  },
  {
    grade: 'stage_5',
    file: 'stage_5_005_water_erosion.jpg',
    subject:
      'A diagram-style illustration of a river bank cross-section showing water erosion, transport, and deposition: rocks being worn away on one side, sediment carried by flowing water, and sand settling on the other side, soft natural colors',
  },
  {
    grade: 'stage_5',
    file: 'stage_5_005_water_cycle.jpg',
    subject:
      'A friendly diagram-style illustration of the water cycle showing ice, liquid water, and rising water vapor/clouds in one gentle circular scene, soft blue and white tones, warm sunlight',
  },
  {
    grade: 'stage_5',
    file: 'stage_5_006_combustion_triangle.jpg',
    subject:
      'A simple, friendly diagram-style illustration of a fire triangle concept: a small gentle flame, a wisp of oxygen/air represented as soft swirls, and a piece of wood as fuel, arranged in a triangle composition, warm soft glow, not scary',
  },
  {
    grade: 'stage_5',
    file: 'stage_5_006_lever.jpg',
    subject:
      'A clear diagram-style illustration of a simple lever/see-saw mechanism showing a long bar resting on a triangular fulcrum, with a hand pressing down on one end and a weight lifting on the other end, clean mechanical illustration, plain background',
  },
  {
    grade: 'stage_5',
    file: 'stage_5_007_magnetic_field.jpg',
    subject:
      'A diagram-style illustration of a coil of wire with a battery, showing soft glowing magnetic field lines curving around the coil, clean electromagnetism illustration, soft blue and orange glow, plain background',
  },
  {
    grade: 'stage_5',
    file: 'stage_5_007_gas_properties.jpg',
    subject:
      'A friendly diagram-style illustration comparing three gases (oxygen, nitrogen, carbon dioxide) as soft glowing colored particle clouds in separate transparent containers, gentle scientific illustration, plain light background',
  },
  {
    grade: 'stage_5',
    file: 'stage_5_008_electromagnet.jpg',
    subject:
      'A friendly illustration of a hand wrapping insulated wire around an iron nail to make an electromagnet, connected to a battery, with paperclips being attracted to the nail tip, warm classroom lighting',
  },
  {
    grade: 'stage_5',
    file: 'stage_5_009_expansion.jpg',
    subject:
      'A simple diagram-style illustration showing thermal expansion: a glass tube with liquid rising higher when warm (red glow) versus lower when cool (blue glow), side-by-side comparison, clean scientific illustration',
  },
  {
    grade: 'stage_5',
    file: 'stage_5_010_dissolution.jpg',
    subject:
      'A gentle illustration showing salt or sugar crystals dissolving into a glass of water, with soft sparkling particle effects showing the dissolving process, clean and simple, plain light background',
  },
  {
    grade: 'stage_5',
    file: 'stage_5_011_environment.jpg',
    subject:
      "A warm, wide illustration showing the same landscape across two gentle seasonal changes (e.g. spring greenery and autumn colors) side by side, showing nature's response to environment, soft painterly style",
  },
  {
    grade: 'stage_5',
    file: 'stage_5_012_food_chain.jpg',
    subject:
      'A friendly illustration of a food chain sequence arranged left to right: a green plant, a small insect eating it, a bird eating the insect, and a small forest carnivore, connected by soft gentle arrows made of light, warm natural setting',
  },

  // ── stage_6（6年生） ──────────────────────────────
  {
    grade: 'stage_6',
    file: 'stage_6_001_light_mirror.jpg',
    subject:
      'A clean diagram-style illustration of a beam of light hitting a mirror and reflecting off at an equal angle, shown as soft glowing light rays against a plain dark background, simple physics illustration',
  },
  {
    grade: 'stage_6',
    file: 'stage_6_002_sound_wave.jpg',
    subject:
      'A friendly diagram-style illustration of sound waves shown as smooth colorful wave patterns of different heights (amplitude) and spacing (frequency), glowing softly against a plain dark background',
  },
  {
    grade: 'stage_6',
    file: 'stage_6_003_combustion.jpg',
    subject:
      'A simple, friendly diagram-style illustration of a fire triangle concept: fuel (a small log), oxygen (soft air swirls), and heat (a gentle warm glow), arranged clearly, warm but not scary',
  },
  {
    grade: 'stage_6',
    file: 'stage_6_004_ph.jpg',
    subject:
      'A clean diagram-style illustration of a pH scale shown as a smooth gradient color bar from red (acidic) through green (neutral) to purple (basic/alkaline), with a few label-free sample liquid droplets floating above each zone, plain background',
  },
  {
    grade: 'stage_6',
    file: 'stage_6_005_earth_orbit.jpg',
    subject:
      "A beautiful diagram-style illustration of Earth's rotation and orbit around the sun, showing Earth at four positions around a glowing sun with a soft starry space background, clean astronomical illustration",
  },
  {
    grade: 'stage_6',
    file: 'stage_6_006_fossils.jpg',
    subject:
      'A warm illustration of a cross-section of layered rock strata (sedimentary layers) with a gentle fossil shape (ammonite or leaf imprint) visible in one layer, earthy natural tones, educational and non-scary',
  },
  {
    grade: 'stage_6',
    file: 'stage_6_007_photosynthesis.jpg',
    subject:
      'A friendly diagram-style illustration of a green leaf cross-section showing sunlight entering, tiny stomata pores, and soft glowing particles representing gas exchange, warm natural green tones, plain background',
  },
  {
    grade: 'stage_6',
    file: 'stage_6_008_energy.jpg',
    subject:
      'A friendly diagram-style illustration showing energy transformation as a gentle flowing sequence: a glowing sun, a solar panel, a light bulb and a warm heater, connected by soft glowing light-trail arrows, clean and simple',
  },
  {
    grade: 'stage_6',
    file: 'stage_6_009_geology.jpg',
    subject:
      "A warm illustration of a cross-section of the earth's crust showing distinct layered rock strata in varied earthy colors stacked naturally, educational geology illustration, soft lighting",
  },
  {
    grade: 'stage_6',
    file: 'stage_6_010_weather.jpg',
    subject:
      'A friendly, simplified weather map illustration showing high-pressure and low-pressure systems as soft swirls with a weather front line, gentle clouds, clean cartographic illustration style, no text',
  },
  {
    grade: 'stage_6',
    file: 'stage_6_011_ecosystem.jpg',
    subject:
      'A warm, wide illustration of a small pond ecosystem (biotope) showing plants, fish, insects, and birds coexisting in a natural cycle, soft painterly nature illustration, gentle sunlight',
  },
  {
    grade: 'stage_6',
    file: 'stage_6_012_body_systems.jpg',
    subject:
      'A friendly diagram-style illustration of a simplified human body silhouette showing four soft-colored overlay systems (digestive, circulatory, respiratory, nervous) each in a distinct soft pastel tone, front view, plain light background',
  },
];

function getAllIllustrationDefs() {
  // id はスキップ判定・--ids 指定用の短い識別子（拡張子を除いたファイル名）
  return ILLUSTRATIONS.map((d) => ({ ...d, id: d.file.replace(/\.jpg$/, '') }));
}

function buildPrompt(def) {
  const prompt = `${def.subject}. ${STYLE_SUFFIX}`;
  return { prompt, negativePrompt: NEGATIVE_PROMPT };
}

module.exports = { getAllIllustrationDefs, buildPrompt, STYLE_SUFFIX, NEGATIVE_PROMPT };
