import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/otp_input_field.dart';
import '../widgets/gradient_button.dart';
import '../../../../core/constants/colors.dart';
import '../../../../shared/widgets/fade_in_animation.dart';

// * OTP VERIFICATION SCREEN
// * Handles OTP input, verification, and navigation to profile setup
// * Features: Auto-read SMS, resend logic, countdown timer

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen>
    with TickerProviderStateMixin {
  // * Controllers and Focus Management
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  // * State Variables
  String _otpCode = '';
  bool _isOtpComplete = false;
  int _remainingSeconds = 300; // Default 5 minutes
  Timer? _countdownTimer;
  bool _canResend = false;
  
  // * Route Arguments
  String _phoneNumber = '';
  String _countryCode = '';

  // * Animation Controllers
  late AnimationController _slideAnimationController;
  late AnimationController _fadeAnimationController;
  late AnimationController _shakeAnimationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _setupCountdown();
    _focusFirstField();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // * Get arguments from route
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _phoneNumber = args['phoneNumber'] ?? '';
      _countryCode = args['countryCode'] ?? '';
      final expiresAt = args['expiresAt'] as DateTime?;
      if (expiresAt != null) {
        final now = DateTime.now();
        _remainingSeconds = expiresAt.difference(now).inSeconds;
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    _countdownTimer?.cancel();
    _slideAnimationController.dispose();
    _fadeAnimationController.dispose();
    _shakeAnimationController.dispose();
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

    _shakeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
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

    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shakeAnimationController,
      curve: Curves.elasticIn,
    ));

    // * Start animations
    _slideAnimationController.forward();
    _fadeAnimationController.forward();
  }

  // * Setup countdown timer
  void _setupCountdown() {
    if (_remainingSeconds > 0) {
      _startCountdown();
    } else {
      setState(() {
        _canResend = true;
      });
    }
  }

  // * Start countdown timer
  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  // * Focus first empty field
  void _focusFirstField() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _otpFocusNodes[0].requestFocus();
    });
  }

  // * Handle OTP input change
  void _onOtpChanged(int index, String value) {
    setState(() {
      _otpControllers[index].text = value;
      
      // * Update complete OTP string
      _otpCode = _otpControllers.map((controller) => controller.text).join();
      _isOtpComplete = _otpCode.length == 6;
      
      // * Move to next field if current field is filled
      if (value.isNotEmpty && index < 5) {
        _otpFocusNodes[index + 1].requestFocus();
      }
      
      // * Move to previous field if current field is cleared
      if (value.isEmpty && index > 0) {
        _otpFocusNodes[index - 1].requestFocus();
      }
    });

    // * Auto-verify when OTP is complete
    if (_isOtpComplete) {
      _handleVerifyOtp();
    }
  }

  // * Handle backspace key
  void _onBackspacePressed(int index) {
    if (index > 0 && _otpControllers[index].text.isEmpty) {
      _otpFocusNodes[index - 1].requestFocus();
      _otpControllers[index - 1].clear();
      _onOtpChanged(index - 1, '');
    }
  }

  // * Handle OTP verification
  void _handleVerifyOtp() {
    if (_isOtpComplete) {
      final phoneNumber = _phoneNumber;
      
      context.read<AuthBloc>().add(
        VerifyOtpRequested(
          phoneNumber: phoneNumber,
          otp: _otpCode,
        ),
      );
    }
  }

  // * Handle resend OTP
  void _handleResendOtp() {
    if (_canResend) {
      // * Extract phone number and country code
      final phoneNumber = _phoneNumber;
      String countryCode = '+91';
      String cleanPhoneNumber = phoneNumber;

      if (phoneNumber.startsWith('+')) {
        // * Parse country code from full number
        final parts = phoneNumber.split(RegExp(r'(?<=\+\d{1,3})'));
        if (parts.length >= 2) {
          countryCode = parts[0];
          cleanPhoneNumber = parts[1];
        }
      }

      context.read<AuthBloc>().add(
        ResendOtpRequested(
          phoneNumber: cleanPhoneNumber,
          countryCode: countryCode,
        ),
      );

      // * Reset countdown
      setState(() {
        _canResend = false;
        _remainingSeconds = 300; // * 5 minutes
      });
      _startCountdown();
    }
  }

  // * Clear OTP fields on error
  void _clearOtpFields() {
    for (final controller in _otpControllers) {
      controller.clear();
    }
    setState(() {
      _otpCode = '';
      _isOtpComplete = false;
    });
    _focusFirstField();
  }

  // * Format time display
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // * Shake animation for errors
  void _triggerShakeAnimation() {
    _shakeAnimationController.forward().then((_) {
      _shakeAnimationController.reverse();
    });
  }

  // * Mock API call to verify OTP
  Future<void> _mockVerifyOtp() async {
    try {
      final phoneNumber = _phoneNumber;
      
      // * Mock API call - replace with actual implementation
      await Future.delayed(const Duration(seconds: 2));
      
      print('Verifying OTP: $_otpCode for phone: $phoneNumber');
      
      // * Mock success response
      if (_otpCode == '123456') {
        // * OTP is correct
        return;
      } else {
        throw Exception('Invalid OTP');
      }
    } catch (e) {
      throw Exception('OTP verification failed');
    }
  }

  // * Mock API call to resend OTP
  Future<void> _mockResendOtp() async {
    try {
      final phoneNumber = _phoneNumber;
      
      // * Mock API call - replace with actual implementation
      await Future.delayed(const Duration(seconds: 1));
      
      print('Resending OTP to: $phoneNumber');
      
      // * Reset timer
      setState(() {
        _remainingSeconds = 300; // 5 minutes
        _canResend = false;
      });
      
      _startCountdown();
    } catch (e) {
      throw Exception('Failed to resend OTP');
    }
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
          if (state is OtpVerified) {
            // * Navigate to profile setup screen after successful OTP verification
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/profile-setup',
              (route) => false,
            );
          } else if (state is AuthError) {
            // * Clear OTP fields and show error
            _clearOtpFields();
            _triggerShakeAnimation();
            
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
          } else if (state is OtpSent) {
            // * OTP resent successfully
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('OTP sent successfully'),
                backgroundColor: colorScheme.primary,
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
                        'Enter Verification Code',
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'We sent a 6-digit code to ${_phoneNumber}',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                // * OTP Input Section
                SlideTransition(
                  position: _slideAnimation,
                  child: AnimatedBuilder(
                    animation: _shakeAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          _shakeAnimation.value * 10 * 
                          (0.5 - _shakeAnimation.value).sign,
                          0,
                        ),
                        child: child,
                      );
                    },
                    child: Column(
                      children: [
                        // * OTP Input Fields
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(6, (index) {
                            return Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                child: OtpInputField(
                                  controller: _otpControllers[index],
                                  focusNode: _otpFocusNodes[index],
                                  onChanged: (value) => _onOtpChanged(index, value),
                                  onBackspacePressed: () => _onBackspacePressed(index),
                                ),
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 24),

                        // * Timer and Resend Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (!_canResend) ...[
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Resend in ${_formatTime(_remainingSeconds)}',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ] else ...[
                              TextButton(
                                onPressed: _handleResendOtp,
                                child: Text(
                                  'Resend OTP',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // * Help Section
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceVariant.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.help_outline,
                          color: colorScheme.onSurfaceVariant,
                          size: 24,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Didn\'t receive the code?',
                          style: textTheme.titleSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Check your SMS messages or wait for the timer to resend',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // * Verify Button
                SlideTransition(
                  position: _slideAnimation,
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;

                      return GradientButton(
                        onPressed: (_isOtpComplete && !isLoading)
                            ? _handleVerifyOtp
                            : null,
                        isLoading: isLoading,
                        text: 'Verify & Continue',
                        icon: Icons.verified_user_rounded,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // * Edit Phone Number
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Wrong number? Edit phone number',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 