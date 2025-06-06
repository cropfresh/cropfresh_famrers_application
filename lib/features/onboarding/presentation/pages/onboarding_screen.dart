import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/theme.dart';
import '../widgets/onboarding_page.dart';
import 'welcome_screen.dart';
import 'marketplace_features_screen.dart';
import 'farm_solution_screen.dart';
import 'language_selection_screen.dart';

/// * CROPFRESH ONBOARDING FLOW
/// * Manages the 4-screen onboarding experience for farmers
/// * Features smooth transitions, progress indicators, and intuitive navigation
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  
  // * ANIMATION CONTROLLERS
  late PageController _pageController;
  late AnimationController _progressController;
  late AnimationController _transitionController;
  
  // * STATE VARIABLES
  int _currentPage = 0;
  bool _isLastPage = false;
  
  // * ONBOARDING PAGES DATA
  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      title: 'Welcome to CropFresh',
      subtitle: 'Transform Your Farming with Digital Tools',
      description: 'Join thousands of farmers who are already benefiting from better prices, easy logistics, and expert support.',
      benefits: ['Better Prices', 'Easy Logistics', 'Expert Support'],
      heroImage: 'assets/images/onboarding/welcome_hero.png',
      backgroundColor: CropFreshColors.background60Primary,
      primaryColor: CropFreshColors.green30Primary,
    ),
    OnboardingPageData(
      title: 'Direct Marketplace',
      subtitle: 'Sell Direct to Buyers - No Middlemen',
      description: 'Upload photos of your produce, set your prices, and connect directly with buyers for maximum profit.',
      benefits: ['Photo Upload', 'Price Negotiation', 'Direct Sales'],
      heroImage: 'assets/images/onboarding/marketplace_hero.png',
      backgroundColor: CropFreshColors.background60Secondary,
      primaryColor: CropFreshColors.green30Fresh,
    ),
    OnboardingPageData(
      title: 'Complete Farm Solution',
      subtitle: 'Everything You Need in One App',
      description: 'Order inputs, book logistics, access vet services, and manage your farm - even when offline.',
      benefits: ['Input Ordering', 'Logistics Booking', 'Vet Services', 'Offline Support'],
      heroImage: 'assets/images/onboarding/farm_solution_hero.png',
      backgroundColor: CropFreshColors.background60Tertiary,
      primaryColor: CropFreshColors.green30Forest,
    ),
    OnboardingPageData(
      title: 'Your Language, Your Way',
      subtitle: 'Choose Your Preferred Language',
      description: 'CropFresh speaks your language. Select from Kannada, Telugu, Hindi, or English for the best experience.',
      benefits: ['Kannada', 'Telugu', 'Hindi', 'English'],
      heroImage: 'assets/images/onboarding/language_hero.png',
      backgroundColor: CropFreshColors.warm60Light,
      primaryColor: CropFreshColors.green30Sage,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    // * PAGE CONTROLLER for smooth transitions
    _pageController = PageController();

    // * PROGRESS ANIMATION (3 seconds per page)
    _progressController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // * TRANSITION ANIMATION for page changes
    _transitionController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // ! SECURITY: Add listener for page changes
    _pageController.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    final page = _pageController.page?.round() ?? 0;
    if (page != _currentPage) {
      setState(() {
        _currentPage = page;
        _isLastPage = page == _pages.length - 1;
      });
      
      // * Reset and start progress animation for new page
      _progressController.reset();
      _progressController.forward();
      
      // * Haptic feedback for page transitions
      HapticFeedback.lightImpact();
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeOnboarding() {
    // ! IMPORTANT: Save onboarding completion state
    // TODO: Implement SharedPreferences to save completion state
    HapticFeedback.mediumImpact();
    
    // * Navigate to welcome home screen for login/register choice
    Navigator.of(context).pushReplacementNamed('/welcome-home');
  }

  void _skipOnboarding() {
    // * Allow users to skip and go directly to app
    HapticFeedback.lightImpact();
    _completeOnboarding();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pages[_currentPage].backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // * TOP NAVIGATION BAR
            _buildTopNavigationBar(),
            
            // * PROGRESS INDICATOR
            _buildProgressIndicator(),
            
            // * ONBOARDING PAGES
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                    _isLastPage = index == _pages.length - 1;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(_pages[index]);
                },
              ),
            ),
            
            // * BOTTOM NAVIGATION
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNavigationBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // * BACK BUTTON (only show if not first page)
          if (_currentPage > 0)
            IconButton(
              onPressed: _previousPage,
              icon: Icon(
                Icons.arrow_back_ios,
                color: _pages[_currentPage].primaryColor,
              ),
            )
          else
            const SizedBox(width: 48), // Maintain spacing
          
          // * CROPFRESH LOGO
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      CropFreshColors.green30Primary,
                      CropFreshColors.orange10Primary,
                    ],
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: const Icon(
                  Icons.agriculture,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'CropFresh',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: _pages[_currentPage].primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          // * SKIP BUTTON (only show if not last page)
          if (!_isLastPage)
            TextButton(
              onPressed: _skipOnboarding,
              child: Text(
                'Skip',
                style: TextStyle(
                  color: CropFreshColors.onBackground60Secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else
            const SizedBox(width: 48), // Maintain spacing
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        children: [
          // * STEP INDICATORS
          Row(
            children: List.generate(_pages.length, (index) {
              final isActive = index == _currentPage;
              final isCompleted = index < _currentPage;
              
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(
                    right: index < _pages.length - 1 ? 8 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: isCompleted || isActive
                        ? _pages[_currentPage].primaryColor
                        : CropFreshColors.onBackground60Disabled,
                    borderRadius: const BorderRadius.all(Radius.circular(2)),
                  ),
                  child: isActive
                      ? AnimatedBuilder(
                          animation: _progressController,
                          builder: (context, child) {
                            return FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: _progressController.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: CropFreshColors.orange10Primary,
                                  borderRadius: const BorderRadius.all(Radius.circular(2)),
                                ),
                              ),
                            );
                          },
                        )
                      : null,
                ),
              );
            }),
          ),
          
          const SizedBox(height: 8),
          
          // * PAGE COUNTER
          Text(
            '${_currentPage + 1} of ${_pages.length}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: CropFreshColors.onBackground60Secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingPageData pageData) {
    // * Return appropriate page widget based on current page
    switch (_currentPage) {
      case 0:
        return WelcomeScreen(pageData: pageData);
      case 1:
        return MarketplaceFeaturesScreen(pageData: pageData);
      case 2:
        return FarmSolutionScreen(pageData: pageData);
      case 3:
        return LanguageSelectionScreen(
          pageData: pageData,
          onLanguageSelected: (language) {
            // * Save language preference
            // TODO: Implement SharedPreferences to save language preference
            print('Selected language: $language');
            
            // * Navigate directly to welcome home screen after language selection
            Navigator.of(context).pushReplacementNamed('/welcome-home');
          },
        );
      default:
        return WelcomeScreen(pageData: pageData);
    }
  }

  Widget _buildBottomNavigation() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          // * PREVIOUS BUTTON
          if (_currentPage > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousPage,
                style: OutlinedButton.styleFrom(
                  foregroundColor: _pages[_currentPage].primaryColor,
                  side: BorderSide(color: _pages[_currentPage].primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Previous'),
              ),
            ),
          
          if (_currentPage > 0) const SizedBox(width: 16),
          
          // * NEXT/GET STARTED BUTTON
          Expanded(
            flex: _currentPage > 0 ? 1 : 2,
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isLastPage
                    ? CropFreshColors.orange10Primary
                    : _pages[_currentPage].primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 2,
              ),
              child: Text(
                _isLastPage ? 'Get Started' : 'Next',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// * ONBOARDING PAGE DATA MODEL
/// * Contains all necessary data for each onboarding screen
class OnboardingPageData {
  final String title;
  final String subtitle;
  final String description;
  final List<String> benefits;
  final String heroImage;
  final Color backgroundColor;
  final Color primaryColor;

  const OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.benefits,
    required this.heroImage,
    required this.backgroundColor,
    required this.primaryColor,
  });
} 