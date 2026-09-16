import * as admin from "firebase-admin";
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { defineSecret } from "firebase-functions/params";
import { callClaudeOnce, ClaudeApiError } from "./claudeClient";
import { consumeUsageOrThrow, getUsageStatus, refundUsage } from "./usageLimiter";

// ② AIはかせチャット: サーバー側プロキシ + 月次利用回数制限
//
// クライアント(Flutter)には Anthropic API キーを一切渡さない。
// リクエストは Firebase Authentication の ID トークンで認証し
// (request.auth.uid)、利用回数は Firestore 上のカウンタを
// Cloud Functions からのみ更新することでクライアント側改ざんを防ぐ。

const ANTHROPIC_API_KEY = defineSecret("ANTHROPIC_API_KEY");

const FREE_MONTHLY_LIMIT = 5;
const USAGE_COLLECTION = "aiChatUsage";
const MODEL = "claude-haiku-4-5-20251001";
const MAX_QUESTION_LENGTH = 500;

const SYSTEM_PROMPT = `あなたは「りかハカセ」という小学生の理科の先生キャラクターです。
小学3〜6年生がわかる言葉で、やさしく・楽しく理科の質問に答えてください。

ルール:
- むずかしい言葉を使わないで、できるだけかんたんに
- 「〜だよ！」「〜なんだよ！」など、元気な話し方で
- ふりがなを使ってわかりやすく（例：磁石（じしゃく））
- 答えが長くなりすぎないように（200文字以内を目安に）
- 理科・科学以外の質問には「それはりかハカセには難しいな〜！理科の質問をしてね！」と答えて
- 危険なこと・不適切な内容には答えないで

キャラクター:
- 理科が大好きで明るい博士
- 実験の話が大好き
- 子どもを応援するポジティブな言葉をよく使う`;

/**
 * 理科の質問をAIはかせ(Claude)に聞く。
 * 呼び出し前に月次利用回数を消費し、上限超過時は resource-exhausted を返す。
 */
export const askScience = onCall(
  {
    secrets: [ANTHROPIC_API_KEY],
    region: "asia-northeast1",
    timeoutSeconds: 30,
    memory: "256MiB",
  },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "サインインが必要です");
    }
    const uid = request.auth.uid;

    const rawQuestion = request.data?.question;
    const question = typeof rawQuestion === "string" ? rawQuestion.trim() : "";
    if (!question) {
      throw new HttpsError("invalid-argument", "質問が空です");
    }
    if (question.length > MAX_QUESTION_LENGTH) {
      throw new HttpsError("invalid-argument", "質問が長すぎます");
    }

    const db = admin.firestore();

    // 上限チェック＆消費（呼び出し失敗時は下で払い戻す）
    const usage = await consumeUsageOrThrow(
      db,
      uid,
      USAGE_COLLECTION,
      FREE_MONTHLY_LIMIT
    );

    try {
      const reply = await callClaudeOnce({
        apiKey: ANTHROPIC_API_KEY.value(),
        model: MODEL,
        systemPrompt: SYSTEM_PROMPT,
        content: [{ type: "text", text: question }],
        maxTokens: 300,
      });

      return { reply, remaining: usage.remaining };
    } catch (err) {
      // Claude API呼び出し自体が失敗した場合は消費した1回分を払い戻す
      await refundUsage(db, uid, USAGE_COLLECTION);

      if (err instanceof ClaudeApiError && err.statusCode === 429) {
        throw new HttpsError(
          "resource-exhausted",
          "ただいまとても混んでいます。少し待ってからもう一度聞いてね！"
        );
      }
      console.error("askScience failed", err);
      throw new HttpsError("internal", "AIとの通信でエラーが発生しました");
    }
  }
);

/** 消費せずに現在の利用状況だけを取得する（画面表示用）。 */
export const getAiChatUsageStatus = onCall(
  { region: "asia-northeast1" },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "サインインが必要です");
    }
    const db = admin.firestore();
    const status = await getUsageStatus(
      db,
      request.auth.uid,
      USAGE_COLLECTION,
      FREE_MONTHLY_LIMIT
    );
    return { ...status, limit: FREE_MONTHLY_LIMIT };
  }
);
