import 'package:equatable/equatable.dart';

// * AUTH USER ENTITY
// * Domain layer representation of authenticated user

class AuthUser extends Equatable {
  final String id;
  final String phoneNumber;
  final String? name;
  final String? email;
  final String? profilePicture;
  final bool isNewUser;
  final DateTime? lastLoginAt;
  final List<String> roles;

  const AuthUser({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.email,
    this.profilePicture,
    required this.isNewUser,
    this.lastLoginAt,
    this.roles = const [],
  });

  // * Copy method for creating modified instances
  AuthUser copyWith({
    String? id,
    String? phoneNumber,
    String? name,
    String? email,
    String? profilePicture,
    bool? isNewUser,
    DateTime? lastLoginAt,
    List<String>? roles,
  }) {
    return AuthUser(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      isNewUser: isNewUser ?? this.isNewUser,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      roles: roles ?? this.roles,
    );
  }

  @override
  List<Object?> get props => [
        id,
        phoneNumber,
        name,
        email,
        profilePicture,
        isNewUser,
        lastLoginAt,
        roles,
      ];
}

// * AUTH SESSION ENTITY
// * Contains authentication session information

class AuthSession extends Equatable {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final AuthUser user;

  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.user,
  });

  // * Check if session is expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  // * Check if session is about to expire (within 5 minutes)
  bool get isNearExpiry =>
      DateTime.now().add(const Duration(minutes: 5)).isAfter(expiresAt);

  AuthSession copyWith({
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    AuthUser? user,
  }) {
    return AuthSession(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresAt, user];
} 