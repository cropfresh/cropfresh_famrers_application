// ===================================================================
// * MATERIAL DESIGN 3 THEME CONFIGURATION
// * Purpose: Comprehensive Material Design 3 theme implementation
// * Features: Light/Dark themes, agricultural color palette, accessibility
// * Security Level: Low - UI configuration only
// ===================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// * AGRICULTURAL COLOR PALETTE INSPIRED BY NATURE
class AppColors {
  // ! ALERT: These colors are carefully chosen for agricultural context
  // Primary colors inspired by crop greens
  static const Color primaryGreen = Color(0xFF228B22);
  static const Color lightGreen = Color(0xFF90EE90);
  static const Color darkGreen = Color(0xFF006400);
  
  // Convenience getters for common usage
  static const Color primary = primaryGreen;
  static const Color secondary = secondaryOrange;
  static const Color accent = tertiaryBlue;
  
  // Secondary colors inspired by harvest and earth
  static const Color secondaryOrange = Color(0xFFFF8C00);
  static const Color lightOrange = Color(0xFFFFB347);
  static const Color darkOrange = Color(0xFFD2691E);
  
  // Tertiary colors inspired by sky and water
  static const Color tertiaryBlue = Color(0xFF4169E1);
  static const Color lightBlue = Color(0xFF87CEEB);
  static const Color darkBlue = Color(0xFF191970);
  
  // Error colors
  static const Color errorRed = Color(0xFFDC3545);
  static const Color lightRed = Color(0xFFFFB3BA);
  static const Color darkRed = Color(0xFF8B0000);
  
  // Warning colors
  static const Color warningAmber = Color(0xFFFFC107);
  static const Color lightAmber = Color(0xFFFFF59D);
  static const Color darkAmber = Color(0xFFF57F17);
  
  // Success colors
  static const Color successGreen = Color(0xFF28A745);
  static const Color lightSuccessGreen = Color(0xFFA8E6A3);
  static const Color darkSuccessGreen = Color(0xFF155724);
  
  // Info colors
  static const Color infoCyan = Color(0xFF17A2B8);
  static const Color lightCyan = Color(0xFF7DD3FC);
  static const Color darkCyan = Color(0xFF0C5460);
  
  // Neutral colors
  static const Color surfaceWhite = Color(0xFFFFFBF5);
  static const Color surfaceGray = Color(0xFFF8F9FA);
  static const Color outlineGray = Color(0xFFE0E0E0);
  static const Color onSurfaceGray = Color(0xFF121212);
  
  // Dark theme colors
  static const Color darkSurface = Color(0xFF121212);
  static const Color darkSurfaceVariant = Color(0xFF1E1E1E);
  static const Color darkOutline = Color(0xFF424242);
  static const Color darkOnSurface = Color(0xFFE0E0E0);
}

// * AGRICULTURAL TYPOGRAPHY SCALE
class AppTypography {
  // NOTE: Typography scale optimized for agricultural content readability
  static const String primaryFont = 'Inter';
  static const String kannadaFont = 'NotoSansKannada';
  static const String teluguFont = 'NotoSansTelugu';
  static const String hindiFont = 'NotoSansDevanagari';
  
  // Display styles for hero sections
  static const TextStyle displayLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    height: 1.12,
  );
  
  static const TextStyle displayMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.16,
  );
  
  static const TextStyle displaySmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 36,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.22,
  );
  
  // Headline styles for section headers
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.25,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.29,
  );
  
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.33,
  );
  
  // Title styles for cards and prominent text
  static const TextStyle titleLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 22,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.27,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.50,
  );
  
  static const TextStyle titleSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );
  
  // Body styles for main content
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.50,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
  );
  
  // Label styles for buttons and form fields
  static const TextStyle labelLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.33,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
  );
}

// * MAIN THEME CONFIGURATION CLASS
class AppTheme {
  // ? TODO: Add dynamic color scheme support for Android 12+
  
  // * LIGHT THEME CONFIGURATION
  static ThemeData get lightTheme {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryGreen,
      brightness: Brightness.light,
      primary: AppColors.primaryGreen,
      secondary: AppColors.secondaryOrange,
      tertiary: AppColors.tertiaryBlue,
      error: AppColors.errorRed,
      surface: AppColors.surfaceWhite,
      surfaceContainerHighest: AppColors.surfaceGray,
      outline: AppColors.outlineGray,
      onSurface: AppColors.onSurfaceGray,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: AppTypography.primaryFont,
      
      // * TYPOGRAPHY THEME
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge.copyWith(color: colorScheme.onSurface),
        displayMedium: AppTypography.displayMedium.copyWith(color: colorScheme.onSurface),
        displaySmall: AppTypography.displaySmall.copyWith(color: colorScheme.onSurface),
        headlineLarge: AppTypography.headlineLarge.copyWith(color: colorScheme.onSurface),
        headlineMedium: AppTypography.headlineMedium.copyWith(color: colorScheme.onSurface),
        headlineSmall: AppTypography.headlineSmall.copyWith(color: colorScheme.onSurface),
        titleLarge: AppTypography.titleLarge.copyWith(color: colorScheme.onSurface),
        titleMedium: AppTypography.titleMedium.copyWith(color: colorScheme.onSurface),
        titleSmall: AppTypography.titleSmall.copyWith(color: colorScheme.onSurface),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: colorScheme.onSurface),
        bodyMedium: AppTypography.bodyMedium.copyWith(color: colorScheme.onSurface),
        bodySmall: AppTypography.bodySmall.copyWith(color: colorScheme.onSurface),
        labelLarge: AppTypography.labelLarge.copyWith(color: colorScheme.onSurface),
        labelMedium: AppTypography.labelMedium.copyWith(color: colorScheme.onSurface),
        labelSmall: AppTypography.labelSmall.copyWith(color: colorScheme.onSurface),
      ),
      
      // * APP BAR THEME
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: colorScheme.surfaceTint,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: colorScheme.onSurface,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: colorScheme.surface,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
      
      // * CARD THEME
      cardTheme: CardThemeData(
        elevation: 1,
        surfaceTintColor: colorScheme.surfaceTint,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      
      // * ELEVATED BUTTON THEME
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTypography.labelLarge,
        ),
      ),
      
      // * FILLED BUTTON THEME
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTypography.labelLarge,
        ),
      ),
      
      // * OUTLINED BUTTON THEME
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: colorScheme.outline),
          textStyle: AppTypography.labelLarge,
        ),
      ),
      
      // * TEXT BUTTON THEME
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: AppTypography.labelLarge,
        ),
      ),
      
      // * INPUT DECORATION THEME
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: AppTypography.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
        hintStyle: AppTypography.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
      ),
      
      // * FLOATING ACTION BUTTON THEME
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // * CHIP THEME
      chipTheme: ChipThemeData(
        labelStyle: AppTypography.labelMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide(color: colorScheme.outline),
      ),
      
      // * NAVIGATION BAR THEME
      navigationBarTheme: NavigationBarThemeData(
        elevation: 3,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        indicatorColor: colorScheme.secondaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.labelMedium.copyWith(color: colorScheme.onSurface);
          }
          return AppTypography.labelMedium.copyWith(color: colorScheme.onSurfaceVariant);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.onSecondaryContainer);
          }
          return IconThemeData(color: colorScheme.onSurfaceVariant);
        }),
      ),
      
      // * DRAWER THEME
      drawerTheme: DrawerThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
      ),
      
      // * BOTTOM SHEET THEME
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      
      // * SNACK BAR THEME
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        actionTextColor: colorScheme.inversePrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      
      // * DIVIDER THEME
      dividerTheme: DividerThemeData(
        color: colorScheme.outline,
        thickness: 1,
      ),
      
      // * ICON THEME
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
        size: 24,
      ),
    );
  }
  
  // * DARK THEME CONFIGURATION
  static ThemeData get darkTheme {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryGreen,
      brightness: Brightness.dark,
      primary: AppColors.lightGreen,
      secondary: AppColors.lightOrange,
      tertiary: AppColors.lightBlue,
      error: AppColors.lightRed,
      surface: AppColors.darkSurface,
      surfaceContainerHighest: AppColors.darkSurfaceVariant,
      outline: AppColors.darkOutline,
      onSurface: AppColors.darkOnSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: AppTypography.primaryFont,
      
      // * TYPOGRAPHY THEME (same as light theme but with dark colors)
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge.copyWith(color: colorScheme.onSurface),
        displayMedium: AppTypography.displayMedium.copyWith(color: colorScheme.onSurface),
        displaySmall: AppTypography.displaySmall.copyWith(color: colorScheme.onSurface),
        headlineLarge: AppTypography.headlineLarge.copyWith(color: colorScheme.onSurface),
        headlineMedium: AppTypography.headlineMedium.copyWith(color: colorScheme.onSurface),
        headlineSmall: AppTypography.headlineSmall.copyWith(color: colorScheme.onSurface),
        titleLarge: AppTypography.titleLarge.copyWith(color: colorScheme.onSurface),
        titleMedium: AppTypography.titleMedium.copyWith(color: colorScheme.onSurface),
        titleSmall: AppTypography.titleSmall.copyWith(color: colorScheme.onSurface),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: colorScheme.onSurface),
        bodyMedium: AppTypography.bodyMedium.copyWith(color: colorScheme.onSurface),
        bodySmall: AppTypography.bodySmall.copyWith(color: colorScheme.onSurface),
        labelLarge: AppTypography.labelLarge.copyWith(color: colorScheme.onSurface),
        labelMedium: AppTypography.labelMedium.copyWith(color: colorScheme.onSurface),
        labelSmall: AppTypography.labelSmall.copyWith(color: colorScheme.onSurface),
      ),
      
      // NOTE: App bar theme for dark mode
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: colorScheme.surfaceTint,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: colorScheme.onSurface,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: colorScheme.surface,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),
      
      // NOTE: Reuse light theme configurations with dark color scheme
      cardTheme: CardThemeData(
        elevation: 1,
        surfaceTintColor: colorScheme.surfaceTint,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTypography.labelLarge,
        ),
      ),
      
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTypography.labelLarge,
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: colorScheme.outline),
          textStyle: AppTypography.labelLarge,
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: AppTypography.labelLarge,
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: AppTypography.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
        hintStyle: AppTypography.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
      ),
      
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      chipTheme: ChipThemeData(
        labelStyle: AppTypography.labelMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide(color: colorScheme.outline),
      ),
      
      navigationBarTheme: NavigationBarThemeData(
        elevation: 3,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        indicatorColor: colorScheme.secondaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.labelMedium.copyWith(color: colorScheme.onSurface);
          }
          return AppTypography.labelMedium.copyWith(color: colorScheme.onSurfaceVariant);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.onSecondaryContainer);
          }
          return IconThemeData(color: colorScheme.onSurfaceVariant);
        }),
      ),
      
      drawerTheme: DrawerThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
      ),
      
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        actionTextColor: colorScheme.inversePrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      
      dividerTheme: DividerThemeData(
        color: colorScheme.outline,
        thickness: 1,
      ),
      
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
        size: 24,
      ),
    );
  }
  
  // * UTILITY METHODS FOR THEME EXTENSIONS
  
  // NOTE: Get semantic color for status indicators
  static Color getStatusColor(String status, ColorScheme colorScheme) {
    switch (status.toLowerCase()) {
      case 'success':
      case 'delivered':
      case 'completed':
        return AppColors.successGreen;
      case 'warning':
      case 'pending':
      case 'in_transit':
        return AppColors.warningAmber;
      case 'error':
      case 'failed':
      case 'cancelled':
        return colorScheme.error;
      case 'info':
      case 'processing':
        return AppColors.infoCyan;
      default:
        return colorScheme.primary;
    }
  }
  
  // NOTE: Get font family based on language
  static String getFontFamily(String languageCode) {
    switch (languageCode) {
      case 'kn':
        return AppTypography.kannadaFont;
      case 'te':
        return AppTypography.teluguFont;
      case 'hi':
        return AppTypography.hindiFont;
      default:
        return AppTypography.primaryFont;
    }
  }
  
  // OPTIMIZE: Cache theme instances to improve performance
  static ThemeData? _cachedLightTheme;
  static ThemeData? _cachedDarkTheme;
  
  static ThemeData getCachedLightTheme() {
    _cachedLightTheme ??= lightTheme;
    return _cachedLightTheme!;
  }
  
  static ThemeData getCachedDarkTheme() {
    _cachedDarkTheme ??= darkTheme;
    return _cachedDarkTheme!;
  }
}

// * THEME EXTENSION FOR AGRICULTURAL SEMANTIC COLORS
extension AppThemeExtension on ThemeData {
  Color get cropGreen => AppColors.primaryGreen;
  Color get harvestOrange => AppColors.secondaryOrange;
  Color get skyBlue => AppColors.tertiaryBlue;
  Color get soilBrown => const Color(0xFF8B4513);
  Color get waterBlue => const Color(0xFF4169E1);
  Color get sunYellow => const Color(0xFFFFD700);
  
  // Status colors for different agricultural contexts
  Color get healthyGreen => AppColors.successGreen;
  Color get cautionAmber => AppColors.warningAmber;
  Color get dangerRed => AppColors.errorRed;
  Color get infoBlue => AppColors.infoCyan;
}
