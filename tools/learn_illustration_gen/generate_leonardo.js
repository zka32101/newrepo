#!/usr/bin/env node
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 学習画面（stage_4/5/6）欠落イラスト 一括生成ツール（Leonardo.ai版）
// tools/rika_monster_image_gen/generate_leonardo.js の構成を継承。
// lib/data/seeds/learn_content_data.dart が imagePath として参照しているが
// 実ファイルが無い33枚を生成し、assets/illustrations/stage_{4,5,6}/ に保存する。
// 主題プロンプトの詳細は AI_IMAGE_PROMPTS_LEONARDO_STAGE_4_5_6.md を参照。
//
// 使い方:
//   （PowerShellでは事前に $env:LEONARDO_API_KEY="xxxx" を実行しておく）
//   node generate_leonardo.js --count 2               # 先頭2枚だけ（プロンプト品質確認用）
//   node generate_leonardo.js --ids stage_4_007_skeleton,stage_6_004_ph
//   node generate_leonardo.js --all                   # 残り全33枚をまとめて生成（推奨）
//   node generate_leonardo.js --all --force            # 既存分も含めて全部作り直す
//
// モデルについて:
//   デフォルトは tools/rika_monster_image_gen で実績のある modelId
//   （Leonardo Phoenix 1.0）をそのまま流用している。プロンプトドキュメント上は
//   Kino XL を推奨しているが、Kino XL の modelId をこちらでは検証できていないため、
//   確実に動作する Phoenix 1.0 をデフォルトにした。Kino XL を使いたい場合は
//   `GET /platformModels` で modelId を調べ、LEONARDO_MODEL_ID で上書きすること。
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

const fs = require('fs');
const path = require('path');
const { getAllIllustrationDefs, buildPrompt } = require('./prompt_builder');

const LEONARDO_API_KEY = process.env.LEONARDO_API_KEY;
// デフォルト: Leonardo Phoenix 1.0（rika_monster_image_gen で実績あり）
const LEONARDO_MODEL_ID = process.env.LEONARDO_MODEL_ID || 'de7d3faf-762f-48e0-b3b7-9d0ac3a3fcf3';
const ASSETS_ROOT = path.join(__dirname, '..', '..', 'assets', 'illustrations');
const API_BASE = 'https://cloud.leonardo.ai/api/rest/v1';

// アプリ表示（フルワイド×高さ200dp/160dp, BoxFit.cover）に合わせた16:9
const WIDTH = 1360;
const HEIGHT = 768;

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Leonardo.ai 呼び出し
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
async function generateImage(prompt, negativePrompt) {
  const createRes = await fetch(`${API_BASE}/generations`, {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${LEONARDO_API_KEY}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      prompt,
      negative_prompt: negativePrompt,
      modelId: LEONARDO_MODEL_ID,
      width: WIDTH,
      height: HEIGHT,
      num_images: 1,
      alchemy: false,
      photoReal: false,
    }),
  });

  if (!createRes.ok) {
    throw new Error(`Leonardo API error (create): ${createRes.status} ${await createRes.text()}`);
  }

  const created = await createRes.json();
  const genId = created?.sdGenerationJob?.generationId;
  if (!genId) {
    throw new Error(`generationId が取得できませんでした: ${JSON.stringify(created)}`);
  }

  // ポーリング（最大2分。1360x768はモンスター画像512x512より時間がかかるため長めに待つ）
  let attempts = 0;
  let images = null;
  while (attempts < 60) {
    await new Promise((r) => setTimeout(r, 2000));
    const poll = await fetch(`${API_BASE}/generations/${genId}`, {
      headers: { Authorization: `Bearer ${LEONARDO_API_KEY}` },
    });
    if (!poll.ok) {
      throw new Error(`Leonardo API error (poll): ${poll.status} ${await poll.text()}`);
    }
    const data = await poll.json();
    const gen = data.generations_by_pk;
    if (gen?.status === 'COMPLETE') {
      images = gen.generated_images;
      break;
    }
    if (gen?.status === 'FAILED') {
      throw new Error(`generation failed: ${JSON.stringify(gen)}`);
    }
    attempts++;
  }

  if (!images || !images[0]?.url) {
    throw new Error('画像生成がタイムアウトしました');
  }

  return images[0].url;
}

async function downloadTo(url, filePath) {
  const res = await fetch(url);
  if (!res.ok) throw new Error(`download failed: ${res.status}`);
  const buf = Buffer.from(await res.arrayBuffer());
  // 注: Leonardo が返す実バイト列の形式に関わらず、pubspec.yaml / imagePath が
  // 参照している .jpg 拡張子のまま保存する。Flutter の Image.asset は拡張子でなく
  // 画像データ自体のシグネチャでデコードするため、実用上問題ない
  // （tools/rika_monster_image_gen でも同様に無変換で保存している）。
  fs.writeFileSync(filePath, buf);
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// CLI
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
function parseArgs() {
  const args = process.argv.slice(2);
  const opts = { count: null, ids: null, all: false, force: false };
  for (let i = 0; i < args.length; i++) {
    if (args[i] === '--count') opts.count = parseInt(args[++i], 10);
    else if (args[i] === '--ids') opts.ids = args[++i].split(',').map((s) => s.trim());
    else if (args[i] === '--all') opts.all = true;
    else if (args[i] === '--force') opts.force = true;
  }
  return opts;
}

async function main() {
  if (!LEONARDO_API_KEY) {
    console.error('❌ LEONARDO_API_KEY が設定されていません。');
    console.error('   例: $env:LEONARDO_API_KEY="xxxx"; node generate_leonardo.js --count 2');
    process.exit(1);
  }

  const opts = parseArgs();
  const allDefs = getAllIllustrationDefs();
  console.log(`📋 イラスト定義 ${allDefs.length} 枚（stage_4/5/6、学習画面の欠落画像）`);

  let target;
  if (opts.ids) {
    target = allDefs.filter((d) => opts.ids.includes(d.id));
  } else if (opts.all) {
    target = allDefs;
  } else {
    const n = opts.count || 2;
    target = allDefs.slice(0, n);
  }

  if (target.length === 0) {
    console.error('❌ 対象イラストが見つかりません');
    process.exit(1);
  }

  const manifestPath = path.join(__dirname, 'manifest.json');
  const manifest = fs.existsSync(manifestPath)
    ? JSON.parse(fs.readFileSync(manifestPath, 'utf8'))
    : {};

  // API課金の節約: 既に画像ファイルが存在するものはデフォルトでスキップする
  let skipped = 0;
  const toGenerate = opts.force
    ? target
    : target.filter((def) => {
        const outPath = path.join(ASSETS_ROOT, def.grade, def.file);
        const exists = fs.existsSync(outPath);
        if (exists) skipped++;
        return !exists;
      });

  if (skipped > 0) {
    console.log(`⏭️  既存の${skipped}枚をスキップ（再生成するには --force を付けてください）`);
  }
  console.log(
    `🎨 ${toGenerate.length} 枚を生成します（Leonardo.ai / modelId=${LEONARDO_MODEL_ID} / ${WIDTH}x${HEIGHT} / alchemy=off）\n`
  );

  for (const def of toGenerate) {
    const { prompt, negativePrompt } = buildPrompt(def);
    const outDir = path.join(ASSETS_ROOT, def.grade);
    fs.mkdirSync(outDir, { recursive: true });
    const outFile = path.join(outDir, def.file);

    process.stdout.write(`  ${def.id} ... `);
    try {
      const imageUrl = await generateImage(prompt, negativePrompt);
      await downloadTo(imageUrl, outFile);
      manifest[def.id] = {
        grade: def.grade,
        file: `${def.grade}/${def.file}`,
        prompt,
        provider: 'leonardo',
        modelId: LEONARDO_MODEL_ID,
        width: WIDTH,
        height: HEIGHT,
        generatedAt: new Date().toISOString(),
      };
      fs.writeFileSync(manifestPath, JSON.stringify(manifest, null, 2));
      console.log('✅');
    } catch (e) {
      console.log(`❌ ${e.message}`);
    }
  }

  console.log(`\n完了（生成${toGenerate.length}枚 / スキップ${skipped}枚）。出力先: ${ASSETS_ROOT}`);
}

main().catch((e) => {
  console.error(`❌ 予期しないエラー: ${e.message}`);
  process.exit(1);
});
