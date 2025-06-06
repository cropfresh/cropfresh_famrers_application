import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/country_code_picker.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/gradient_button.dart';
import 'otp_verification_screen.dart';

// * PHONE NUMBER ENTRY SCREEN
// * Primary authentication screen for phone number input
// * Features: Country code selection, phone validation, accessibility support

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen>
    with TickerProviderStateMixin {
  // * Controllers and Focus Management
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // * State Variables
  String _selectedCountryCode = '+91';
  String _selectedCountryFlag = '🇮🇳';
  String _selectedCountryName = 'India';
  bool _isPhoneValid = false;

  // * Animation Controllers
  late AnimationController _slideAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _setupListeners();
    _autoFillPhoneNumber();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    _slideAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  // * Animation Setup
  void _setupAnimations() {
    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeOut,
    ));

    // * Start animations
    _slideAnimationController.forward();
    _fadeAnimationController.forward();
  }

  // * Setup event listeners
  void _setupListeners() {
    _phoneController.addListener(_validatePhone);
  }

  // * Auto-fill phone number from device SIM (if available)
  void _autoFillPhoneNumber() {
    // TODO: Implement SIM card phone number detection
    // This would require platform channels or a plugin like sim_data
  }

  // * Real-time phone number validation
  void _validatePhone() {
    final phoneNumber = _phoneController.text.trim();
    final isValid = _isValidIndianPhoneNumber(phoneNumber);

    if (isValid != _isPhoneValid) {
      setState(() {
        _isPhoneValid = isValid;
      });
    }
  }

  // * Phone number validation logic
  bool _isValidIndianPhoneNumber(String phoneNumber) {
    // * Remove all non-digit characters
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // * Check for valid Indian mobile number pattern
    if (cleanNumber.length == 10) {
      // * Must start with 6, 7, 8, or 9
      return RegExp(r'^[6-9]\d{9}$').hasMatch(cleanNumber);
    }
    return false;
  }

  // * Format phone number with spaces for better readability
  String _formatPhoneNumber(String phoneNumber) {
    // * Remove all non-digit characters
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

    if (cleanNumber.length <= 5) {
      return cleanNumber;
    } else if (cleanNumber.length <= 10) {
      // * Format as: XXXXX XXXXX
      return '${cleanNumber.substring(0, 5)} ${cleanNumber.substring(5)}';
    }
    return cleanNumber;
  }

  // * Handle form submission
  void _handleSendOtp() {
    if (_formKey.currentState?.validate() ?? false) {
      final phoneNumber = _phoneController.text.replaceAll(RegExp(r'\D'), '');
      final fullPhoneNumber = '$_selectedCountryCode$phoneNumber';

      // * Send OTP request via BLoC
      context.read<AuthBloc>().add(
            SendOtpRequested(
              phoneNumber: fullPhoneNumber,
              countryCode: _selectedCountryCode,
            ),
          );
    }
  }

  // * Handle country code selection
  void _handleCountryCodeChange(String countryCode, String flag, String name) {
    setState(() {
      _selectedCountryCode = countryCode;
      _selectedCountryFlag = flag;
      _selectedCountryName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpSent) {
            // * Navigate to OTP verification screen
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OtpVerificationScreen(
                  phoneNumber: state.phoneNumber,
                  expiresAt: state.expiresAt,
                ),
              ),
            );
          } else if (state is AuthError) {
            // * Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: colorScheme.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // * Header Section
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enter Your Phone Number',
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'We\'ll send you a verification code to confirm your identity',
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 48),

                  // * Phone Input Section
                  SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Phone Number',
                          style: textTheme.labelLarge?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // * Phone Number Input Field with Country Code
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // * Country Code Picker
                            CountryCodePicker(
                              selectedCountryCode: _selectedCountryCode,
                              selectedCountryFlag: _selectedCountryFlag,
                              selectedCountryName: _selectedCountryName,
                              onCountryChanged: _handleCountryCodeChange,
                            ),

                            const SizedBox(width: 12),

                            // * Phone Number Input
                            Expanded(
                              child: CustomTextField(
                                controller: _phoneController,
                                focusNode: _phoneFocusNode,
                                labelText: 'Mobile Number',
                                hintText: '98765 43210',
                                keyboardType: TextInputType.phone,
                                maxLength: 12, // * Account for formatting
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                  TextInputFormatter.withFunction(
                                    (oldValue, newValue) {
                                      final formatted = _formatPhoneNumber(
                                        newValue.text,
                                      );
                                      return TextEditingValue(
                                        text: formatted,
                                        selection: TextSelection.collapsed(
                                          offset: formatted.length,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your phone number';
                                  }
                                  if (!_isValidIndianPhoneNumber(value)) {
                                    return 'Please enter a valid phone number';
                                  }
                                  return null;
                                },
                                suffixIcon: _isPhoneValid
                                    ? Icon(
                                        Icons.check_circle,
                                        color: colorScheme.primary,
                                      )
                                    : null,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // * Helper Text
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Standard SMS charges may apply',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // * Send OTP Button
                  SlideTransition(
                    position: _slideAnimation,
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final isLoading = state is AuthLoading;

                        return GradientButton(
                          onPressed: (_isPhoneValid && !isLoading)
                              ? _handleSendOtp
                              : null,
                          isLoading: isLoading,
                          text: 'Send OTP',
                          icon: Icons.arrow_forward_rounded,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // * Privacy Notice
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'By continuing, you agree to our Terms of Service and Privacy Policy',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
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
} 