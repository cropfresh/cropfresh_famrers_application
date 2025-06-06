import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

/// * REUSABLE ONBOARDING PAGE WIDGET
/// * Base widget for consistent onboarding page structure
/// * Provides common layout and styling for all onboarding screens
class OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final Widget heroSection;
  final List<Widget> features;
  final Color backgroundColor;
  final Color primaryColor;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.heroSection,
    required this.features,
    required this.backgroundColor,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenHeight > 800;

    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              SizedBox(height: isTablet ? 40 : 20),
              
              // * HERO SECTION
              heroSection,
              
              SizedBox(height: isTablet ? 48 : 32),
              
              // * CONTENT SECTION
              _buildContentSection(context, isTablet),
              
              SizedBox(height: isTablet ? 40 : 24),
              
              // * FEATURES SECTION
              ...features,
              
              SizedBox(height: isTablet ? 60 : 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection(BuildContext context, bool isTablet) {
    return Column(
      children: [
        // * MAIN TITLE
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 32 : 28,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 12),
        
        // * SUBTITLE
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: CropFreshColors.orange10Container,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: Text(
            subtitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: CropFreshColors.orange10Primary,
              fontWeight: FontWeight.w600,
              fontSize: isTablet ? 18 : 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        
        const SizedBox(height: 20),
        
        // * DESCRIPTION
        Text(
          description,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: CropFreshColors.onBackground60Secondary,
            height: 1.6,
            fontSize: isTablet ? 18 : 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
} 