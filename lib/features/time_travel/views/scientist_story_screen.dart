import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/scientist_stories_data.dart';
import '../providers/scientist_provider.dart';

/// 科学者ストーリー詳細画面
class ScientistStoryScreen extends ConsumerStatefulWidget {
  final String scientistId;

  const ScientistStoryScreen({
    super.key,
    required this.scientistId,
  });

  @override
  ConsumerState<ScientistStoryScreen> createState() =>
      _ScientistStoryScreenState();
}

class _ScientistStoryScreenState extends ConsumerState<ScientistStoryScreen> {
  bool _isMarked = false;

  @override
  void initState() {
    super.initState();
    _markAsViewed();
  }

  Future<void> _markAsViewed() async {
    final story = getScientistStory(widget.scientistId);
    if (story != null) {
      await ref
          .read(scientistStoryProvider.notifier)
          .markStoryAsViewed(widget.scientistId, story.grade);
      setState(() => _isMarked = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final story = getScientistStory(widget.scientistId);

    if (story == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('科学者ストーリー')),
        body: const Center(
          child: Text('ストーリーが見つかりません'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        title: const Text('タイムトラベル 🕰️'),
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ヘッダーセクション
            _buildHeaderSection(story),
            // 基本情報セクション
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildInfoSection(story),
            ),
            // 生涯セクション
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSection(
                title: '📖 生涯',
                content: story.biography,
                color: Colors.blue.shade50,
                borderColor: Colors.blue.shade200,
              ),
            ),
            const SizedBox(height: 12),
            // 主な業績セクション
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSection(
                title: '🏆 主な業績',
                content: story.majorWork,
                color: Colors.amber.shade50,
                borderColor: Colors.amber.shade300,
              ),
            ),
            const SizedBox(height: 12),
            // 面白い事実セクション
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSection(
                title: '💡 面白い事実',
                content: story.interestingFact,
                color: Colors.green.shade50,
                borderColor: Colors.green.shade300,
              ),
            ),
            const SizedBox(height: 12),
            // 関連する実験セクション
            if (story.relatedExperiments.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildRelatedExperimentsSection(story),
              ),
            const SizedBox(height: 20),
            // 学んだことを記録ボタン
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _isMarked
                  ? Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade400, width: 2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle,
                              color: Colors.green, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'ストーリーを読みました！',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(ScientistStory story) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Text(
            story.emoji,
            style: const TextStyle(fontSize: 64),
          ),
          const SizedBox(height: 16),
          Text(
            story.nameJp,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            story.name,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Text(
              story.yearRange,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(ScientistStory story) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              const Text(
                '時代',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                story.era,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Container(
            width: 1,
            height: 50,
            color: Colors.grey.shade300,
          ),
          Column(
            children: [
              const Text(
                '分野',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                story.field,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required Color color,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              fontSize: 13,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedExperimentsSection(ScientistStory story) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🔬 関連する実験',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${story.nameJp}の研究と関連する実験を試してみよう！',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 10),
          ...story.relatedExperiments.map((expId) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Text('✓', style: TextStyle(color: Colors.purple)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        expId,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
