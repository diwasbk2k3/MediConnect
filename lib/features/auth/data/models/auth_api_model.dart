import 'package:json_annotation/json_annotation.dart';
import 'package:mediconnect/features/auth/domain/entities/auth_entity.dart';

part 'auth_api_model.g.dart';

@JsonSerializable()
class AuthApiModel {
  final String? email;
  final String? password;
  final String? confirmPassword;
  @JsonKey(name: 'phone')
  final String? phoneNumber;
  final bool? termsAgreed;

  AuthApiModel({
    this.email,
    this.password,
    this.confirmPassword,
    this.phoneNumber,
    this.termsAgreed,
  });

  // From Json
  factory AuthApiModel.fromJson(Map<String, dynamic> json) =>
      _$AuthApiModelFromJson(json);

  // To Json
  Map<String, dynamic> toJson() => _$AuthApiModelToJson(this);

  // From Entity
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      email: entity.email,
      password: entity.password,
      confirmPassword: entity.confirmPassword,
      phoneNumber: entity.phoneNumber,
      termsAgreed: entity.termsAgreed,
    );
  }

  // To Entity
  AuthEntity toEntity() {
    return AuthEntity(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      phoneNumber: phoneNumber,
      termsAgreed: termsAgreed,
    );
  }

  // To Entity List
  static List<AuthEntity> toEntityList(List<AuthApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
