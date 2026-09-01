import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/locale_provider.dart';
import '../shared/theme/app_theme.dart';
import '../shared/utils/responsive.dart';
import '../shared/localization/app_localizations.dart';

/// 言語選択ウィジェット
class LanguageSelectorWidget extends ConsumerWidget {
  const LanguageSelectorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final isJapanese = currentLocale.languageCode == 'ja';
    final isDark = AppColors.isDark(context);
    final localizations = AppLocalizations.of(context);
    final isMobile = Responsive.isMobile(context);

    return Card(
      margin: EdgeInsets.all(isMobile ? 12 : 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.language,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _LanguageButton(
                    label: '日本語',
                    isSelected: isJapanese,
                    onTap: () {
                      ref.read(localeProvider.notifier).setLocale(const Locale('ja'));
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _LanguageButton(
                    label: 'English',
                    isSelected: !isJapanese,
                    onTap: () {
                      ref.read(localeProvider.notifier).setLocale(const Locale('en'));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 言語ボタン
class _LanguageButton extends ConsumerWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = AppColors.isDark(context);
    final colors = AppColors.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? colors.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? colors.primary.withOpacity(isDark ? 0.15 : 0.08)
              : (isDark ? Colors.grey.shade800 : Colors.grey.shade100),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? colors.primary : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }
}

/// 言語設定セクション（設定画面用）
class LanguageSettingSection extends ConsumerWidget {
  const LanguageSettingSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final isMobile = Responsive.isMobile(context);
    final responsivePadding = Responsive.getPadding(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(responsivePadding.left),
          child: Text(
            localizations.language,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        LanguageSelectorWidget(),
      ],
    );
  }
}
