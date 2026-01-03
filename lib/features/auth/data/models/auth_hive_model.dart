import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:mediconnect/core/constants/hive_table_constant.dart';
import 'package:mediconnect/features/auth/domain/entities/auth_entity.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.authTypeId)

class AuthHiveModel extends HiveObject {
  @HiveField(0)
  String? authId;

  @HiveField(1)
  String fullName;

  @HiveField(2)
  String email;

  @HiveField(3)
  String? password;

  @HiveField(4)
  String? phoneNumber;

  @HiveField(5)
  String address;

  @HiveField(6)
  String? profilePicture;

  AuthHiveModel({
    String? authId,
    required this.fullName,
    required this.email,
    this.password,
    this.phoneNumber,
    required this.address,
    this.profilePicture,
  }) : authId = authId ?? const Uuid().v4();


  // From Entity 
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      authId: entity.authId,
      fullName: entity.fullName,
      email: entity.email,
      password: entity.password,
      phoneNumber: entity.phoneNumber,
      address: entity.address,
      profilePicture: entity.profilePicture,
    );
  }

  // To Entity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: authId,
      fullName: fullName,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      address: address,
      profilePicture: profilePicture,
    );
  }

  // To Entity List
  static List<AuthEntity> toEntityList(List<AuthHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}