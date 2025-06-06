import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_response.g.dart';

// * AUTH RESPONSE MODELS
// * These models define the structure for authentication API responses

@JsonSerializable()
class SendOtpResponse extends Equatable {
  final bool success;
  final String message;
  
  @JsonKey(name: 'expires_at')
  final String? expiresAt;

  const SendOtpResponse({
    required this.success,
    required this.message,
    this.expiresAt,
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) =>
      _$SendOtpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendOtpResponseToJson(this);

  @override
  List<Object?> get props => [success, message, expiresAt];
}

@JsonSerializable()
class VerifyOtpResponse extends Equatable {
  final bool success;
  final String message;
  
  @JsonKey(name: 'access_token')
  final String? accessToken;
  
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;
  
  @JsonKey(name: 'expires_in')
  final int? expiresIn;
  
  @JsonKey(name: 'user_id')
  final String? userId;
  
  @JsonKey(name: 'is_new_user')
  final bool? isNewUser;

  const VerifyOtpResponse({
    required this.success,
    required this.message,
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.userId,
    this.isNewUser,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpResponseToJson(this);

  @override
  List<Object?> get props => [
        success,
        message,
        accessToken,
        refreshToken,
        expiresIn,
        userId,
        isNewUser,
      ];
} 