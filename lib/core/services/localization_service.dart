import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';

/// Localization Service for Multi-language Support
class LocalizationService {
  LocalizationService._();

  static const LocalizationsDelegate<LocalizationService> delegate = 
      _LocalizationServiceDelegate();

  static const List<Locale> supportedLocales = [
    Locale(AppConstants.kannadaCode, 'IN'), // Kannada (India)
    Locale(AppConstants.teluguCode, 'IN'),  // Telugu (India)
    Locale(AppConstants.hindiCode, 'IN'),   // Hindi (India)
    Locale(AppConstants.englishCode, 'IN'), // English (India)
  ];

  static LocalizationService? of(BuildContext context) {
    return Localizations.of<LocalizationService>(context, LocalizationService);
  }

  static late LocalizationService _current;
  static LocalizationService get current => _current;

  late Locale _locale;
  Locale get locale => _locale;

  late Map<String, String> _localizedStrings;

  Future<bool> load(Locale locale) async {
    _locale = locale;
    _current = this;

    // Load localization strings based on locale
    String languageCode = locale.languageCode;
    
    // For demo purposes, we'll use English strings for all languages
    // In production, you would load language-specific JSON files
    _localizedStrings = await _loadLanguageStrings(languageCode);
    
    return true;
  }

  Future<Map<String, String>> _loadLanguageStrings(String languageCode) async {
    // In production, load from assets/l10n/{languageCode}.json
    // For now, returning English strings with translation placeholders
    
    return {
      // App General
      'app_name': 'CropFresh Farmers',
      'app_tagline': 'Empowering Farmers with Digital Agriculture',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'cancel': 'Cancel',
      'ok': 'OK',
      'yes': 'Yes',
      'no': 'No',
      'save': 'Save',
      'continue': 'Continue',
      'back': 'Back',
      'next': 'Next',
      'skip': 'Skip',
      'done': 'Done',
      'submit': 'Submit',
      'update': 'Update',
      'delete': 'Delete',
      'edit': 'Edit',
      'view': 'View',
      'search': 'Search',
      'filter': 'Filter',
      'sort': 'Sort',
      'refresh': 'Refresh',
      'retry': 'Retry',
      'share': 'Share',
      'download': 'Download',
      'upload': 'Upload',
      'select': 'Select',
      'choose': 'Choose',
      
      // Onboarding
      'welcome_title': 'Welcome to CropFresh',
      'welcome_subtitle': 'Transform Your Farming with Digital Tools',
      'welcome_description': 'Get better prices, easy logistics, and expert support all in one app',
      'marketplace_title': 'Direct Marketplace',
      'marketplace_subtitle': 'Sell Direct to Buyers - No Middlemen',
      'marketplace_description': 'List your products, negotiate prices, and connect directly with buyers',
      'farm_solution_title': 'Complete Farm Solution',
      'farm_solution_subtitle': 'Everything You Need in One App',
      'farm_solution_description': 'Input ordering, logistics booking, vet services, and offline capability',
      'language_title': 'Choose Your Language',
      'language_subtitle': 'Select your preferred language',
      'language_kannada': 'ಕನ್ನಡ',
      'language_telugu': 'తెలుగు',
      'language_hindi': 'हिंदी',
      'language_english': 'English',
      
      // Authentication
      'phone_number_title': 'Enter Your Phone Number',
      'phone_number_subtitle': 'We\'ll send you a verification code',
      'phone_number_hint': 'Enter phone number',
      'phone_number_error': 'Please enter a valid phone number',
      'send_otp': 'Send OTP',
      'otp_title': 'Verify Phone Number',
      'otp_subtitle': 'Enter the 6-digit code sent to',
      'otp_hint': 'Enter OTP',
      'otp_error': 'Please enter a valid OTP',
      'resend_otp': 'Resend OTP',
      'resend_otp_timer': 'Resend OTP in {seconds}s',
      'verify_otp': 'Verify OTP',
      
      // Profile Setup
      'profile_setup_title': 'Set Up Your Profile',
      'profile_setup_subtitle': 'Tell us about yourself',
      'full_name': 'Full Name',
      'full_name_hint': 'Enter your full name',
      'age': 'Age',
      'age_hint': 'Enter your age',
      'gender': 'Gender',
      'male': 'Male',
      'female': 'Female',
      'other': 'Other',
      'experience_level': 'Farming Experience',
      'new_farmer': 'New Farmer',
      'experienced_farmer': 'Experienced',
      'expert_farmer': 'Expert',
      'upload_photo': 'Upload Photo',
      'take_photo': 'Take Photo',
      'choose_from_gallery': 'Choose from Gallery',
      
      // Farm Details
      'farm_details_title': 'Farm Details',
      'farm_details_subtitle': 'Tell us about your farm',
      'farm_location': 'Farm Location',
      'use_current_location': 'Use Current Location',
      'farm_address': 'Farm Address',
      'farm_address_hint': 'Enter your farm address',
      'land_area': 'Land Area',
      'land_area_hint': 'Enter area in hectares',
      'land_ownership': 'Land Ownership',
      'owner': 'Owner',
      'tenant': 'Tenant',
      'sharecropper': 'Sharecropper',
      'cooperative_member': 'Cooperative Member',
      'primary_crops': 'Primary Crops',
      'select_crops': 'Select crops you grow',
      'irrigation_type': 'Irrigation Type',
      'irrigation_source': 'Irrigation Source',
      
      // Dashboard
      'dashboard': 'Dashboard',
      'good_morning': 'Good Morning',
      'good_afternoon': 'Good Afternoon',
      'good_evening': 'Good Evening',
      'weather_today': 'Weather Today',
      'market_prices': 'Market Prices',
      'quick_actions': 'Quick Actions',
      'recent_activity': 'Recent Activity',
      'notifications': 'Notifications',
      'sell_produce': 'Sell Produce',
      'buy_inputs': 'Buy Inputs',
      'book_logistics': 'Book Logistics',
      'soil_test': 'Get Soil Tested',
      'call_vet': 'Call Veterinarian',
      'knowledge_hub': 'Knowledge Hub',
      
      // Marketplace
      'marketplace': 'Marketplace',
      'my_products': 'My Products',
      'create_listing': 'Create Listing',
      'product_name': 'Product Name',
      'product_category': 'Category',
      'quantity': 'Quantity',
      'quality_grade': 'Quality Grade',
      'price': 'Price',
      'price_per_kg': 'Price per kg',
      'negotiable': 'Negotiable',
      'fixed_price': 'Fixed Price',
      'auction': 'Auction',
      'harvest_date': 'Harvest Date',
      'available_from': 'Available From',
      'product_description': 'Description',
      'upload_photos': 'Upload Photos',
      'minimum_photos': 'Upload at least 3 photos',
      'list_product': 'List Product',
      
      // Settings
      'settings': 'Settings',
      'profile': 'Profile',
      'account_settings': 'Account Settings',
      'notification_settings': 'Notification Settings',
      'language_settings': 'Language',
      'privacy_settings': 'Privacy',
      'help_support': 'Help & Support',
      'about_app': 'About App',
      'logout': 'Logout',
      'version': 'Version',
      
      // Error Messages
      'network_error': 'Please check your internet connection and try again',
      'server_error': 'Something went wrong. Please try again later',
      'session_expired': 'Your session has expired. Please login again',
      'location_permission': 'Location permission is required for this feature',
      'camera_permission': 'Camera permission is required to take photos',
      'storage_permission': 'Storage permission is required to save files',
      
      // Success Messages
      'login_success': 'Welcome back to CropFresh!',
      'registration_success': 'Account created successfully!',
      'profile_update_success': 'Profile updated successfully!',
      'product_listed_success': 'Product listed successfully!',
      'order_placed_success': 'Order placed successfully!',
    };
  }

  String getString(String key, {Map<String, String>? params}) {
    String value = _localizedStrings[key] ?? key;
    
    if (params != null) {
      params.forEach((paramKey, paramValue) {
        value = value.replaceAll('{$paramKey}', paramValue);
      });
    }
    
    return value;
  }

  // Convenience getters for common strings
  String get appName => getString('app_name');
  String get loading => getString('loading');
  String get error => getString('error');
  String get success => getString('success');
  String get cancel => getString('cancel');
  String get ok => getString('ok');
  String get save => getString('save');
  String get continueText => getString('continue');
  String get back => getString('back');
  String get next => getString('next');
  String get done => getString('done');
  String get submit => getString('submit');
}

/// Localization Delegate
class _LocalizationServiceDelegate extends LocalizationsDelegate<LocalizationService> {
  const _LocalizationServiceDelegate();

  @override
  bool isSupported(Locale locale) {
    return LocalizationService.supportedLocales
        .any((supportedLocale) => supportedLocale.languageCode == locale.languageCode);
  }

  @override
  Future<LocalizationService> load(Locale locale) async {
    final localizationService = LocalizationService._();
    await localizationService.load(locale);
    return localizationService;
  }

  @override
  bool shouldReload(LocalizationsDelegate<LocalizationService> old) => false;
}

/// Extension for easy access to localization
extension LocalizationContext on BuildContext {
  LocalizationService get l10n {
    final localization = LocalizationService.of(this);
    if (localization == null) {
      throw Exception('LocalizationService not found in context');
    }
    return localization;
  }
  
  String tr(String key, {Map<String, String>? params}) {
    return l10n.getString(key, params: params);
  }
}
