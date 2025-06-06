import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/storage_service.dart';

/// * MATERIAL DESIGN 3 CROPFRESH ONBOARDING EXPERIENCE
/// * Purpose: Guide farmers through app features with modern Material You design
/// * Features: Adaptive colors, enhanced accessibility, smooth animations
/// * Design: Follows Material Design 3 principles and CropFresh brand identity
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  
  // * CONTROLLERS AND STATE
  late PageController _pageController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  
  int _currentPage = 0;
  bool _isAnimating = false;
  
  // * MATERIAL 3 ONBOARDING PAGES
  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      id: 'welcome',
      title: 'Welcome to CropFresh',
      subtitle: 'Farm Smarter, Sell Better',
      description: 'Join thousands of farmers transforming their agriculture with digital innovation. Better prices, easier logistics, expert guidance.',
      features: [
        OnboardingFeature(
          icon: Icons.trending_up_rounded,
          title: 'Better Prices',
          description: 'Direct buyer connections eliminate middlemen',
        ),
        OnboardingFeature(
          icon: Icons.local_shipping_rounded,
          title: 'Easy Logistics',
          description: 'Seamless transportation and delivery',
        ),
        OnboardingFeature(
          icon: Icons.support_agent_rounded,
          title: 'Expert Support',
          description: '24/7 agricultural guidance and assistance',
        ),
      ],
      primaryColor: CropFreshColors.green30Primary,
      surfaceColor: const Color(0xFFF6FDFA),
      iconData: Icons.agriculture_rounded,
    ),
    OnboardingPageData(
      id: 'marketplace',
      title: 'Direct Marketplace',
      subtitle: 'No Middlemen, Maximum Profit',
      description: 'Upload high-quality photos of your produce, set competitive prices, and connect directly with verified buyers across the region.',
      features: [
        OnboardingFeature(
          icon: Icons.photo_camera_rounded,
          title: 'Photo Upload',
          description: 'Showcase your produce with quality images',
        ),
        OnboardingFeature(
          icon: Icons.handshake_rounded,
          title: 'Price Negotiation',
          description: 'Real-time negotiation with multiple buyers',
        ),
        OnboardingFeature(
          icon: Icons.verified_rounded,
          title: 'Verified Buyers',
          description: 'Connect with trusted business partners',
        ),
      ],
      primaryColor: CropFreshColors.green30Fresh,
      surfaceColor: const Color(0xFFF8FDFB),
      iconData: Icons.storefront_rounded,
    ),
    OnboardingPageData(
      id: 'farm_solution',
      title: 'Complete Farm Solution',
      subtitle: 'Everything in One App',
      description: 'Manage your entire farming operation from seed to sale. Order inputs, book logistics, access veterinary services, and get expert advice.',
      features: [
        OnboardingFeature(
          icon: Icons.shopping_cart_rounded,
          title: 'Input Ordering',
          description: 'Seeds, fertilizers, and tools delivered',
        ),
        OnboardingFeature(
          icon: Icons.medical_services_rounded,
          title: 'Vet Services',
          description: 'Professional livestock care on-demand',
        ),
        OnboardingFeature(
          icon: Icons.offline_bolt_rounded,
          title: 'Works Offline',
          description: 'Core features available without internet',
        ),
      ],
      primaryColor: CropFreshColors.green30Forest,
      surfaceColor: const Color(0xFFF5FCF7),
      iconData: Icons.dashboard_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeFirstPageAnimation();
  }

  void _initializeAnimations() {
    _pageController = PageController();
    
    // * FADE ANIMATION for content transitions
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    // * SLIDE ANIMATION for page transitions
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // * SCALE ANIMATION for interactive elements
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
  }

  void _initializeFirstPageAnimation() {
    // * Start entrance animation for first page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeController.forward();
      _slideController.forward();
      _scaleController.forward();
    });
  }

  Future<void> _nextPage() async {
    if (_isAnimating) return;
    
    setState(() => _isAnimating = true);
    
    // * HAPTIC FEEDBACK for better user experience
    await HapticFeedback.mediumImpact();
    
    if (_currentPage < _pages.length - 1) {
      // * ANIMATE OUT current page
      await Future.wait([
        _fadeController.reverse(),
        _slideController.reverse(),
      ]);
      
      // * NAVIGATE to next page
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
      
      // * ANIMATE IN new page
      await Future.wait([
        _fadeController.forward(),
        _slideController.forward(),
      ]);
    } else {
      await _completeOnboarding();
    }
    
    setState(() => _isAnimating = false);
  }

  Future<void> _previousPage() async {
    if (_isAnimating || _currentPage == 0) return;
    
    setState(() => _isAnimating = true);
    
    await HapticFeedback.lightImpact();
    
    // * ANIMATE OUT current page
    await Future.wait([
      _fadeController.reverse(),
      _slideController.reverse(),
    ]);
    
    // * NAVIGATE to previous page
    await _pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
    
    // * ANIMATE IN new page
    await Future.wait([
      _fadeController.forward(),
      _slideController.forward(),
    ]);
    
    setState(() => _isAnimating = false);
  }

  Future<void> _completeOnboarding() async {
    // ! IMPORTANT: Save onboarding completion state
    await StorageService.setOnboardingComplete(true);
    
    await HapticFeedback.heavyImpact();
    
    if (mounted) {
      // * Navigate to language selection after onboarding completion
      context.go(AppRoutes.languageSelection);
    }
  }

  Future<void> _skipOnboarding() async {
    await HapticFeedback.lightImpact();
    await _completeOnboarding();
  }

  void _onPageChanged(int page) {
    if (_currentPage != page) {
      setState(() => _currentPage = page);
      
      // * Restart animations for new page
      _fadeController.reset();
      _slideController.reset();
      _scaleController.reset();
      
      _fadeController.forward();
      _slideController.forward();
      _scaleController.forward();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentPageData = _pages[_currentPage];
    
    return Scaffold(
      backgroundColor: currentPageData.surfaceColor,
      extendBodyBehindAppBar: true,
      appBar: _buildMaterialAppBar(theme, currentPageData),
      body: SafeArea(
        child: Column(
          children: [
            // * PROGRESS INDICATOR following Material 3 guidelines
            _buildMaterial3ProgressIndicator(theme, currentPageData),
            
            // * ONBOARDING PAGES with smooth transitions
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) => _buildOnboardingPage(
                  context,
                  _pages[index],
                  theme,
                ),
              ),
            ),
            
            // * BOTTOM NAVIGATION following Material 3 patterns
            _buildMaterial3BottomNavigation(theme, currentPageData),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildMaterialAppBar(
    ThemeData theme,
    OnboardingPageData pageData,
  ) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: _currentPage > 0
          ? IconButton(
              onPressed: _previousPage,
              icon: const Icon(Icons.arrow_back_rounded),
              style: IconButton.styleFrom(
                foregroundColor: pageData.primaryColor,
                backgroundColor: pageData.primaryColor.withOpacity(0.1),
              ),
            )
          : null,
      title: _buildLogoSection(theme, pageData),
      centerTitle: true,
      actions: [
        if (_currentPage < _pages.length - 1)
          TextButton(
            onPressed: _skipOnboarding,
            style: TextButton.styleFrom(
              foregroundColor: pageData.primaryColor,
            ),
            child: const Text(
              'Skip',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildLogoSection(ThemeData theme, OnboardingPageData pageData) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // * CROPFRESH LOGO with Material 3 styling
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: pageData.primaryColor.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      CropFreshColors.green30Primary,
                      CropFreshColors.orange10Primary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.agriculture_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // * CROPFRESH TEXT LOGO
        SizedBox(
          height: 20,
          child: Image.asset(
            'assets/images/logo-text.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Text(
              'CropFresh',
              style: theme.textTheme.titleLarge?.copyWith(
                color: pageData.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMaterial3ProgressIndicator(
    ThemeData theme,
    OnboardingPageData pageData,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Column(
        children: [
          // * LINEAR PROGRESS INDICATOR (Material 3 style)
          LinearProgressIndicator(
            value: (_currentPage + 1) / _pages.length,
            backgroundColor: pageData.primaryColor.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(pageData.primaryColor),
            borderRadius: BorderRadius.circular(4),
            minHeight: 6,
          ),
          const SizedBox(height: 8),
          // * PAGE COUNTER with Material 3 typography
          Text(
            '${_currentPage + 1} of ${_pages.length}',
            style: theme.textTheme.labelMedium?.copyWith(
              color: pageData.primaryColor.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(
    BuildContext context,
    OnboardingPageData pageData,
    ThemeData theme,
  ) {
    return AnimatedBuilder(
      animation: Listenable.merge([_fadeController, _slideController, _scaleController]),
      builder: (context, child) {
        final fadeValue = _fadeController.value;
        final slideValue = _slideController.value;
        final scaleValue = _scaleController.value;
        
        return Opacity(
          opacity: fadeValue,
          child: Transform.translate(
            offset: Offset(0, 50 * (1 - slideValue)),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // * HERO ICON with Material 3 styling
                  Transform.scale(
                    scale: 0.8 + (0.2 * scaleValue),
                    child: _buildHeroIcon(pageData, theme),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // * TITLE SECTION with Material 3 typography
                  _buildTitleSection(pageData, theme, fadeValue),
                  
                  const SizedBox(height: 32),
                  
                  // * FEATURES LIST with Material 3 cards
                  _buildFeaturesList(pageData, theme, slideValue),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroIcon(OnboardingPageData pageData, ThemeData theme) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            pageData.primaryColor,
            pageData.primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: pageData.primaryColor.withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        pageData.iconData,
        size: 64,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTitleSection(
    OnboardingPageData pageData,
    ThemeData theme,
    double fadeValue,
  ) {
    return Column(
      children: [
        // * MAIN TITLE
        Text(
          pageData.title,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: pageData.primaryColor,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 12),
        
        // * SUBTITLE with Material 3 chip styling
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: pageData.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: pageData.primaryColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Text(
            pageData.subtitle,
            style: theme.textTheme.titleMedium?.copyWith(
              color: pageData.primaryColor,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        
        const SizedBox(height: 20),
        
        // * DESCRIPTION
        Opacity(
          opacity: fadeValue,
          child: Text(
            pageData.description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesList(
    OnboardingPageData pageData,
    ThemeData theme,
    double slideValue,
  ) {
    return Column(
      children: pageData.features.asMap().entries.map((entry) {
        final index = entry.key;
        final feature = entry.value;
        final delay = index * 0.1;
        final animationValue = ((slideValue - delay) / (1 - delay)).clamp(0.0, 1.0);
        
        return Transform.translate(
          offset: Offset(0, 30 * (1 - animationValue)),
          child: Opacity(
            opacity: animationValue,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildFeatureCard(feature, pageData, theme),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFeatureCard(
    OnboardingFeature feature,
    OnboardingPageData pageData,
    ThemeData theme,
  ) {
    return Card(
      elevation: 0,
      color: Colors.white.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: pageData.primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // * FEATURE ICON
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: pageData.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                feature.icon,
                color: pageData.primaryColor,
                size: 24,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // * FEATURE CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feature.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: pageData.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    feature.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterial3BottomNavigation(
    ThemeData theme,
    OnboardingPageData pageData,
  ) {
    final isLastPage = _currentPage == _pages.length - 1;
    
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: pageData.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // * PREVIOUS BUTTON (Material 3 style)
          if (_currentPage > 0) ...[
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isAnimating ? null : _previousPage,
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Previous'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: pageData.primaryColor,
                  side: BorderSide(color: pageData.primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
          
          // * NEXT/GET STARTED BUTTON (Material 3 style)
          Expanded(
            flex: _currentPage > 0 ? 1 : 1,
            child: FilledButton.icon(
              onPressed: _isAnimating ? null : _nextPage,
              icon: Icon(isLastPage ? Icons.check_circle_rounded : Icons.arrow_forward_rounded),
              label: Text(isLastPage ? 'Get Started' : 'Next'),
              style: FilledButton.styleFrom(
                backgroundColor: isLastPage 
                    ? CropFreshColors.orange10Primary 
                    : pageData.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// * ONBOARDING PAGE DATA MODEL (Material Design 3 compliant)
class OnboardingPageData {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final List<OnboardingFeature> features;
  final Color primaryColor;
  final Color surfaceColor;
  final IconData iconData;

  const OnboardingPageData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.features,
    required this.primaryColor,
    required this.surfaceColor,
    required this.iconData,
  });
}

/// * ONBOARDING FEATURE MODEL
class OnboardingFeature {
  final IconData icon;
  final String title;
  final String description;

  const OnboardingFeature({
    required this.icon,
    required this.title,
    required this.description,
  });
} 