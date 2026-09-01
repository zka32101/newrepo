import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as developer;
import '../models/streak_model.dart';

/// SNS シェア対象データ
class ShareContent {
  final String title;
  final String message;
  final String? imageUrl;
  final String? hashtags;
  final String? url;

  ShareContent({
    required this.title,
    required this.message,
    this.imageUrl,
    this.hashtags,
    this.url,
  });

  /// SNS用の本文を生成
  String toTwitterText() {
    final text = '$message${hashtags != null ? '\n\n$hashtags' : ''}';
    return text;
  }

  /// TikTok用の説明文を生成
  String toTikTokCaption() {
    return '$title\n$message${hashtags != null ? '\n$hashtags' : ''}';
  }

  /// Instagram用のキャプション
  String toInstagramCaption() {
    return '$message${hashtags != null ? '\n\n$hashtags' : ''}';
  }
}

/// SNS シェアサービス
class SocialShareService {
  static final SocialShareService _instance =
      SocialShareService._internal();
  static SocialShareService get instance => _instance;

  factory SocialShareService() {
    return _instance;
  }

  SocialShareService._internal();

  /// 学習スコアをシェア
  Future<void> shareScore({
    required int score,
    required String categoryName,
    required int currentStreak,
    required int maxStreak,
  }) async {
    try {
      final emoji = _getScoreEmoji(score);
      final streakEmoji = _getStreakEmoji(currentStreak);

      final content = ShareContent(
        title: '理科クイズに挑戦中！',
        message: '''$emoji スコア: $score点
$categoryName で学習中！

$streakEmoji 連続学習: $currentStreak日間
📊 最高記録: $maxStreak日間

小学コレ！理科で学習しよう！''',
        hashtags: '#小学コレ理科 #理科学習 #クイズ #連続学習 #教育アプリ',
        url: 'https://play.google.com/store/apps/details?id=com.example.shokollen_science',
      );

      await _share(content);
    } catch (e) {
      developer.log('Error sharing score: $e', error: e);
      rethrow;
    }
  }

  /// ストリーク達成をシェア
  Future<void> shareStreak({
    required int streakDays,
    required String milestoneTitle,
    required String milestoneEmoji,
  }) async {
    try {
      final content = ShareContent(
        title: 'ストリーク達成！',
        message: '''$milestoneEmoji $milestoneTitle を達成しました！

🔥 $streakDays 日間連続で学習を継続！

小学コレ！理科は毎日の学習を応援しています。
一緒に楽しく理科を学びませんか？''',
        hashtags: '#小学コレ理科 #ストリーク達成 #連続学習 #頑張った #理科',
        url: 'https://play.google.com/store/apps/details?id=com.example.shokollen_science',
      );

      await _share(content);
    } catch (e) {
      developer.log('Error sharing streak: $e', error: e);
      rethrow;
    }
  }

  /// バッジ獲得をシェア
  Future<void> shareBadge({
    required String badgeTitle,
    required String badgeEmoji,
    required String description,
  }) async {
    try {
      final content = ShareContent(
        title: 'バッジ獲得！',
        message: '''$badgeEmoji 新しいバッジを獲得しました！

🎖️ $badgeTitle
$description

小学コレ！理科で楽しく学習しよう！''',
        hashtags: '#小学コレ理科 #バッジ獲得 #頑張った #理科学習 #教育',
        url: 'https://play.google.com/store/apps/details?id=com.example.shokollen_science',
      );

      await _share(content);
    } catch (e) {
      developer.log('Error sharing badge: $e', error: e);
      rethrow;
    }
  }

  /// ランキング入賞をシェア
  Future<void> shareRanking({
    required int rank,
    required int score,
    required String period, // "daily", "weekly", "monthly"
  }) async {
    try {
      final periodText = _getPeriodText(period);
      final rankEmoji = _getRankEmoji(rank);

      final content = ShareContent(
        title: 'ランキング入賞！',
        message: '''$rankEmoji $periodText ランキング $rank 位に入賞！

🎯 スコア: $score点
📊 $periodText ランキング入賞おめでとう！

小学コレ！理科はランキング機能で競い合いながら学習できます。
あなたも挑戦してみませんか？''',
        hashtags: '#小学コレ理科 #ランキング入賞 #競い合い #理科学習 #教育アプリ',
        url: 'https://play.google.com/store/apps/details?id=com.example.shokollen_science',
      );

      await _share(content);
    } catch (e) {
      developer.log('Error sharing ranking: $e', error: e);
      rethrow;
    }
  }

  /// 問題解答をシェア
  Future<void> shareQuestion({
    required String questionText,
    required String correctAnswer,
    required String categoryName,
  }) async {
    try {
      final content = ShareContent(
        title: '今日の学習問題',
        message: '''📚 $categoryName の問題に挑戦中！

Q) $questionText
A) $correctAnswer

小学コレ！理科で毎日新しい問題に挑戦しよう！''',
        hashtags: '#小学コレ理科 #理科学習 #クイズ #勉強 #教育',
        url: 'https://play.google.com/store/apps/details?id=com.example.shokollen_science',
      );

      await _share(content);
    } catch (e) {
      developer.log('Error sharing question: $e', error: e);
      rethrow;
    }
  }

  /// Twitter に直接シェア
  Future<void> shareToTwitter(ShareContent content) async {
    try {
      final text = Uri.encodeComponent(content.toTwitterText());
      final twitterUrl = 'https://twitter.com/intent/tweet?text=$text';
      await _launchUrl(twitterUrl);
    } catch (e) {
      developer.log('Error sharing to Twitter: $e', error: e);
      rethrow;
    }
  }

  /// TikTok のプロフィールを開く
  Future<void> shareTikTok(ShareContent content) async {
    try {
      // TikTok の直接シェア URL スキーム
      final tiktokScheme = 'tiktok://';
      if (await canLaunchUrl(Uri.parse(tiktokScheme))) {
        await launchUrl(Uri.parse(tiktokScheme));
      } else {
        // フォールバック: App Store へ
        await _launchUrl('https://www.tiktok.com/');
      }
    } catch (e) {
      developer.log('Error sharing to TikTok: $e', error: e);
      rethrow;
    }
  }

  /// Instagram のプロフィールを開く
  Future<void> shareInstagram(ShareContent content) async {
    try {
      // Instagram の直接シェア URL スキーム
      final instagramScheme = 'instagram://';
      if (await canLaunchUrl(Uri.parse(instagramScheme))) {
        await launchUrl(Uri.parse(instagramScheme));
      } else {
        await _launchUrl('https://www.instagram.com/');
      }
    } catch (e) {
      developer.log('Error sharing to Instagram: $e', error: e);
      rethrow;
    }
  }

  /// LINE でシェア
  Future<void> shareToLine(ShareContent content) async {
    try {
      final text = Uri.encodeComponent('${content.title}\n${content.message}');
      final lineUrl = 'https://line.me/R/msg/text/?$text';
      await _launchUrl(lineUrl);
    } catch (e) {
      developer.log('Error sharing to LINE: $e', error: e);
      rethrow;
    }
  }

  /// WhatsApp でシェア
  Future<void> shareToWhatsApp(ShareContent content) async {
    try {
      final text = Uri.encodeComponent('${content.title}\n${content.message}');
      final whatsappUrl = 'https://wa.me/?text=$text';
      await _launchUrl(whatsappUrl);
    } catch (e) {
      developer.log('Error sharing to WhatsApp: $e', error: e);
      rethrow;
    }
  }

  /// システムシェアダイアログを表示
  Future<void> _share(ShareContent content) async {
    try {
      await Share.share(
        content.message,
        subject: content.title,
      );
    } catch (e) {
      developer.log('Error in share dialog: $e', error: e);
      rethrow;
    }
  }

  /// URL を開く
  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'URL を開くことができません: $url';
      }
    } catch (e) {
      developer.log('Error launching URL: $e', error: e);
      rethrow;
    }
  }

  /// スコアに応じた絵文字を取得
  String _getScoreEmoji(int score) {
    if (score >= 90) return '🌟';
    if (score >= 70) return '⭐';
    if (score >= 50) return '👍';
    return '💪';
  }

  /// ストリーク日数に応じた絵文字を取得
  String _getStreakEmoji(int days) {
    if (days >= 365) return '👑';
    if (days >= 100) return '🏆';
    if (days >= 30) return '⭐';
    if (days >= 14) return '💪';
    return '🔥';
  }

  /// ランク に応じた絵文字を取得
  String _getRankEmoji(int rank) {
    if (rank == 1) return '🥇';
    if (rank == 2) return '🥈';
    if (rank == 3) return '🥉';
    return '🎖️';
  }

  /// 期間文字列を取得
  String _getPeriodText(String period) {
    switch (period) {
      case 'daily':
        return '日間';
      case 'weekly':
        return '週間';
      case 'monthly':
        return '月間';
      default:
        return '期間';
    }
  }
}
