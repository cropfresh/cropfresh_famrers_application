import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_request.g.dart';

// * AUTH REQUEST MODELS
// * These models define the structure for authentication API requests

@JsonSerializable()
class SendOtpRequest extends Equatable {
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  
  @JsonKey(name: 'country_code')
  final String countryCode;

  const SendOtpRequest({
    required this.phoneNumber,
    required this.countryCode,
  });

  factory SendOtpRequest.fromJson(Map<String, dynamic> json) =>
      _$SendOtpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SendOtpRequestToJson(this);

  @override
  List<Object?> get props => [phoneNumber, countryCode];
}

@JsonSerializable()
class VerifyOtpRequest extends Equatable {
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  
  final String otp;

  const VerifyOtpRequest({
    required this.phoneNumber,
    required this.otp,
  });

  factory VerifyOtpRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpRequestToJson(this);

  @override
  List<Object?> get props => [phoneNumber, otp];
} 