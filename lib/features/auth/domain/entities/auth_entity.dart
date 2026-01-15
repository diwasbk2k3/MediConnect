import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? authId;
  final String email;
  final String? password;
  final String? confirmPassword;
  final String? phoneNumber;
  final bool? termsAgreed;

  const AuthEntity({
    this.authId,
    required this.email,
    this.password,
    this.confirmPassword,
    this.phoneNumber,
    this.termsAgreed,
  });

  AuthEntity copyWith({
    String? authId,
    String? email,
    String? password,
    String? confirmPassword,
    String? phoneNumber,
    bool? termsAgreed,
  }) {
    return AuthEntity(
      authId: authId ?? this.authId,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      termsAgreed: termsAgreed ?? this.termsAgreed,
    );
  }

  @override
  List<Object?> get props => [
    authId,
    email,
    password,
    confirmPassword,
    phoneNumber,
    termsAgreed,
  ];
}
