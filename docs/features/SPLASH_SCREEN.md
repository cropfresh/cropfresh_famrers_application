# CropFresh Splash Screen Documentation

## Overview

The CropFresh splash screen provides a premium, animated introduction to the application featuring 3D logo effects, floating particles, and smooth transitions to the onboarding flow.

## Features

### ✨ Visual Elements

- **3D Animated Logo**: Real CropFresh logo with rotation, scaling, and perspective effects
- **Gradient Background**: Dynamic color transitions using the 60-30-10 color scheme
- **Floating Particles**: Agricultural-themed particle system
- **Shimmer Effects**: Premium overlay animations
- **Loading Indicator**: Progress visualization
- **Floating Icons**: Agricultural symbols orbiting the logo

### ⏱️ Timing & Navigation

- **Duration**: 5 seconds total display time
- **Auto-Navigation**: Automatically transitions to onboarding screens
- **Animation Sequence**: Staggered animations for optimal visual impact

## Implementation Details

### File Structure

```
lib/features/splash/
├── presentation/
│   └── pages/
│       └── splash_screen.dart
```

### Key Components

#### 1. Animation Controllers

```dart
// Logo 3D rotation and scaling (3 seconds)
AnimationController _logoController;

// Background gradient animation (5 seconds)
AnimationController _backgroundController;

// Floating particles animation (continuous)
AnimationController _particleController;

// Text fade-in animation (1 second)
AnimationController _textController;
```

#### 2. Logo Implementation

```dart
Widget _build3DLogo() {
  return AnimatedBuilder(
    animation: _logoController,
    builder: (context, child) {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) // Perspective
          ..rotateX(_rotationX + _logoRotation.value * 0.2)
          ..rotateY(_rotationY + _logoRotation.value)
          ..rotateZ(_rotationZ + _logoRotation.value * 0.1),
        child: // Logo container with gradient background
      );
    },
  );
}
```

## Configuration Options

### Logo Variants

The splash screen supports multiple logo options:

```dart
// Current active logo
'assets/images/logo.png' // Main logo

// Alternative options (commented out)
'assets/images/logo-text.png' // Logo with text
'assets/images/Horizontal-logo-art-optimized.png' // Horizontal layout
```

### Timing Configuration

```dart
// Splash duration
Future.delayed(const Duration(seconds: 5), () {
  _navigateToNext();
});

// Animation durations
_logoController = AnimationController(
  duration: const Duration(seconds: 3), // Logo animation
  vsync: this,
);

_backgroundController = AnimationController(
  duration: const Duration(seconds: 5), // Background animation
  vsync: this,
);
```

### Color Scheme

Uses the established 60-30-10 color rule:

```dart
// 60% - Background colors
CropFreshColors.background60Primary
CropFreshColors.warm60Light

// 30% - Primary green colors
CropFreshColors.green30Primary
CropFreshColors.green30Light

// 10% - Orange accents
CropFreshColors.orange10Primary
```

## Customization Guide

### Changing Logo

1. **Replace Logo File**: Add your logo to `assets/images/`
2. **Update Asset Path**: Modify the image path in `_build3DLogo()`
3. **Adjust Dimensions**: Modify width/height values if needed

```dart
Image.asset(
  'assets/images/your-logo.png',
  width: 80,  // Adjust size
  height: 80, // Adjust size
  fit: BoxFit.contain,
)
```

### Modifying Duration

```dart
// Change splash display time
Future.delayed(const Duration(seconds: 7), () { // 7 seconds instead of 5
  _navigateToNext();
});

// Update background animation to match
_backgroundController = AnimationController(
  duration: const Duration(seconds: 7), // Match splash duration
  vsync: this,
);
```

### Customizing Animations

#### Logo Rotation Speed

```dart
// Modify rotation multipliers
..rotateX(_rotationX + _logoRotation.value * 0.1) // Slower X rotation
..rotateY(_rotationY + _logoRotation.value * 2.0) // Faster Y rotation
```

#### Particle Count

```dart
// Change number of floating particles
Stack(
  children: List.generate(20, (index) { // 20 instead of 15
    // Particle generation logic
  }),
)
```

### Adding Custom Elements

#### Custom Text

```dart
Widget _buildCustomText() {
  return FadeTransition(
    opacity: _textFade,
    child: Text(
      'Your Custom Text',
      style: TextStyle(
        fontSize: 18,
        color: CropFreshColors.green30Primary,
      ),
    ),
  );
}
```

## Navigation Flow

```
App Launch → Splash Screen (5s) → Onboarding Screens → Main App
```

### Navigation Implementation

```dart
void _navigateToNext() {
  HapticFeedback.lightImpact();
  
  try {
    Navigator.of(context).pushReplacementNamed('/onboarding');
  } catch (e) {
    // Fallback navigation
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const OnboardingScreen(),
      ),
    );
  }
}
```

## Performance Considerations

### Animation Optimization

- **Bounded Animations**: All animations use `.clamp()` to prevent overflow
- **Disposal**: Proper controller disposal in `dispose()` method
- **Frame Rate**: Optimized for 60fps performance

### Memory Management

```dart
@override
void dispose() {
  _logoController.dispose();
  _backgroundController.dispose();
  _particleController.dispose();
  _textController.dispose();
  super.dispose();
}
```

## Error Handling

### Logo Loading Fallback

```dart
errorBuilder: (context, error, stackTrace) {
  return Container(
    width: 80,
    height: 80,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Icon(
      Icons.agriculture,
      size: 60,
      color: Colors.white,
    ),
  );
}
```

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  # No additional packages required for splash screen
```

## Assets Required

```yaml
flutter:
  assets:
    - assets/images/logo.png
    - assets/images/logo-text.png  # Optional alternative
    - assets/images/Horizontal-logo-art-optimized.png  # Optional alternative
```

## Testing

### Manual Testing Checklist

- [ ] Logo loads correctly
- [ ] All animations run smoothly
- [ ] Timing is exactly 5 seconds
- [ ] Navigation to onboarding works
- [ ] Fallback icon appears if logo fails to load
- [ ] No memory leaks after navigation

### Performance Testing

```dart
// Add to test environment
flutter run --profile  // Test performance
flutter run --release  // Test production build
```

## Troubleshooting

### Common Issues

1. **Logo Not Displaying**
   - Check asset path in `pubspec.yaml`
   - Verify image file exists in `assets/images/`
   - Check console for loading errors

2. **Animation Stuttering**
   - Reduce particle count
   - Simplify 3D transforms
   - Check device performance

3. **Navigation Issues**
   - Verify route definitions in `main.dart`
   - Check onboarding screen imports
   - Review navigation context

### Debug Output

Enable debug prints for development:

```dart
void _navigateToNext() {
  print('🚀 Splash Screen: Navigation starting...');
  // Navigation logic
}
```

## Accessibility

### Features Implemented

- **Semantic Labels**: Proper widget labeling
- **Reduced Motion**: Respects system accessibility settings
- **Focus Management**: Proper focus handling

### Future Enhancements

- [ ] Skip button for accessibility
- [ ] Voice-over support
- [ ] High contrast mode support

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2024 | Initial implementation with custom painted logo |
| 1.1.0 | 2024 | Updated to use real logo.png asset |
| 1.2.0 | 2024 | Enhanced timing to 5 seconds |

---

**Last Updated**: December 2024  
**Maintainer**: CropFresh Development Team 