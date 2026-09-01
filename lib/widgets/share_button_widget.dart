import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/social_share_service.dart';
import '../models/streak_model.dart';

/// シェアボタンのタイプ
enum ShareType {
  score,      // スコアシェア
  streak,     // ストリークシェア
  badge,      // バッジシェア
  ranking,    // ランキングシェア
  question,   // 問題シェア
}

/// シェアボタンウィジェット
class ShareButton extends StatelessWidget {
  final ShareType type;
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;

  const ShareButton({
    Key? key,
    required this.type,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.blue,
        foregroundColor: textColor ?? Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

/// SNS シェアオプションダイアログ
class ShareOptionsDialog extends ConsumerWidget {
  final ShareType shareType;
  final Map<String, dynamic> shareData;

  const ShareOptionsDialog({
    Key? key,
    required this.shareType,
    required this.shareData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('シェア方法を選択'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildShareOption(
              context: context,
              icon: '𝕏',
              label: 'Twitter でシェア',
              onTap: () {
                _shareToTwitter(ref);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 12),
            _buildShareOption(
              context: context,
              icon: '♪',
              label: 'TikTok でシェア',
              onTap: () {
                _shareToTikTok(ref);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 12),
            _buildShareOption(
              context: context,
              icon: '📷',
              label: 'Instagram でシェア',
              onTap: () {
                _shareToInstagram(ref);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 12),
            _buildShareOption(
              context: context,
              icon: '💬',
              label: 'LINE でシェア',
              onTap: () {
                _shareToLine(ref);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 12),
            _buildShareOption(
              context: context,
              icon: '💭',
              label: 'WhatsApp でシェア',
              onTap: () {
                _shareToWhatsApp(ref);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 12),
            _buildShareOption(
              context: context,
              icon: '⋯',
              label: 'その他の方法でシェア',
              onTap: () {
                _shareDefault(ref);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('キャンセル'),
        ),
      ],
    );
  }

  Widget _buildShareOption({
    required BuildContext context,
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  void _shareToTwitter(WidgetRef ref) async {
    final content = _buildShareContent();
    try {
      await SocialShareService.instance.shareToTwitter(content);
    } catch (e) {
      // エラーハンドリング
    }
  }

  void _shareToTikTok(WidgetRef ref) async {
    final content = _buildShareContent();
    try {
      await SocialShareService.instance.shareTikTok(content);
    } catch (e) {
      // エラーハンドリング
    }
  }

  void _shareToInstagram(WidgetRef ref) async {
    final content = _buildShareContent();
    try {
      await SocialShareService.instance.shareInstagram(content);
    } catch (e) {
      // エラーハンドリング
    }
  }

  void _shareToLine(WidgetRef ref) async {
    final content = _buildShareContent();
    try {
      await SocialShareService.instance.shareToLine(content);
    } catch (e) {
      // エラーハンドリング
    }
  }

  void _shareToWhatsApp(WidgetRef ref) async {
    final content = _buildShareContent();
    try {
      await SocialShareService.instance.shareToWhatsApp(content);
    } catch (e) {
      // エラーハンドリング
    }
  }

  void _shareDefault(WidgetRef ref) async {
    final content = _buildShareContent();
    try {
      await SocialShareService.instance._share(content);
    } catch (e) {
      // エラーハンドリング
    }
  }

  ShareContent _buildShareContent() {
    switch (shareType) {
      case ShareType.score:
        return ShareContent(
          title: '理科クイズに挑戦中！',
          message: '''⭐ スコア: ${shareData['score']}点
${shareData['categoryName']} で学習中！

🔥 連続学習: ${shareData['streak']}日間
📊 最高記録: ${shareData['maxStreak']}日間

小学コレ！理科で学習しよう！''',
          hashtags:
              '#小学コレ理科 #理科学習 #クイズ #連続学習 #教育アプリ',
        );

      case ShareType.streak:
        return ShareContent(
          title: 'ストリーク達成！',
          message:
              '''${shareData['emoji']} ${shareData['milestone']} を達成しました！

🔥 ${shareData['days']} 日間連続で学習を継続！

小学コレ！理科は毎日の学習を応援しています。''',
          hashtags:
              '#小学コレ理科 #ストリーク達成 #連続学習 #頑張った #理科',
        );

      case ShareType.badge:
        return ShareContent(
          title: 'バッジ獲得！',
          message:
              '''${shareData['emoji']} 新しいバッジを獲得しました！

🎖️ ${shareData['badgeTitle']}
${shareData['description']}

小学コレ！理科で楽しく学習しよう！''',
          hashtags:
              '#小学コレ理科 #バッジ獲得 #頑張った #理科学習 #教育',
        );

      case ShareType.ranking:
        return ShareContent(
          title: 'ランキング入賞！',
          message:
              '''${shareData['emoji']} ランキング ${shareData['rank']} 位に入賞！

🎯 スコア: ${shareData['score']}点
📊 ランキング入賞おめでとう！

小学コレ！理科であなたも挑戦してみませんか？''',
          hashtags:
              '#小学コレ理科 #ランキング入賞 #競い合い #理科学習 #教育アプリ',
        );

      case ShareType.question:
        return ShareContent(
          title: '今日の学習問題',
          message:
              '''📚 ${shareData['categoryName']} の問題に挑戦中！

Q) ${shareData['question']}
A) ${shareData['answer']}

小学コレ！理科で毎日新しい問題に挑戦しよう！''',
          hashtags:
              '#小学コレ理科 #理科学習 #クイズ #勉強 #教育',
        );
    }
  }
}

/// スコアシェアボタン（クイズ完了後）
class ScoreShareButton extends ConsumerWidget {
  final int score;
  final String categoryName;
  final int streak;
  final int maxStreak;

  const ScoreShareButton({
    Key? key,
    required this.score,
    required this.categoryName,
    required this.streak,
    required this.maxStreak,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ShareButton(
      type: ShareType.score,
      label: 'スコアをシェア',
      icon: Icons.share,
      backgroundColor: Colors.blue,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => ShareOptionsDialog(
            shareType: ShareType.score,
            shareData: {
              'score': score,
              'categoryName': categoryName,
              'streak': streak,
              'maxStreak': maxStreak,
            },
          ),
        );
      },
    );
  }
}

/// ストリークシェアボタン（マイルストーン達成時）
class StreakShareButton extends ConsumerWidget {
  final int days;
  final String milestoneTitle;
  final String milestoneEmoji;

  const StreakShareButton({
    Key? key,
    required this.days,
    required this.milestoneTitle,
    required this.milestoneEmoji,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ShareButton(
      type: ShareType.streak,
      label: 'ストリークをシェア',
      icon: Icons.local_fire_department,
      backgroundColor: Colors.orange,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => ShareOptionsDialog(
            shareType: ShareType.streak,
            shareData: {
              'days': days,
              'milestone': milestoneTitle,
              'emoji': milestoneEmoji,
            },
          ),
        );
      },
    );
  }
}

/// クイック シェアボタン（複数SNC対応）
class QuickShareButtons extends ConsumerWidget {
  final ShareType shareType;
  final Map<String, dynamic> shareData;

  const QuickShareButtons({
    Key? key,
    required this.shareType,
    required this.shareData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildQuickShareButton(
          icon: '𝕏',
          onTap: () async {
            // Twitter シェア
          },
        ),
        _buildQuickShareButton(
          icon: '♪',
          onTap: () async {
            // TikTok シェア
          },
        ),
        _buildQuickShareButton(
          icon: '📷',
          onTap: () async {
            // Instagram シェア
          },
        ),
      ],
    );
  }

  Widget _buildQuickShareButton({
    required String icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Center(
          child: Text(
            icon,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
