import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';

// * MATERIAL DESIGN 3 WELCOME SCREEN
// * Purpose: Authentication entry point after onboarding completion
// * Features: Login/Register options, brand presentation, Material You design
// * Design: Clean, welcoming interface with CropFresh branding
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  
  // * ANIMATION CONTROLLERS
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  
  // * ANIMATIONS
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startEntryAnimation();
  }

  void _initializeAnimations() {
    // * FADE ANIMATION for content appearance
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // * SLIDE ANIMATION for content entrance
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    // * SCALE ANIMATION for interactive elements
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // * Animation definitions
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
  }

  void _startEntryAnimation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeController.forward();
      _slideController.forward();
      _scaleController.forward();
    });
  }

  Future<void> _navigateToLogin() async {
    await HapticFeedback.lightImpact();
    if (mounted) {
      context.go(AppRoutes.phoneNumber);
    }
  }

  Future<void> _navigateToRegister() async {
    await HapticFeedback.lightImpact();
    if (mounted) {
      // For now, register also goes to phone number (same flow)
      // TODO: Create separate registration flow if needed
      context.go(AppRoutes.phoneNumber);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBFF), // Material 3 surface
      body: SafeArea(
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _fadeController,
            _slideController,
            _scaleController,
          ]),
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: _buildBackgroundDecoration(),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        
                        // * LOGO SECTION
                        _buildLogoSection(theme),
                        
                        const SizedBox(height: 60),
                        
                        // * WELCOME CONTENT
                        _buildWelcomeContent(theme),
                        
                        const SizedBox(height: 80),
                        
                        // * ACTION BUTTONS
                        _buildActionButtons(theme),
                        
                        const SizedBox(height: 40),
                        
                        // * FOOTER
                        _buildFooter(theme),
                        
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFFFFBFF),
          CropFreshColors.green30Primary.withOpacity(0.03),
          CropFreshColors.orange10Primary.withOpacity(0.02),
          const Color(0xFFFFFBFF),
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
      ),
    );
  }

  Widget _buildLogoSection(ThemeData theme) {
    return Transform.scale(
      scale: _scaleAnimation.value,
      child: Column(
        children: [
          // * MAIN LOGO
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: CropFreshColors.green30Primary.withOpacity(0.2),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                  spreadRadius: 5,
                ),
                BoxShadow(
                  color: CropFreshColors.orange10Primary.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
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
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: const Icon(
                    Icons.agriculture_rounded,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // * LOGO TEXT
          SizedBox(
            height: 32,
            child: Image.asset(
              'assets/images/logo-text.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Text(
                'CropFresh',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: CropFreshColors.green30Primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeContent(ThemeData theme) {
    return Column(
      children: [
        // * MAIN TITLE
        Text(
          'Welcome to CropFresh',
          style: theme.textTheme.headlineLarge?.copyWith(
            color: CropFreshColors.green30Primary,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 16),
        
        // * SLOGAN
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                CropFreshColors.green30Primary.withOpacity(0.1),
                CropFreshColors.orange10Primary.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: CropFreshColors.green30Primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Text(
            'Empowering Local Farmers',
            style: theme.textTheme.titleLarge?.copyWith(
              color: CropFreshColors.green30Primary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // * SUBTITLE
        Text(
          'Digital Agriculture Platform',
          style: theme.textTheme.titleMedium?.copyWith(
            color: CropFreshColors.orange10Primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // * DESCRIPTION
        Text(
          'Join thousands of farmers who are transforming their agriculture with our comprehensive digital platform. Get better prices, easier logistics, and expert guidance.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.8),
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 32),
        
        // * FEATURES HIGHLIGHTS
        _buildFeatureHighlights(theme),
      ],
    );
  }

  Widget _buildFeatureHighlights(ThemeData theme) {
    final features = [
      {'icon': Icons.trending_up_rounded, 'text': 'Better Prices'},
      {'icon': Icons.local_shipping_rounded, 'text': 'Easy Logistics'},
      {'icon': Icons.support_agent_rounded, 'text': 'Expert Support'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: features.map((feature) {
        return Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: CropFreshColors.green30Primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: CropFreshColors.green30Primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                feature['icon'] as IconData,
                color: CropFreshColors.green30Primary,
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              feature['text'] as String,
              style: theme.textTheme.labelLarge?.copyWith(
                color: CropFreshColors.green30Primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Column(
      children: [
        // * LOGIN BUTTON (Primary)
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton.icon(
            onPressed: _navigateToLogin,
            icon: const Icon(Icons.login_rounded),
            label: const Text(
              'Login to Your Account',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: CropFreshColors.green30Primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // * REGISTER BUTTON (Secondary)
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton.icon(
            onPressed: _navigateToRegister,
            icon: const Icon(Icons.person_add_rounded),
            label: const Text(
              'Create New Account',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: CropFreshColors.orange10Primary,
              side: BorderSide(
                color: CropFreshColors.orange10Primary,
                width: 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // * DIVIDER
        Row(
          children: [
            Expanded(
              child: Divider(
                color: theme.colorScheme.outline.withOpacity(0.3),
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'or',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: theme.colorScheme.outline.withOpacity(0.3),
                thickness: 1,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // * GUEST MODE BUTTON
        TextButton.icon(
          onPressed: () {
            // TODO: Implement guest mode functionality
            HapticFeedback.lightImpact();
          },
          icon: Icon(
            Icons.explore_rounded,
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
          label: Text(
            'Explore as Guest',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Column(
      children: [
        // * APP VERSION
        Text(
          'Version ${AppConstants.appVersion}',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // * TERMS AND PRIVACY
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                // TODO: Open terms of service
                HapticFeedback.lightImpact();
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Terms',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: CropFreshColors.green30Primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            
            Text(
              ' • ',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
            
            TextButton(
              onPressed: () {
                // TODO: Open privacy policy
                HapticFeedback.lightImpact();
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Privacy',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: CropFreshColors.green30Primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // * HELP TEXT
        Text(
          'Need help? Contact our support team',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
} 