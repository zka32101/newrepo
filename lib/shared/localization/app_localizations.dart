import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

/// アプリケーション翻訳管理クラス
class AppLocalizations {
  static const String _enLocaleCode = 'en';
  static const String _jaLocaleCode = 'ja';

  final Locale locale;
  late Map<String, dynamic> _translations;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  /// 翻訳ファイルを読み込み
  Future<void> load() async {
    try {
      final jsonFile = 'lib/l10n/app_${locale.languageCode}.arb';
      final jsonContent = await rootBundle.loadString(jsonFile);
      _translations = jsonDecode(jsonContent) as Map<String, dynamic>;
    } catch (e) {
      print('Failed to load translations for locale $locale: $e');
      // フォールバック：日本語を読み込み
      if (locale.languageCode != _jaLocaleCode) {
        final jsonContent = await rootBundle.loadString('lib/l10n/app_ja.arb');
        _translations = jsonDecode(jsonContent) as Map<String, dynamic>;
      }
    }
  }

  /// 翻訳文字列を取得
  String translate(String key) {
    return _translations[key] ?? key;
  }

  /// キー付き翻訳取得（拡張用）
  String get(String key, {Map<String, String>? args}) {
    String value = _translations[key] ?? key;

    if (args != null) {
      args.forEach((argKey, argValue) {
        value = value.replaceAll('{$argKey}', argValue);
      });
    }

    return value;
  }

  // =============================================
  // アプリ全体
  // =============================================
  String get appTitle => translate('appTitle');

  // =============================================
  // ナビゲーション
  // =============================================
  String get navigationHome => translate('navigationHome');
  String get navigationQuiz => translate('navigationQuiz');
  String get navigationProgress => translate('navigationProgress');
  String get navigationSettings => translate('navigationSettings');
  String get navigationAchievements => translate('navigationAchievements');
  String get navigationRanking => translate('navigationRanking');
  String get navigationCharacters => translate('navigationCharacters');
  String get navigationShop => translate('navigationShop');

  // =============================================
  // ホーム画面
  // =============================================
  String get homeScreenTitle => translate('homeScreenTitle');
  String get dailyChallengeTitle => translate('dailyChallengeTitle');
  String get weeklyReportTitle => translate('weeklyReportTitle');
  String get continueLearning => translate('continueLearning');
  String get startQuiz => translate('startQuiz');
  String get viewProgress => translate('viewProgress');

  // =============================================
  // クイズ画面
  // =============================================
  String get quizScreenTitle => translate('quizScreenTitle');
  String get timerQuizMode => translate('timerQuizMode');
  String get normalQuizMode => translate('normalQuizMode');
  String get selectStage => translate('selectStage');
  String get grade3 => translate('grade3');
  String get grade4 => translate('grade4');
  String get grade5 => translate('grade5');
  String get grade6 => translate('grade6');
  String get question => translate('question');
  String get of => translate('of');
  String get selectAnswer => translate('selectAnswer');
  String get correct => translate('correct');
  String get incorrect => translate('incorrect');
  String get tryAgain => translate('tryAgain');
  String get nextQuestion => translate('nextQuestion');
  String get finish => translate('finish');
  String get score => translate('score');
  String get correctCount => translate('correctCount');
  String get timeRemaining => translate('timeRemaining');

  // =============================================
  // アチーブメント画面
  // =============================================
  String get achievementScreenTitle => translate('achievementScreenTitle');
  String get achievementList => translate('achievementList');
  String get achievementDetails => translate('achievementDetails');
  String get unlocked => translate('unlocked');
  String get locked => translate('locked');
  String get rarity => translate('rarity');
  String get common => translate('common');
  String get uncommon => translate('uncommon');
  String get rare => translate('rare');
  String get epic => translate('epic');
  String get legendary => translate('legendary');
  String get achievementCondition => translate('achievementCondition');
  String get achievedOn => translate('achievedOn');

  // =============================================
  // ランキング画面
  // =============================================
  String get rankingScreenTitle => translate('rankingScreenTitle');
  String get topThree => translate('topThree');
  String get allRanking => translate('allRanking');
  String get daily => translate('daily');
  String get weekly => translate('weekly');
  String get monthly => translate('monthly');
  String get rank => translate('rank');
  String get yourRank => translate('yourRank');
  String get correctRate => translate('correctRate');
  String get participants => translate('participants');
  String get averageScore => translate('averageScore');
  String get topScore => translate('topScore');
  String get percentile => translate('percentile');

  // =============================================
  // 進捗画面
  // =============================================
  String get progressScreenTitle => translate('progressScreenTitle');
  String get totalProgress => translate('totalProgress');
  String get stageProgress => translate('stageProgress');
  String get completedStages => translate('completedStages');
  String get masteredStages => translate('masteredStages');
  String get learningStreak => translate('learningStreak');
  String get days => translate('days');
  String get bestStreak => translate('bestStreak');
  String get completedToday => translate('completedToday');
  String get notCompletedToday => translate('notCompletedToday');

  // =============================================
  // キャラクター画面
  // =============================================
  String get characterScreenTitle => translate('characterScreenTitle');
  String get characterCollection => translate('characterCollection');
  String get characterName => translate('characterName');
  String get characterDescription => translate('characterDescription');
  String get unlockedAt => translate('unlockedAt');

  // =============================================
  // ショップ画面
  // =============================================
  String get shopScreenTitle => translate('shopScreenTitle');
  String get coinShop => translate('coinShop');
  String get purchaseItem => translate('purchaseItem');
  String get coins => translate('coins');
  String get yourCoins => translate('yourCoins');
  String get notEnoughCoins => translate('notEnoughCoins');
  String get purchaseComplete => translate('purchaseComplete');
  String get purchaseFailed => translate('purchaseFailed');

  // =============================================
  // 設定画面
  // =============================================
  String get settingsScreenTitle => translate('settingsScreenTitle');
  String get language => translate('language');
  String get theme => translate('theme');
  String get lightMode => translate('lightMode');
  String get darkMode => translate('darkMode');
  String get systemDefault => translate('systemDefault');
  String get notifications => translate('notifications');
  String get soundEffects => translate('soundEffects');
  String get vibration => translate('vibration');
  String get privacyPolicy => translate('privacyPolicy');
  String get termsOfService => translate('termsOfService');
  String get about => translate('about');
  String get version => translate('version');

  // =============================================
  // ダイアログ・共通
  // =============================================
  String get dialogCancel => translate('dialogCancel');
  String get dialogOk => translate('dialogOk');
  String get dialogClose => translate('dialogClose');
  String get dialogDelete => translate('dialogDelete');
  String get dialogConfirm => translate('dialogConfirm');
  String get errorOccurred => translate('errorOccurred');
  String get tryAgainLater => translate('tryAgainLater');
  String get loadingData => translate('loadingData');
  String get noData => translate('noData');
}

/// アプリケーション翻訳デリゲート
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ja'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

/// 翻訳テキストウィジェット
class TranslationText extends StatelessWidget {
  final String keyName;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const TranslationText(
    this.keyName, {
    Key? key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Text(
      localizations.translate(keyName),
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
