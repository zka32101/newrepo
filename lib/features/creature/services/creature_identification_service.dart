import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

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
class CreatureIdentificationService {
  final String _apiKey;
  static const String _apiEndpoint =
      'https://api.anthropic.com/v1/messages';
  static const String _modelId = 'claude-3-5-sonnet-20241022';
  static const int _timeoutSeconds = 30;

  CreatureIdentificationService({required String apiKey}) : _apiKey = apiKey;

  /// 画像から生き物を特定
  ///
  /// [imageBytes]: 画像のバイナリデータ
  /// [mediaType]: メディアタイプ ('image/jpeg', 'image/png', 'image/gif', 'image/webp')
  Future<CreatureIdentificationResult> identifyCreature({
    required Uint8List imageBytes,
    String mediaType = 'image/jpeg',
  }) async {
    try {
      // Base64エンコード
      final base64Image = base64Encode(imageBytes);

      // プロンプト
      const systemPrompt = '''あなたは小学生向けの博物学者です。
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
confidence は 0.0-1.0 の数値で信頼度を表現してください。''';

      const userPrompt =
          'この画像に写っている生き物を特定して、JSON形式で情報を教えてください。';

      // API リクエスト
      final response = await http
          .post(
            Uri.parse(_apiEndpoint),
            headers: {
              'x-api-key': _apiKey,
              'anthropic-version': '2023-06-01',
              'content-type': 'application/json',
            },
            body: jsonEncode({
              'model': _modelId,
              'max_tokens': 1024,
              'system': systemPrompt,
              'messages': [
                {
                  'role': 'user',
                  'content': [
                    {
                      'type': 'image',
                      'source': {
                        'type': 'base64',
                        'media_type': mediaType,
                        'data': base64Image,
                      },
                    },
                    {
                      'type': 'text',
                      'text': userPrompt,
                    }
                  ],
                }
              ],
            }),
          )
          .timeout(
            const Duration(seconds: _timeoutSeconds),
            onTimeout: () => throw Exception('リクエストがタイムアウトしました'),
          );

      // エラーハンドリング
      if (response.statusCode == 429) {
        throw Exception('API呼び出し数が上限に達しました。少し待ってから試してください。');
      }

      if (response.statusCode != 200) {
        throw Exception(
            'API呼び出しに失敗しました（ステータス: ${response.statusCode}）');
      }

      // レスポンスパース
      final data = jsonDecode(response.body);
      final content = data['content'][0]['text'] as String?;

      if (content == null) {
        throw Exception('API応答が不正です');
      }

      // JSON抽出（Markdownコードブロックから抽出）
      final jsonMatch = RegExp(r'```json\n([\s\S]*?)\n```').firstMatch(content);
      final jsonStr = jsonMatch?.group(1) ?? content;
      final parsed = jsonDecode(jsonStr) as Map<String, dynamic>;

      return CreatureIdentificationResult.fromJson(parsed);
    } on http.ClientException catch (e) {
      throw Exception('ネットワークエラー: ${e.message}');
    } catch (e) {
      throw Exception('生き物特定エラー: $e');
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
}
