import 'package:flutter/material.dart';

/// アプリのテーマ定義
class AppTheme {
  // ライトモード
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2196F3),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFFAFAFA),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textTheme: _buildLightTextTheme(),
    extensions: const <ThemeExtension<dynamic>>[
      AppColors.light,
    ],
  );

  // ダークモード
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2196F3),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF1E1E1E),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textTheme: _buildDarkTextTheme(),
    extensions: const <ThemeExtension<dynamic>>[
      AppColors.dark,
    ],
  );

  static TextTheme _buildLightTextTheme() {
    return const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.black87,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: Colors.black54,
      ),
      labelLarge: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }

  static TextTheme _buildDarkTextTheme() {
    return const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white70,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.white70,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: Colors.white54,
      ),
      labelLarge: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    );
  }
}

/// カスタムカラー拡張
class AppColors extends ThemeExtension<AppColors> {
  final Color primary;
  final Color secondary;
  final Color surface;
  final Color surfaceVariant;
  final Color background;
  final Color error;
  final Color success;
  final Color warning;
  final Color info;

  const AppColors({
    required this.primary,
    required this.secondary,
    required this.surface,
    required this.surfaceVariant,
    required this.background,
    required this.error,
    required this.success,
    required this.warning,
    required this.info,
  });

  // ライトモード用
  static const AppColors light = AppColors(
    primary: Color(0xFF2196F3),
    secondary: Color(0xFFFF6B6B),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFF5F5F5),
    background: Color(0xFFFAFAFA),
    error: Color(0xFFE53935),
    success: Color(0xFF43A047),
    warning: Color(0xFFFDD835),
    info: Color(0xFF1976D2),
  );

  // ダークモード用
  static const AppColors dark = AppColors(
    primary: Color(0xFF64B5F6),
    secondary: Color(0xFFEF5350),
    surface: Color(0xFF1E1E1E),
    surfaceVariant: Color(0xFF2D2D2D),
    background: Color(0xFF121212),
    error: Color(0xFFEF5350),
    success: Color(0xFF66BB6A),
    warning: Color(0xFFFFca28),
    info: Color(0xFF42A5F5),
  );

  @override
  AppColors copyWith({
    Color? primary,
    Color? secondary,
    Color? surface,
    Color? surfaceVariant,
    Color? background,
    Color? error,
    Color? success,
    Color? warning,
    Color? info,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      background: background ?? this.background,
      error: error ?? this.error,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      primary: Color.lerp(primary, other.primary, t) ?? primary,
      secondary: Color.lerp(secondary, other.secondary, t) ?? secondary,
      surface: Color.lerp(surface, other.surface, t) ?? surface,
      surfaceVariant:
          Color.lerp(surfaceVariant, other.surfaceVariant, t) ?? surfaceVariant,
      background: Color.lerp(background, other.background, t) ?? background,
      error: Color.lerp(error, other.error, t) ?? error,
      success: Color.lerp(success, other.success, t) ?? success,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      info: Color.lerp(info, other.info, t) ?? info,
    );
  }

  /// テーマから AppColors を取得
  static AppColors of(BuildContext context) {
    return Theme.of(context).extension<AppColors>() ?? light;
  }

  /// ダークモード判定
  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
