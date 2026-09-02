import 'package:flutter/material.dart';
import '../../../data/seeds/quiz_images_metadata.dart';

/// クイズ解説に対応する画像を表示するウィジェット
class ExplanationImageWidget extends StatelessWidget {
  final String questionId; // e.g., "stage_3_001_q1"
  final String? imageKeyword;

  const ExplanationImageWidget({
    super.key,
    required this.questionId,
    this.imageKeyword,
  });

  @override
  Widget build(BuildContext context) {
    // 画像メタデータを取得
    final imageData = getImageMetadataForQuestion(questionId);

    if (imageData == null) {
      // 画像がまだ準備されていない場合
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFBECDDB),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // タイトル
          Row(
            children: [
              const Icon(
                Icons.image,
                size: 16,
                color: Color(0xFF5E7C99),
              ),
              const SizedBox(width: 8),
              Text(
                '📊 図解・イラスト',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: const Color(0xFF5E7C99),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 画像プレースホルダー（実装時にネットワーク画像またはローカル画像に置き換え）
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: const Color(0xFFE0E8F0),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.image_not_supported,
                    size: 48,
                    color: Color(0xFFBECDDB),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '画像: ${imageData.imageKeyword}',
                    style: const TextStyle(
                      color: Color(0xFF9AAEC1),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '(${imageData.imageType})',
                    style: const TextStyle(
                      color: Color(0xFFD0D8E0),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // 説明文
          Text(
            imageData.imageDescription,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF5E7C99),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// 画像ギャラリー表示用ウィジェット（複数画像対応）
class ExplanationImageGallery extends StatelessWidget {
  final String stageId; // e.g., "stage_3_001"
  final int questionNumber; // 1-10

  const ExplanationImageGallery({
    super.key,
    required this.stageId,
    required this.questionNumber,
  });

  @override
  Widget build(BuildContext context) {
    final questionId = '${stageId}_q$questionNumber';
    return ExplanationImageWidget(questionId: questionId);
  }
}
