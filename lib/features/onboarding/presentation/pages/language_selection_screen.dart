import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'dart:math' as math;
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/localization_service.dart';

/// * LANGUAGE SELECTION SCREEN - FOURTH ONBOARDING PAGE
/// * Features: Multi-language support, audio preview, cultural adaptation
/// * Supports Kannada, Telugu, Hindi, English with flag icons and native script
class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen>
    with TickerProviderStateMixin {
  
  // * ANIMATION CONTROLLERS
  late AnimationController _fadeController;
  late AnimationController _cardController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _cardScale;
  
  // * SELECTED LANGUAGE STATE
  String _selectedLanguage = 'kannada';
  
  // * LANGUAGE DATA
  final List<LanguageOption> _languageOptions = [
    LanguageOption(
      code: 'kannada',
      name: 'ಕನ್ನಡ',
      englishName: 'Kannada',
      flag: '🇮🇳',
      region: 'Karnataka',
      greeting: 'ನಮಸ್ಕಾರ',
      sample: 'ಕೃಷಿ ತಂತ್ರಜ್ಞಾನದೊಂದಿಗೆ ಬೆಳೆಗಾರಿಕೆಯನ್ನು ಬದಲಾಯಿಸಿ',
    ),
    LanguageOption(
      code: 'telugu',
      name: 'తెలుగు',
      englishName: 'Telugu',
      flag: '🇮🇳',
      region: 'Andhra Pradesh & Telangana',
      greeting: 'నమస్కారం',
      sample: 'వ్యవసాయ సాంకేతికతతో మీ వ్యవసాయాన్ని మార్చండి',
    ),
    LanguageOption(
      code: 'hindi',
      name: 'हिन्दी',
      englishName: 'Hindi',
      flag: '🇮🇳',
      region: 'India',
      greeting: 'नमस्ते',
      sample: 'कृषि प्रौद्योगिकी के साथ अपनी खेती को बदलें',
    ),
    LanguageOption(
      code: 'english',
      name: 'English',
      englishName: 'English',
      flag: '🌍',
      region: 'Global',
      greeting: 'Hello',
      sample: 'Transform your farming with agricultural technology',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _cardScale = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.elasticOut,
    ));
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _cardController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenHeight > 800;
    
    return Scaffold(
      backgroundColor: CropFreshColors.background60Surface,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildHeader(context, isTablet),
              Expanded(
                child: _buildLanguageSelection(context, isTablet),
              ),
              _buildContinueButton(context, isTablet),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 32 : 24),
      child: Column(
        children: [
          // * LOGO AND TITLE
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  CropFreshColors.green30Forest,
                  CropFreshColors.green10Primary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: CropFreshColors.green30Forest.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.language_rounded,
              size: isTablet ? 48 : 40,
              color: Colors.white,
            ),
          ),
          
          SizedBox(height: isTablet ? 24 : 16),
          
          Text(
            'Choose Your Language',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: CropFreshColors.green30Forest,
              fontWeight: FontWeight.bold,
              fontSize: isTablet ? 32 : 28,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: isTablet ? 12 : 8),
          
          Text(
            'ನಿಮ್ಮ ಭಾಷೆಯನ್ನು ಆರಿಸಿ • మీ భాషను ఎంచుకోండి • अपनी भाषा चुनें',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: CropFreshColors.onBackground60Secondary,
              fontSize: isTablet ? 16 : 14,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: isTablet ? 16 : 12),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: CropFreshColors.orange10Container,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Text(
              'Tap to hear pronunciation',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: CropFreshColors.orange10Primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelection(BuildContext context, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 24),
      child: AnimationLimiter(
        child: ListView.builder(
          itemCount: _languageOptions.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 600),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: _buildLanguageCard(
                    context,
                    _languageOptions[index],
                    index,
                    isTablet,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLanguageCard(BuildContext context, LanguageOption language, int index, bool isTablet) {
    final isSelected = _selectedLanguage == language.code;
    
    return ScaleTransition(
      scale: _cardScale,
      child: Container(
        margin: EdgeInsets.only(bottom: isTablet ? 20 : 16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _selectLanguage(language.code),
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.all(isTablet ? 24 : 20),
              decoration: BoxDecoration(
                color: isSelected 
                    ? CropFreshColors.green10Container
                    : CropFreshColors.background60Card,
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                border: Border.all(
                  color: isSelected 
                      ? CropFreshColors.green10Primary
                      : CropFreshColors.outline30Variant,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: CropFreshColors.green10Primary.withValues(alpha: 0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ] : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // * FLAG AND SELECTION INDICATOR
                  Container(
                    width: isTablet ? 60 : 50,
                    height: isTablet ? 60 : 50,
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? CropFreshColors.green10Primary
                          : CropFreshColors.outline30Variant.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          language.flag,
                          style: TextStyle(fontSize: isTablet ? 24 : 20),
                        ),
                        if (isSelected)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: CropFreshColors.green30Forest,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  SizedBox(width: isTablet ? 20 : 16),
                  
                  // * LANGUAGE INFO
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              language.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: isSelected 
                                    ? CropFreshColors.green30Forest
                                    : CropFreshColors.onBackground90Primary,
                                fontWeight: FontWeight.bold,
                                fontSize: isTablet ? 22 : 18,
                              ),
                            ),
                            if (language.code != 'english') ...[
                              SizedBox(width: isTablet ? 12 : 8),
                              Text(
                                '(${language.englishName})',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: CropFreshColors.onBackground60Secondary,
                                  fontSize: isTablet ? 16 : 14,
                                ),
                              ),
                            ],
                          ],
                        ),
                        
                        SizedBox(height: isTablet ? 8 : 4),
                        
                        Text(
                          language.region,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: CropFreshColors.onBackground60Secondary,
                            fontSize: isTablet ? 14 : 12,
                          ),
                        ),
                        
                        SizedBox(height: isTablet ? 12 : 8),
                        
                        // * SAMPLE TEXT
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? CropFreshColors.green30Container
                                : CropFreshColors.outline30Variant.withValues(alpha: 0.1),
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Text(
                            language.sample,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isSelected 
                                  ? CropFreshColors.green30Forest
                                  : CropFreshColors.onBackground60Secondary,
                              fontSize: isTablet ? 13 : 11,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // * AUDIO PLAY BUTTON
                  Container(
                    margin: EdgeInsets.only(left: isTablet ? 16 : 12),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _playAudioSample(language),
                        borderRadius: const BorderRadius.all(Radius.circular(25)),
                        child: Container(
                          width: isTablet ? 50 : 40,
                          height: isTablet ? 50 : 40,
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? CropFreshColors.orange10Primary
                                : CropFreshColors.outline30Variant.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.volume_up_rounded,
                            size: isTablet ? 24 : 20,
                            color: isSelected 
                                ? Colors.white
                                : CropFreshColors.onBackground60Secondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 32 : 24),
      child: Column(
        children: [
          // * SELECTED LANGUAGE PREVIEW
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  CropFreshColors.green10Container,
                  CropFreshColors.green30Container,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(16)),
            ),
            child: Column(
              children: [
                Text(
                  'Selected Language',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: CropFreshColors.green30Forest,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: isTablet ? 8 : 4),
                Text(
                  _languageOptions.firstWhere((lang) => lang.code == _selectedLanguage).greeting,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: CropFreshColors.green30Forest,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: isTablet ? 24 : 16),
          
          // * CONTINUE BUTTON
          SizedBox(
            width: double.infinity,
            height: isTablet ? 56 : 48,
            child: ElevatedButton(
              onPressed: _continueWithSelectedLanguage,
              style: ElevatedButton.styleFrom(
                backgroundColor: CropFreshColors.green10Primary,
                foregroundColor: Colors.white,
                elevation: 8,
                shadowColor: CropFreshColors.green10Primary.withValues(alpha: 0.3),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isTablet ? 18 : 16,
                    ),
                  ),
                  SizedBox(width: isTablet ? 12 : 8),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: isTablet ? 24 : 20,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: isTablet ? 16 : 12),
          
          // * CHANGE LATER NOTE
          Text(
            'You can change this later in Settings',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: CropFreshColors.onBackground60Secondary,
              fontSize: isTablet ? 14 : 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _selectLanguage(String languageCode) {
    if (_selectedLanguage != languageCode) {
      setState(() {
        _selectedLanguage = languageCode;
      });
      
      // * HAPTIC FEEDBACK
      HapticFeedback.lightImpact();
      
      // ! TODO: Update app language preference
      LocalizationService.setLanguage(languageCode);
    }
  }

  void _playAudioSample(LanguageOption language) {
    // * HAPTIC FEEDBACK
    HapticFeedback.selectionClick();
    
    // ! TODO: Implement text-to-speech for language sample
    // AudioService.speak(language.sample, language.code);
    
    // * Show temporary feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing: ${language.greeting}'),
        duration: const Duration(seconds: 1),
        backgroundColor: CropFreshColors.orange10Primary,
      ),
    );
  }

  void _continueWithSelectedLanguage() {
    // * HAPTIC FEEDBACK
    HapticFeedback.lightImpact();
    
    // ! SECURITY: Save language preference securely
    LocalizationService.saveLanguagePreference(_selectedLanguage);
    
    // * Navigate to authentication flow
    // TODO: Navigate to phone number entry screen
    Navigator.pushReplacementNamed(context, '/auth/phone-entry');
  }
}

/// * LANGUAGE OPTION DATA MODEL
class LanguageOption {
  final String code;
  final String name;
  final String englishName;
  final String flag;
  final String region;
  final String greeting;
  final String sample;

  const LanguageOption({
    required this.code,
    required this.name,
    required this.englishName,
    required this.flag,
    required this.region,
    required this.greeting,
    required this.sample,
  });
}

/// * CUSTOM PAINTER FOR CULTURAL BACKGROUND PATTERN
/// * Creates subtle cultural design elements
class CulturalPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CropFreshColors.green30Sage.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // * DRAW SUBTLE CULTURAL PATTERNS
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    // * CONCENTRIC CIRCLES (representing unity in diversity)
    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(
        Offset(centerX, centerY),
        30.0 + (i * 20.0),
        paint,
      );
    }
    
    // * SMALL DECORATIVE DOTS
    paint.style = PaintingStyle.fill;
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * (3.14159 / 180);
      final x = centerX + 60 * math.cos(angle);
      final y = centerY + 60 * math.sin(angle);
      
      canvas.drawCircle(
        Offset(x, y),
        2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 