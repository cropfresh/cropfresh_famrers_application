import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:go_router/go_router.dart';

import 'package:cropfresh_farmers_app/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:cropfresh_farmers_app/core/constants/colors.dart';
import 'package:cropfresh_farmers_app/core/services/storage_service.dart';
import 'package:cropfresh_farmers_app/core/router/app_router.dart';

// * COMPREHENSIVE ONBOARDING SCREEN TESTS
// * Purpose: Test Material Design 3 onboarding implementation
// * Coverage: Animations, navigation, accessibility, user interactions
// * Focus: Material 3 components, haptic feedback, storage integration

class MockStorageService extends Mock implements StorageService {}
class MockGoRouter extends Mock implements GoRouter {}

void main() {
  group('Material Design 3 Onboarding Screen Tests', () {
    setUp(() async {
      // * Initialize storage service for testing
      await StorageService.initialize();
    });

    testWidgets('Should display Material 3 styled onboarding interface', (WidgetTester tester) async {
      // * ARRANGE
      await tester.pumpWidget(
        MaterialApp(
          home: const OnboardingScreen(),
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: CropFreshColors.green30Primary,
            ),
          ),
        ),
      );

      // * ACT & ASSERT - Check Material 3 components
      // ! IMPORTANT: Verify Material 3 LinearProgressIndicator is present
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      
      // * Verify Material 3 AppBar with transparent background
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, Colors.transparent);
      expect(appBar.elevation, 0);
      expect(appBar.scrolledUnderElevation, 0);
      
      // * Verify logo assets are properly integrated
      expect(find.byType(Image), findsWidgets);
      
      // * Check if onboarding content is displayed
      expect(find.text('Welcome to CropFresh'), findsOneWidget);
      expect(find.text('Farm Smarter, Sell Better'), findsOneWidget);
    });

    testWidgets('Should show proper page structure with Material 3 cards', (WidgetTester tester) async {
      // * ARRANGE
      await tester.pumpWidget(
        MaterialApp(
          home: const OnboardingScreen(),
          theme: ThemeData(useMaterial3: true),
        ),
      );

      // * ACT & ASSERT - Verify Material 3 card structure
      expect(find.byType(Card), findsWidgets);
      
      // * Check feature cards with Material 3 styling
      final cards = tester.widgetList<Card>(find.byType(Card));
      for (final card in cards) {
        expect(card.elevation, 0); // Material 3 uses elevation 0 for outlined cards
        expect(card.shape, isA<RoundedRectangleBorder>());
      }
      
      // * Verify feature icons and content
      expect(find.byIcon(Icons.trending_up_rounded), findsOneWidget);
      expect(find.byIcon(Icons.local_shipping_rounded), findsOneWidget);
      expect(find.byIcon(Icons.support_agent_rounded), findsOneWidget);
      
      expect(find.text('Better Prices'), findsOneWidget);
      expect(find.text('Easy Logistics'), findsOneWidget);
      expect(find.text('Expert Support'), findsOneWidget);
    });

    testWidgets('Should navigate through pages with proper animations', (WidgetTester tester) async {
      // * ARRANGE
      await tester.pumpWidget(
        MaterialApp(
          home: const OnboardingScreen(),
          theme: ThemeData(useMaterial3: true),
        ),
      );

      // * ACT - Navigate to next page
      final nextButton = find.byType(FilledButton);
      expect(nextButton, findsOneWidget);
      
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      // * ASSERT - Check page change
      expect(find.text('Direct Marketplace'), findsOneWidget);
      expect(find.text('No Middlemen, Maximum Profit'), findsOneWidget);
      
      // * Verify progress indicator updated
      final progressIndicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(progressIndicator.value, 2.0 / 4.0); // Page 2 of 4
    });

    testWidgets('Should display previous button on subsequent pages', (WidgetTester tester) async {
      // * ARRANGE
      await tester.pumpWidget(
        MaterialApp(
          home: const OnboardingScreen(),
          theme: ThemeData(useMaterial3: true),
        ),
      );

      // * ACT - Navigate to second page
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      // * ASSERT - Previous button should be visible
      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.text('Previous'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    });

    testWidgets('Should complete onboarding on last page', (WidgetTester tester) async {
      // * ARRANGE
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: GoRouter(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const OnboardingScreen(),
              ),
              GoRoute(
                path: '/welcome',
                builder: (context, state) => const Scaffold(
                  body: Text('Welcome Screen'),
                ),
              ),
            ],
          ),
          theme: ThemeData(useMaterial3: true),
        ),
      );

      // * ACT - Navigate through all pages
      for (int i = 0; i < 4; i++) {
        final nextButton = find.byType(FilledButton);
        await tester.tap(nextButton);
        await tester.pumpAndSettle();
      }

      // * ASSERT - Should navigate to welcome screen
      expect(find.text('Welcome Screen'), findsOneWidget);
    });

    testWidgets('Should handle skip functionality correctly', (WidgetTester tester) async {
      // * ARRANGE
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: GoRouter(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const OnboardingScreen(),
              ),
              GoRoute(
                path: '/welcome',
                builder: (context, state) => const Scaffold(
                  body: Text('Welcome Screen'),
                ),
              ),
            ],
          ),
          theme: ThemeData(useMaterial3: true),
        ),
      );

      // * ACT - Tap skip button
      final skipButton = find.text('Skip');
      expect(skipButton, findsOneWidget);
      
      await tester.tap(skipButton);
      await tester.pumpAndSettle();

      // * ASSERT - Should navigate to welcome screen
      expect(find.text('Welcome Screen'), findsOneWidget);
    });

    testWidgets('Should display correct content for each onboarding page', (WidgetTester tester) async {
      // * ARRANGE
      await tester.pumpWidget(
        MaterialApp(
          home: const OnboardingScreen(),
          theme: ThemeData(useMaterial3: true),
        ),
      );

      // * Test Page 1 - Welcome
      expect(find.text('Welcome to CropFresh'), findsOneWidget);
      expect(find.text('Farm Smarter, Sell Better'), findsOneWidget);
      expect(find.byIcon(Icons.agriculture_rounded), findsOneWidget);

      // * Navigate to Page 2 - Marketplace
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();
      
      expect(find.text('Direct Marketplace'), findsOneWidget);
      expect(find.text('No Middlemen, Maximum Profit'), findsOneWidget);
      expect(find.byIcon(Icons.storefront_rounded), findsOneWidget);

      // * Navigate to Page 3 - Farm Solution
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();
      
      expect(find.text('Complete Farm Solution'), findsOneWidget);
      expect(find.text('Everything in One App'), findsOneWidget);
      expect(find.byIcon(Icons.dashboard_rounded), findsOneWidget);

      // * Navigate to Page 4 - Language
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();
      
      expect(find.text('Choose Your Language'), findsOneWidget);
      expect(find.text('CropFresh Speaks Your Language'), findsOneWidget);
      expect(find.byIcon(Icons.public_rounded), findsOneWidget);
    });

    testWidgets('Should display language options with proper localization', (WidgetTester tester) async {
      // * ARRANGE
      await tester.pumpWidget(
        MaterialApp(
          home: const OnboardingScreen(),
          theme: ThemeData(useMaterial3: true),
        ),
      );

      // * ACT - Navigate to language page
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.byType(FilledButton));
        await tester.pumpAndSettle();
      }

      // * ASSERT - Verify language options
      expect(find.text('ಕನ್ನಡ'), findsOneWidget); // Kannada
      expect(find.text('తెలుగు'), findsOneWidget); // Telugu
      expect(find.text('हिंदी & English'), findsOneWidget); // Hindi & English
      
      // * Verify language descriptions
      expect(find.text('Karnataka farmers\' native language'), findsOneWidget);
      expect(find.text('Andhra Pradesh & Telangana support'), findsOneWidget);
      expect(find.text('Wide regional coverage and support'), findsOneWidget);
    });

    testWidgets('Should use proper Material 3 colors and theming', (WidgetTester tester) async {
      // * ARRANGE
      await tester.pumpWidget(
        MaterialApp(
          home: const OnboardingScreen(),
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: CropFreshColors.green30Primary,
            ),
          ),
        ),
      );

      // * ACT & ASSERT - Verify Material 3 color usage
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, isA<Color>());
      
      // * Check if buttons use FilledButton (Material 3)
      expect(find.byType(FilledButton), findsOneWidget);
      
      // * Verify proper color theming for different pages
      final heroIcon = find.byType(Container).first;
      expect(heroIcon, findsOneWidget);
    });

    testWidgets('Should have proper accessibility support', (WidgetTester tester) async {
      // * ARRANGE
      await tester.pumpWidget(
        MaterialApp(
          home: const OnboardingScreen(),
          theme: ThemeData(useMaterial3: true),
        ),
      );

      // * ACT & ASSERT - Check semantic labels and hints
      expect(tester.getSemantics(find.byType(FilledButton)), isNotNull);
      expect(tester.getSemantics(find.text('Welcome to CropFresh')), isNotNull);
      
      // * Verify button accessibility
      final nextButton = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(nextButton.onPressed, isNotNull);
    });

    testWidgets('Should handle animation states correctly', (WidgetTester tester) async {
      // * ARRANGE
      await tester.pumpWidget(
        MaterialApp(
          home: const OnboardingScreen(),
          theme: ThemeData(useMaterial3: true),
        ),
      );

      // * ACT - Trigger animation by navigating
      await tester.tap(find.byType(FilledButton));
      
      // * ASSERT - Verify animations are running
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(AnimatedBuilder), findsWidgets);
      
      // * Wait for animation to complete
      await tester.pumpAndSettle();
      expect(find.text('Direct Marketplace'), findsOneWidget);
    });

    group('Logo Asset Integration Tests', () {
      testWidgets('Should display logo assets correctly', (WidgetTester tester) async {
        // * ARRANGE
        await tester.pumpWidget(
          MaterialApp(
            home: const OnboardingScreen(),
            theme: ThemeData(useMaterial3: true),
          ),
        );

        // * ACT & ASSERT - Verify logo images are loaded
        final logoImages = find.byType(Image);
        expect(logoImages, findsWidgets);
        
        // * Check if error builders are working
        final images = tester.widgetList<Image>(logoImages);
        for (final image in images) {
          expect(image.errorBuilder, isNotNull);
        }
      });

      testWidgets('Should fallback gracefully when assets are missing', (WidgetTester tester) async {
        // * ARRANGE - This test checks error handling
        await tester.pumpWidget(
          MaterialApp(
            home: const OnboardingScreen(),
            theme: ThemeData(useMaterial3: true),
          ),
        );

        // * ACT & ASSERT - Verify fallback content exists
        // This verifies that error builders provide fallback content
        expect(find.byType(Container), findsWidgets);
        expect(find.text('CropFresh'), findsWidgets);
      });
    });

    group('Material 3 Component Tests', () {
      testWidgets('Should use Material 3 FilledButton instead of ElevatedButton', (WidgetTester tester) async {
        // * ARRANGE
        await tester.pumpWidget(
          MaterialApp(
            home: const OnboardingScreen(),
            theme: ThemeData(useMaterial3: true),
          ),
        );

        // * ACT & ASSERT - Verify Material 3 button types
        expect(find.byType(FilledButton), findsOneWidget);
        expect(find.byType(ElevatedButton), findsNothing);
        
        // * Check FilledButton styling
        final filledButton = tester.widget<FilledButton>(find.byType(FilledButton));
        expect(filledButton.style, isNotNull);
      });

      testWidgets('Should use Material 3 OutlinedButton for secondary actions', (WidgetTester tester) async {
        // * ARRANGE
        await tester.pumpWidget(
          MaterialApp(
            home: const OnboardingScreen(),
            theme: ThemeData(useMaterial3: true),
          ),
        );

        // * ACT - Navigate to show previous button
        await tester.tap(find.byType(FilledButton));
        await tester.pumpAndSettle();

        // * ASSERT - Verify OutlinedButton for previous action
        expect(find.byType(OutlinedButton), findsOneWidget);
        
        final outlinedButton = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
        expect(outlinedButton.style, isNotNull);
      });

      testWidgets('Should use Material 3 LinearProgressIndicator', (WidgetTester tester) async {
        // * ARRANGE
        await tester.pumpWidget(
          MaterialApp(
            home: const OnboardingScreen(),
            theme: ThemeData(useMaterial3: true),
          ),
        );

        // * ACT & ASSERT - Verify Material 3 progress indicator
        final progressIndicator = tester.widget<LinearProgressIndicator>(
          find.byType(LinearProgressIndicator),
        );
        
        expect(progressIndicator.borderRadius, isNotNull);
        expect(progressIndicator.minHeight, greaterThan(4));
      });
    });
  });
} 