import 'package:mediconnect/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? authId;
  final String email;
  final String? password;
  final String? phoneNumber;

  AuthApiModel({
    this.authId,
    required this.email,
    this.password,
    this.phoneNumber,
  });

  // from JSON
  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      authId: json['authId'] as String?,
      email: json['email'] as String,
      password: json['password'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
    );
  }

  // to JSON
  Map<String, dynamic> toJson() {
    return {
      'authId': authId,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
    };
  }

  // from Entity
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      authId: entity.authId,
      email: entity.email,
      password: entity.password,
      phoneNumber: entity.phoneNumber,
    );
  }

  // to Entity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: authId,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
    );
  }

  // to Entity List
  static List<AuthEntity> toEntityList(List<AuthApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
