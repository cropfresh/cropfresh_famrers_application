import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../core/constants/colors.dart';
import 'onboarding_screen.dart';

/// * FARM SOLUTION SCREEN - THIRD ONBOARDING PAGE
/// * Features: Complete farm management tools, input ordering, logistics, vet services
/// * Highlights offline capability and comprehensive farm support
class FarmSolutionScreen extends StatefulWidget {
  final OnboardingPageData pageData;

  const FarmSolutionScreen({
    super.key,
    required this.pageData,
  });

  @override
  State<FarmSolutionScreen> createState() => _FarmSolutionScreenState();
}

class _FarmSolutionScreenState extends State<FarmSolutionScreen>
    with TickerProviderStateMixin {
  
  // * ANIMATION CONTROLLERS
  late AnimationController _dashboardController;
  late AnimationController _contentController;
  late Animation<double> _dashboardScale;
  late Animation<double> _dashboardRotation;
  late Animation<Offset> _contentSlide;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    // * DASHBOARD MOCKUP ANIMATIONS
    _dashboardController = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    );

    // * CONTENT ANIMATIONS
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // * DASHBOARD ANIMATIONS
    _dashboardScale = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _dashboardController,
      curve: Curves.elasticOut,
    ));

    _dashboardRotation = Tween<double>(
      begin: -0.1,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _dashboardController,
      curve: Curves.easeOutBack,
    ));

    // * CONTENT SLIDE ANIMATION
    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _dashboardController.forward();
      }
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        _contentController.forward();
      }
    });
  }

  @override
  void dispose() {
    _dashboardController.dispose();
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
          SizedBox(height: isTablet ? 20 : 10),
          
          // * FARM DASHBOARD MOCKUP SECTION
          _buildFarmDashboard(isTablet),
          
          SizedBox(height: isTablet ? 32 : 20),
          
          // * CONTENT SECTION
          _buildContentSection(isTablet),
          
          SizedBox(height: isTablet ? 24 : 16),
          
          // * SERVICES SECTION
          _buildServicesSection(),
          
          SizedBox(height: isTablet ? 32 : 20),
        ],
      ),
    );
  }

  Widget _buildFarmDashboard(bool isTablet) {
    return AnimatedBuilder(
      animation: _dashboardController,
      builder: (context, child) {
        return Transform.scale(
          scale: _dashboardScale.value,
          child: Transform.rotate(
            angle: _dashboardRotation.value,
            child: Container(
              height: isTablet ? 280 : 220,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    CropFreshColors.background60Card,
                    CropFreshColors.green30Container,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: CropFreshColors.green30Forest.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: _buildDashboardContent(isTablet),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDashboardContent(bool isTablet) {
    return Column(
      children: [
        // * DASHBOARD HEADER
        Row(
          children: [
            Icon(
              Icons.dashboard_outlined,
              color: CropFreshColors.green30Forest,
              size: isTablet ? 28 : 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Farm Dashboard',
              style: TextStyle(
                fontSize: isTablet ? 20 : 16,
                fontWeight: FontWeight.bold,
                color: CropFreshColors.green30Forest,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: CropFreshColors.green30Container,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.wifi_off,
                    color: CropFreshColors.green30Forest,
                    size: isTablet ? 16 : 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'OFFLINE',
                    style: TextStyle(
                      fontSize: isTablet ? 10 : 8,
                      fontWeight: FontWeight.bold,
                      color: CropFreshColors.green30Forest,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // * SERVICE ICONS GRID
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildServiceIcon(
                Icons.shopping_cart_outlined,
                'Input\nOrdering',
                CropFreshColors.green30Fresh,
                isTablet,
              ),
              _buildServiceIcon(
                Icons.local_shipping_outlined,
                'Logistics\nBooking',
                CropFreshColors.orange10Primary,
                isTablet,
              ),
              _buildServiceIcon(
                Icons.medical_services_outlined,
                'Vet\nServices',
                CropFreshColors.green30Sage,
                isTablet,
              ),
              _buildServiceIcon(
                Icons.support_agent_outlined,
                'Expert\nSupport',
                CropFreshColors.green30Forest,
                isTablet,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceIcon(IconData icon, String label, Color color, bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        color: CropFreshColors.background60Card,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: isTablet ? 40 : 32,
            height: isTablet ? 40 : 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: Icon(
              icon,
              color: color,
              size: isTablet ? 24 : 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isTablet ? 11 : 9,
              fontWeight: FontWeight.w600,
              color: color,
              height: 1.2,
            ),
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
                fontSize: isTablet ? 30 : 26,
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

  Widget _buildServicesSection() {
    return AnimationLimiter(
      child: Column(
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 600),
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(child: widget),
          ),
          children: widget.pageData.benefits.asMap().entries.map((entry) {
            final index = entry.key;
            final service = entry.value;
            return _buildServiceCard(service, index);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildServiceCard(String service, int index) {
    final icons = [
      Icons.shopping_cart,     // Input Ordering
      Icons.local_shipping,    // Logistics Booking
      Icons.medical_services,  // Vet Services
      Icons.cloud_off,         // Offline Support
    ];

    final colors = [
      CropFreshColors.green30Fresh,
      CropFreshColors.orange10Primary,
      CropFreshColors.green30Sage,
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
          // * SERVICE ICON
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colors[index % colors.length].withValues(alpha: 0.2),
              borderRadius: const BorderRadius.all(Radius.circular(16)),
            ),
            child: Icon(
              icons[index % icons.length],
              color: colors[index % colors.length],
              size: 28,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // * SERVICE TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colors[index % colors.length],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _getServiceDescription(service),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: CropFreshColors.onBackground60Secondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          
          // * AVAILABILITY BADGE
          if (service == 'Offline Support')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: CropFreshColors.green30Container,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: Text(
                '24/7',
                style: TextStyle(
                  color: CropFreshColors.green30Forest,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getServiceDescription(String service) {
    switch (service) {
      case 'Input Ordering':
        return 'Order seeds, fertilizers, pesticides and other farm inputs directly from trusted suppliers';
      case 'Logistics Booking':
        return 'Book transportation for your produce with real-time tracking and delivery confirmation';
      case 'Vet Services':
        return 'Connect with certified veterinarians for livestock health consultations and emergency care';
      case 'Offline Support':
        return 'Access essential features even without internet connection, sync when online';
      default:
        return 'Comprehensive farm management tools at your fingertips';
    }
  }
} 