import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/creature_collection_provider.dart';
import '../services/creature_identification_service.dart';

/// 生き物特定結果画面
class CreatureResultScreen extends ConsumerStatefulWidget {
  final CreatureIdentificationResult result;

  const CreatureResultScreen({
    super.key,
    required this.result,
  });

  @override
  ConsumerState<CreatureResultScreen> createState() =>
      _CreatureResultScreenState();
}

class _CreatureResultScreenState
    extends ConsumerState<CreatureResultScreen> {
  bool _isAdding = false;
  bool _alreadyCollected = false;

  @override
  void initState() {
    super.initState();
    // 既に集めているかチェック
    final collection = ref.read(creatureCollectionProvider);
    _alreadyCollected = collection.hasDiscovered(widget.result.name);
  }

  Future<void> _addToCollection() async {
    setState(() => _isAdding = true);

    try {
      await ref.read(creatureCollectionProvider.notifier).addCreature(
            id: widget.result.species,
            name: widget.result.name,
            emoji: widget.result.emoji,
            points: 50,
          );

      if (!mounted) return;
      setState(() => _alreadyCollected = true);

      // 確認ダイアログ
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('🎉 コレクション完成！'),
          content: Text(
            '「${widget.result.name}」を図鑑に追加しました！\n+50ポイント獲得',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, true);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() => _isAdding = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('エラー: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final confidence = (result.confidence * 100).toInt();

    return Scaffold(
      backgroundColor: const Color(0xFF0F4C3B),
      appBar: AppBar(
        title: const Text('生き物の情報 🔍'),
        backgroundColor: const Color(0xFF0D3D2E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 大きな生き物の表示
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F4C3B), Color(0xFF1B6A52)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    result.emoji,
                    style: const TextStyle(fontSize: 80),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    result.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    result.species,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildConfidenceBar(confidence),
                ],
              ),
            ),

            // 説明セクション
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection('説明', result.description),
                  const SizedBox(height: 16),
                  _buildInfoSection('生息地', result.habitat),
                  const SizedBox(height: 16),
                  _buildInfoSection('食性', result.diet),
                  const SizedBox(height: 16),
                  _buildInfoSection('寿命', result.lifeSpan),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '💡 面白い事実',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          result.interestingFact,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.6,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // コレクションボタン
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: SizedBox(
                width: double.infinity,
                child: _alreadyCollected
                    ? Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.green.shade400, width: 2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle,
                                color: Colors.green, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              '既にコレクションに追加済み',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade800,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ElevatedButton.icon(
                        onPressed:
                            _isAdding ? null : _addToCollection,
                        icon: const Text('📚', style: TextStyle(fontSize: 18)),
                        label: const Text(
                          'コレクションに追加 (+50ポイント)',
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
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfidenceBar(int confidence) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '特定の正確さ',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
            Text(
              '$confidence%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: widget.result.confidence,
            minHeight: 6,
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              confidence >= 80
                  ? Colors.green
                  : confidence >= 60
                      ? Colors.amber
                      : Colors.orange,
            ),
          ),
        ),
      ],
    );
  }
}
