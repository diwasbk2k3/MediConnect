import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? authId;
  final String fullName;
  final String email;
  final String? password;
  final String? phoneNumber;
  final String address;
  final String? profilePicture;

  const AuthEntity({
    this.authId,
    required this.fullName,
    required this.email,
    this.password,
    this.phoneNumber,
    required this.address,
    this.profilePicture,
  });

  AuthEntity copyWith({
    String? authId,
    String? fullName,
    String? email,
    String? password,
    String? phoneNumber,
    String? address,
    String? profilePicture,
  }) {
    return AuthEntity(
      authId: authId ?? this.authId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  @override
  List<Object?> get props => [
    authId,
    fullName,
    email,
    password,
    phoneNumber,
    address,
    profilePicture,
  ];
}
