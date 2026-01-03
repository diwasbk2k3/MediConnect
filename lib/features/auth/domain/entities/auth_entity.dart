import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? userId;
  final String fullName;
  final String email;
  final String? password;
  final String? phoneNumber;
  final String address;
  final String? profilePicture;

  const AuthEntity({
    this.userId,
    required this.fullName,
    required this.email,
    this.password,
    this.phoneNumber,
    required this.address,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [
    userId,
    fullName,
    email,
    password,
    phoneNumber,
    address,
    profilePicture,
  ];
}
