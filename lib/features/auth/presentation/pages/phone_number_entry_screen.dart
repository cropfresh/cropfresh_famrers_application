import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/colors.dart';
import '../../../../shared/widgets/fade_in_animation.dart';
import '../widgets/country_code_picker.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/gradient_button.dart';

/// * PHONE NUMBER ENTRY SCREEN
/// * First step in registration - collects phone number with country code
/// * Features Material 3 design with 60-30-10 color implementation
class PhoneNumberEntryScreen extends StatefulWidget {
  const PhoneNumberEntryScreen({super.key});

  @override
  State<PhoneNumberEntryScreen> createState() => _PhoneNumberEntryScreenState();
}

class _PhoneNumberEntryScreenState extends State<PhoneNumberEntryScreen>
    with TickerProviderStateMixin {
  
  // * ANIMATION CONTROLLERS
  late AnimationController _fadeController;
  late AnimationController _slideController;
  
  // * FORM CONTROLLERS
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  
  // * STATE VARIABLES
  String _selectedCountryCode = '+91'; // Default to India
  String _countryName = 'India';
  String _countryFlag = '🇮🇳';
  bool _isPhoneValid = false;
  bool _isLoading = false;
  String? _errorMessage;
  
  // * FORM KEY
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    _initializePhoneDetection();
    
    // * Listen to phone number changes for real-time validation
    _phoneController.addListener(_validatePhoneNumber);
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _fadeController.forward();
    
    await Future.delayed(const Duration(milliseconds: 200));
    _slideController.forward();
  }

  void _initializePhoneDetection() {
    // TODO: Implement SIM card phone number detection
    // * This would integrate with device APIs to auto-fill phone number
    // * For now, we'll use manual entry
  }

  void _validatePhoneNumber() {
    final phone = _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');
    
    setState(() {
      _errorMessage = null;
      
      // * Indian phone number validation (10 digits)
      if (_selectedCountryCode == '+91') {
        _isPhoneValid = phone.length == 10 && 
                       phone.startsWith(RegExp(r'[6789]')); // Valid Indian mobile prefixes
      } else {
        // * Basic validation for other countries (minimum 7 digits)
        _isPhoneValid = phone.length >= 7 && phone.length <= 15;
      }
    });
  }

  String _formatPhoneNumber(String input) {
    final digits = input.replaceAll(RegExp(r'[^\d]'), '');
    
    if (_selectedCountryCode == '+91' && digits.length <= 10) {
      // * Format Indian phone numbers as XXXXX XXXXX
      if (digits.length > 5) {
        return '${digits.substring(0, 5)} ${digits.substring(5)}';
      }
      return digits;
    }
    
    // * Basic formatting for other countries
    return digits;
  }

  void _onCountrySelected(String countryCode, String countryName, String flag) {
    setState(() {
      _selectedCountryCode = countryCode;
      _countryName = countryName;
      _countryFlag = flag;
    });
    _validatePhoneNumber();
  }

  void _sendOTP() async {
    if (!_isPhoneValid || _isLoading) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    // * Haptic feedback
    HapticFeedback.lightImpact();
    
    try {
      final phoneNumber = _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');
      final fullPhoneNumber = '$_selectedCountryCode$phoneNumber';
      
      // * API call to send OTP
      // TODO: Implement actual API call
      await _mockSendOTP(fullPhoneNumber);
      
      // * Navigate to OTP verification screen
      if (mounted) {
        Navigator.pushNamed(
          context,
          '/otp-verification',
          arguments: {
            'phoneNumber': fullPhoneNumber,
            'countryCode': _selectedCountryCode,
            'countryName': _countryName,
          },
        );
      }
      
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to send OTP. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _mockSendOTP(String phoneNumber) async {
    // * Mock API call - replace with actual implementation
    await Future.delayed(const Duration(seconds: 2));
    
    // * Simulate potential errors
    if (phoneNumber.endsWith('0000')) {
      throw Exception('Invalid phone number');
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CropFreshColors.background60Primary,
      appBar: _buildAppBar(),
      body: FadeInAnimation(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // * HEADER SECTION
                  _buildHeaderSection(),
                  
                  const SizedBox(height: 40),
                  
                  // * PHONE INPUT SECTION
                  Expanded(
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _slideController,
                        curve: Curves.easeOutCubic,
                      )),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // * PHONE NUMBER INPUT
                          _buildPhoneNumberInput(),
                          
                          const SizedBox(height: 16),
                          
                          // * ERROR MESSAGE
                          if (_errorMessage != null) _buildErrorMessage(),
                          
                          const SizedBox(height: 24),
                          
                          // * HELP TEXT
                          _buildHelpText(),
                          
                          const Spacer(),
                          
                          // * CONTINUE BUTTON
                          _buildContinueButton(),
                          
                          const SizedBox(height: 16),
                          
                          // * TERMS AND CONDITIONS
                          _buildTermsText(),
                        ],
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

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: CropFreshColors.background60Primary,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          Icons.arrow_back,
          color: CropFreshColors.green30Primary,
        ),
      ),
      title: Text(
        'Create Account',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: CropFreshColors.green30Primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // * TITLE
        Text(
          'Enter your phone number',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: CropFreshColors.onBackground60,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // * SUBTITLE
        Text(
          'We\'ll send you a verification code to confirm your number',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: CropFreshColors.onBackground60Secondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // * LABEL
        Text(
          'Phone Number',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: CropFreshColors.onBackground60,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        const SizedBox(height: 12),
        
        // * INPUT FIELD WITH COUNTRY CODE
        Container(
          decoration: BoxDecoration(
            color: CropFreshColors.background60Secondary,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            border: Border.all(
              color: _phoneFocusNode.hasFocus 
                  ? CropFreshColors.green30Primary
                  : CropFreshColors.onBackground60Disabled,
              width: _phoneFocusNode.hasFocus ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // * COUNTRY CODE PICKER
              IntrinsicWidth(
                child: InkWell(
                  onTap: () => _showCountryPicker(),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _countryFlag,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _selectedCountryCode,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: CropFreshColors.onBackground60,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: CropFreshColors.onBackground60Secondary,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // * VERTICAL DIVIDER
              Container(
                width: 1,
                height: 56,
                color: CropFreshColors.onBackground60Disabled,
              ),
              
              // * PHONE NUMBER INPUT
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  focusNode: _phoneFocusNode,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(
                      _selectedCountryCode == '+91' ? 10 : 15,
                    ),
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      final formatted = _formatPhoneNumber(newValue.text);
                      return TextEditingValue(
                        text: formatted,
                        selection: TextSelection.collapsed(
                          offset: formatted.length,
                        ),
                      );
                    }),
                  ],
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: CropFreshColors.onBackground60,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: _selectedCountryCode == '+91' 
                        ? '98765 43210'
                        : 'Enter phone number',
                    hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: CropFreshColors.onBackground60Tertiary,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                  ),
                  onChanged: (value) => _validatePhoneNumber(),
                ),
              ),
              
              // * VALIDATION INDICATOR
              if (_phoneController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(
                    _isPhoneValid ? Icons.check_circle : Icons.error,
                    color: _isPhoneValid 
                        ? CropFreshColors.successPrimary
                        : CropFreshColors.errorPrimary,
                    size: 20,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CropFreshColors.errorContainer,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: CropFreshColors.errorPrimary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: CropFreshColors.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpText() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CropFreshColors.green30Container,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: CropFreshColors.green30Primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Why do we need your phone number?',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: CropFreshColors.onGreen30Container,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'We use your phone number to secure your account and send important updates about your farming activities.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: CropFreshColors.onGreen30Container,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isPhoneValid && !_isLoading ? _sendOTP : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isPhoneValid 
              ? CropFreshColors.green30Primary
              : CropFreshColors.onBackground60Disabled,
          foregroundColor: Colors.white,
          elevation: _isPhoneValid ? 4 : 0,
          shadowColor: CropFreshColors.green30Primary.withValues(alpha: 0.3),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        child: _isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.sms, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    'Send Verification Code',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTermsText() {
    return Text.rich(
      TextSpan(
        text: 'By continuing, you agree to our ',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: CropFreshColors.onBackground60Secondary,
        ),
        children: [
          TextSpan(
            text: 'Terms of Service',
            style: TextStyle(
              color: CropFreshColors.green30Primary,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w600,
            ),
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: TextStyle(
              color: CropFreshColors.green30Primary,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => CountryCodePicker(
        selectedCountryCode: _selectedCountryCode,
        onCountrySelected: _onCountrySelected,
      ),
    );
  }
} 