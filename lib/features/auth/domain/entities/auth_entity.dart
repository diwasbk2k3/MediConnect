import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? authId;
  final String email;
  final String? password;
  final String? phoneNumber;

  const AuthEntity({
    this.authId,
    required this.email,
    this.password,
    this.phoneNumber,
  });

  AuthEntity copyWith({
    String? authId,
    String? email,
    String? password,
    String? phoneNumber,
  }) {
    return AuthEntity(
      authId: authId ?? this.authId,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  List<Object?> get props => [
    authId,
    email,
    password,
    phoneNumber
  ];
}
