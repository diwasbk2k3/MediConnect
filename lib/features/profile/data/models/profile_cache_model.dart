import 'package:hive_flutter/hive_flutter.dart';
import 'package:mediconnect/core/constants/hive_table_constant.dart';
import 'package:mediconnect/features/profile/domain/entities/profile_entity.dart';

part 'profile_cache_model.g.dart';

@HiveType(typeId: HiveTableConstant.profileCacheTypeId)
class ProfileCacheModel extends HiveObject {
  @HiveField(0)
  String? patientId;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? address;

  @HiveField(3)
  String? phoneNumber;

  @HiveField(4)
  String? gender;

  @HiveField(5)
  int? age;

  @HiveField(6)
  String? medicalHistory;

  @HiveField(7)
  String? profileImageUrl;

  ProfileCacheModel({
    this.patientId,
    this.name,
    this.address,
    this.phoneNumber,
    this.gender,
    this.age,
    this.medicalHistory,
    this.profileImageUrl,
  });

  /// From Entity
  factory ProfileCacheModel.fromEntity(ProfileEntity entity) {
    return ProfileCacheModel(
      patientId: entity.patientId,
      name: entity.name,
      address: entity.address,
      phoneNumber: entity.phoneNumber,
      gender: entity.gender,
      age: entity.age,
      medicalHistory: entity.medicalHistory,
      profileImageUrl: entity.profileImageUrl,
    );
  }

  /// To Entity
  ProfileEntity toEntity() {
    return ProfileEntity(
      patientId: patientId,
      name: name,
      address: address,
      phoneNumber: phoneNumber,
      gender: gender,
      age: age,
      medicalHistory: medicalHistory,
      profileImageUrl: profileImageUrl,
    );
  }

  ProfileCacheModel copyWith({
    String? patientId,
    String? name,
    String? address,
    String? phoneNumber,
    String? gender,
    int? age,
    String? medicalHistory,
    String? profileImageUrl,
  }) {
    return ProfileCacheModel(
      patientId: patientId ?? this.patientId,
      name: name ?? this.name,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
