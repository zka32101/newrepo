import 'package:cloud_functions/cloud_functions.dart';

// ② AIはかせチャット: Claude API呼び出しサービス
//
// APIキーはクライアントに一切埋め込まない。Firebase Cloud Functions の
// callable function (`askScience`) をサーバー側プロキシとして呼び出す。
// 月次利用回数の判定もサーバー側（Firestore）で行われ、クライアントは
// その結果（remaining）を表示に使うだけで、制限そのものはここでは強制しない
// （強制はサーバー側の責務。クライアント側の canSend/recordUsage は
// あくまで「無駄なリクエストを事前に減らすための表示上の最適化」に過ぎない）。
class ClaudeServiceException implements Exception {
  final String message;
  ClaudeServiceException(this.message);

  @override
  String toString() => message;
}

class AskScienceResult {
  final String reply;
  final int remaining;
  const AskScienceResult({required this.reply, required this.remaining});
}

class ClaudeService {
  ClaudeService({FirebaseFunctions? functions})
      : _functions =
            functions ?? FirebaseFunctions.instanceFor(region: 'asia-northeast1');

  final FirebaseFunctions _functions;

  Future<AskScienceResult> askHaiku(String question) async {
    try {
      final callable = _functions.httpsCallable(
        'askScience',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 30)),
      );
      final response = await callable.call<Map<String, dynamic>>({
        'question': question,
      });

      final data = response.data;
      final reply = data['reply'] as String?;
      final remaining = data['remaining'] as int?;
      if (reply == null || reply.isEmpty) {
        throw ClaudeServiceException('AIからの応答がありません');
      }

      return AskScienceResult(reply: reply, remaining: remaining ?? 0);
    } on FirebaseFunctionsException catch (e) {
      throw ClaudeServiceException(_messageFor(e));
    } catch (e) {
      throw ClaudeServiceException('つながらなかったよ。インターネットをかくにんしてね！');
    }
  }

  String _messageFor(FirebaseFunctionsException e) {
    switch (e.code) {
      case 'resource-exhausted':
        return e.message ?? '今月の無料回数を使い切ったよ。来月になるとまた使えるよ！';
      case 'unauthenticated':
        return 'サインインを確認できませんでした。少ししてからもう一度試してね！';
      case 'invalid-argument':
        return '質問の内容をもう一度確認してね！';
      case 'deadline-exceeded':
        return '応答に時間がかかりすぎました。もう一度試してね！';
      default:
        return 'エラーが起きたよ（${e.code}）。もう一度試してね！';
    }
  }
}
