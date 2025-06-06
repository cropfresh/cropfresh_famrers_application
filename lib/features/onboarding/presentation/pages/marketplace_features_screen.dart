import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../core/constants/colors.dart';
import 'onboarding_screen.dart';

/// * MARKETPLACE FEATURES SCREEN - SECOND ONBOARDING PAGE
/// * Features: Product listing visuals, photo upload demo, price negotiation
/// * Shows direct buyer connection capabilities
class MarketplaceFeaturesScreen extends StatefulWidget {
  final OnboardingPageData pageData;

  const MarketplaceFeaturesScreen({
    super.key,
    required this.pageData,
  });

  @override
  State<MarketplaceFeaturesScreen> createState() => _MarketplaceFeaturesScreenState();
}

class _MarketplaceFeaturesScreenState extends State<MarketplaceFeaturesScreen>
    with TickerProviderStateMixin {
  
  // * ANIMATION CONTROLLERS
  late AnimationController _mockupController;
  late AnimationController _contentController;
  late Animation<double> _mockupScale;
  late Animation<double> _mockupRotation;
  late Animation<Offset> _contentSlide;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    // * MOCKUP ANIMATIONS
    _mockupController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // * CONTENT ANIMATIONS
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // * MOCKUP ANIMATIONS
    _mockupScale = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mockupController,
      curve: Curves.elasticOut,
    ));

    _mockupRotation = Tween<double>(
      begin: 0.1,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _mockupController,
      curve: Curves.easeOutBack,
    ));

    // * CONTENT SLIDE ANIMATION
    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _mockupController.forward();
      }
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _contentController.forward();
      }
    });
  }

  @override
  void dispose() {
    _mockupController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenHeight > 800;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          SizedBox(height: isTablet ? 30 : 15),
          
          // * MARKETPLACE MOCKUP SECTION
          _buildMarketplaceMockup(isTablet),
          
          SizedBox(height: isTablet ? 40 : 24),
          
          // * CONTENT SECTION
          _buildContentSection(isTablet),
          
          SizedBox(height: isTablet ? 32 : 20),
          
          // * FEATURES SECTION
          _buildFeaturesSection(),
          
          SizedBox(height: isTablet ? 40 : 20),
        ],
      ),
    );
  }

  Widget _buildMarketplaceMockup(bool isTablet) {
    return AnimatedBuilder(
      animation: _mockupController,
      builder: (context, child) {
        return Transform.scale(
          scale: _mockupScale.value,
          child: Transform.rotate(
            angle: _mockupRotation.value,
            child: Container(
              height: isTablet ? 320 : 260,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    CropFreshColors.background60Card,
                    CropFreshColors.green30Container,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: CropFreshColors.green30Fresh.withValues(alpha: 0.2),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // * MOCKUP PHONE FRAME
                  Center(
                    child: Container(
                      width: isTablet ? 200 : 160,
                      height: isTablet ? 280 : 220,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: const BorderRadius.all(Radius.circular(24)),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: CropFreshColors.background60Primary,
                          borderRadius: const BorderRadius.all(Radius.circular(16)),
                        ),
                        child: _buildMockupContent(isTablet),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMockupContent(bool isTablet) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          // * MOCKUP HEADER
          Container(
            height: 30,
            decoration: BoxDecoration(
              color: CropFreshColors.green30Primary,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 8),
                const Icon(
                  Icons.storefront,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'My Marketplace',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 12 : 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // * PRODUCT CARD MOCKUP
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: CropFreshColors.background60Card,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                border: Border.all(
                  color: CropFreshColors.green30Container,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  // * PRODUCT IMAGE AREA
                  Container(
                    height: isTablet ? 80 : 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          CropFreshColors.green30Light,
                          CropFreshColors.green30Container,
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            Icons.photo_camera,
                            color: CropFreshColors.green30Primary,
                            size: isTablet ? 32 : 24,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: CropFreshColors.orange10Primary,
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Text(
                              'UPLOAD',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isTablet ? 8 : 6,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // * PRODUCT INFO
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fresh Tomatoes',
                            style: TextStyle(
                              fontSize: isTablet ? 12 : 10,
                              fontWeight: FontWeight.bold,
                              color: CropFreshColors.onBackground60,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹45/kg',
                            style: TextStyle(
                              fontSize: isTablet ? 14 : 12,
                              fontWeight: FontWeight.bold,
                              color: CropFreshColors.green30Primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: CropFreshColors.orange10Container,
                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                            ),
                            child: Text(
                              'NEGOTIABLE',
                              style: TextStyle(
                                color: CropFreshColors.orange10Primary,
                                fontSize: isTablet ? 8 : 6,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // * ACTION BUTTONS
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 24,
                  decoration: BoxDecoration(
                    color: CropFreshColors.orange10Primary,
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                  ),
                  child: Center(
                    child: Text(
                      'PUBLISH',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 10 : 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: CropFreshColors.green30Container,
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                ),
                child: Icon(
                  Icons.share,
                  color: CropFreshColors.green30Primary,
                  size: isTablet ? 14 : 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection(bool isTablet) {
    return SlideTransition(
      position: _contentSlide,
      child: FadeTransition(
        opacity: _contentController,
        child: Column(
          children: [
            // * MAIN TITLE
            Text(
              widget.pageData.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: widget.pageData.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: isTablet ? 32 : 26,
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
                widget.pageData.subtitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: CropFreshColors.orange10Primary,
                  fontWeight: FontWeight.w600,
                  fontSize: isTablet ? 16 : 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // * DESCRIPTION
            Text(
              widget.pageData.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: CropFreshColors.onBackground60Secondary,
                height: 1.5,
                fontSize: isTablet ? 16 : 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return AnimationLimiter(
      child: Column(
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 500),
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: 40.0,
            child: FadeInAnimation(child: widget),
          ),
          children: widget.pageData.benefits.asMap().entries.map((entry) {
            final index = entry.key;
            final feature = entry.value;
            return _buildFeatureCard(feature, index);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(String feature, int index) {
    final icons = [
      Icons.photo_camera_outlined, // Photo Upload
      Icons.handshake_outlined,    // Price Negotiation
      Icons.storefront_outlined,   // Direct Sales
    ];

    final colors = [
      CropFreshColors.green30Fresh,
      CropFreshColors.orange10Primary,
      CropFreshColors.green30Forest,
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CropFreshColors.background60Card,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(
          color: colors[index % colors.length].withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colors[index % colors.length].withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // * FEATURE ICON
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colors[index % colors.length].withValues(alpha: 0.2),
              borderRadius: const BorderRadius.all(Radius.circular(14)),
            ),
            child: Icon(
              icons[index % icons.length],
              color: colors[index % colors.length],
              size: 26,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // * FEATURE TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colors[index % colors.length],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _getFeatureDescription(feature),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: CropFreshColors.onBackground60Secondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getFeatureDescription(String feature) {
    switch (feature) {
      case 'Photo Upload':
        return 'Take high-quality photos of your produce to attract more buyers and get better prices';
      case 'Price Negotiation':
        return 'Chat directly with buyers to negotiate the best prices for your crops';
      case 'Direct Sales':
        return 'Eliminate middlemen and sell directly to buyers for maximum profit margins';
      default:
        return 'Enhance your selling experience with CropFresh marketplace';
    }
  }
} 