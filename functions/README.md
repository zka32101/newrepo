# Cloud Functions（AIプロキシ）

`AIはかせチャット`・`いきものカメラ` から Anthropic Claude API を呼ぶための
薄いプロキシ関数。APIキーはこの Functions 環境（Secret Manager）にのみ置き、
Flutterクライアントには一切渡さない。月次利用回数もここ（Firestore）で検証する。

## 初回セットアップ（未実施 — ユーザー作業）

このリポジトリの `lib/firebase_options.dart` はプレースホルダ値（`dummy_*`）の
ままで、実際の Firebase プロジェクトに接続されていない。以下がユーザー側の
残作業:

1. Firebase コンソールで本番プロジェクトを作成（またはこの目的専用プロジェクト）
2. `flutterfire configure` を実行して `lib/firebase_options.dart` を実値で上書き
3. `firebase use --add` で `.firebaserc` にプロジェクトを紐付け（このリポジトリには
   実プロジェクトIDが不明なため `.firebaserc` を含めていない）
4. Anthropic APIキーを Secret Manager に登録:
   ```bash
   firebase functions:secrets:set ANTHROPIC_API_KEY
   ```
5. デプロイ:
   ```bash
   cd functions && npm install
   firebase deploy --only functions,firestore:rules
   ```

## エンドポイント

- `askScience` (`onCall`): AIはかせチャットの質問を中継。呼び出し前に
  Firestore `users/{uid}/aiChatUsage/{yyyy-MM}` のカウンタをトランザクションで
  チェック・消費し、無料枠（月5回）を超えると `resource-exhausted` を返す。
- `getAiChatUsageStatus` (`onCall`): 現在の残り回数を消費せずに取得（画面表示用）。
- `identifyCreature` (`onCall`): いきものカメラの画像を中継（Claude Vision）。
  `users/{uid}/creatureIdUsage/{yyyy-MM}` で同様に月5回まで。

いずれも Firebase Authentication の ID トークンで認証必須（匿名ログインでも可）。
`request.auth.uid` をそのままカウンタのキーに使うため、クライアントが送る
ユーザーIDは信用しない設計になっている。

## 既知の制約・未解決事項

- **本番 Firebase プロジェクト未接続**: 上記の通り `dummy_*` のままなので、
  この変更はローカルでのコンパイル・構文レベルの妥当性のみ確認済み。
  実機/エミュレータでの動作確認は行えていない（環境にFlutter/Node SDKなし）。
- **RevenueCat との連携は別問題**: 課金判定の改ざん防止は本PRの範囲外
  （`lib/features/trial/providers/trial_provider.dart` 側で対応、詳細はPR本文参照）。
- **レート制限は「月5回」のみ**: 短時間の連投（バースト）を防ぐレート制限は
  未実装。必要であれば `usageLimiter.ts` に分単位のトークンバケット等を追加する。
- **画像アップロードのコスト**: `identifyCreature` は base64 で画像をそのまま
  送信するため、Cloud Functions の受信サイズ上限（デフォルト10MB）に収まるよう
  クライアント側で事前に圧縮・リサイズすることを推奨（未実装）。
