import 'package:flutter/material.dart';
import '../services/grade_advancement_service.dart';

/// 学年進級祝い表示ダイアログ
/// 進級が実施された際に表示するお祝いダイアログ
class GradeAdvancementCelebrationDialog extends StatefulWidget {
  /// 進級結果
  final GradeAdvancementResult result;

  /// ダイアログを閉じるコールバック
  final VoidCallback? onDismiss;

  const GradeAdvancementCelebrationDialog({
    Key? key,
    required this.result,
    this.onDismiss,
  }) : super(key: key);

  @override
  State<GradeAdvancementCelebrationDialog> createState() =>
      _GradeAdvancementCelebrationDialogState();
}

class _GradeAdvancementCelebrationDialogState
    extends State<GradeAdvancementCelebrationDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: widget.result.isPromotion
              ? _buildPromotionContent(context)
              : _buildNormalContent(context),
        ),
      ),
    );
  }

  Widget _buildPromotionContent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🎉 祝い絵文字
            _buildCelebrationEmojis(),
            const SizedBox(height: 24),

            // タイトル
            Text(
              'おめでとう！🎓',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[700],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // メインメッセージ
            Text(
              widget.result.message,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // 学年遷移表示
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.amber[100]!,
                    Colors.amber[50]!,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber[300]!, width: 2),
              ),
              child: Column(
                children: [
                  Text(
                    '学年が進級しました',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.amber[700],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildGradeBox(
                        widget.result.previousGradeDisplayText,
                        context,
                        isOld: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.amber[700],
                          size: 24,
                        ),
                      ),
                      _buildGradeBox(
                        widget.result.gradeDisplayText,
                        context,
                        isOld: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 進級日付
            if (widget.result.advancementDate != null) ...[
              Text(
                '進級日: ${widget.result.advancementDate}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 12),
            ],

            // ランキング情報
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📊 ランキング情報',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '新しい学年のランキングに参加できます！\n学年別ランキングで活躍してくださいね。',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 閉じるボタン
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onDismiss?.call();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.amber[700],
                ),
                child: const Text(
                  'ありがとうございます！',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNormalContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.info_outline,
            size: 48,
            color: Colors.blue[400],
          ),
          const SizedBox(height: 16),
          Text(
            'ご確認ください',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            widget.result.message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDismiss?.call();
              },
              child: const Text('わかりました'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeBox(String grade, BuildContext context,
      {required bool isOld}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isOld ? Colors.grey[300] : Colors.amber[300],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isOld ? Colors.grey[500]! : Colors.amber[700]!,
          width: 2,
        ),
      ),
      child: Text(
        grade,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: isOld ? Colors.grey[700] : Colors.amber[900],
        ),
      ),
    );
  }

  Widget _buildCelebrationEmojis() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildFloatingEmoji('🎉', 0.0),
        _buildFloatingEmoji('✨', 0.3),
        _buildFloatingEmoji('🎊', 0.6),
      ],
    );
  }

  Widget _buildFloatingEmoji(String emoji, double delay) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 1200, inMilliseconds: ((1200 * delay).toInt())),
      curve: Curves.elasticInOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -30 * value),
          child: Opacity(
            opacity: 1.0 - (value * 0.3),
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 36),
            ),
          ),
        );
      },
    );
  }
}

/// 学年進級ダイアログを表示するヘルパー関数
Future<void> showGradeAdvancementDialog(
  BuildContext context,
  GradeAdvancementResult result, {
  VoidCallback? onDismiss,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => GradeAdvancementCelebrationDialog(
      result: result,
      onDismiss: onDismiss,
    ),
  );
}
