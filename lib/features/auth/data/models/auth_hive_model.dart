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
  String email;

  @HiveField(2)
  String? password;

  @HiveField(3)
  String? phoneNumber;

  @HiveField(4)
  String? profilePicture;

  AuthHiveModel({
    String? authId,
    required this.email,
    this.password,
    this.phoneNumber,
  }) : authId = authId ?? const Uuid().v4();


  // From Entity 
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      authId: entity.authId,
      email: entity.email,
      password: entity.password,
      phoneNumber: entity.phoneNumber,
    );
  }

  // To Entity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: authId,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
    );
  }

  // To Entity List
  static List<AuthEntity> toEntityList(List<AuthHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}