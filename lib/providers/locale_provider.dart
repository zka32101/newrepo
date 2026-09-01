import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ロケール変更ノーティファイアー
class LocaleNotifier extends StateNotifier<Locale> {
  static const String _localeKey = 'app_locale';

  LocaleNotifier(Locale initialLocale) : super(initialLocale);

  /// ロケールを変更して SharedPreferences に保存
  Future<void> setLocale(Locale locale) async {
    state = locale;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, locale.languageCode);
    } catch (e) {
      print('Failed to save locale preference: $e');
    }
  }

  /// 保存されたロケール設定を読み込み
  static Future<Locale> loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_localeKey);

      if (languageCode != null) {
        if (languageCode == 'ja') {
          return const Locale('ja');
        } else if (languageCode == 'en') {
          return const Locale('en');
        }
      }
    } catch (e) {
      print('Failed to load locale preference: $e');
    }

    // デフォルトは日本語
    return const Locale('ja');
  }
}

/// ロケール プロバイダー
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier(const Locale('ja'));
});

/// 現在のロケールコード プロバイダー
final currentLocaleCodeProvider = Provider<String>((ref) {
  final locale = ref.watch(localeProvider);
  return locale.languageCode;
});

/// ロケールが日本語かどうか判定 プロバイダー
final isJapaneseLocaleProvider = Provider<bool>((ref) {
  final locale = ref.watch(localeProvider);
  return locale.languageCode == 'ja';
});

/// ロケールが英語かどうか判定 プロバイダー
final isEnglishLocaleProvider = Provider<bool>((ref) {
  final locale = ref.watch(localeProvider);
  return locale.languageCode == 'en';
});
