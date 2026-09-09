import * as admin from "firebase-admin";
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { defineSecret } from "firebase-functions/params";
import { callClaudeOnce, ClaudeApiError } from "./claudeClient";
import { consumeUsageOrThrow, refundUsage } from "./usageLimiter";

// ⑤ いきものカメラ: Claude Vision サーバー側プロキシ + 月次利用回数制限
//
// AIはかせチャットと同じ理由（APIキーの非露出・改ざん不可な回数制限）で
// Cloud Functions 経由にする。画像は base64 文字列でクライアントから送る。

const ANTHROPIC_API_KEY = defineSecret("ANTHROPIC_API_KEY");

const FREE_MONTHLY_LIMIT = 5;
const USAGE_COLLECTION = "creatureIdUsage";
const MODEL = "claude-3-5-sonnet-20241022";
// Base64エンコード後で ~6MB 程度（元画像 4.5MB 程度）を上限にし、
// Cloud Functions のリクエストサイズ・Claude API 側の制限に配慮する。
const MAX_BASE64_LENGTH = 6 * 1024 * 1024;
const ALLOWED_MEDIA_TYPES = new Set([
  "image/jpeg",
  "image/png",
  "image/gif",
  "image/webp",
]);

const SYSTEM_PROMPT = `あなたは小学生向けの博物学者です。
提供された画像から生き物を特定し、以下の JSON フォーマットで返してください：
{
  "name": "日本語の生き物名",
  "species": "学名",
  "description": "簡潔な説明（100字以内）",
  "habitat": "生息地",
  "diet": "食性",
  "lifeSpan": "寿命",
  "interestingFact": "面白い事実",
  "emoji": "適切な絵文字",
  "confidence": 0.8
}

生き物が見つからない場合は、最も近い可能性のある生き物を返してください。
confidence は 0.0-1.0 の数値で信頼度を表現してください。`;

const USER_PROMPT = "この画像に写っている生き物を特定して、JSON形式で情報を教えてください。";

export const identifyCreature = onCall(
  {
    secrets: [ANTHROPIC_API_KEY],
    region: "asia-northeast1",
    timeoutSeconds: 45,
    memory: "256MiB",
  },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "サインインが必要です");
    }
    const uid = request.auth.uid;

    const imageBase64 = request.data?.imageBase64;
    const mediaType = request.data?.mediaType ?? "image/jpeg";

    if (typeof imageBase64 !== "string" || imageBase64.length === 0) {
      throw new HttpsError("invalid-argument", "画像データがありません");
    }
    if (imageBase64.length > MAX_BASE64_LENGTH) {
      throw new HttpsError("invalid-argument", "画像サイズが大きすぎます");
    }
    if (
      typeof mediaType !== "string" ||
      !ALLOWED_MEDIA_TYPES.has(mediaType)
    ) {
      throw new HttpsError("invalid-argument", "対応していない画像形式です");
    }

    const db = admin.firestore();
    const usage = await consumeUsageOrThrow(
      db,
      uid,
      USAGE_COLLECTION,
      FREE_MONTHLY_LIMIT
    );

    try {
      const text = await callClaudeOnce({
        apiKey: ANTHROPIC_API_KEY.value(),
        model: MODEL,
        systemPrompt: SYSTEM_PROMPT,
        maxTokens: 1024,
        content: [
          {
            type: "image",
            source: { type: "base64", media_type: mediaType, data: imageBase64 },
          },
          { type: "text", text: USER_PROMPT },
        ],
      });

      const jsonMatch = /```json\n([\s\S]*?)\n```/.exec(text);
      const jsonStr = jsonMatch ? jsonMatch[1] : text;
      let parsed: Record<string, unknown>;
      try {
        parsed = JSON.parse(jsonStr);
      } catch {
        throw new HttpsError("internal", "AIの応答を解析できませんでした");
      }

      return { result: parsed, remaining: usage.remaining };
    } catch (err) {
      await refundUsage(db, uid, USAGE_COLLECTION);

      if (err instanceof HttpsError) throw err;
      if (err instanceof ClaudeApiError && err.statusCode === 429) {
        throw new HttpsError(
          "resource-exhausted",
          "AIがとても混んでいます。少し待ってからもう一度試してね！"
        );
      }
      console.error("identifyCreature failed", err);
      throw new HttpsError("internal", "生き物の特定でエラーが発生しました");
    }
  }
);
