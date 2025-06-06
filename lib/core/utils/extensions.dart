import 'package:flutter/material.dart';
import '../constants/colors.dart';

/// CropFresh Color-aware Extensions
/// Provides easy access to theme colors following 60-30-10 rule
extension CropFreshContextExtensions on BuildContext {
  
  // ============================================================================
  // THEME ACCESSORS
  // ============================================================================
  
  /// Get current theme data
  ThemeData get theme => Theme.of(this);
  
  /// Get current color scheme
  ColorScheme get colors => Theme.of(this).colorScheme;
  
  /// Get current text theme
  TextTheme get textTheme => Theme.of(this).textTheme;
  
  /// Check if current theme is dark mode
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  
  /// Get media query data
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  
  /// Get screen size
  Size get screenSize => MediaQuery.of(this).size;
  
  /// Get screen width
  double get screenWidth => MediaQuery.of(this).size.width;
  
  /// Get screen height
  double get screenHeight => MediaQuery.of(this).size.height;
  
  /// Check if device is tablet
  bool get isTablet => MediaQuery.of(this).size.width > 768;
  
  /// Check if device is mobile
  bool get isMobile => MediaQuery.of(this).size.width <= 768;

  // ============================================================================
  // CROPFRESH COLOR ACCESSORS (60-30-10 RULE)
  // ============================================================================
  
  /// 60% - Background Colors (Dominant)
  Color get background60Primary => 
    isDarkMode ? CropFreshColors.darkBackground60 : CropFreshColors.background60Primary;
  
  Color get background60Secondary => 
    isDarkMode ? CropFreshColors.darkSurface60 : CropFreshColors.background60Secondary;
  
  Color get background60Card => 
    isDarkMode ? CropFreshColors.darkCard60 : CropFreshColors.background60Card;
  
  /// 30% - Green Supporting Colors
  Color get green30Primary => 
    isDarkMode ? CropFreshColors.darkGreen30 : CropFreshColors.green30Primary;
  
  Color get green30Container => 
    isDarkMode ? CropFreshColors.darkGreen30Container : CropFreshColors.green30Container;
  
  Color get green30Text => 
    isDarkMode ? CropFreshColors.onDarkGreen30 : CropFreshColors.onGreen30;
  
  /// 10% - Orange Action Colors
  Color get orange10Primary => 
    isDarkMode ? CropFreshColors.darkOrange10 : CropFreshColors.orange10Primary;
  
  Color get orange10Container => 
    isDarkMode ? CropFreshColors.darkOrange10Container : CropFreshColors.orange10Container;
  
  Color get orange10Text => 
    isDarkMode ? CropFreshColors.onDarkOrange10 : CropFreshColors.onOrange10;

  // ============================================================================
  // SEMANTIC COLOR ACCESSORS
  // ============================================================================
  
  /// Success colors (30% green theme)
  Color get successColor => CropFreshColors.successPrimary;
  Color get successContainer => CropFreshColors.successContainer;
  
  /// Warning colors (10% orange theme)
  Color get warningColor => CropFreshColors.warningPrimary;
  Color get warningContainer => CropFreshColors.warningContainer;
  
  /// Error colors (10% intensity)
  Color get errorColor => CropFreshColors.errorPrimary;
  Color get errorContainer => CropFreshColors.errorContainer;
  
  /// Info colors (30% intensity)
  Color get infoColor => CropFreshColors.infoPrimary;
  Color get infoContainer => CropFreshColors.infoContainer;

  // ============================================================================
  // AGRICULTURAL CONTEXT COLORS
  // ============================================================================
  
  /// Get crop health color based on percentage
  Color getCropHealthColor(double healthPercentage) {
    return CropFreshColors.getCropHealthColor(healthPercentage);
  }
  
  /// Get price change color based on change percentage
  Color getPriceChangeColor(double changePercentage) {
    return CropFreshColors.getPriceChangeColor(changePercentage);
  }
  
  /// Agricultural success color (30% green)
  Color get cropSuccessColor => CropFreshColors.green30Fresh;
  
  /// Agricultural warning color (10% orange)
  Color get cropWarningColor => CropFreshColors.orange10Primary;

  // ============================================================================
  // TEXT COLORS
  // ============================================================================
  
  /// Primary text color (60% context)
  Color get primaryTextColor => 
    isDarkMode ? CropFreshColors.onDarkBackground60 : CropFreshColors.onBackground60;
  
  /// Secondary text color (60% context)
  Color get secondaryTextColor => 
    isDarkMode ? CropFreshColors.onDarkSurface60 : CropFreshColors.onBackground60Secondary;
  
  /// Tertiary text color (60% context)
  Color get tertiaryTextColor => 
    isDarkMode ? CropFreshColors.onDarkSurface60 : CropFreshColors.onBackground60Tertiary;

  // ============================================================================
  // RESPONSIVE HELPERS
  // ============================================================================
  
  /// Get responsive padding based on screen size
  EdgeInsets get responsivePadding {
    if (isTablet) {
      return const EdgeInsets.all(24);
    }
    return const EdgeInsets.all(16);
  }
  
  /// Get responsive margin based on screen size
  EdgeInsets get responsiveMargin {
    if (isTablet) {
      return const EdgeInsets.all(16);
    }
    return const EdgeInsets.all(8);
  }
  
  /// Get responsive font size multiplier
  double get fontSizeMultiplier {
    if (isTablet) return 1.2;
    if (screenWidth < 360) return 0.9;
    return 1.0;
  }
  
  /// Get grid cross axis count based on screen size
  int getGridCrossAxisCount(double itemWidth) {
    return (screenWidth / itemWidth).floor().clamp(1, 4);
  }
}

/// CropFresh String Extensions
extension CropFreshStringExtensions on String {
  
  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
  
  /// Title case
  String get toTitleCase {
    return split(' ').map((word) => word.capitalize).join(' ');
  }
  
  /// Check if string is valid phone number (Indian format)
  bool get isValidPhoneNumber {
    final phoneRegex = RegExp(r'^[6-9]\d{9}$');
    return phoneRegex.hasMatch(this);
  }
  
  /// Check if string is valid email
  bool get isValidEmail {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }
  
  /// Format price with Indian currency
  String get toIndianCurrency {
    final price = double.tryParse(this) ?? 0;
    return '₹${price.toStringAsFixed(2)}';
  }
  
  /// Format as Indian phone number
  String get toFormattedPhoneNumber {
    if (length == 10) {
      return '+91 ${substring(0, 5)} ${substring(5)}';
    }
    return this;
  }
}

/// CropFresh Number Extensions
extension CropFreshNumberExtensions on num {
  
  /// Convert to Indian currency format
  String get toIndianCurrency {
    return '₹${toStringAsFixed(2)}';
  }
  
  /// Convert to Indian currency with K/L suffixes
  String get toShortCurrency {
    if (this >= 10000000) {
      return '₹${(this / 10000000).toStringAsFixed(1)}Cr';
    } else if (this >= 100000) {
      return '₹${(this / 100000).toStringAsFixed(1)}L';
    } else if (this >= 1000) {
      return '₹${(this / 1000).toStringAsFixed(1)}K';
    }
    return '₹${toStringAsFixed(0)}';
  }
  
  /// Convert to weight format (kg, ton)
  String get toWeightFormat {
    if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)} ton';
    }
    return '${toStringAsFixed(1)} kg';
  }
  
  /// Convert to area format (hectare, acre)
  String get toAreaFormat {
    return '${toStringAsFixed(2)} hectare';
  }
  
  /// Get percentage format
  String get toPercentage {
    return '${toStringAsFixed(1)}%';
  }
  
  /// Get distance format
  String get toDistanceFormat {
    if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)} km';
    }
    return '${toStringAsFixed(0)} m';
  }
}

/// CropFresh DateTime Extensions
extension CropFreshDateTimeExtensions on DateTime {
  
  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
  
  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }
  
  /// Get relative time string (e.g., "2 hours ago", "3 days ago")
  String get relativeTime {
    final now = DateTime.now();
    final difference = now.difference(this);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
  
  /// Format as Indian date (DD/MM/YYYY)
  String get toIndianDate {
    return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
  }
  
  /// Format as time (HH:MM AM/PM)
  String get toTimeString {
    final hour = this.hour;
    final minute = this.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }
  
  /// Get farming season
  String get farmingSeason {
    switch (month) {
      case 1:
      case 2:
      case 3:
        return 'Rabi Season';
      case 4:
      case 5:
      case 6:
        return 'Summer Season';
      case 7:
      case 8:
      case 9:
      case 10:
        return 'Kharif Season';
      case 11:
      case 12:
        return 'Post-Harvest Season';
      default:
        return 'Unknown Season';
    }
  }
}

/// CropFresh Color Extensions
extension CropFreshColorExtensions on Color {
  
  /// Get a lighter shade of the color (useful for 60% backgrounds)
  Color lighter([double amount = 0.1]) {
    return Color.lerp(this, Colors.white, amount) ?? this;
  }
  
  /// Get a darker shade of the color (useful for 30% supporting elements)
  Color darker([double amount = 0.1]) {
    return Color.lerp(this, Colors.black, amount) ?? this;
  }
  
  /// Get a more vibrant version (useful for 10% action elements)
  Color vibrant([double amount = 0.2]) {
    final hsl = HSLColor.fromColor(this);
    return hsl.withSaturation((hsl.saturation + amount).clamp(0.0, 1.0)).toColor();
  }
  
  /// Check if color is light (useful for determining if it's a 60% background)
  bool get isLight => computeLuminance() > 0.5;
  
  /// Check if color is dark
  bool get isDark => computeLuminance() <= 0.5;
  
  /// Get appropriate text color for this background following 60-30-10 rule
  Color get appropriateTextColor {
    return CropFreshColors.getAccessibleTextColor(this);
  }
  
  /// Convert to agricultural context (adds slight green tint for 30% elements)
  Color get agriculturalTint {
    return Color.lerp(this, CropFreshColors.green30Light, 0.1) ?? this;
  }
  
  /// Convert to action context (adds slight orange tint for 10% elements)
  Color get actionTint {
    return Color.lerp(this, CropFreshColors.orange10Light, 0.1) ?? this;
  }
  
  /// Get hex string representation
  String get toHex {
    return '#${value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }
}

/// CropFresh List Extensions
extension CropFreshListExtensions<T> on List<T> {
  
  /// Get a safe element at index (returns null if out of bounds)
  T? safeGet(int index) {
    if (index >= 0 && index < length) {
      return this[index];
    }
    return null;
  }
  
  /// Chunk list into smaller lists of specified size
  List<List<T>> chunk(int chunkSize) {
    final chunks = <List<T>>[];
    for (int i = 0; i < length; i += chunkSize) {
      chunks.add(sublist(i, i + chunkSize > length ? length : i + chunkSize));
    }
    return chunks;
  }
  
  /// Get first element or null if empty
  T? get firstOrNull => isEmpty ? null : first;
  
  /// Get last element or null if empty
  T? get lastOrNull => isEmpty ? null : last;
}

/// CropFresh Widget Extensions
extension CropFreshWidgetExtensions on Widget {
  
  /// Apply CropFresh container decoration with 60-30-10 theming
  Widget cropFreshContainer({
    CropFreshContainerType type = CropFreshContainerType.background60,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? borderRadius,
  }) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin ?? const EdgeInsets.all(8),
      decoration: _getCropFreshDecoration(type, borderRadius),
      child: this,
    );
  }
  
  /// Apply responsive padding
  Widget responsivePadding(BuildContext context) {
    return Padding(
      padding: context.responsivePadding,
      child: this,
    );
  }
  
  /// Apply responsive margin
  Widget responsiveMargin(BuildContext context) {
    return Container(
      margin: context.responsiveMargin,
      child: this,
    );
  }
  
  /// Apply fade transition
  Widget fadeTransition(Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: this,
    );
  }
  
  /// Apply slide transition
  Widget slideTransition(Animation<Offset> animation) {
    return SlideTransition(
      position: animation,
      child: this,
    );
  }
  
  /// Apply scale transition
  Widget scaleTransition(Animation<double> animation) {
    return ScaleTransition(
      scale: animation,
      child: this,
    );
  }
  
  /// Center the widget
  Widget get centered => Center(child: this);
  
  /// Expand the widget
  Widget get expanded => Expanded(child: this);
  
  /// Apply flexible
  Widget flexible([int flex = 1]) => Flexible(flex: flex, child: this);
  
  /// Apply visibility
  Widget visible(bool isVisible) => Visibility(
    visible: isVisible,
    child: this,
  );
  
  /// Apply opacity
  Widget opacity(double opacity) => Opacity(
    opacity: opacity,
    child: this,
  );
  
  /// Apply gesture detector
  Widget onTap(VoidCallback? onTap) => GestureDetector(
    onTap: onTap,
    child: this,
  );
  
  /// Apply safe area
  Widget get safeArea => SafeArea(child: this);
  
  /// Apply hero animation
  Widget hero(String tag) => Hero(tag: tag, child: this);
}

/// CropFresh Container Types
enum CropFreshContainerType {
  background60,     // 60% - Light backgrounds
  supporting30,     // 30% - Green supporting elements
  action10,         // 10% - Orange action elements
  success,          // Success container
  warning,          // Warning container
  error,            // Error container
}

/// Get decoration for container type
BoxDecoration _getCropFreshDecoration(CropFreshContainerType type, double? borderRadius) {
  final radius = BorderRadius.circular(borderRadius ?? 12);
  
  switch (type) {
    case CropFreshContainerType.background60:
      return BoxDecoration(
        color: CropFreshColors.background60Card,
        borderRadius: radius,
        border: Border.all(color: CropFreshColors.onBackground60Disabled),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      );
    
    case CropFreshContainerType.supporting30:
      return BoxDecoration(
        color: CropFreshColors.green30Container,
        borderRadius: radius,
        border: Border.all(color: CropFreshColors.green30Primary),
        boxShadow: [
          BoxShadow(
            color: CropFreshColors.green30Primary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      );
    
    case CropFreshContainerType.action10:
      return BoxDecoration(
        color: CropFreshColors.orange10Container,
        borderRadius: radius,
        border: Border.all(color: CropFreshColors.orange10Primary),
        boxShadow: [
          BoxShadow(
            color: CropFreshColors.orange10Primary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      );
    
    case CropFreshContainerType.success:
      return BoxDecoration(
        color: CropFreshColors.successContainer,
        borderRadius: radius,
        border: Border.all(color: CropFreshColors.successPrimary),
      );
    
    case CropFreshContainerType.warning:
      return BoxDecoration(
        color: CropFreshColors.warningContainer,
        borderRadius: radius,
        border: Border.all(color: CropFreshColors.warningPrimary),
      );
    
    case CropFreshContainerType.error:
      return BoxDecoration(
        color: CropFreshColors.errorContainer,
        borderRadius: radius,
        border: Border.all(color: CropFreshColors.errorPrimary),
      );
  }
}
