import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_user.dart';

// * AUTH EVENTS
// * All possible authentication events

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SendOtpRequested extends AuthEvent {
  final String phoneNumber;
  final String countryCode;

  const SendOtpRequested({
    required this.phoneNumber,
    required this.countryCode,
  });

  @override
  List<Object?> get props => [phoneNumber, countryCode];
}

class VerifyOtpRequested extends AuthEvent {
  final String phoneNumber;
  final String otp;

  const VerifyOtpRequested({
    required this.phoneNumber,
    required this.otp,
  });

  @override
  List<Object?> get props => [phoneNumber, otp];
}

class ResendOtpRequested extends AuthEvent {
  final String phoneNumber;
  final String countryCode;

  const ResendOtpRequested({
    required this.phoneNumber,
    required this.countryCode,
  });

  @override
  List<Object?> get props => [phoneNumber, countryCode];
}

class LogoutRequested extends AuthEvent {}

class CheckAuthStatusRequested extends AuthEvent {}

// * AUTH STATES
// * All possible authentication states

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class OtpSent extends AuthState {
  final String phoneNumber;
  final String message;
  final DateTime expiresAt;

  const OtpSent({
    required this.phoneNumber,
    required this.message,
    required this.expiresAt,
  });

  @override
  List<Object?> get props => [phoneNumber, message, expiresAt];
}

class OtpVerified extends AuthState {
  final AuthSession session;

  const OtpVerified({required this.session});

  @override
  List<Object?> get props => [session];
}

class AuthAuthenticated extends AuthState {
  final AuthSession session;

  const AuthAuthenticated({required this.session});

  @override
  List<Object?> get props => [session];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  final String? errorCode;

  const AuthError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

// * AUTH BLOC
// * Manages authentication state and business logic

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // TODO: Inject AuthRepository when implementing backend integration
  // final AuthRepository _authRepository;

  AuthBloc() : super(AuthInitial()) {
    on<SendOtpRequested>(_onSendOtpRequested);
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
    on<ResendOtpRequested>(_onResendOtpRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatusRequested>(_onCheckAuthStatusRequested);
  }

  // * Handle OTP send request
  Future<void> _onSendOtpRequested(
    SendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      // * Validate phone number format
      if (!_isValidPhoneNumber(event.phoneNumber)) {
        emit(const AuthError(
          message: 'Please enter a valid phone number',
          errorCode: 'INVALID_PHONE_NUMBER',
        ));
        return;
      }

      // TODO: Implement actual API call
      // final response = await _authRepository.sendOtp(
      //   SendOtpRequest(
      //     phoneNumber: event.phoneNumber,
      //     countryCode: event.countryCode,
      //   ),
      // );

      // * Simulate API call for now
      await Future.delayed(const Duration(seconds: 2));

      // * Simulate successful response
      emit(OtpSent(
        phoneNumber: event.phoneNumber,
        message: 'OTP sent successfully to ${event.phoneNumber}',
        expiresAt: DateTime.now().add(const Duration(minutes: 5)),
      ));
    } catch (error) {
      emit(AuthError(
        message: 'Failed to send OTP. Please try again.',
        errorCode: 'OTP_SEND_FAILED',
      ));
    }
  }

  // * Handle OTP verification
  Future<void> _onVerifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      // * Validate OTP format
      if (!_isValidOtp(event.otp)) {
        emit(const AuthError(
          message: 'Please enter a valid 6-digit OTP',
          errorCode: 'INVALID_OTP',
        ));
        return;
      }

      // TODO: Implement actual API call
      // final response = await _authRepository.verifyOtp(
      //   VerifyOtpRequest(
      //     phoneNumber: event.phoneNumber,
      //     otp: event.otp,
      //   ),
      // );

      // * Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // * Simulate successful verification
      final user = AuthUser(
        id: 'user_123',
        phoneNumber: event.phoneNumber,
        isNewUser: true,
        lastLoginAt: DateTime.now(),
      );

      final session = AuthSession(
        accessToken: 'mock_access_token',
        refreshToken: 'mock_refresh_token',
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
        user: user,
      );

      emit(OtpVerified(session: session));
    } catch (error) {
      emit(const AuthError(
        message: 'Invalid OTP. Please try again.',
        errorCode: 'OTP_VERIFICATION_FAILED',
      ));
    }
  }

  // * Handle OTP resend request
  Future<void> _onResendOtpRequested(
    ResendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    // * Reuse the send OTP logic
    add(SendOtpRequested(
      phoneNumber: event.phoneNumber,
      countryCode: event.countryCode,
    ));
  }

  // * Handle logout request
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    // TODO: Implement actual logout logic
    // await _authRepository.logout();
    
    emit(AuthUnauthenticated());
  }

  // * Check authentication status
  Future<void> _onCheckAuthStatusRequested(
    CheckAuthStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    // TODO: Check stored session and validate tokens
    emit(AuthUnauthenticated());
  }

  // * Validation helpers
  bool _isValidPhoneNumber(String phoneNumber) {
    // * Remove spaces and special characters
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    // * Check if it's a valid Indian phone number (10 digits)
    return RegExp(r'^[6-9]\d{9}$').hasMatch(cleanNumber);
  }

  bool _isValidOtp(String otp) {
    // * Check if it's exactly 6 digits
    return RegExp(r'^\d{6}$').hasMatch(otp);
  }
} 