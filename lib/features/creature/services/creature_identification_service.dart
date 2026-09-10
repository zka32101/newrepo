import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_functions/cloud_functions.dart';

/// 生き物特定レスポンス
class CreatureIdentificationResult {
  final String name; // 生き物の名前
  final String species; // 学名
  final String description; // 説明
  final String habitat; // 生息地
  final String diet; // 食性
  final String lifeSpan; // 寿命
  final String interestingFact; // 面白い事実
  final String emoji; // 絵文字
  final double confidence; // 信頼度 (0.0-1.0)

  const CreatureIdentificationResult({
    required this.name,
    required this.species,
    required this.description,
    required this.habitat,
    required this.diet,
    required this.lifeSpan,
    required this.interestingFact,
    required this.emoji,
    required this.confidence,
  });

  factory CreatureIdentificationResult.fromJson(Map<String, dynamic> json) {
    return CreatureIdentificationResult(
      name: json['name'] as String? ?? '不明な生き物',
      species: json['species'] as String? ?? '',
      description: json['description'] as String? ?? '',
      habitat: json['habitat'] as String? ?? '',
      diet: json['diet'] as String? ?? '',
      lifeSpan: json['lifeSpan'] as String? ?? '',
      interestingFact: json['interestingFact'] as String? ?? '',
      emoji: json['emoji'] as String? ?? '🐛',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.5,
    );
  }
}

class CreatureIdentificationException implements Exception {
  final String message;
  CreatureIdentificationException(this.message);

  @override
  String toString() => message;
}

/// 生き物図鑑のコレクションアイテム
class CreatureCollectionItem {
  final String id;
  final String name;
  final String emoji;
  final DateTime discoveredAt;
  final String? photoPath;
  final CreatureIdentificationResult? details;
  final int points; // 理科ポイント

  const CreatureCollectionItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.discoveredAt,
    this.photoPath,
    this.details,
    this.points = 50,
  });
}

/// Claude Vision API を使った生き物特定サービス
///
/// APIキーはクライアントに埋め込まない。Cloud Functions の callable function
/// (`identifyCreature`) をサーバー側プロキシとして呼び出す。月次利用回数の
/// 判定もサーバー側（Firestore）で行われる。
class CreatureIdentificationService {
  CreatureIdentificationService({FirebaseFunctions? functions})
      : _functions = functions ??
            FirebaseFunctions.instanceFor(region: 'asia-northeast1');

  final FirebaseFunctions _functions;

  /// 画像から生き物を特定
  ///
  /// [imageBytes]: 画像のバイナリデータ
  /// [mediaType]: メディアタイプ ('image/jpeg', 'image/png', 'image/gif', 'image/webp')
  Future<CreatureIdentificationResult> identifyCreature({
    required Uint8List imageBytes,
    String mediaType = 'image/jpeg',
  }) async {
    try {
      final base64Image = base64Encode(imageBytes);

      final callable = _functions.httpsCallable(
        'identifyCreature',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 45)),
      );
      final response = await callable.call<Map<String, dynamic>>({
        'imageBase64': base64Image,
        'mediaType': mediaType,
      });

      final data = response.data;
      final result = data['result'] as Map<Object?, Object?>?;
      if (result == null) {
        throw CreatureIdentificationException('AIの応答が不正です');
      }

      return CreatureIdentificationResult.fromJson(
        Map<String, dynamic>.from(result),
      );
    } on FirebaseFunctionsException catch (e) {
      throw CreatureIdentificationException(_messageFor(e));
    } on CreatureIdentificationException {
      rethrow;
    } catch (e) {
      throw CreatureIdentificationException('つながらなかったよ。インターネットをかくにんしてね！');
    }
  }

  /// 複数の画像を処理
  Future<List<CreatureIdentificationResult>> identifyMultipleCreatures({
    required List<Uint8List> imagesBytesList,
    String mediaType = 'image/jpeg',
  }) async {
    final results = <CreatureIdentificationResult>[];
    for (final bytes in imagesBytesList) {
      results.add(
        await identifyCreature(imageBytes: bytes, mediaType: mediaType),
      );
    }
    return results;
  }

  String _messageFor(FirebaseFunctionsException e) {
    switch (e.code) {
      case 'resource-exhausted':
        return e.message ?? '今月の無料回数を使い切ったよ。来月になるとまた使えるよ！';
      case 'unauthenticated':
        return 'サインインを確認できませんでした。少ししてからもう一度試してね！';
      case 'invalid-argument':
        return e.message ?? '画像を確認できませんでした。もう一度試してね！';
      default:
        return 'エラーが起きたよ（${e.code}）。もう一度試してね！';
    }
  }
}
