/// Application Constants for CropFresh Farmers App
class AppConstants {
  AppConstants._();

  // App Information
  static const String appName = 'CropFresh Farmers';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  static const String appTagline = 'Empowering Farmers with Digital Agriculture';
  
  // API Configuration
  static const String baseUrl = 'https://api.cropfresh.com/v1';
  static const String devBaseUrl = 'https://api-dev.cropfresh.com/v1';
  static const String stagingBaseUrl = 'https://api-staging.cropfresh.com/v1';
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String onboardingCompleteKey = 'onboarding_complete';
  static const String languageSelectionCompleteKey = 'language_selection_complete';
  static const String selectedLanguageKey = 'selected_language';
  static const String biometricEnabledKey = 'biometric_enabled';
  static const String notificationEnabledKey = 'notification_enabled';
  static const String offlineDataKey = 'offline_data';
  static const String lastSyncTimeKey = 'last_sync_time';
  
  // Default Values
  static const String defaultLanguage = 'en';
  
  // Route Names
  static const String splashRoute = '/';
  static const String onboardingRoute = '/onboarding';
  static const String languageSelectionRoute = '/language-selection';
  static const String authRoute = '/auth';
  static const String phoneNumberRoute = '/phone-number';
  static const String otpVerificationRoute = '/otp-verification';
  static const String profileSetupRoute = '/profile-setup';
  static const String farmDetailsRoute = '/farm-details';
  static const String documentUploadRoute = '/document-upload';
  static const String dashboardRoute = '/dashboard';
  static const String marketplaceRoute = '/marketplace';
  static const String productListingRoute = '/product-listing';
  static const String createProductRoute = '/create-product';
  static const String negotiationRoute = '/negotiation';
  static const String logisticsRoute = '/logistics';
  static const String logisticsBookingRoute = '/logistics-booking';
  static const String trackingRoute = '/tracking';
  static const String inputProcurementRoute = '/input-procurement';
  static const String inputCatalogRoute = '/input-catalog';
  static const String orderTrackingRoute = '/order-tracking';
  static const String soilTestingRoute = '/soil-testing';
  static const String labDiscoveryRoute = '/lab-discovery';
  static const String testResultsRoute = '/test-results';
  static const String vetServicesRoute = '/vet-services';
  static const String vetDiscoveryRoute = '/vet-discovery';
  static const String appointmentBookingRoute = '/appointment-booking';
  static const String livestockRoute = '/livestock';
  static const String animalProfileRoute = '/animal-profile';
  static const String healthTrackingRoute = '/health-tracking';
  static const String knowledgeHubRoute = '/knowledge-hub';
  static const String nurseryServicesRoute = '/nursery-services';
  static const String settingsRoute = '/settings';
  static const String profileRoute = '/profile';
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  static const Duration splashDuration = Duration(seconds: 3);
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Image Configuration
  static const int maxImageSizeKB = 2048; // 2MB
  static const int imageQuality = 85;
  static const double imageCompressionRatio = 0.8;
  
  // Location Configuration
  static const double defaultLocationAccuracy = 100.0; // meters
  static const Duration locationTimeout = Duration(seconds: 10);
  
  // Notification Configuration
  static const String notificationChannelId = 'cropfresh_farmers';
  static const String notificationChannelName = 'CropFresh Farmers';
  static const String notificationChannelDescription = 'CropFresh Farmers App Notifications';
  
  // File Upload Configuration
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png', 'webp'];
  static const List<String> allowedDocumentExtensions = ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'];
  static const int maxFileUploadSizeMB = 10;
  
  // Validation Rules
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int phoneNumberLength = 10;
  static const int otpLength = 6;
  static const int otpValidityMinutes = 5;
  static const int maxRetryAttempts = 3;
  
  // Offline Configuration
  static const Duration offlineDataRetention = Duration(days: 7);
  static const int maxOfflineRecords = 1000;
  
  // Language Codes
  static const String kannadaCode = 'kn';
  static const String teluguCode = 'te';
  static const String hindiCode = 'hi';
  static const String englishCode = 'en';
  
  // Default Values
  static const String defaultCountryCode = '+91';
  static const String defaultCurrency = 'INR';
  static const String defaultCurrencySymbol = '₹';
  
  // URL Patterns
  static const String phonePattern = r'^[6-9]\d{9}$';
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String passwordPattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{6,}$';
  
  // Error Messages
  static const String networkErrorMessage = 'Please check your internet connection and try again.';
  static const String serverErrorMessage = 'Something went wrong. Please try again later.';
  static const String sessionExpiredMessage = 'Your session has expired. Please login again.';
  static const String locationPermissionMessage = 'Location permission is required for this feature.';
  static const String cameraPermissionMessage = 'Camera permission is required to take photos.';
  static const String storagePermissionMessage = 'Storage permission is required to save files.';
  
  // Success Messages
  static const String loginSuccessMessage = 'Welcome back to CropFresh!';
  static const String registrationSuccessMessage = 'Account created successfully!';
  static const String profileUpdateSuccessMessage = 'Profile updated successfully!';
  static const String productListedSuccessMessage = 'Product listed successfully!';
  static const String orderPlacedSuccessMessage = 'Order placed successfully!';
  
  // Feature Flags
  static const bool enableBiometricAuth = true;
  static const bool enablePushNotifications = true;
  static const bool enableOfflineMode = true;
  static const bool enableDarkMode = true;
  static const bool enableVoiceCommands = true;
  static const bool enableAIFeatures = false; // Phase 2
  static const bool enableFinancialServices = false; // Phase 3
  
  // Marketplace Configuration
  static const int maxProductImages = 5;
  static const int minProductImages = 3;
  static const double minProductPrice = 1.0;
  static const double maxProductPrice = 999999.0;
  static const int maxProductDescriptionLength = 500;
  static const int maxProductTitleLength = 100;
  
  // Logistics Configuration
  static const double maxDeliveryDistanceKM = 500.0;
  static const int maxBookingDaysInAdvance = 30;
  static const double minVehicleCapacity = 50.0; // kg
  static const double maxVehicleCapacity = 10000.0; // kg
  
  // Livestock Configuration
  static const int maxAnimalsPerFarm = 1000;
  static const int maxVaccinationReminders = 50;
  static const int maxHealthRecordsPerAnimal = 500;
  
  // Knowledge Hub Configuration
  static const int maxBookmarkedArticles = 100;
  static const int maxDownloadedContent = 50;
  static const Duration contentCacheExpiry = Duration(days: 3);
  
  // Support Information
  static const String supportEmail = 'support@cropfresh.com';
  static const String supportPhone = '+91-80-1234-5678';
  static const String websiteUrl = 'https://cropfresh.com';
  static const String privacyPolicyUrl = 'https://cropfresh.com/privacy';
  static const String termsOfServiceUrl = 'https://cropfresh.com/terms';
  
  // Social Media
  static const String facebookUrl = 'https://facebook.com/cropfresh';
  static const String twitterUrl = 'https://twitter.com/cropfresh';
  static const String linkedinUrl = 'https://linkedin.com/company/cropfresh';
  static const String youtubeUrl = 'https://youtube.com/cropfresh';
  
  // Environment Configuration
  static bool get isProduction => const String.fromEnvironment('ENV') == 'production';
  static bool get isDevelopment => const String.fromEnvironment('ENV') == 'development';
  static bool get isStaging => const String.fromEnvironment('ENV') == 'staging';
  
  static String get currentBaseUrl {
    if (isProduction) return baseUrl;
    if (isStaging) return stagingBaseUrl;
    return devBaseUrl;
  }
}

/// API Endpoints
class ApiEndpoints {
  ApiEndpoints._();
  
  // Authentication
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String refreshToken = '/auth/refresh-token';
  static const String logout = '/auth/logout';
  
  // User Profile
  static const String profile = '/farmer/profile';
  static const String updateProfile = '/farmer/profile';
  static const String farmDetails = '/farmer/farm-details';
  static const String uploadDocument = '/farmer/documents';
  
  // Dashboard
  static const String dashboard = '/farmer/dashboard';
  static const String weather = '/weather/current';
  static const String marketPrices = '/market/prices';
  static const String notifications = '/notifications';
  
  // Marketplace
  static const String products = '/marketplace/products';
  static const String createProduct = '/products';
  static const String updateProduct = '/products';
  static const String deleteProduct = '/products';
  static const String productInquiries = '/products/{id}/inquiries';
  static const String negotiations = '/negotiations';
  
  // Logistics
  static const String logisticsProviders = '/logistics/providers';
  static const String vehicles = '/logistics/vehicles';
  static const String bookings = '/logistics/bookings';
  static const String tracking = '/logistics/tracking';
  
  // Input Procurement
  static const String inputCategories = '/inputs/categories';
  static const String inputProducts = '/inputs/products';
  static const String inputOrders = '/inputs/orders';
  static const String dealers = '/dealers/nearby';
  
  // Soil Testing
  static const String soilLabs = '/soil-labs/search';
  static const String testPackages = '/soil-tests/packages';
  static const String testBookings = '/soil-tests/bookings';
  static const String testResults = '/soil-tests/results';
  
  // Veterinary Services
  static const String veterinarians = '/veterinarians/search';
  static const String vetServices = '/vet-services';
  static const String appointments = '/vet-appointments';
  static const String prescriptions = '/prescriptions';
  
  // Livestock Management
  static const String livestock = '/farmer/livestock';
  static const String animalProfile = '/livestock/{id}/profile';
  static const String healthRecords = '/livestock/{id}/health-records';
  static const String vaccinations = '/livestock/{id}/vaccinations';
  
  // Knowledge Hub
  static const String knowledgeCategories = '/knowledge/categories';
  static const String knowledgeContent = '/knowledge/content';
  static const String downloadContent = '/knowledge/download';
  
  // Nursery Services
  static const String nurseries = '/nurseries/search';
  static const String plantCatalog = '/plants/catalog';
  static const String nurseryOrders = '/nursery/orders';
  
  // File Upload
  static const String uploadMedia = '/media/upload';
}

/// Asset Paths
class AssetPaths {
  AssetPaths._();
  
  // Images
  static const String imagesPath = 'assets/images/';
  static const String appLogo = '${imagesPath}app_logo.png';
  static const String splashLogo = '${imagesPath}splash_logo.png';
  static const String onboardingWelcome = '${imagesPath}onboarding_welcome.png';
  static const String onboardingMarketplace = '${imagesPath}onboarding_marketplace.png';
  static const String onboardingFarmSolution = '${imagesPath}onboarding_farm_solution.png';
  static const String onboardingLanguage = '${imagesPath}onboarding_language.png';
  static const String farmerAvatar = '${imagesPath}farmer_avatar.png';
  static const String cropPlaceholder = '${imagesPath}crop_placeholder.png';
  static const String livestockPlaceholder = '${imagesPath}livestock_placeholder.png';
  
  // Icons
  static const String iconsPath = 'assets/icons/';
  static const String dashboardIcon = '${iconsPath}dashboard.svg';
  static const String marketplaceIcon = '${iconsPath}marketplace.svg';
  static const String logisticsIcon = '${iconsPath}logistics.svg';
  static const String inputsIcon = '${iconsPath}inputs.svg';
  static const String soilTestIcon = '${iconsPath}soil_test.svg';
  static const String vetIcon = '${iconsPath}veterinary.svg';
  static const String livestockIcon = '${iconsPath}livestock.svg';
  static const String knowledgeIcon = '${iconsPath}knowledge.svg';
  static const String nurseryIcon = '${iconsPath}nursery.svg';
  static const String settingsIcon = '${iconsPath}settings.svg';
  
  // Lottie Animations
  static const String lottiePath = 'assets/lottie/';
  static const String loadingAnimation = '${lottiePath}loading.json';
  static const String successAnimation = '${lottiePath}success.json';
  static const String errorAnimation = '${lottiePath}error.json';
  static const String farmingAnimation = '${lottiePath}farming.json';
  static const String weatherAnimation = '${lottiePath}weather.json';
  static const String deliveryAnimation = '${lottiePath}delivery.json';
  
  // Fonts
  static const String fontsPath = 'assets/fonts/';
}

/// Device Types for Responsive Design
enum DeviceType {
  mobile,
  tablet,
  desktop,
}

/// Screen Breakpoints
class ScreenBreakpoints {
  ScreenBreakpoints._();
  
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1440;
  
  static DeviceType getDeviceType(double width) {
    if (width < mobile) return DeviceType.mobile;
    if (width < tablet) return DeviceType.tablet;
    return DeviceType.desktop;
  }
}

/// App-wide Dimensions
class AppDimensions {
  AppDimensions._();
  
  // Padding & Margins
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;
  
  // Border Radius
  static const double radiusXS = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusXXL = 32.0;
  
  // Icon Sizes
  static const double iconXS = 16.0;
  static const double iconS = 20.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;
  static const double iconXXL = 64.0;
  
  // Button Heights
  static const double buttonHeightS = 40.0;
  static const double buttonHeightM = 48.0;
  static const double buttonHeightL = 56.0;
  
  // Card Elevations
  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;
  static const double elevationXL = 16.0;
}
