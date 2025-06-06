import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/colors.dart';
import 'dart:math' as math;

/// * CROPFRESH WELCOME HOME SCREEN
/// * Entry point after onboarding - presents login/register options
/// * Features beautiful Material 3 design with 60-30-10 color implementation
class WelcomeHomeScreen extends StatefulWidget {
  const WelcomeHomeScreen({super.key});

  @override
  State<WelcomeHomeScreen> createState() => _WelcomeHomeScreenState();
}

class _WelcomeHomeScreenState extends State<WelcomeHomeScreen>
    with TickerProviderStateMixin {
  
  // * ANIMATION CONTROLLERS
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _bounceController;
  
  // * ANIMATIONS
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    // * FADE ANIMATION for main content
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    // * SLIDE ANIMATION for content elements
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // * SCALE ANIMATION for buttons
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // * BOUNCE ANIMATION for logo
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.bounceOut,
    ));
  }

  void _startAnimations() async {
    // * SEQUENTIAL ANIMATION START
    await Future.delayed(const Duration(milliseconds: 200));
    _fadeController.forward();
    
    await Future.delayed(const Duration(milliseconds: 300));
    _bounceController.forward();
    
    await Future.delayed(const Duration(milliseconds: 400));
    _slideController.forward();
    
    await Future.delayed(const Duration(milliseconds: 600));
    _scaleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    // * Haptic feedback for user interaction
    HapticFeedback.lightImpact();
    
    // TODO: Navigate to login screen
    Navigator.pushNamed(context, '/login');
  }

  void _navigateToRegister() {
    // * Haptic feedback for user interaction
    HapticFeedback.lightImpact();
    
    // TODO: Navigate to registration screen
    Navigator.pushNamed(context, '/register');
  }

  void _navigateToGuestMode() {
    // * Haptic feedback for user interaction
    HapticFeedback.lightImpact();
    
    // TODO: Navigate to dashboard in guest mode
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CropFreshColors.background60Primary,
      body: CustomPaint(
        painter: FarmPatternPainter(),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // * TOP SPACING
                  const SizedBox(height: 40),
                  
                  // * LOGO AND BRAND SECTION
                  _buildLogoSection(),
                  
                  // * MAIN CONTENT
                  Expanded(
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // * WELCOME MESSAGE
                          _buildWelcomeMessage(),
                          
                          const SizedBox(height: 48),
                          
                          // * FEATURE HIGHLIGHTS
                          _buildFeatureHighlights(),
                          
                          const SizedBox(height: 64),
                          
                          // * ACTION BUTTONS
                          _buildActionButtons(),
                        ],
                      ),
                    ),
                  ),
                  
                  // * FOOTER SECTION
                  _buildFooterSection(),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return ScaleTransition(
      scale: _bounceAnimation,
      child: Column(
        children: [
          // * CROPFRESH LOGO
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  CropFreshColors.green30Primary,
                  CropFreshColors.green30Fresh,
                ],
              ),
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: CropFreshColors.green30Primary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.agriculture,
              size: 60,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // * BRAND NAME
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Crop',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: CropFreshColors.green30Primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
                TextSpan(
                  text: 'Fresh',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: CropFreshColors.orange10Primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // * TAGLINE
          Text(
            'Farmers App',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: CropFreshColors.onBackground60Secondary,
              fontWeight: FontWeight.w500,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Column(
      children: [
        // * MAIN WELCOME TEXT
        Text(
          'Welcome to the Future of Farming',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: CropFreshColors.onBackground60,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // * DESCRIPTION
        Text(
          'Join thousands of farmers transforming agriculture with digital tools. Better prices, easier logistics, and expert support at your fingertips.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: CropFreshColors.onBackground60Secondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureHighlights() {
    final features = [
      {
        'icon': Icons.storefront,
        'title': 'Direct Sales',
        'color': CropFreshColors.green30Primary,
      },
      {
        'icon': Icons.local_shipping,
        'title': 'Easy Logistics',
        'color': CropFreshColors.orange10Primary,
      },
      {
        'icon': Icons.support_agent,
        'title': 'Expert Support',
        'color': CropFreshColors.green30Fresh,
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: features.map((feature) {
        return _buildFeatureCard(
          icon: feature['icon'] as IconData,
          title: feature['title'] as String,
          color: feature['color'] as Color,
        );
      }).toList(),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: CropFreshColors.onBackground60Secondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Column(
        children: [
          // * LOGIN BUTTON (Primary Action - 30% Green)
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _navigateToLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: CropFreshColors.green30Primary,
                foregroundColor: CropFreshColors.onGreen30,
                elevation: 4,
                shadowColor: CropFreshColors.green30Primary.withValues(alpha: 0.4),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.login, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'Login to Your Account',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: CropFreshColors.onGreen30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // * REGISTER BUTTON (Secondary Action - Outlined)
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton(
              onPressed: _navigateToRegister,
              style: OutlinedButton.styleFrom(
                foregroundColor: CropFreshColors.green30Primary,
                side: const BorderSide(
                  color: CropFreshColors.green30Primary,
                  width: 2,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_add, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'Create New Account',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: CropFreshColors.green30Primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // * GUEST MODE OPTION (10% Orange accent)
          TextButton(
            onPressed: _navigateToGuestMode,
            style: TextButton.styleFrom(
              foregroundColor: CropFreshColors.orange10Primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.visibility,
                  size: 20,
                  color: CropFreshColors.orange10Primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Continue as Guest',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: CropFreshColors.orange10Primary,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterSection() {
    return Column(
      children: [
        // * SECURITY BADGE
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: CropFreshColors.background60Secondary,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(
              color: CropFreshColors.green30Primary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.verified_user,
                size: 16,
                color: CropFreshColors.green30Primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Secure & Trusted',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: CropFreshColors.green30Primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // * HELP TEXT
        Text(
          'Need help? Contact our support team',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: CropFreshColors.onBackground60Tertiary,
          ),
        ),
      ],
    );
  }
}

/// * CUSTOM PAINTER FOR FARM BACKGROUND PATTERN
/// * Creates subtle agricultural design elements following 60-30-10 rule
class FarmPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CropFreshColors.green30Primary.withValues(alpha: 0.03)
      ..style = PaintingStyle.fill;

    // * DRAW SUBTLE FARM PATTERN (60% Background implementation)
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    // * LARGE CIRCULAR ELEMENTS (representing sun/fields)
    canvas.drawCircle(
      Offset(centerX * 0.2, centerY * 0.3),
      40,
      paint,
    );
    
    canvas.drawCircle(
      Offset(centerX * 1.8, centerY * 0.7),
      35,
      paint,
    );
    
    // * SMALL DECORATIVE ELEMENTS (representing crops/leaves)
    paint.color = CropFreshColors.green30Fresh.withValues(alpha: 0.05);
    
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30) * (math.pi / 180);
      final radius = 80 + (i % 3) * 20;
      final x = centerX + radius * math.cos(angle);
      final y = centerY + radius * math.sin(angle);
      
      canvas.drawCircle(
        Offset(x, y),
        3 + (i % 2),
        paint,
      );
    }
    
    // * ACCENT ELEMENTS (10% Orange implementation)
    paint.color = CropFreshColors.orange10Primary.withValues(alpha: 0.02);
    
    canvas.drawCircle(
      Offset(centerX * 0.1, centerY * 1.2),
      25,
      paint,
    );
    
    canvas.drawCircle(
      Offset(centerX * 1.9, centerY * 0.2),
      20,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 