/**
 * Anthropic Claude API への薄いラッパー。
 *
 * APIキーは呼び出し側（各 Cloud Function）が Secret Manager
 * (`defineSecret("ANTHROPIC_API_KEY")`) 経由で取得し、ここには文字列として渡すのみ。
 * クライアント（Flutterアプリ）には一切キーを渡さない。
 */

const ANTHROPIC_API_URL = "https://api.anthropic.com/v1/messages";
const ANTHROPIC_VERSION = "2023-06-01";

export class ClaudeApiError extends Error {
  readonly statusCode?: number;

  constructor(message: string, statusCode?: number) {
    super(message);
    this.name = "ClaudeApiError";
    this.statusCode = statusCode;
  }
}

interface ClaudeTextContent {
  type: "text";
  text: string;
}

interface ClaudeImageContent {
  type: "image";
  source: {
    type: "base64";
    media_type: string;
    data: string;
  };
}

type ClaudeContent = ClaudeTextContent | ClaudeImageContent;

interface ClaudeRequestOptions {
  apiKey: string;
  model: string;
  systemPrompt: string;
  content: ClaudeContent[];
  maxTokens: number;
  timeoutMs?: number;
}

/**
 * Claude Messages API を1ターンだけ呼び出し、最初のテキストブロックを返す。
 * Node.js 18+ のグローバル fetch を利用する（Cloud Functions Gen2 の
 * Node 20 ランタイムでは標準で利用可能）。
 */
export async function callClaudeOnce(
  options: ClaudeRequestOptions
): Promise<string> {
  const { apiKey, model, systemPrompt, content, maxTokens } = options;
  const timeoutMs = options.timeoutMs ?? 20000;

  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), timeoutMs);

  let response: Response;
  try {
    response = await fetch(ANTHROPIC_API_URL, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "x-api-key": apiKey,
        "anthropic-version": ANTHROPIC_VERSION,
      },
      body: JSON.stringify({
        model,
        max_tokens: maxTokens,
        system: systemPrompt,
        messages: [{ role: "user", content }],
      }),
      signal: controller.signal,
    });
  } catch (err) {
    throw new ClaudeApiError(
      `Claude API へのリクエストに失敗しました: ${(err as Error).message}`
    );
  } finally {
    clearTimeout(timeout);
  }

  if (response.status === 429) {
    throw new ClaudeApiError("Claude API のレート制限に達しました", 429);
  }
  if (!response.ok) {
    const bodyText = await response.text().catch(() => "");
    throw new ClaudeApiError(
      `Claude API エラー (status=${response.status}): ${bodyText}`,
      response.status
    );
  }

  const data = (await response.json()) as {
    content?: Array<{ type: string; text?: string }>;
  };

  const first = data.content?.[0];
  if (!first || first.type !== "text" || !first.text) {
    throw new ClaudeApiError("Claude API のレスポンスにテキストがありません");
  }

  return first.text;
}
