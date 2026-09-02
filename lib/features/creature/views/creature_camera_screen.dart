import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';
import '../providers/creature_collection_provider.dart';
import '../services/creature_identification_service.dart';
import 'creature_result_screen.dart';

/// ⑤ いきものカメラ: Claude Vision による生き物特定
class CreatureCameraScreen extends ConsumerStatefulWidget {
  const CreatureCameraScreen({super.key});

  @override
  ConsumerState<CreatureCameraScreen> createState() =>
      _CreatureCameraScreenState();
}

class _CreatureCameraScreenState extends ConsumerState<CreatureCameraScreen> {
  bool _isIdentifying = false;
  String? _errorMessage;

  // テスト用: 画像データシミュレーション
  Future<Uint8List> _getTestImage() async {
    // 実装時は camera プラグインで実際の画像を取得
    // ここでは空のダミーデータを返す
    return Uint8List.fromList([0xFF, 0xD8, 0xFF, 0xE0]);
  }

  Future<void> _captureAndIdentify() async {
    setState(() {
      _isIdentifying = true;
      _errorMessage = null;
    });

    try {
      // テスト用画像取得（実装時はカメラから取得）
      final imageBytes = await _getTestImage();

      // APIキーは環境変数から取得
      // 本実装ではビルド時に --dart-define で注入
      const apiKey = String.fromEnvironment('ANTHROPIC_API_KEY');

      if (apiKey.isEmpty) {
        throw Exception('APIキーが設定されていません');
      }

      // サービスで生き物を特定
      final result = await ref
          .read(creatureIdentificationProvider.notifier)
          .identifyFromImage(imageBytes: imageBytes, apiKey: apiKey);

      if (!mounted) return;

      // 結果画面へ遷移
      await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => CreatureResultScreen(result: result),
        ),
      ).then((isAdded) {
        if (isAdded == true) {
          // コレクションに追加された
          if (mounted) {
            setState(() => _isIdentifying = false);
          }
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isIdentifying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final collectionState = ref.watch(creatureCollectionProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F4C3B),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
          tooltip: '戻る',
        ),
        title: const Text('いきものカメラ 📷'),
        backgroundColor: const Color(0xFF0D3D2E),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                '${collectionState.getDiscoveredCount()}種類',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ヘッダー情報
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F4C3B), Color(0xFF1B6A52)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '自然の中の生き物を見つけよう！',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'AIが生き物の名前や特徴を教えてくれるよ',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // カメラプレビュー（シミュレーション版）
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                height: 280,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white30),
                ),
                child: Center(
                  child: _isIdentifying
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '生き物を特定中...',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Phase 1: Camera guide image integration
                            Image.asset(
                              'lib/assets/images/features/creature_camera/camera_guide.svg',
                              width: 120,
                              height: 120,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Text(
                                  '📷',
                                  style: TextStyle(fontSize: 64),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'カメラが起動します',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),

            // エラーメッセージ表示
            if (_errorMessage != null) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.shade400),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Colors.red.shade900,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],

            // キャプチャボタン
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isIdentifying ? null : _captureAndIdentify,
                  icon: const Text('📸', style: TextStyle(fontSize: 20)),
                  label: const Text(
                    '写真を撮って特定する',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),

            // 観察のコツ
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📝 上手に撮影するコツ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...[
                    ('🎯', 'ピント', '生き物がはっきり見える角度から撮影しよう'),
                    ('☀️', 'ライト', '太陽の光が背中から当たる位置がベスト'),
                    ('📐', '距離', '近すぎず遠すぎず（20-50cm）がおすすめ'),
                    (
                      '📐',
                      ' 背景',
                      '単純な背景の方が正確に特定できるよ'
                    ),
                  ]
                      .map((tip) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Text(tip.$1, style: const TextStyle(fontSize: 16)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tip.$2,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        tip.$3,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
