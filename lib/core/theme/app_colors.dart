import 'package:flutter/material.dart';

/// * CROPFRESH COLORS THEME SYSTEM
/// * Centralized color management for CropFresh Farmers App
/// * Based on Material Design 3 color system with agricultural theme
class CropFreshColors {
  CropFreshColors._(); // Private constructor to prevent instantiation

  // * PRIMARY GREEN PALETTE - Agricultural focus
  static const Color green10Primary = Color(0xFF2E7D32); // Primary Deep Green
  static const Color green20Primary = Color(0xFF388E3C); // Lighter Primary Green
  static const Color green30Primary = Color(0xFF4CAF50); // Medium Green
  static const Color green10Container = Color(0xFFC8E6C9); // Light Green Container
  static const Color green20Container = Color(0xFFDCEDDC); // Very Light Green Container
  static const Color onGreen = Color(0xFFFFFFFF); // White text on green
  static const Color onGreenContainer = Color(0xFF1B5E20); // Dark text on light container

  // * SECONDARY ORANGE PALETTE - Accent colors
  static const Color orange10Primary = Color(0xFFFF8F00); // Primary Orange
  static const Color orange20Primary = Color(0xFFFFA000); // Lighter Orange
  static const Color orange10Container = Color(0xFFFFE0B2); // Light Orange Container
  static const Color onOrange = Color(0xFFFFFFFF); // White text on orange
  static const Color onOrangeContainer = Color(0xFFFF6F00); // Dark text on light container

  // * BACKGROUND AND SURFACE COLORS
  static const Color background = Color(0xFFF5F7FA); // Primary Background
  static const Color background60Surface = Color(0xFFF8FAFB); // Light Surface Background
  static const Color surface = Color(0xFFFFFFFF); // Pure White Surface
  static const Color surface10 = Color(0xFFF0F4F7); // Light Gray Surface
  static const Color surface20 = Color(0xFFE8EAED); // Medium Light Surface
  static const Color onBackground = Color(0xFF1A1C1E); // Dark text on background
  static const Color onSurface = Color(0xFF1A1C1E); // Dark text on surface

  // * OUTLINE COLORS
  static const Color outline = Color(0xFF77787D); // Primary outline
  static const Color outline30Variant = Color(0xFFC6C8CD); // Light outline variant
  static const Color outlineVariant = Color(0xFFE0E1E6); // Very light outline

  // * ERROR COLORS
  static const Color error = Color(0xFFD32F2F); // Primary Red
  static const Color errorContainer = Color(0xFFFFCDD2); // Light Red Container
  static const Color onError = Color(0xFFFFFFFF); // White text on error
  static const Color onErrorContainer = Color(0xFFD32F2F); // Red text on light container

  // * SUCCESS COLORS
  static const Color success = Color(0xFF388E3C); // Success Green
  static const Color successContainer = Color(0xFFC8E6C9); // Light Success Container
  static const Color onSuccess = Color(0xFFFFFFFF); // White text on success
  static const Color onSuccessContainer = Color(0xFF1B5E20); // Dark text on success container

  // * WARNING COLORS
  static const Color warning = Color(0xFFF57C00); // Warning Orange
  static const Color warningContainer = Color(0xFFFFE0B2); // Light Warning Container
  static const Color onWarning = Color(0xFFFFFFFF); // White text on warning
  static const Color onWarningContainer = Color(0xFFE65100); // Dark text on warning container

  // * NEUTRAL PALETTE
  static const Color neutral10 = Color(0xFF1A1C1E); // Very Dark Gray
  static const Color neutral20 = Color(0xFF2F3033); // Dark Gray
  static const Color neutral30 = Color(0xFF46474A); // Medium Dark Gray
  static const Color neutral40 = Color(0xFF5E5F63); // Medium Gray
  static const Color neutral50 = Color(0xFF77787D); // Medium Light Gray
  static const Color neutral60 = Color(0xFF919297); // Light Medium Gray
  static const Color neutral70 = Color(0xFFABADB2); // Light Gray
  static const Color neutral80 = Color(0xFFC6C8CD); // Very Light Gray
  static const Color neutral90 = Color(0xFFE2E3E8); // Almost White
  static const Color neutral95 = Color(0xFFF0F1F6); // Near White
  static const Color neutral99 = Color(0xFFFDFEFF); // Pure White

  // * MODULE-SPECIFIC COLORS
  static const Color marketplace = Color(0xFF2E7D32); // Green for marketplace
  static const Color logistics = Color(0xFF1976D2); // Blue for logistics
  static const Color veterinary = Color(0xFF7B1FA2); // Purple for vet services
  static const Color knowledge = Color(0xFFFF8F00); // Orange for knowledge hub
  static const Color livestock = Color(0xFF5D4037); // Brown for livestock
  static const Color soilTesting = Color(0xFF6D4C41); // Soil brown
  static const Color nursery = Color(0xFF388E3C); // Plant green

  // * SPECIAL AGRICULTURAL COLORS
  static const Color cropGreen = Color(0xFF4CAF50); // Healthy Crop Green
  static const Color soilBrown = Color(0xFF6D4C41); // Rich Soil Brown
  static const Color skyBlue = Color(0xFF2196F3); // Clear Sky Blue
  static const Color sunYellow = Color(0xFFFFC107); // Sunny Yellow
  static const Color waterBlue = Color(0xFF03DAC6); // Water/Irrigation Blue

  // * GRADIENT DEFINITIONS
  static const List<Color> primaryGradient = [
    Color(0xFF2E7D32),
    Color(0xFF4CAF50),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFFFF8F00),
    Color(0xFFFFC107),
  ];

  static const List<Color> backgroundGradient = [
    Color(0xFFF5F7FA),
    Color(0xFFFFFFFF),
  ];

  // * UTILITY METHODS
  static Color withOpacity(Color color, double opacity) => color.withOpacity(opacity);
  
  static Color primaryWithOpacity(double opacity) => green10Primary.withOpacity(opacity);
  static Color secondaryWithOpacity(double opacity) => orange10Primary.withOpacity(opacity);
  static Color errorWithOpacity(double opacity) => error.withOpacity(opacity);
  static Color successWithOpacity(double opacity) => success.withOpacity(opacity);
  static Color warningWithOpacity(double opacity) => warning.withOpacity(opacity);

  // * SHADOW COLORS
  static Color shadowLight = Colors.black.withOpacity(0.08);
  static Color shadowMedium = Colors.black.withOpacity(0.12);
  static Color shadowDark = Colors.black.withOpacity(0.16);

  // * SHIMMER COLORS (for loading states)
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // * STATUS COLORS
  static const Color statusActive = Color(0xFF4CAF50); // Active/Online
  static const Color statusInactive = Color(0xFF9E9E9E); // Inactive/Offline
  static const Color statusPending = Color(0xFFFF9800); // Pending/Processing
  static const Color statusError = Color(0xFFF44336); // Error/Failed
}

/// * LEGACY APP COLORS CLASS FOR BACKWARD COMPATIBILITY
/// ! DEPRECATED: Use CropFreshColors instead
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // * Map legacy colors to new CropFreshColors
  static Color get primary => CropFreshColors.green10Primary;
  static Color get primaryVariant => CropFreshColors.green20Primary;
  static Color get primaryContainer => CropFreshColors.green10Container;
  static Color get onPrimary => CropFreshColors.onGreen;
  static Color get onPrimaryContainer => CropFreshColors.onGreenContainer;

  static Color get secondary => CropFreshColors.orange10Primary;
  static Color get secondaryVariant => CropFreshColors.orange20Primary;
  static Color get secondaryContainer => CropFreshColors.orange10Container;
  static Color get onSecondary => CropFreshColors.onOrange;
  static Color get onSecondaryContainer => CropFreshColors.onOrangeContainer;

  static Color get background => CropFreshColors.background;
  static Color get surface => CropFreshColors.surface;
  static Color get onBackground => CropFreshColors.onBackground;
  static Color get onSurface => CropFreshColors.onSurface;

  static Color get error => CropFreshColors.error;
  static Color get onError => CropFreshColors.onError;
  static Color get success => CropFreshColors.success;
  static Color get warning => CropFreshColors.warning;
}

/// * EXTENSION FOR EASY COLOR ACCESS
/// * Access CropFreshColors properties directly without instantiation
extension CropFreshColorsExtension on BuildContext {
  // * Access primary colors
  Color get primaryColor => CropFreshColors.green10Primary;
  Color get primaryContainer => CropFreshColors.green10Container;
  Color get secondaryColor => CropFreshColors.orange10Primary;
  Color get backgroundColor => CropFreshColors.background;
  Color get surfaceColor => CropFreshColors.surface;
  Color get errorColor => CropFreshColors.error;
  Color get successColor => CropFreshColors.success;
  Color get warningColor => CropFreshColors.warning;
} 