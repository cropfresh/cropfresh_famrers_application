import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/constants/colors.dart';

/// Splash Screen with brand animation and initialization
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // * Animation controllers for different elements
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _backgroundController;
  
  // * Logo animations
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoRotation;
  
  // * Text animations
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _textScale;
  
  // * Background animations
  late Animation<double> _backgroundOpacity;
  
  // * Loading and error states
  bool _isInitialized = false;
  String? _initializationError;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  // * ANIMATION SETUP - Configure all animation controllers and curves
  void _setupAnimations() {
    // ! PERFORMANCE: Using staggered animations for smooth experience
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _setupLogoAnimations();
    _setupTextAnimations();
    _setupBackgroundAnimations();
    _startAnimationSequence();
  }

  // * LOGO ANIMATION CONFIGURATION
  void _setupLogoAnimations() {
    _logoScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    _logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
    ));

    _logoRotation = Tween<double>(
      begin: -0.1,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));
  }

  // * TEXT ANIMATION CONFIGURATION
  void _setupTextAnimations() {
    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
    ));

    _textScale = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));
  }

  // * BACKGROUND ANIMATION CONFIGURATION
  void _setupBackgroundAnimations() {
    _backgroundOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));
  }

  // * ANIMATION SEQUENCE - Start animations in proper order
  void _startAnimationSequence() {
    _backgroundController.forward();
    
    // Start logo animation immediately
    _logoController.forward();
    
    // Start text animation after logo begins
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _textController.forward();
      }
    });
  }

  // * APP INITIALIZATION - Handle startup tasks and navigation
  Future<void> _initializeApp() async {
    try {
      // ! SECURITY: Ensure minimum splash time for UX while initializing
      await Future.wait([
        Future.delayed(AppConstants.splashDuration),
        _performStartupTasks(),
      ]);

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        
        // Wait a bit more for animations to complete
        await Future.delayed(const Duration(milliseconds: 500));
        
        if (mounted) {
          _navigateToNextScreen();
        }
      }
    } catch (e) {
      // ! ALERT: Handle initialization errors gracefully
      if (mounted) {
        setState(() {
          _initializationError = e.toString();
        });
        _showErrorDialog(e.toString());
      }
    }
  }

  // * STARTUP TASKS - Perform essential app initialization
  Future<void> _performStartupTasks() async {
    try {
      // Initialize storage service
      await StorageService.initialize();
      
      // Perform data migration if needed
      await StorageService.migrateData();
      
      // Pre-load critical resources
      await _preloadAssets();
      
      // Initialize app configuration
      await _initializeAppConfig();
      
    } catch (e) {
      // TODO: Add proper error logging service
      debugPrint('Startup initialization failed: $e');
      rethrow;
    }
  }

  // * ASSET PRELOADING - Load critical images and fonts
  Future<void> _preloadAssets() async {
    try {
      // Preload logo images
      await Future.wait([
        precacheImage(const AssetImage('assets/images/logo.png'), context),
        precacheImage(const AssetImage('assets/images/logo-text.png'), context),
      ]);
    } catch (e) {
      // NOTE: Asset preloading failure is not critical for app startup
      debugPrint('Asset preloading failed: $e');
    }
  }

  // * APP CONFIGURATION - Initialize app-wide settings
  Future<void> _initializeAppConfig() async {
    // Simulate configuration loading
    await Future.delayed(const Duration(milliseconds: 300));
    
    // ? TODO: Load configuration from secure storage
    // ? TODO: Initialize analytics service
    // ? TODO: Setup crash reporting
  }

  // * NAVIGATION LOGIC - Determine next screen based on user state
  void _navigateToNextScreen() {
    try {
      final token = StorageService.getUserToken();
      final isOnboardingComplete = StorageService.isOnboardingComplete();
      final isLanguageSelectionComplete = StorageService.isLanguageSelectionComplete();

      if (token != null && token.isNotEmpty) {
        // * SECURITY: User is authenticated, go to dashboard
        context.go(AppRoutes.dashboard);
      } else if (!isOnboardingComplete) {
        // * First time user, show onboarding
        context.go(AppRoutes.onboarding);
      } else if (!isLanguageSelectionComplete) {
        // * Onboarding complete but language not selected
        context.go(AppRoutes.languageSelection);
      } else {
        // * Both onboarding and language selection complete, go to welcome
        context.go(AppRoutes.welcome);
      }
    } catch (e) {
      // ! ALERT: Navigation failure - fallback to onboarding
      debugPrint('Navigation error: $e');
      context.go(AppRoutes.onboarding);
    }
  }

  // * ERROR HANDLING - Show user-friendly error dialog
  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 8),
            const Text('Initialization Error'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Failed to initialize the app. Please try again.'),
            const SizedBox(height: 16),
            if (error.isNotEmpty)
              Text(
                'Error: $error',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _initializationError = null;
              });
              _initializeApp(); // Retry initialization
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _setSystemUIOverlay();
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _buildSplashContent(),
    );
  }

  // * SYSTEM UI CONFIGURATION
  void _setSystemUIOverlay() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }

  // * MAIN SPLASH CONTENT LAYOUT
  Widget _buildSplashContent() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: _buildBackgroundDecoration(),
      child: SafeArea(
        child: Column(
          children: [
            // Main content area
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLogoSection(),
                    const SizedBox(height: 48),
                    _buildTextSection(),
                    const SizedBox(height: 64),
                    _buildLoadingSection(),
                  ],
                ),
              ),
            ),
            
            // Footer section
            _buildFooterSection(),
          ],
        ),
      ),
    );
  }

  // * BACKGROUND GRADIENT DECORATION
  BoxDecoration _buildBackgroundDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Theme.of(context).colorScheme.surface,
          CropFreshColors.brandGreen.withOpacity(0.05),
          CropFreshColors.brandOrange.withOpacity(0.03),
          Theme.of(context).colorScheme.surface,
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
      ),
    );
  }

  // * ANIMATED LOGO SECTION
  Widget _buildLogoSection() {
    return AnimatedBuilder(
      animation: Listenable.merge([_logoController, _backgroundController]),
      builder: (context, child) {
        return FadeTransition(
          opacity: _backgroundOpacity,
          child: Transform.scale(
            scale: _logoScale.value,
            child: Transform.rotate(
              angle: _logoRotation.value,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: CropFreshColors.brandGreen.withOpacity(0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                      spreadRadius: 5,
                    ),
                    BoxShadow(
                      color: CropFreshColors.brandOrange.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: _buildLogoImage(),
              ),
            ),
          ),
        );
      },
    );
  }

  // * LOGO IMAGE WITH FALLBACK
  Widget _buildLogoImage() {
    return Image.asset(
      'assets/images/logo.png',
      width: 100,
      height: 100,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // ! ALERT: Logo asset not found - using fallback icon
        return Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: CropFreshColors.brandGreen,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.agriculture,
            size: 60,
            color: Colors.white,
          ),
        );
      },
    );
  }

  // * ANIMATED TEXT SECTION
  Widget _buildTextSection() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return SlideTransition(
          position: _textSlide,
          child: FadeTransition(
            opacity: _textOpacity,
            child: Transform.scale(
              scale: _textScale.value,
              child: Column(
                children: [
                  _buildLogoText(),
                  const SizedBox(height: 16),
                  _buildTagline(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // * LOGO TEXT IMAGE WITH FALLBACK
  Widget _buildLogoText() {
    return Image.asset(
      'assets/images/logo-text.png',
      height: 60,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // NOTE: Logo text asset not found - using text fallback
        return Text(
          AppConstants.appName,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: CropFreshColors.brandGreen,
            letterSpacing: 1.2,
          ),
        );
      },
    );
  }

  // * APP TAGLINE
  Widget _buildTagline() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        AppConstants.appTagline,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // * LOADING INDICATOR SECTION
  Widget _buildLoadingSection() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _textOpacity,
          child: Column(
            children: [
              if (!_isInitialized && _initializationError == null)
                _buildLoadingIndicator(),
              if (_isInitialized)
                _buildSuccessIndicator(),
            ],
          ),
        );
      },
    );
  }

  // * LOADING SPINNER
  Widget _buildLoadingIndicator() {
    return Container(
      width: 50,
      height: 50,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(25),
      ),
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(
          CropFreshColors.brandGreen,
        ),
      ),
    );
  }

  // * SUCCESS INDICATOR
  Widget _buildSuccessIndicator() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: CropFreshColors.brandGreen,
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Icon(
        Icons.check,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  // * FOOTER SECTION
  Widget _buildFooterSection() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _textOpacity,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  'Empowering farmers with digital agriculture',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Version ${AppConstants.appVersion}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


