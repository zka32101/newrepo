import * as admin from "firebase-admin";
import { HttpsError } from "firebase-functions/v2/https";

/**
 * 月次利用回数の管理。
 *
 * カウンタは Firestore の `users/{uid}/{usageCollection}/{yyyy-MM}` に保存する。
 * firestore.rules 側でこのサブコレクションへのクライアント直接読み書きは
 * 許可していない（デフォルト deny）ため、カウンタは Cloud Functions
 * （Admin SDK・ルール無視）からしか変更できない = クライアント改ざん不可。
 */

export function currentYearMonth(date: Date = new Date()): string {
  const y = date.getUTCFullYear();
  // 日本時間との差は最大でも日付が1日ずれる程度で、月次カウンタの
  // 用途では十分な精度のため UTC を採用する。
  const m = (date.getUTCMonth() + 1).toString().padStart(2, "0");
  return `${y}-${m}`;
}

export interface UsageResult {
  usedCount: number;
  remaining: number;
}

/**
 * 上限に達していなければカウンタを1消費し、新しい使用回数を返す。
 * 上限到達時は HttpsError("resource-exhausted") を投げる。
 * Firestore トランザクションで読み取り→判定→書き込みを行うため、
 * 同一ユーザーからの同時リクエストでも上限を超えて消費されることはない。
 */
export async function consumeUsageOrThrow(
  db: admin.firestore.Firestore,
  uid: string,
  usageCollection: string,
  limit: number
): Promise<UsageResult> {
  const ref = db
    .collection("users")
    .doc(uid)
    .collection(usageCollection)
    .doc(currentYearMonth());

  const usedCount = await db.runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    const used = (snap.exists ? (snap.data()?.count as number) : 0) || 0;
    if (used >= limit) {
      throw new HttpsError(
        "resource-exhausted",
        "今月の無料利用回数の上限に達しました"
      );
    }
    const next = used + 1;
    tx.set(
      ref,
      { count: next, updatedAt: admin.firestore.FieldValue.serverTimestamp() },
      { merge: true }
    );
    return next;
  });

  return { usedCount, remaining: Math.max(limit - usedCount, 0) };
}

/** API呼び出し自体が失敗した場合に、消費したカウントを1つ払い戻す。 */
export async function refundUsage(
  db: admin.firestore.Firestore,
  uid: string,
  usageCollection: string
): Promise<void> {
  const ref = db
    .collection("users")
    .doc(uid)
    .collection(usageCollection)
    .doc(currentYearMonth());
  try {
    await ref.set(
      { count: admin.firestore.FieldValue.increment(-1) },
      { merge: true }
    );
  } catch (err) {
    // 払い戻し失敗はユーザー体験上致命的ではないためログのみ
    console.error("usage refund failed", err);
  }
}

export async function getUsageStatus(
  db: admin.firestore.Firestore,
  uid: string,
  usageCollection: string,
  limit: number
): Promise<UsageResult> {
  const ref = db
    .collection("users")
    .doc(uid)
    .collection(usageCollection)
    .doc(currentYearMonth());
  const snap = await ref.get();
  const usedCount = (snap.exists ? (snap.data()?.count as number) : 0) || 0;
  return { usedCount, remaining: Math.max(limit - usedCount, 0) };
}
