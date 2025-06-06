// ===================================================================
// * ONBOARDING PAGE
// * Purpose: App introduction and feature showcase
// * Features: Welcome screens, feature highlights, get started button
// ===================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Core imports
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Welcome to CropFresh',
      subtitle: 'Transform Your Farming with Digital Tools',
      description: 'Connect directly with buyers, access expert services, and grow your farming business with our comprehensive platform.',
      image: 'assets/images/onboarding_1.png',
      color: const Color(0xFF4CAF50),
    ),
    OnboardingData(
      title: 'Direct Marketplace',
      subtitle: 'Sell Direct to Buyers - No Middlemen',
      description: 'List your produce, negotiate prices, and connect directly with businesses looking for fresh agricultural products.',
      image: 'assets/images/onboarding_2.png',
      color: const Color(0xFF2196F3),
    ),
    OnboardingData(
      title: 'Complete Farm Solution',
      subtitle: 'Everything You Need in One App',
      description: 'Order inputs, book logistics, access veterinary services, and get expert farming advice - all in one place.',
      image: 'assets/images/onboarding_3.png',
      color: const Color(0xFFFF9800),
    ),
    OnboardingData(
      title: 'Smart & Local',
      subtitle: 'Designed for Indian Farmers',
      description: 'Multi-language support, offline capabilities, and features tailored specifically for Indian agriculture.',
      image: 'assets/images/onboarding_4.png',
      color: const Color(0xFF9C27B0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // * Skip button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_currentPage < _pages.length - 1)
                    TextButton(
                      onPressed: () => _goToAuth(),
                      child: const Text('Skip'),
                    ),
                ],
              ),
            ),

            // * Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),

            // * Bottom section
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // * Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => _buildPageIndicator(index),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // * Action button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _currentPage == _pages.length - 1
                          ? _goToAuth
                          : _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _pages[_currentPage].color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _currentPage == _pages.length - 1
                            ? 'Get Started'
                            : 'Next',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
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

  Widget _buildPage(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // * Image placeholder
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIconForPage(_currentPage),
              size: 120,
              color: data.color,
            ),
          ),
          const SizedBox(height: 48),

          // * Title
          Text(
            data.title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: data.color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // * Subtitle
          Text(
            data.subtitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // * Description
          Text(
            data.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 32 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? _pages[_currentPage].color
            : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  IconData _getIconForPage(int page) {
    switch (page) {
      case 0:
        return Icons.agriculture;
      case 1:
        return Icons.storefront;
      case 2:
        return Icons.dashboard;
      case 3:
        return Icons.language;
      default:
        return Icons.agriculture;
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToAuth() {
    context.go('/auth/phone');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

// * Data model for onboarding pages
class OnboardingData {
  final String title;
  final String subtitle;
  final String description;
  final String image;
  final Color color;

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.image,
    required this.color,
  });
} 