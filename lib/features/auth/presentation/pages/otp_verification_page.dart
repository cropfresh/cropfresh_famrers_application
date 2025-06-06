// ===================================================================
// * OTP VERIFICATION PAGE
// * Purpose: OTP input and verification for authentication
// * Features: 6-digit OTP input, auto-fill, resend functionality
// ===================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

// Core imports
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';

// BLoC import
import '../bloc/auth_bloc.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  
  const OtpVerificationPage({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (index) => FocusNode());
  
  Timer? _resendTimer;
  int _resendCountdown = 30;
  bool _canResend = false;
  String _enteredOTP = '';

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    
    // Auto-focus on first input
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _otpFocusNodes[0].requestFocus();
    });
  }

  void _startResendTimer() {
    _canResend = false;
    _resendCountdown = 30;
    
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  void _onOTPChanged(String value, int index) {
    if (value.length == 1) {
      // Move to next field
      if (index < 5) {
        _otpFocusNodes[index + 1].requestFocus();
      } else {
        // Last digit entered, hide keyboard
        _otpFocusNodes[index].unfocus();
      }
    } else if (value.isEmpty && index > 0) {
      // Move to previous field on backspace
      _otpFocusNodes[index - 1].requestFocus();
    }
    
    // Update entered OTP
    _enteredOTP = _otpControllers.map((controller) => controller.text).join();
    
    // Auto-verify when all 6 digits are entered
    if (_enteredOTP.length == 6) {
      _verifyOTP();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go('/dashboard');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
            // Clear OTP fields on error
            _clearOTP();
          } else if (state is OtpSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('OTP sent successfully'),
                backgroundColor: Colors.green,
              ),
            );
            _startResendTimer();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // * Header
              const Text(
                'Enter verification code',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  children: [
                    const TextSpan(text: 'We sent a 6-digit code to '),
                    TextSpan(
                      text: widget.phoneNumber,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // * OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 45,
                    height: 55,
                    child: TextFormField(
                      controller: _otpControllers[index],
                      focusNode: _otpFocusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                        ),
                        contentPadding: const EdgeInsets.all(0),
                      ),
                      onChanged: (value) => _onOTPChanged(value, index),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),

              // * Resend OTP
              Center(
                child: Column(
                  children: [
                    Text(
                      'Didn\'t receive the code?',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_canResend)
                      TextButton(
                        onPressed: _resendOTP,
                        child: Text(
                          'Resend OTP',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      )
                    else
                      Text(
                        'Resend OTP in ${_resendCountdown}s',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // * Auto-verification note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue[700],
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'OTP will be verified automatically when you enter all 6 digits',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // * Verify button
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final isLoading = state is AuthLoading;
                  final isOTPComplete = _enteredOTP.length == 6;
                  
                  return SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isOTPComplete && !isLoading ? _verifyOTP : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        disabledBackgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Verify OTP',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _verifyOTP() {
    if (_enteredOTP.length == 6) {
      context.read<AuthBloc>().add(
        VerifyOtpRequested(
          phoneNumber: widget.phoneNumber,
          otp: _enteredOTP,
        ),
      );
    }
  }

  void _resendOTP() {
    // Extract phone number and country code from full phone number
    final phoneNumber = widget.phoneNumber.replaceFirst('+91', '');
    context.read<AuthBloc>().add(
      ResendOtpRequested(
        phoneNumber: phoneNumber,
        countryCode: '+91',
      ),
    );
    _clearOTP();
  }

  void _clearOTP() {
    setState(() {
      _enteredOTP = '';
      for (var controller in _otpControllers) {
        controller.clear();
      }
    });
    _otpFocusNodes[0].requestFocus();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
} 