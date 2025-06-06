import 'package:flutter/material.dart';
import '../constants/colors.dart';

/// CropFresh Theme Configuration
/// Implements Material Design 3 with CropFresh brand colors
class CropFreshTheme {
  CropFreshTheme._();

  // ============================================================================
  // LIGHT THEME
  // ============================================================================

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme (60-30-10 Implementation)
      colorScheme: const ColorScheme.light(
        // 60% - Backgrounds and Surfaces
        background: CropFreshColors.background60Primary,
        surface: CropFreshColors.background60Card,
        surfaceVariant: CropFreshColors.background60Secondary,

        // 30% - Primary (Green) Colors
        primary: CropFreshColors.green30Primary,
        primaryContainer: CropFreshColors.green30Container,
        onPrimary: CropFreshColors.onGreen30,
        onPrimaryContainer: CropFreshColors.onGreen30Container,

        // 10% - Secondary (Orange) Colors
        secondary: CropFreshColors.orange10Primary,
        secondaryContainer: CropFreshColors.orange10Container,
        onSecondary: CropFreshColors.onOrange10,
        onSecondaryContainer: CropFreshColors.onOrange10Container,

        // Text Colors
        onBackground: CropFreshColors.onBackground60,
        onSurface: CropFreshColors.onBackground60,
        onSurfaceVariant: CropFreshColors.onBackground60Secondary,

        // Semantic Colors
        error: CropFreshColors.errorPrimary,
        errorContainer: CropFreshColors.errorContainer,
        onError: CropFreshColors.onError,
        onErrorContainer: CropFreshColors.onErrorContainer,

        // Additional Colors
        tertiary: CropFreshColors.green30Light,
        tertiaryContainer: CropFreshColors.green30Surface,
        outline: CropFreshColors.onBackground60Tertiary,
        outlineVariant: CropFreshColors.onBackground60Disabled,
      ),

      // App Bar Theme (30% Green Implementation)
      appBarTheme: const AppBarTheme(
        backgroundColor: CropFreshColors.background60Primary,
        foregroundColor: CropFreshColors.onBackground60,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: CropFreshColors.green30Primary,
        ),
        iconTheme: IconThemeData(
          color: CropFreshColors.green30Primary,
          size: 24,
        ),
      ),

      // Bottom Navigation Bar Theme (60-30-10 Implementation)
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: CropFreshColors.background60Primary,
        selectedItemColor: CropFreshColors.green30Primary, // 30%
        unselectedItemColor: CropFreshColors.onBackground60Tertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
      ),

      // Elevated Button Theme (10% Orange Actions)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CropFreshColors.green30Primary,
          foregroundColor: CropFreshColors.onGreen30,
          elevation: 2,
          shadowColor: CropFreshColors.onBackground60,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button Theme (30% Green Supporting)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: CropFreshColors.green30Primary,
          side: const BorderSide(
            color: CropFreshColors.green30Primary,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: CropFreshColors.orange10Primary,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // FloatingActionButton Theme (10% Orange Accent)
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: CropFreshColors.orange10Primary,
        foregroundColor: CropFreshColors.onOrange10,
        elevation: 6,
        shape: CircleBorder(),
      ),

      // Card Theme (60% Background Implementation)
      cardTheme: const CardThemeData(
        color: CropFreshColors.background60Card,
        elevation: 2,
        shadowColor: CropFreshColors.onBackground60,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        margin: EdgeInsets.all(8),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: CropFreshColors.background60Secondary,
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: const BorderSide(
            color: CropFreshColors.onBackground60Disabled,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: const BorderSide(
            color: CropFreshColors.onBackground60Disabled,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: const BorderSide(
            color: CropFreshColors.green30Primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: const BorderSide(
            color: CropFreshColors.errorPrimary,
            width: 2,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: const TextStyle(
          color: CropFreshColors.onBackground60Secondary,
        ),
        hintStyle: const TextStyle(
          color: CropFreshColors.onBackground60Tertiary,
        ),
      ),

      // Chip Theme (30% Green Supporting)
      chipTheme: ChipThemeData(
        backgroundColor: CropFreshColors.green30Container,
        labelStyle: const TextStyle(
          color: CropFreshColors.onGreen30Container,
        ),
        selectedColor: CropFreshColors.green30Primary,
        disabledColor: CropFreshColors.onBackground60Disabled,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
      ),

      // Switch Theme (30% Green)
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return CropFreshColors.green30Primary;
          }
          return CropFreshColors.onBackground60Disabled;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return CropFreshColors.green30Container;
          }
          return CropFreshColors.background60Container;
        }),
      ),

      // Checkbox Theme (30% Green)
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return CropFreshColors.green30Primary;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(CropFreshColors.onGreen30),
        side: const BorderSide(
          color: CropFreshColors.green30Primary,
          width: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
      ),

      // Radio Theme (30% Green)
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return CropFreshColors.green30Primary;
          }
          return CropFreshColors.onBackground60Tertiary;
        }),
      ),

      // Progress Indicator Theme (30% Green)
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: CropFreshColors.green30Primary,
        linearTrackColor: CropFreshColors.green30Container,
        circularTrackColor: CropFreshColors.green30Container,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: CropFreshColors.onBackground60Disabled,
        thickness: 1,
        space: 16,
      ),

      // Typography
      textTheme: _buildTextTheme(),

      // Icon Theme (30% Green)
      iconTheme: const IconThemeData(
        color: CropFreshColors.green30Primary,
        size: 24,
      ),

      // Scaffold Background (60% Implementation)
      scaffoldBackgroundColor: CropFreshColors.background60Primary,

      // Visual Density
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  // ============================================================================
  // DARK THEME
  // ============================================================================

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme (60-30-10 Implementation for Dark Mode)
      colorScheme: const ColorScheme.dark(
        // 60% - Dark Backgrounds
        background: CropFreshColors.darkBackground60,
        surface: CropFreshColors.darkCard60,
        surfaceVariant: CropFreshColors.darkSurface60,

        // 30% - Primary (Green) Colors
        primary: CropFreshColors.darkGreen30,
        primaryContainer: CropFreshColors.darkGreen30Container,
        onPrimary: CropFreshColors.onDarkGreen30,
        onPrimaryContainer: CropFreshColors.onDarkGreen30,

        // 10% - Secondary (Orange) Colors
        secondary: CropFreshColors.darkOrange10,
        secondaryContainer: CropFreshColors.darkOrange10Container,
        onSecondary: CropFreshColors.onDarkOrange10,
        onSecondaryContainer: CropFreshColors.onDarkOrange10,

        // Text Colors
        onBackground: CropFreshColors.onDarkBackground60,
        onSurface: CropFreshColors.onDarkBackground60,
        onSurfaceVariant: CropFreshColors.onDarkSurface60,

        // Semantic Colors
        error: CropFreshColors.errorPrimary,
        errorContainer: CropFreshColors.darkContainer60,
        onError: CropFreshColors.onError,
        onErrorContainer: CropFreshColors.onDarkBackground60,

        // Additional Colors
        tertiary: CropFreshColors.darkGreen30,
        tertiaryContainer: CropFreshColors.darkGreen30Container,
        outline: CropFreshColors.onDarkSurface60,
        outlineVariant: CropFreshColors.onDarkSurface60,
      ),

      // Scaffold Background (60% Dark Implementation)
      scaffoldBackgroundColor: CropFreshColors.darkBackground60,

      // App Bar Theme (Dark)
      appBarTheme: const AppBarTheme(
        backgroundColor: CropFreshColors.darkBackground60,
        foregroundColor: CropFreshColors.onDarkBackground60,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: CropFreshColors.darkGreen30,
        ),
        iconTheme: IconThemeData(
          color: CropFreshColors.darkGreen30,
          size: 24,
        ),
      ),

      // Typography (Same as light theme)
      textTheme: _buildTextTheme(isDark: true),

      // Visual Density
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  // ============================================================================
  // TEXT THEME
  // ============================================================================

  static TextTheme _buildTextTheme({bool isDark = false}) {
    final baseColor = isDark
        ? CropFreshColors.onDarkBackground60
        : CropFreshColors.onBackground60;

    final secondaryColor = isDark
        ? CropFreshColors.onDarkSurface60
        : CropFreshColors.onBackground60Secondary;

    return TextTheme(
      // Headlines
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: baseColor,
        letterSpacing: -0.25,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: baseColor,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: baseColor,
      ),

      // Headlines
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: baseColor,
      ),

      // Titles
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: baseColor,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: baseColor,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: baseColor,
      ),

      // Body Text
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: baseColor,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: baseColor,
        height: 1.4,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
        height: 1.3,
      ),

      // Labels
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
      ),
    );
  }

  // ============================================================================
  // CUSTOM COMPONENT THEMES
  // ============================================================================

  /// Custom Card Theme for Product Cards
  static CardTheme get productCardTheme => CardTheme(
        color: CropFreshColors.background60Card,
        elevation: 3,
        shadowColor: CropFreshColors.green30Primary.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          side: const BorderSide(
            color: CropFreshColors.green30Container,
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      );

  /// Custom Button Theme for Agricultural Actions
  static ElevatedButtonThemeData get agriculturalButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CropFreshColors
              .green30Primary, // 30% green for agricultural actions
          foregroundColor: CropFreshColors.onGreen30,
          elevation: 2,
          shadowColor: CropFreshColors.green30Primary.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  /// Custom Button Theme for Marketplace Actions
  static ElevatedButtonThemeData get marketplaceButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CropFreshColors
              .orange10Primary, // 10% orange for marketplace actions
          foregroundColor: CropFreshColors.onOrange10,
          elevation: 3,
          shadowColor: CropFreshColors.orange10Primary.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      );

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Get theme-appropriate color based on context
  static Color getContextualColor(BuildContext context, String colorContext) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (colorContext.toLowerCase()) {
      case 'primary':
        return isDark
            ? CropFreshColors.darkGreen30
            : CropFreshColors.green30Primary;
      case 'action':
        return isDark
            ? CropFreshColors.darkOrange10
            : CropFreshColors.orange10Primary;
      case 'background':
        return isDark
            ? CropFreshColors.darkBackground60
            : CropFreshColors.background60Primary;
      case 'surface':
        return isDark
            ? CropFreshColors.darkCard60
            : CropFreshColors.background60Card;
      default:
        return isDark
            ? CropFreshColors.onDarkBackground60
            : CropFreshColors.onBackground60;
    }
  }

  /// Apply agricultural context styling to any widget
  static BoxDecoration get agriculturalContainerDecoration => BoxDecoration(
        color: CropFreshColors.background60Card,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(
          color: CropFreshColors.green30Container,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: CropFreshColors.green30Primary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      );

  /// Apply marketplace context styling to any widget
  static BoxDecoration get marketplaceContainerDecoration => BoxDecoration(
        color: CropFreshColors.background60Card,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(
          color: CropFreshColors.orange10Container,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: CropFreshColors.orange10Primary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      );
}

/// Extension for easy theme access
extension CropFreshThemeExtension on BuildContext {
  /// Get current theme colors
  ColorScheme get colors => Theme.of(this).colorScheme;

  /// Get current text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Check if current theme is dark
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Get CropFresh contextual color
  Color cropFreshColor(String context) =>
      CropFreshTheme.getContextualColor(this, context);
}
