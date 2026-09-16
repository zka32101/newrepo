# 小学コレ！理科 4〜6年生 AI画像生成プロンプト（Leonardo.AI用）

対象: `lib/data/seeds/learn_content_data.dart` に定義済みだが実ファイルが未配置の33枚
（引継ぎ元: 欠落画像リスト。`assets/illustrations/stage_4|5|6/` に配置する）

## 共通方針

- **スタイル**: リアル×かわいいハイブリッド（既存の `AI_IMAGE_PROMPTS_LEONARDO.md` と統一）。anime影響のかわいい比率＋自然な色調・光。
- **対象年齢**: 小学4〜6年生（9〜12歳）
- **画像内に文字・ラベルを入れない**: アプリ側でキャプションを別途テキスト表示するため、画像はラベル無しの図解/イラストにする（Leonardo.AIは日本語文字の描画精度が低いため）
- **タイプA（診断図・概念図）**: 骨格・消化・月・天気図・てこ・電磁石・pH・光の反射など、人物を出さずに「モノ・現象そのもの」を分かりやすく描く図解イラスト
- **タイプB（観察・情景）**: メダカのライフサイクル・花の構造・生態系など、写実寄りの自然観察イラスト。人物を入れる場合は既存キャラ設定（青いフード・赤いバックパック等）に寄せなくてよい（背景/事象が主役）

## 共通スタイル・サフィックス（各プロンプト末尾に必ず付ける）

```
Semi-realistic anime-influenced educational illustration for a Japanese elementary school
science learning app (grades 4-6). Clean, uncluttered composition. Warm, soft natural
lighting, vibrant but not oversaturated colors. Friendly and encouraging atmosphere,
never scary or grotesque. No embedded text, no labels, no letters, no numbers, no
watermark, no signature — this illustration will have captions added separately by the
app. High quality, 4K, professional educational illustration.
```

## 共通ネガティブプロンプト

```
blurry, low quality, dark, scary, grotesque, gore, overly realistic internal organs,
distorted proportions, bad anatomy, extra limbs, text, watermark, signature, letters,
words, japanese text, english text, captions, labels, arrows with text, jpeg artifacts,
oversaturated, cluttered background, photorealistic gore
```

## 共通設定（Leonardo.AI）

| 項目 | 値 |
|---|---|
| Model | Leonardo Kino XL |
| Quality | High |
| Guidance Scale | 7–8 |
| Steps | 60–80 |
| Aspect Ratio | 16:9（アプリ表示が横長フルワイド×高さ200dp/160dpのため） |
| Style Preset | Illustration, Semi-Realistic |

---

## プロンプト一覧

各行の「主題プロンプト」を共通スタイル・サフィックスの**前**に置いて1つのプロンプトとして使う。
例: `stage_4_007_skeleton.jpg` の場合 →
`A friendly, clear diagram-style illustration of a human skeleton and major muscle groups viewed from the front, bones in soft ivory-white tone, muscles in gentle red tone, simple standing pose. + [共通スタイル・サフィックス]`

### stage_4（4年生）

| ファイル | タイプ | 主題プロンプト |
|---|---|---|
| `stage_4_007_skeleton.jpg` | A | A friendly, clear diagram-style illustration of a human skeleton and major muscle groups viewed from the front, bones in soft ivory-white tone, muscles in gentle translucent red overlay, simple standing pose, plain light background |
| `stage_4_007_organs.jpg` | A | A friendly, clear diagram-style illustration of the human torso showing major internal organs (heart, lungs, stomach, intestines) in soft pastel colors, simplified anatomical style (not graphic/gory), front view silhouette, plain light background |
| `stage_4_008_digestive.jpg` | A | A friendly diagram-style illustration of the human digestive tract pathway from mouth through esophagus, stomach, and intestines, shown as a smooth flowing tube inside a simplified body silhouette, soft pastel colors, plain light background |
| `stage_4_009_stars.jpg` | B | A dreamy night sky illustration showing four seasonal star constellations arranged softly across a gradient dark-blue sky, twinkling stars, faint Milky Way, warm and magical but scientifically accurate constellation shapes, no ground clutter |
| `stage_4_010_moon_phases.jpg` | A | A clear diagram-style illustration of the moon's phase cycle, showing 5 moon phases (new moon, crescent, first quarter, full moon, last quarter) arranged in a gentle arc against a soft night-sky gradient background, each moon rendered with soft realistic shading |
| `stage_4_011_weather_map.jpg` | A | A friendly, simplified weather map illustration of Japan from above, showing soft blue high-pressure swirl and soft gray low-pressure swirl over a stylized map, gentle cloud illustrations, clean and simple cartographic style, no text |

### stage_5（5年生）

| ファイル | タイプ | 主題プロンプト |
|---|---|---|
| `stage_5_001_flower_structure.jpg` | B | A detailed, friendly botanical illustration of a cross-section of a large flower (like a lily or tulip) clearly showing petals, stamen, and pistil in natural vivid colors, soft studio lighting, plain light background |
| `stage_5_002_germination.jpg` | B | A gentle illustration showing a seed germinating in soil across three growth stages side by side (seed, sprouting root and shoot, small seedling with leaves), warm earthy tones, soft natural lighting |
| `stage_5_003_medaka_lifecycle.jpg` | B | A cute, gentle illustration of the life cycle of Japanese medaka fish (killifish) shown as a circular sequence: egg, hatching, young fry, adult fish swimming, set in a soft blue aquatic watercolor-style background |
| `stage_5_004_river_flow.jpg` | B | A wide landscape illustration of a river flowing from steep rocky mountains (upstream) through a winding valley (midstream) into a calm wide flat plain (downstream), showing the changing terrain and water speed naturally, soft painterly style |
| `stage_5_005_water_erosion.jpg` | A | A diagram-style illustration of a river bank cross-section showing water erosion, transport, and deposition: rocks being worn away on one side, sediment carried by flowing water, and sand settling on the other side, soft natural colors |
| `stage_5_005_water_cycle.jpg` | A | A friendly diagram-style illustration of the water cycle showing ice, liquid water, and rising water vapor/clouds in one gentle circular scene, soft blue and white tones, warm sunlight |
| `stage_5_006_combustion_triangle.jpg` | A | A simple, friendly diagram-style illustration of a fire triangle concept: a small gentle flame, a wisp of oxygen/air represented as soft swirls, and a piece of wood as fuel, arranged in a triangle composition, warm soft glow, not scary |
| `stage_5_006_lever.jpg` | A | A clear diagram-style illustration of a simple lever/see-saw mechanism showing a long bar resting on a triangular fulcrum, with a hand pressing down on one end and a weight lifting on the other end, clean mechanical illustration, plain background |
| `stage_5_007_magnetic_field.jpg` | A | A diagram-style illustration of a coil of wire with a battery, showing soft glowing magnetic field lines curving around the coil, clean electromagnetism illustration, soft blue and orange glow, plain background |
| `stage_5_007_gas_properties.jpg` | A | A friendly diagram-style illustration comparing three gases (oxygen, nitrogen, carbon dioxide) as soft glowing colored particle clouds in separate transparent containers, gentle scientific illustration, plain light background |
| `stage_5_008_electromagnet.jpg` | B | A friendly illustration of a hand wrapping insulated wire around an iron nail to make an electromagnet, connected to a battery, with paperclips being attracted to the nail tip, warm classroom lighting |
| `stage_5_009_expansion.jpg` | A | A simple diagram-style illustration showing thermal expansion: a glass tube with liquid rising higher when warm (red glow) versus lower when cool (blue glow), side-by-side comparison, clean scientific illustration |
| `stage_5_010_dissolution.jpg` | A | A gentle illustration showing salt or sugar crystals dissolving into a glass of water, with soft sparkling particle effects showing the dissolving process, clean and simple, plain light background |
| `stage_5_011_environment.jpg` | B | A warm, wide illustration showing the same landscape across two gentle seasonal changes (e.g. spring greenery and autumn colors) side by side, showing nature's response to environment, soft painterly style |
| `stage_5_012_food_chain.jpg` | B | A friendly illustration of a food chain sequence arranged left to right: a green plant, a small insect eating it, a bird eating the insect, and a small forest carnivore, connected by soft gentle arrows made of light, warm natural setting |

### stage_6（6年生）

| ファイル | タイプ | 主題プロンプト |
|---|---|---|
| `stage_6_001_light_mirror.jpg` | A | A clean diagram-style illustration of a beam of light hitting a mirror and reflecting off at an equal angle, shown as soft glowing light rays against a plain dark background, simple physics illustration |
| `stage_6_002_sound_wave.jpg` | A | A friendly diagram-style illustration of sound waves shown as smooth colorful wave patterns of different heights (amplitude) and spacing (frequency), glowing softly against a plain dark background |
| `stage_6_003_combustion.jpg` | A | A simple, friendly diagram-style illustration of a fire triangle concept: fuel (a small log), oxygen (soft air swirls), and heat (a gentle warm glow), arranged clearly, warm but not scary |
| `stage_6_004_ph.jpg` | A | A clean diagram-style illustration of a pH scale shown as a smooth gradient color bar from red (acidic) through green (neutral) to purple (basic/alkaline), with a few labeled-free sample liquid droplets floating above each zone, plain background |
| `stage_6_005_earth_orbit.jpg` | A | A beautiful diagram-style illustration of Earth's rotation and orbit around the sun, showing Earth at four positions around a glowing sun with a soft starry space background, clean astronomical illustration |
| `stage_6_006_fossils.jpg` | B | A warm illustration of a cross-section of layered rock strata (sedimentary layers) with a gentle fossil shape (ammonite or leaf imprint) visible in one layer, earthy natural tones, educational and non-scary |
| `stage_6_007_photosynthesis.jpg` | A | A friendly diagram-style illustration of a green leaf cross-section showing sunlight entering, tiny stomata pores, and soft glowing particles representing gas exchange, warm natural green tones, plain background |
| `stage_6_008_energy.jpg` | A | A friendly diagram-style illustration showing energy transformation as a gentle flowing sequence: a glowing sun, a solar panel, a light bulb and a warm heater, connected by soft glowing light-trail arrows, clean and simple |
| `stage_6_009_geology.jpg` | B | A warm illustration of a cross-section of the earth's crust showing distinct layered rock strata in varied earthy colors stacked naturally, educational geology illustration, soft lighting |
| `stage_6_010_weather.jpg` | A | A friendly, simplified weather map illustration showing high-pressure and low-pressure systems as soft swirls with a weather front line, gentle clouds, clean cartographic illustration style, no text |
| `stage_6_011_ecosystem.jpg` | B | A warm, wide illustration of a small pond ecosystem (biotope) showing plants, fish, insects, and birds coexisting in a natural cycle, soft painterly nature illustration, gentle sunlight |
| `stage_6_012_body_systems.jpg` | A | A friendly diagram-style illustration of a simplified human body silhouette showing four soft-colored overlay systems (digestive, circulatory, respiratory, nervous) each in a distinct soft pastel tone, front view, plain light background |

---

## 実行手順（既存ドキュメントと同様）

1. leonardo.ai → Create → Image Generation
2. 上表の「主題プロンプト」＋共通スタイル・サフィックスを結合してメインプロンプト欄へ
3. ネガティブプロンプト欄に共通ネガティブプロンプットを入力
4. 設定は共通設定の表のとおり
5. Generate → 生成後ギャラリーから最良の1枚を選択、必要ならUpscale
6. ファイル名は `assets/illustrations/stage_N/` 配下、上表のファイル名どおりに保存

## ライセンス・著作権メモ

- Leonardo.AIで生成した画像は商用利用可（利用規約要確認）
- Wikipedia等の外部画像を使わずAI生成のみで完結する場合、`ATTRIBUTION.md`は不要
