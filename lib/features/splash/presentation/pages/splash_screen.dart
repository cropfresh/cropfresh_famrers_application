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
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoScale;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Logo scale animation
    _logoScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    // Text opacity animation
    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ));

    // Text slide animation
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    ));

    // Start animations
    _logoController.forward();
    
    // Start text animation after logo animation begins
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _textController.forward();
      }
    });
  }

  Future<void> _initializeApp() async {
    try {
      // Minimum splash duration for branding
      await Future.wait([
        Future.delayed(AppConstants.splashDuration),
        _performInitialization(),
      ]);

      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      // Handle initialization errors
      if (mounted) {
        _showErrorDialog(e.toString());
      }
    }
  }

  Future<void> _performInitialization() async {
    // Simulate app initialization tasks
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Initialize storage if not already done
    // Additional initialization can be added here
    
    // Check for data migration
    await StorageService.migrateData();
  }

  void _navigateToNextScreen() {
    // Check authentication status
    final token = StorageService.getUserToken();
    final isOnboardingComplete = StorageService.isOnboardingComplete();

    if (token != null && token.isNotEmpty) {
      // User is authenticated, go to dashboard
      context.go(AppRoutes.dashboard);
    } else if (isOnboardingComplete) {
      // Onboarding completed, go to auth
      context.go(AppRoutes.phoneNumber);
    } else {
      // First time user, show onboarding
      context.go(AppRoutes.onboarding);
    }
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Initialization Error'),
        content: Text('Failed to initialize app: $error'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Main content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo section
                    AnimatedBuilder(
                      animation: _logoScale,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _logoScale.value,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.agriculture,
                              size: 60,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // App name and tagline
                    AnimatedBuilder(
                      animation: _textController,
                      builder: (context, child) {
                        return SlideTransition(
                          position: _textSlide,
                          child: FadeTransition(
                            opacity: _textOpacity,
                            child: Column(
                              children: [
                                Text(
                                  AppConstants.appName,
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  AppConstants.appTagline,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 48),
                    
                    // Loading indicator
                    AnimatedBuilder(
                      animation: _textController,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _textOpacity,
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              // Footer
              AnimatedBuilder(
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
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Version ${AppConstants.appVersion}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Alternative Splash Screen with Lottie Animation
class LottieSplashScreen extends StatefulWidget {
  const LottieSplashScreen({super.key});

  @override
  State<LottieSplashScreen> createState() => _LottieSplashScreenState();
}

class _LottieSplashScreenState extends State<LottieSplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeAndNavigate();
  }

  Future<void> _initializeAndNavigate() async {
    // Wait for minimum splash duration
    await Future.delayed(AppConstants.splashDuration);
    
    if (mounted) {
      // Check authentication and navigate
      final token = StorageService.getUserToken();
      final isOnboardingComplete = StorageService.isOnboardingComplete();

      if (token != null && token.isNotEmpty) {
        context.go(AppRoutes.dashboard);
      } else if (isOnboardingComplete) {
        context.go(AppRoutes.phoneNumber);
      } else {
        context.go(AppRoutes.onboarding);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
        decoration: BoxDecoration(
          gradient: CropFreshColors.agriculturalGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lottie animation (if available)
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Icon(
                  Icons.agriculture,
                  size: 100,
                  color: CropFreshColors.brandGreen,
                ),
              ),
              
              const SizedBox(height: 32),
              
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: CropFreshColors.brandGreen,
                ),
              ),
              
              const SizedBox(height: 16),
              
              Text(
                AppConstants.appTagline,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 48),
              
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  CropFreshColors.brandGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
