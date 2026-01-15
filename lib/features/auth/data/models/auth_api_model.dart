import 'package:mediconnect/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String email;
  final String? password;
  final String? confirmPassword;
  final String? phoneNumber;
  final bool? termsAgreed;

  AuthApiModel({
    required this.email,
    this.password,
    this.confirmPassword,
    this.phoneNumber,
    this.termsAgreed,
  });

  // from JSON
  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      email: json['email'] as String,
      password: json['password'] as String?,
      confirmPassword: json['confirmPassword'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      termsAgreed: json['termsAgreed'] as bool?,
    );
  }

  // to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'phoneNumber': phoneNumber,
      'termsAgreed': termsAgreed ?? false,
    };
  }

  // from Entity
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      email: entity.email,
      password: entity.password,
      confirmPassword: entity.confirmPassword,
      phoneNumber: entity.phoneNumber,
      termsAgreed: entity.termsAgreed,
    );
  }

  // to Entity
  AuthEntity toEntity() {
    return AuthEntity(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      phoneNumber: phoneNumber,
      termsAgreed: termsAgreed,
    );
  }

  // to Entity List
  static List<AuthEntity> toEntityList(List<AuthApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
