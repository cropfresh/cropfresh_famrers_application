# CropFresh Farmers App - Routing Flow Documentation

## Overview
This document describes the corrected navigation flow for the CropFresh Farmers application, ensuring proper user onboarding and authentication sequence.

## Routing Flow Sequence

### 1. Splash Screen (Always First)
**Route**: `/`
**Duration**: 3-5 seconds (minimum for animations + initialization)
**Purpose**: 
- App initialization and configuration loading
- Check user authentication and onboarding status
- Route determination based on user state

### 2. User State-Based Navigation

#### First Time User Flow
```
Splash → Onboarding → Language Selection → Welcome → Authentication
```

#### Returning User Flows
```
// User completed onboarding but not language selection
Splash → Language Selection → Welcome → Authentication

// User completed onboarding & language but not authenticated  
Splash → Welcome → Authentication

// Fully authenticated user
Splash → Dashboard
```

## Detailed Route Specifications

### Navigation Logic (from Splash Screen)

```typescript
const determineNextRoute = () => {
  const hasToken = getUserToken() !== null;
  const onboardingComplete = isOnboardingComplete();
  const languageSelected = isLanguageSelectionComplete();

  // Priority 1: Authenticated users go to dashboard
  if (hasToken) return '/main/dashboard';
  
  // Priority 2: First time users see onboarding
  if (!onboardingComplete) return '/onboarding';
  
  // Priority 3: Language selection required
  if (!languageSelected) return '/language-selection';
  
  // Priority 4: Ready for authentication
  return '/welcome';
};
```

### Route Guards & Redirects

The app implements automatic route protection through GoRouter's redirect functionality:

1. **Onboarding Guard**: Redirects to `/onboarding` if not completed
2. **Language Selection Guard**: Redirects to `/language-selection` if onboarding complete but language not selected
3. **Authentication Guard**: Redirects to `/phone-number` if accessing protected routes without authentication

## Storage Keys & State Management

### Storage Keys Used
```dart
// Core flow control
static const String onboardingCompleteKey = 'onboarding_complete';
static const String languageSelectionCompleteKey = 'language_selection_complete';
static const String selectedLanguageKey = 'selected_language';
static const String userTokenKey = 'user_token';
```

### State Transitions
```dart
// When onboarding is completed
await StorageService.setOnboardingComplete(true);

// When language is selected (automatically marks selection as complete)
await StorageService.setSelectedLanguage('en'); // Also sets languageSelectionCompleteKey = true

// When user authenticates
await StorageService.setUserToken(jwtToken);
```

## Screen Responsibilities

### Splash Screen
- **Purpose**: Initialize app and determine navigation flow
- **Navigation Logic**: Implemented in `_navigateToNextScreen()`
- **Dependencies**: StorageService for state checking

### Onboarding Screen  
- **Purpose**: Introduce app features to new users
- **Completion Action**: Navigate to Language Selection
- **Storage Update**: Set `onboarding_complete = true`

### Language Selection Screen
- **Purpose**: Capture user's preferred language
- **Completion Action**: Navigate to Welcome Screen  
- **Storage Updates**: 
  - Set `selected_language = chosen_language`
  - Set `language_selection_complete = true`

### Welcome Screen
- **Purpose**: Welcome returning users and initiate authentication
- **Next Action**: Navigate to Phone Number entry for authentication

## Testing the Flow

### Manual Testing Scenarios

#### Scenario 1: First Time User
1. **Clear app data** (or fresh install)
2. **Launch app** → Should show Splash
3. **Wait for splash completion** → Should navigate to Onboarding
4. **Complete onboarding** → Should navigate to Language Selection
5. **Select language** → Should navigate to Welcome Screen

#### Scenario 2: Returning User (Onboarding Complete, Language Not Selected)
1. **Set onboarding_complete = true** in storage
2. **Ensure language_selection_complete = false**
3. **Launch app** → Should show Splash
4. **Wait for completion** → Should navigate directly to Language Selection
5. **Select language** → Should navigate to Welcome Screen

#### Scenario 3: Returning User (Ready for Auth)
1. **Set onboarding_complete = true**
2. **Set language_selection_complete = true**  
3. **Ensure no auth token**
4. **Launch app** → Should show Splash
5. **Wait for completion** → Should navigate directly to Welcome Screen

#### Scenario 4: Authenticated User
1. **Set valid auth token** in storage
2. **Launch app** → Should show Splash
3. **Wait for completion** → Should navigate directly to Dashboard

### Automated Testing

The routing logic is tested in `test/features/splash/splash_screen_test.dart` with the following test cases:

- First time user navigation to onboarding
- Onboarding complete → Language selection navigation
- Language selection complete → Welcome navigation  
- Authenticated user → Dashboard navigation

## Error Handling

### Navigation Failure Recovery
If navigation fails at any point, the app falls back to the onboarding flow:

```dart
catch (e) {
  debugPrint('Navigation error: $e');
  context.go(AppRoutes.onboarding); // Safe fallback
}
```

### Storage Service Failures
If storage service fails to read user state, app assumes first-time user state and starts onboarding flow.

## Route Definitions

All routes are defined in `/lib/core/router/app_router.dart`:

```dart
static const String splash = '/';
static const String onboarding = '/onboarding';  
static const String languageSelection = '/language-selection';
static const String welcome = '/welcome';
static const String phoneNumber = '/phone-number';
// ... additional routes
```

## Best Practices

1. **Always check user state in splash screen** - Never assume previous app state
2. **Use storage service consistently** - All state persistence goes through StorageService
3. **Implement proper error handling** - Graceful fallbacks for navigation failures
4. **Test all user scenarios** - Verify flow works for all user states
5. **Keep route guards updated** - Ensure router redirects match business logic

## Future Enhancements

- **Deep linking support** - Handle external links while respecting flow
- **Route animations** - Smooth transitions between onboarding screens
- **State persistence** - Remember partial form data across app restarts
- **Analytics integration** - Track user flow completion rates

---

*Last Updated: January 2024*
*Version: 1.0.0* 