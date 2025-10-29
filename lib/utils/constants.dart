import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1E1F29); // Đen
  static const Color secondary = Color(0xFF757575); // Xám đậm
  static const Color accent = Color(0xFFBDBDBD); // Xám nhạt
  static const Color background = Color(0xFFFAFAFA); // Trắng hơi xám
  static const Color surface = Color(0xFFFFFFFF); // Trắng
  static const Color error = Color(0xFFD32F2F); // Đỏ
  static const Color success = Color(0xFF388E3C); // Xanh lá
  static const Color textPrimary = Color(0xFF212121); // Đen text
  static const Color textSecondary = Color(0xFF757575); // Xám text
  static const Color divider = Color(0xFFE0E0E0); // Đường kẻ
}

// Text Styles - iOS Style (SF Pro)
class AppTextStyles {
  // iOS San Francisco font family
  static const String fontFamily = '.SF Pro Text';
  static const String displayFontFamily = '.SF Pro Display';

  static const TextStyle heading1 = TextStyle(
    fontFamily: displayFontFamily,
    fontSize: 34,
    fontWeight: FontWeight.w700, // Bold iOS
    color: AppColors.textPrimary,
    letterSpacing: 0.37,
    height: 1.2,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: displayFontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700, // Bold iOS
    color: AppColors.textPrimary,
    letterSpacing: 0.36,
    height: 1.3,
  );

  static const TextStyle heading3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600, // Semibold iOS
    color: AppColors.textPrimary,
    letterSpacing: 0.38,
    height: 1.4,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17, // iOS default body size
    fontWeight: FontWeight.w500, // Medium iOS
    color: AppColors.textPrimary,
    letterSpacing: -0.41,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w500, // Medium iOS
    color: AppColors.textSecondary,
    letterSpacing: -0.24,
    height: 1.4,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13, // iOS footnote size
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: -0.08,
    height: 1.3,
  );

  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w600, // Semibold iOS
    color: AppColors.surface,
    letterSpacing: -0.41,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12, // iOS caption
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0,
  );
}

// Spacing
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

// Border Radius
class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static BorderRadius circular(double radius) => BorderRadius.circular(radius);
}

// Shadows
class AppShadows {
  static List<BoxShadow> get small => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get medium => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get large => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];
}

// App Theme
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      // iOS font family
      fontFamily: AppTextStyles.fontFamily,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.surface,
          letterSpacing: -0.41,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.surface,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // iOS radius
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // iOS radius
          ),
          textStyle: AppTextStyles.button.copyWith(color: AppColors.primary),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 12,
          ),
          textStyle: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 17,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.41,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // iOS radius
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: AppTextStyles.bodyMedium,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.accent),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        elevation: 6, // iOS elevation
      ),
    );
  }
}

// Firebase Storage Configuration
// LƯU Ý: Firebase Storage tự động sử dụng bucket mặc định của project
// Không cần specify bucket name, chỉ cần dùng FirebaseStorage.instance
