import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../core/constants/colors.dart';
import 'onboarding_screen.dart';

/// * WELCOME SCREEN - FIRST ONBOARDING PAGE
/// * Features: Hero image, transformation message, key benefits
/// * Implements staggered animations for engaging user experience
class WelcomeScreen extends StatefulWidget {
  final OnboardingPageData pageData;

  const WelcomeScreen({
    super.key,
    required this.pageData,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  
  // * ANIMATION CONTROLLERS
  late AnimationController _heroController;
  late AnimationController _contentController;
  late Animation<double> _heroScale;
  late Animation<double> _heroRotation;
  late Animation<Offset> _contentSlide;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    // * HERO IMAGE ANIMATIONS
    _heroController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // * CONTENT ANIMATIONS
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // * HERO ANIMATIONS
    _heroScale = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _heroController,
      curve: Curves.elasticOut,
    ));

    _heroRotation = Tween<double>(
      begin: -0.1,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _heroController,
      curve: Curves.easeOutBack,
    ));

    // * CONTENT SLIDE ANIMATION
    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _heroController.forward();
      }
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        _contentController.forward();
      }
    });
  }

  @override
  void dispose() {
    _heroController.dispose();
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
          SizedBox(height: isTablet ? 40 : 20),
          
          // * HERO IMAGE SECTION
          _buildHeroSection(isTablet),
          
          SizedBox(height: isTablet ? 48 : 32),
          
          // * CONTENT SECTION
          _buildContentSection(isTablet),
          
          SizedBox(height: isTablet ? 40 : 24),
          
          // * BENEFITS SECTION
          _buildBenefitsSection(),
          
          SizedBox(height: isTablet ? 60 : 40),
        ],
      ),
    );
  }

  Widget _buildHeroSection(bool isTablet) {
    return AnimatedBuilder(
      animation: _heroController,
      builder: (context, child) {
        return Transform.scale(
          scale: _heroScale.value,
          child: Transform.rotate(
            angle: _heroRotation.value,
            child: Container(
              height: isTablet ? 300 : 240,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    CropFreshColors.green30Container,
                    CropFreshColors.warm60Light,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: CropFreshColors.green30Primary.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // * BACKGROUND PATTERN
                  Positioned.fill(
                    child: CustomPaint(
                      painter: WelcomePatternPainter(),
                    ),
                  ),
                  
                  // * HERO ILLUSTRATION
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // * FARMER ICON
                        Container(
                          width: isTablet ? 80 : 64,
                          height: isTablet ? 80 : 64,
                          decoration: BoxDecoration(
                            color: CropFreshColors.green30Primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: CropFreshColors.green30Primary.withValues(alpha: 0.3),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.agriculture,
                            size: isTablet ? 40 : 32,
                            color: Colors.white,
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // * TECH SYMBOLS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildTechIcon(Icons.smartphone, CropFreshColors.orange10Primary),
                            const SizedBox(width: 12),
                            _buildTechIcon(Icons.trending_up, CropFreshColors.green30Fresh),
                            const SizedBox(width: 12),
                            _buildTechIcon(Icons.support_agent, CropFreshColors.green30Sage),
                          ],
                        ),
                      ],
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

  Widget _buildTechIcon(IconData icon, Color color) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Icon(
        icon,
        size: 20,
        color: color,
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
                widget.pageData.subtitle,
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
              widget.pageData.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: CropFreshColors.onBackground60Secondary,
                height: 1.6,
                fontSize: isTablet ? 18 : 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitsSection() {
    return AnimationLimiter(
      child: Column(
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 400),
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: 30.0,
            child: FadeInAnimation(child: widget),
          ),
          children: [
            // * BENEFITS HEADER
            Text(
              'Why Choose CropFresh?',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: widget.pageData.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // * BENEFITS GRID
            ...widget.pageData.benefits.asMap().entries.map((entry) {
              final index = entry.key;
              final benefit = entry.value;
              return _buildBenefitCard(benefit, index);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitCard(String benefit, int index) {
    final icons = [
      Icons.monetization_on, // Better Prices
      Icons.local_shipping,  // Easy Logistics
      Icons.support_agent,   // Expert Support
    ];

    final colors = [
      CropFreshColors.green30Fresh,
      CropFreshColors.orange10Primary,
      CropFreshColors.green30Sage,
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
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // * BENEFIT ICON
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colors[index % colors.length].withValues(alpha: 0.2),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Icon(
              icons[index % icons.length],
              color: colors[index % colors.length],
              size: 24,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // * BENEFIT TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  benefit,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colors[index % colors.length],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getBenefitDescription(benefit),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: CropFreshColors.onBackground60Secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getBenefitDescription(String benefit) {
    switch (benefit) {
      case 'Better Prices':
        return 'Get fair market rates by selling directly to buyers';
      case 'Easy Logistics':
        return 'Book transportation and delivery with just a few taps';
      case 'Expert Support':
        return 'Access agricultural experts and veterinary services';
      default:
        return 'Enhance your farming experience with CropFresh';
    }
  }
}

/// * CUSTOM PAINTER FOR WELCOME SCREEN BACKGROUND PATTERN
/// * Creates agricultural-themed decorative elements
class WelcomePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CropFreshColors.green30Primary.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    // * DRAW SUBTLE AGRICULTURAL PATTERN
    final path = Path();
    
    // * WHEAT GRAIN PATTERN
    for (int i = 0; i < 5; i++) {
      final x = (size.width / 6) * (i + 1);
      final y = size.height * 0.2;
      
      path.moveTo(x, y);
      path.quadraticBezierTo(x + 10, y - 15, x + 20, y);
      path.quadraticBezierTo(x + 10, y + 15, x, y);
    }
    
    canvas.drawPath(path, paint);
    
    // * SUBTLE DOTS PATTERN
    paint.color = CropFreshColors.orange10Primary.withValues(alpha: 0.1);
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 2; j++) {
        canvas.drawCircle(
          Offset(
            size.width * 0.8 + (i * 20),
            size.height * 0.7 + (j * 20),
          ),
          4,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 