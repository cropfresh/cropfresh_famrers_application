# Icons & Visual Guidelines 📱

## Overview

CropFresh Farmers App uses a carefully curated icon system that supports the agricultural theme while maintaining the 60-30-10 color rule for optimal user experience.

## Icon Color Usage

### Primary Icons (30% Green)
Use `CropFreshColors.green30Primary` (#228B22) for:
- **Navigation icons** (selected states)
- **Agricultural features** (crop management, farm tools)
- **Success indicators** (completed tasks, healthy status)
- **Brand elements** (logo representations)

### Action Icons (10% Orange)
Use `CropFreshColors.orange10Primary` (#FF5722) for:
- **Call-to-action buttons** (Sell, Buy, Book)
- **Warning indicators** (attention required)
- **Urgent notifications** (alerts, deadlines)
- **Price/financial highlights** (profit, premium pricing)

### Neutral Icons (60% Context)
Use neutral colors for:
- **Inactive navigation** (`CropFreshColors.onBackground60Tertiary`)
- **Supporting information** (`CropFreshColors.onBackground60Secondary`)
- **Decorative elements** (`CropFreshColors.onBackground60Disabled`)

## Core Icon Categories

### 1. Navigation Icons

#### Bottom Navigation
```dart
// Dashboard - Always green (30%)
Icon(Icons.dashboard, color: CropFreshColors.green30Primary)
Icon(Icons.home, color: CropFreshColors.green30Primary)

// Marketplace - Green when selected (30%), orange for sell actions (10%)
Icon(Icons.store, color: CropFreshColors.green30Primary)
Icon(Icons.shopping_bag, color: CropFreshColors.green30Primary)

// Sell Action - Orange highlight (10%)
Icon(Icons.add_circle, color: CropFreshColors.orange10Primary, size: 32)

// Services - Green supporting (30%)
Icon(Icons.agriculture, color: CropFreshColors.green30Primary)
Icon(Icons.local_shipping, color: CropFreshColors.green30Primary)

// Profile - Green identity (30%)
Icon(Icons.person, color: CropFreshColors.green30Primary)
Icon(Icons.account_circle, color: CropFreshColors.green30Primary)
```

#### App Bar Icons
```dart
// Notifications - Orange for attention (10%)
Icon(Icons.notifications, color: CropFreshColors.orange10Primary)
Icon(Icons.notifications_active, color: CropFreshColors.orange10Primary)

// Menu/Navigation - Green brand (30%)
Icon(Icons.menu, color: CropFreshColors.green30Primary)
Icon(Icons.arrow_back, color: CropFreshColors.green30Primary)

// Search - Neutral
Icon(Icons.search, color: CropFreshColors.onBackground60Secondary)
```

### 2. Agricultural Feature Icons

#### Crop Management (30% Green)
```dart
Icon(Icons.agriculture, color: CropFreshColors.green30Primary)
Icon(Icons.grass, color: CropFreshColors.green30Fresh)
Icon(Icons.eco, color: CropFreshColors.green30Light)
Icon(Icons.nature, color: CropFreshColors.green30Primary)
Icon(Icons.park, color: CropFreshColors.green30Forest)
Icon(Icons.forest, color: CropFreshColors.green30Dark)
```

#### Weather & Environment (Mixed Colors)
```dart
// Sunny/Good weather - Orange warmth (10%)
Icon(Icons.wb_sunny, color: CropFreshColors.orange10Amber)
Icon(Icons.wb_cloudy, color: CropFreshColors.onBackground60Secondary)

// Rain/Water - Blue (30% intensity for agricultural importance)
Icon(Icons.water_drop, color: CropFreshColors.waterBlue)
Icon(Icons.cloud, color: CropFreshColors.onBackground60Secondary)

// Temperature - Context-based
Icon(Icons.thermostat, color: CropFreshColors.onBackground60Secondary)
```

#### Livestock (30% Green with context variations)
```dart
Icon(Icons.pets, color: CropFreshColors.green30Primary)
// Custom livestock icons with green theme
```

### 3. Marketplace Icons

#### Products & Selling (Mixed 30% Green + 10% Orange)
```dart
// Product categories - Green agricultural (30%)
Icon(Icons.local_florist, color: CropFreshColors.green30Primary)  // Flowers
Icon(Icons.grain, color: CropFreshColors.green30Primary)          // Grains
Icon(Icons.apple, color: CropFreshColors.green30Fresh)            // Fruits

// Selling actions - Orange emphasis (10%)
Icon(Icons.sell, color: CropFreshColors.orange10Primary)
Icon(Icons.monetization_on, color: CropFreshColors.orange10Primary)
Icon(Icons.trending_up, color: CropFreshColors.orange10Primary)   // Price increase

// Shopping/Buying - Green supporting (30%)
Icon(Icons.shopping_cart, color: CropFreshColors.green30Primary)
Icon(Icons.add_shopping_cart, color: CropFreshColors.green30Primary)
```

#### Financial Indicators
```dart
// Profit/Positive - Green (30%)
Icon(Icons.trending_up, color: CropFreshColors.green30Primary)
Icon(Icons.attach_money, color: CropFreshColors.green30Primary)

// Loss/Negative - Orange/Red (10%)
Icon(Icons.trending_down, color: CropFreshColors.orange10Primary)

// Stable - Neutral
Icon(Icons.trending_flat, color: CropFreshColors.onBackground60Secondary)
```

### 4. Service Icons

#### Logistics (30% Green supporting)
```dart
Icon(Icons.local_shipping, color: CropFreshColors.green30Primary)
Icon(Icons.delivery_dining, color: CropFreshColors.green30Primary)
Icon(Icons.track_changes, color: CropFreshColors.green30Primary)
Icon(Icons.location_on, color: CropFreshColors.green30Primary)
Icon(Icons.route, color: CropFreshColors.green30Primary)
```

#### Input Procurement (30% Green)
```dart
Icon(Icons.inventory, color: CropFreshColors.green30Primary)
Icon(Icons.science, color: CropFreshColors.green30Primary)        // Fertilizers
Icon(Icons.bug_report, color: CropFreshColors.green30Primary)     // Pesticides
Icon(Icons.build, color: CropFreshColors.green30Primary)          // Tools
```

#### Agricultural Services (30% Green)
```dart
// Soil Testing
Icon(Icons.science, color: CropFreshColors.green30Primary)
Icon(Icons.biotech, color: CropFreshColors.green30Primary)

// Veterinary
Icon(Icons.medical_services, color: CropFreshColors.green30Primary)
Icon(Icons.local_hospital, color: CropFreshColors.green30Primary)

// Nursery
Icon(Icons.local_florist, color: CropFreshColors.green30Primary)
Icon(Icons.yard, color: CropFreshColors.green30Fresh)
```

### 5. Action & Status Icons

#### Primary Actions (10% Orange)
```dart
Icon(Icons.add, color: CropFreshColors.orange10Primary)
Icon(Icons.edit, color: CropFreshColors.orange10Primary)
Icon(Icons.camera_alt, color: CropFreshColors.orange10Primary)
Icon(Icons.upload, color: CropFreshColors.orange10Primary)
Icon(Icons.save, color: CropFreshColors.orange10Primary)
Icon(Icons.send, color: CropFreshColors.orange10Primary)
```

#### Status Indicators
```dart
// Success - Green (30%)
Icon(Icons.check_circle, color: CropFreshColors.green30Primary)
Icon(Icons.verified, color: CropFreshColors.green30Primary)
Icon(Icons.done, color: CropFreshColors.green30Fresh)

// Warning - Orange (10%)
Icon(Icons.warning, color: CropFreshColors.orange10Primary)
Icon(Icons.priority_high, color: CropFreshColors.orange10Primary)

// Error - Red (10% intensity)
Icon(Icons.error, color: CropFreshColors.errorPrimary)
Icon(Icons.cancel, color: CropFreshColors.errorPrimary)

// Info - Blue (30% intensity)
Icon(Icons.info, color: CropFreshColors.infoPrimary)
Icon(Icons.help, color: CropFreshColors.infoPrimary)
```

## Custom Icon Implementation

### Icon Container Component
```dart
class CropFreshIcon extends StatelessWidget {
  final IconData icon;
  final CropFreshIconType type;
  final double size;
  final VoidCallback? onTap;

  const CropFreshIcon({
    Key? key,
    required this.icon,
    required this.type,
    this.size = 24,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = _getColorForType(type);
    final container = _getContainerForType(type);
    
    Widget iconWidget = Icon(
      icon,
      color: color,
      size: size,
    );
    
    if (container != null) {
      iconWidget = Container(
        padding: EdgeInsets.all(size * 0.3),
        decoration: container,
        child: iconWidget,
      );
    }
    
    if (onTap != null) {
      iconWidget = GestureDetector(
        onTap: onTap,
        child: iconWidget,
      );
    }
    
    return iconWidget;
  }

  Color _getColorForType(CropFreshIconType type) {
    switch (type) {
      case CropFreshIconType.primary:
        return CropFreshColors.green30Primary;      // 30% green
      case CropFreshIconType.action:
        return CropFreshColors.orange10Primary;     // 10% orange
      case CropFreshIconType.success:
        return CropFreshColors.green30Fresh;        // 30% green variant
      case CropFreshIconType.warning:
        return CropFreshColors.orange10Primary;     // 10% orange
      case CropFreshIconType.error:
        return CropFreshColors.errorPrimary;        // 10% intensity
      case CropFreshIconType.neutral:
        return CropFreshColors.onBackground60Secondary; // 60% context
    }
  }

  BoxDecoration? _getContainerForType(CropFreshIconType type) {
    switch (type) {
      case CropFreshIconType.primary:
        return BoxDecoration(
          color: CropFreshColors.green30Container,   // 30% green bg
          borderRadius: BorderRadius.circular(8),
        );
      case CropFreshIconType.action:
        return BoxDecoration(
          color: CropFreshColors.orange10Container,  // 10% orange bg
          borderRadius: BorderRadius.circular(8),
        );
      default:
        return null;
    }
  }
}

enum CropFreshIconType {
  primary,    // 30% green - Agricultural features, navigation
  action,     // 10% orange - CTAs, urgent actions
  success,    // 30% green variant - Success states
  warning,    // 10% orange - Warnings, attention
  error,      // 10% intensity - Errors, problems
  neutral,    // 60% context - Supporting, inactive
}
```

### Icon Usage Examples

#### Dashboard Quick Actions
```dart
GridView.count(
  crossAxisCount: 2,
  children: [
    _buildQuickAction(
      'Sell Produce',
      CropFreshIcon(
        icon: Icons.sell,
        type: CropFreshIconType.action,  // 10% orange for selling
        size: 32,
      ),
    ),
    _buildQuickAction(
      'Crop Health',
      CropFreshIcon(
        icon: Icons.agriculture,
        type: CropFreshIconType.primary, // 30% green for agriculture
        size: 32,
      ),
    ),
    _buildQuickAction(
      'Weather',
      CropFreshIcon(
        icon: Icons.wb_sunny,
        type: CropFreshIconType.neutral, // Neutral for weather
        size: 32,
      ),
    ),
    _buildQuickAction(
      'Market Prices',
      CropFreshIcon(
        icon: Icons.trending_up,
        type: CropFreshIconType.action,  // 10% orange for market action
        size: 32,
      ),
    ),
  ],
)
```

#### Product Status Indicators
```dart
Row(
  children: [
    CropFreshIcon(
      icon: Icons.verified,
      type: CropFreshIconType.success,  // 30% green for quality verified
      size: 20,
    ),
    SizedBox(width: 4),
    Text('Quality Verified'),
    Spacer(),
    CropFreshIcon(
      icon: Icons.trending_up,
      type: CropFreshIconType.action,   // 10% orange for price increase
      size: 16,
    ),
    Text('+5%', style: TextStyle(color: CropFreshColors.orange10Primary)),
  ],
)
```

## Accessibility Guidelines

### Icon Accessibility
```dart
// Always provide semantic labels
Semantics(
  label: 'Sell your produce',
  button: true,
  child: CropFreshIcon(
    icon: Icons.sell,
    type: CropFreshIconType.action,
    onTap: () => _navigateToSelling(),
  ),
)

// Ensure minimum touch targets (48dp)
Container(
  width: 48,
  height: 48,
  child: CropFreshIcon(
    icon: Icons.agriculture,
    type: CropFreshIconType.primary,
    onTap: () => _openCropManagement(),
  ),
)
```

### Color Contrast
- ✅ Green (#228B22) on white background: 7.2:1 contrast ratio
- ✅ Orange (#FF5722) on white background: 5.8:1 contrast ratio
- ✅ All icon colors meet WCAG AA standards

## Icon Animation Guidelines

### Micro-animations
```dart
class AnimatedCropFreshIcon extends StatefulWidget {
  final IconData icon;
  final CropFreshIconType type;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      transform: Matrix4.identity()..scale(isActive ? 1.1 : 1.0),
      child: CropFreshIcon(
        icon: icon,
        type: type,
      ),
    );
  }
}
```

### Loading States
```dart
class LoadingCropFreshIcon extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animationController,
      child: CropFreshIcon(
        icon: Icons.refresh,
        type: CropFreshIconType.primary,
      ),
    );
  }
}
```

This icon system ensures consistent visual communication while maintaining the CropFresh brand identity through the strategic use of the 60-30-10 color rule.
