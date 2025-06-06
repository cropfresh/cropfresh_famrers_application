// ===================================================================
// * APPLICATION ROUTER CONFIGURATION
// * Purpose: Centralized routing configuration using GoRouter
// * Features: Route definitions, navigation guards, deep linking
// * Security Level: Medium - Contains app navigation structure
// ===================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// * CORE IMPORTS
import '../services/storage_service.dart';
import '../constants/app_constants.dart';

// * SCREEN IMPORTS
// Splash & Onboarding
import '../../features/splash/presentation/pages/splash_screen.dart';
import '../../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../../features/onboarding/presentation/pages/language_selection_page.dart';

// Authentication
import '../../features/auth/presentation/pages/welcome_screen.dart';
import '../../features/auth/presentation/pages/phone_number_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/auth/presentation/pages/profile_setup_page.dart';
import '../../features/auth/presentation/pages/farm_details_page.dart';
import '../../features/auth/presentation/pages/document_upload_page.dart';

// Dashboard & Main Navigation
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/dashboard/presentation/pages/main_navigation_page.dart';

// Marketplace
import '../../features/marketplace/presentation/pages/marketplace_page.dart';
import '../../features/marketplace/presentation/pages/product_listing_page.dart';
import '../../features/marketplace/presentation/pages/create_product_page.dart';
import '../../features/marketplace/presentation/pages/product_detail_page.dart';
import '../../features/marketplace/presentation/pages/negotiation_page.dart';

// Logistics
import '../../features/logistics/presentation/pages/logistics_page.dart';
import '../../features/logistics/presentation/pages/provider_discovery_page.dart';
import '../../features/logistics/presentation/pages/booking_details_page.dart';
import '../../features/logistics/presentation/pages/tracking_page.dart';

// Services
import '../../features/services/presentation/pages/services_page.dart';
import '../../features/services/presentation/pages/input_procurement_page.dart';
import '../../features/services/presentation/pages/soil_testing_page.dart';
import '../../features/services/presentation/pages/vet_services_page.dart';
import '../../features/services/presentation/pages/nursery_services_page.dart';

// Livestock
import '../../features/livestock/presentation/pages/livestock_page.dart';
import '../../features/livestock/presentation/pages/animal_profile_page.dart';
import '../../features/livestock/presentation/pages/health_tracking_page.dart';

// Knowledge Hub
import '../../features/knowledge/presentation/pages/knowledge_hub_page.dart';
import '../../features/knowledge/presentation/pages/article_detail_page.dart';
import '../../features/knowledge/presentation/pages/video_player_page.dart';

// Profile & Settings
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/settings_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';

// * ROUTE DEFINITIONS
class AppRoutes {
  // ! ALERT: These route paths must match the navigation structure
  
  // Splash & Onboarding
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String languageSelection = '/language-selection';
  
  // Authentication Flow
  static const String welcome = '/welcome';
  static const String phoneNumber = '/phone-number';
  static const String otpVerification = '/otp-verification';
  static const String profileSetup = '/profile-setup';
  static const String farmDetails = '/farm-details';
  static const String documentUpload = '/document-upload';
  
  // Main Application
  static const String mainNavigation = '/main';
  static const String dashboard = '/main/dashboard';
  static const String marketplace = '/main/marketplace';
  static const String services = '/main/services';
  static const String knowledge = '/main/knowledge';
  static const String profile = '/main/profile';
  
  // Marketplace Sub-routes
  static const String productListing = '/main/marketplace/my-products';
  static const String createProduct = '/main/marketplace/create-product';
  static const String productDetail = '/main/marketplace/product/:productId';
  static const String negotiation = '/main/marketplace/negotiation/:negotiationId';
  
  // Logistics Sub-routes
  static const String logistics = '/main/services/logistics';
  static const String logisticsProviders = '/main/services/logistics/providers';
  static const String logisticsBooking = '/main/services/logistics/booking';
  static const String logisticsTracking = '/main/services/logistics/tracking/:bookingId';
  
  // Service Sub-routes
  static const String inputProcurement = '/main/services/input-procurement';
  static const String soilTesting = '/main/services/soil-testing';
  static const String vetServices = '/main/services/vet-services';
  static const String nurseryServices = '/main/services/nursery-services';
  
  // Livestock Sub-routes
  static const String livestock = '/main/livestock';
  static const String animalProfile = '/main/livestock/animal/:animalId';
  static const String healthTracking = '/main/livestock/health/:animalId';
  
  // Knowledge Hub Sub-routes
  static const String articleDetail = '/main/knowledge/article/:articleId';
  static const String videoPlayer = '/main/knowledge/video/:videoId';
  
  // Profile Sub-routes
  static const String settings = '/main/profile/settings';
  static const String editProfile = '/main/profile/edit';
  
  // Utility methods for route generation
  static String productDetailRoute(String productId) => '/main/marketplace/product/$productId';
  static String negotiationRoute(String negotiationId) => '/main/marketplace/negotiation/$negotiationId';
  static String trackingRoute(String bookingId) => '/main/services/logistics/tracking/$bookingId';
  static String animalProfileRoute(String animalId) => '/main/livestock/animal/$animalId';
  static String healthTrackingRoute(String animalId) => '/main/livestock/health/$animalId';
  static String articleDetailRoute(String articleId) => '/main/knowledge/article/$articleId';
  static String videoPlayerRoute(String videoId) => '/main/knowledge/video/$videoId';
}

// * MAIN ROUTER CONFIGURATION
class AppRouter {
  // ? TODO: Add route transition animations and custom transitions
  
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');
  
  // * ROUTER INSTANCE
  static late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: AppRoutes.splash,
    
    // * ROUTE DEFINITIONS
    routes: [
      // * SPLASH SCREEN
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // * ONBOARDING FLOW
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      
      GoRoute(
        path: AppRoutes.languageSelection,
        name: 'language-selection',
        builder: (context, state) => const LanguageSelectionPage(),
      ),
      
      // * AUTHENTICATION FLOW
      GoRoute(
        path: AppRoutes.welcome,
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      
      GoRoute(
        path: AppRoutes.phoneNumber,
        name: 'phone-number',
        builder: (context, state) => const PhoneNumberPage(),
      ),
      
      GoRoute(
        path: AppRoutes.otpVerification,
        name: 'otp-verification',
        builder: (context, state) {
          final phoneNumber = state.uri.queryParameters['phoneNumber'] ?? '';
          return OtpVerificationPage(phoneNumber: phoneNumber);
        },
      ),
      
      GoRoute(
        path: AppRoutes.profileSetup,
        name: 'profile-setup',
        builder: (context, state) => const ProfileSetupPage(),
      ),
      
      GoRoute(
        path: AppRoutes.farmDetails,
        name: 'farm-details',
        builder: (context, state) => const FarmDetailsPage(),
      ),
      
      GoRoute(
        path: AppRoutes.documentUpload,
        name: 'document-upload',
        builder: (context, state) => const DocumentUploadPage(),
      ),
      
      // * MAIN APPLICATION WITH SHELL ROUTE
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainNavigationPage(child: child);
        },
        routes: [
          // * DASHBOARD
          GoRoute(
            path: AppRoutes.dashboard,
            name: 'dashboard',
            builder: (context, state) => const DashboardPage(),
          ),
          
          // * MARKETPLACE
          GoRoute(
            path: AppRoutes.marketplace,
            name: 'marketplace',
            builder: (context, state) => const MarketplacePage(),
            routes: [
              // My Products
              GoRoute(
                path: 'my-products',
                name: 'product-listing',
                builder: (context, state) => const ProductListingPage(),
              ),
              
              // Create Product
              GoRoute(
                path: 'create-product',
                name: 'create-product',
                builder: (context, state) => const CreateProductPage(),
              ),
              
              // Product Detail
              GoRoute(
                path: 'product/:productId',
                name: 'product-detail',
                builder: (context, state) {
                  final productId = state.pathParameters['productId']!;
                  return ProductDetailPage(productId: productId);
                },
              ),
              
              // Negotiation
              GoRoute(
                path: 'negotiation/:negotiationId',
                name: 'negotiation',
                builder: (context, state) {
                  final negotiationId = state.pathParameters['negotiationId']!;
                  return NegotiationPage(negotiationId: negotiationId);
                },
              ),
            ],
          ),
          
          // * SERVICES
          GoRoute(
            path: AppRoutes.services,
            name: 'services',
            builder: (context, state) => const ServicesPage(),
            routes: [
              // Logistics
              GoRoute(
                path: 'logistics',
                name: 'logistics',
                builder: (context, state) => const LogisticsPage(),
                routes: [
                  GoRoute(
                    path: 'providers',
                    name: 'logistics-providers',
                    builder: (context, state) => const ProviderDiscoveryPage(),
                  ),
                  GoRoute(
                    path: 'booking',
                    name: 'logistics-booking',
                    builder: (context, state) => const BookingDetailsPage(),
                  ),
                  GoRoute(
                    path: 'tracking/:bookingId',
                    name: 'logistics-tracking',
                    builder: (context, state) {
                      final bookingId = state.pathParameters['bookingId']!;
                      return TrackingPage(bookingId: bookingId);
                    },
                  ),
                ],
              ),
              
              // Input Procurement
              GoRoute(
                path: 'input-procurement',
                name: 'input-procurement',
                builder: (context, state) => const InputProcurementPage(),
              ),
              
              // Soil Testing
              GoRoute(
                path: 'soil-testing',
                name: 'soil-testing',
                builder: (context, state) => const SoilTestingPage(),
              ),
              
              // Veterinary Services
              GoRoute(
                path: 'vet-services',
                name: 'vet-services',
                builder: (context, state) => const VetServicesPage(),
              ),
              
              // Nursery Services
              GoRoute(
                path: 'nursery-services',
                name: 'nursery-services',
                builder: (context, state) => const NurseryServicesPage(),
              ),
            ],
          ),
          
          // * LIVESTOCK
          GoRoute(
            path: AppRoutes.livestock,
            name: 'livestock',
            builder: (context, state) => const LivestockPage(),
            routes: [
              // Animal Profile
              GoRoute(
                path: 'animal/:animalId',
                name: 'animal-profile',
                builder: (context, state) {
                  final animalId = state.pathParameters['animalId']!;
                  return AnimalProfilePage(animalId: animalId);
                },
              ),
              
              // Health Tracking
              GoRoute(
                path: 'health/:animalId',
                name: 'health-tracking',
                builder: (context, state) {
                  final animalId = state.pathParameters['animalId']!;
                  return HealthTrackingPage(animalId: animalId);
                },
              ),
            ],
          ),
          
          // * KNOWLEDGE HUB
          GoRoute(
            path: AppRoutes.knowledge,
            name: 'knowledge',
            builder: (context, state) => const KnowledgeHubPage(),
            routes: [
              // Article Detail
              GoRoute(
                path: 'article/:articleId',
                name: 'article-detail',
                builder: (context, state) {
                  final articleId = state.pathParameters['articleId']!;
                  return ArticleDetailPage(articleId: articleId);
                },
              ),
              
              // Video Player
              GoRoute(
                path: 'video/:videoId',
                name: 'video-player',
                builder: (context, state) {
                  final videoId = state.pathParameters['videoId']!;
                  return VideoPlayerPage(videoId: videoId);
                },
              ),
            ],
          ),
          
          // * PROFILE
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
            routes: [
              // Settings
              GoRoute(
                path: 'settings',
                name: 'settings',
                builder: (context, state) => const SettingsPage(),
              ),
              
              // Edit Profile
              GoRoute(
                path: 'edit',
                name: 'edit-profile',
                builder: (context, state) => const EditProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
    
    // * ROUTE REDIRECTS AND GUARDS
    redirect: (context, state) async {
      // ! ALERT: Authentication and onboarding flow management
      
      final isOnboardingComplete = await StorageService.getBool('onboarding_complete') ?? false;
      final isLanguageSelectionComplete = await StorageService.getBool('language_selection_complete') ?? false;
      final isAuthenticated = await StorageService.getString('access_token') != null;
      final currentPath = state.uri.path;
      
      // NOTE: Skip guards for initial app load
      if (currentPath == AppRoutes.splash) {
        return null;
      }
      
      // * ONBOARDING GUARD - First priority
      if (!isOnboardingComplete && !_isOnboardingRoute(currentPath)) {
        return AppRoutes.onboarding;
      }
      
      // * LANGUAGE SELECTION GUARD - Second priority
      if (isOnboardingComplete && !isLanguageSelectionComplete && currentPath != AppRoutes.languageSelection) {
        return AppRoutes.languageSelection;
      }
      
      // * AUTHENTICATION GUARD - Third priority
      if (!isAuthenticated && !_isPublicRoute(currentPath)) {
        return AppRoutes.phoneNumber;
      }
      
      // * MAIN APP REDIRECT
      if (isAuthenticated && isOnboardingComplete && isLanguageSelectionComplete && currentPath == '/') {
        return AppRoutes.dashboard;
      }
      
      return null;
    },
    
    // * ERROR HANDLING
    errorBuilder: (context, state) => ErrorPage(error: state.error),
    
    // * ROUTE INFORMATION PARSER
    routerNeglect: false,
    
    // * OBSERVERS FOR ANALYTICS
    observers: [
      AppRouterObserver(),
    ],
  );
  
  // * HELPER METHODS
  
  // NOTE: Check if route is part of onboarding flow
  static bool _isOnboardingRoute(String path) {
    return path.startsWith('/onboarding') || 
           path.startsWith('/language-selection');
  }
  
  // NOTE: Check if route is publicly accessible (no auth required)
  static bool _isPublicRoute(String path) {
    const publicRoutes = [
      '/',
      '/onboarding',
      '/language-selection',
      '/welcome',
      '/phone-number',
      '/otp-verification',
      '/profile-setup',
      '/farm-details',
      '/document-upload',
    ];
    
    return publicRoutes.contains(path) || _isOnboardingRoute(path);
  }
  
  // * NAVIGATION HELPERS
  
  // NOTE: Navigate to a route with optional replacement
  static void go(String location, {Object? extra}) {
    router.go(location, extra: extra);
  }
  
  // NOTE: Navigate to a route and add to stack
  static void push(String location, {Object? extra}) {
    router.push(location, extra: extra);
  }
  
  // NOTE: Pop the current route
  static void pop([Object? result]) {
    router.pop(result);
  }
  
  // NOTE: Replace current route
  static void pushReplacement(String location, {Object? extra}) {
    router.pushReplacement(location, extra: extra);
  }
  
  // NOTE: Clear stack and navigate to new route
  static void goAndClearStack(String location, {Object? extra}) {
    router.go(location, extra: extra);
  }
  
  // NOTE: Check if can pop
  static bool canPop() {
    return router.canPop();
  }
  
  // NOTE: Get current location
  static String get currentLocation => router.routeInformationProvider.value.uri.path;
  
  // * TYPED NAVIGATION METHODS
  
  // Onboarding Navigation
  static void goToOnboarding() => go(AppRoutes.onboarding);
  static void goToLanguageSelection() => go(AppRoutes.languageSelection);
  
  // Authentication Navigation
  static void goToPhoneNumber() => go(AppRoutes.phoneNumber);
  static void goToOtpVerification(String phoneNumber) => 
      go('${AppRoutes.otpVerification}?phoneNumber=$phoneNumber');
  static void goToProfileSetup() => go(AppRoutes.profileSetup);
  static void goToFarmDetails() => go(AppRoutes.farmDetails);
  static void goToDocumentUpload() => go(AppRoutes.documentUpload);
  
  // Main App Navigation
  static void goToDashboard() => go(AppRoutes.dashboard);
  static void goToMarketplace() => go(AppRoutes.marketplace);
  static void goToServices() => go(AppRoutes.services);
  static void goToKnowledge() => go(AppRoutes.knowledge);
  static void goToProfile() => go(AppRoutes.profile);
  
  // Marketplace Navigation
  static void goToProductListing() => go(AppRoutes.productListing);
  static void goToCreateProduct() => go(AppRoutes.createProduct);
  static void goToProductDetail(String productId) => go(AppRoutes.productDetailRoute(productId));
  static void goToNegotiation(String negotiationId) => go(AppRoutes.negotiationRoute(negotiationId));
  
  // Services Navigation
  static void goToLogistics() => go(AppRoutes.logistics);
  static void goToInputProcurement() => go(AppRoutes.inputProcurement);
  static void goToSoilTesting() => go(AppRoutes.soilTesting);
  static void goToVetServices() => go(AppRoutes.vetServices);
  static void goToNurseryServices() => go(AppRoutes.nurseryServices);
  
  // Livestock Navigation
  static void goToLivestock() => go(AppRoutes.livestock);
  static void goToAnimalProfile(String animalId) => go(AppRoutes.animalProfileRoute(animalId));
  static void goToHealthTracking(String animalId) => go(AppRoutes.healthTrackingRoute(animalId));
  
  // Knowledge Navigation
  static void goToArticleDetail(String articleId) => go(AppRoutes.articleDetailRoute(articleId));
  static void goToVideoPlayer(String videoId) => go(AppRoutes.videoPlayerRoute(videoId));
  
  // Profile Navigation
  static void goToSettings() => go(AppRoutes.settings);
  static void goToEditProfile() => go(AppRoutes.editProfile);
}

// * ERROR PAGE FOR ROUTE ERRORS
class ErrorPage extends StatelessWidget {
  final Exception? error;
  
  const ErrorPage({super.key, this.error});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Error'),
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 24),
              Text(
                'Navigation Error',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                error?.toString() ?? 'An error occurred while navigating.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () => AppRouter.goToDashboard(),
                child: const Text('Return to Dashboard'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => AppRouter.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// * ROUTER OBSERVER FOR ANALYTICS AND LOGGING
class AppRouterObserver extends NavigatorObserver {
  // NOTE: Track route changes for analytics
  
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logRouteChange('PUSH', route, previousRoute);
  }
  
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _logRouteChange('POP', route, previousRoute);
  }
  
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _logRouteChange('REPLACE', newRoute, oldRoute);
  }
  
  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _logRouteChange('REMOVE', route, previousRoute);
  }
  
  void _logRouteChange(String action, Route<dynamic>? route, Route<dynamic>? previousRoute) {
    final routeName = route?.settings.name ?? 'Unknown';
    final previousRouteName = previousRoute?.settings.name ?? 'None';
    
    // TODO: Send analytics event
    debugPrint('🗺️ Router: $action - $routeName (from: $previousRouteName)');
    
    // OPTIMIZE: Add analytics tracking here
    // AnalyticsService.trackScreenView(routeName);
  }
}
