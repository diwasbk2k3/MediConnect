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
