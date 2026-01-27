import 'package:json_annotation/json_annotation.dart';
import 'package:mediconnect/features/profile/domain/entities/profile_entity.dart';

part 'profile_api_model.g.dart';

@JsonSerializable()
class ProfileApiModel {
  final String? name;
  final String? address;
  @JsonKey(name: 'phone')
  final String? phoneNumber;
  final String? gender;
  final int? age;
  final String? medicalHistory;

  ProfileApiModel({
    this.name,
    this.address,
    this.phoneNumber,
    this.gender,
    this.age,
    this.medicalHistory,
  });

  // From Json
  factory ProfileApiModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileApiModelFromJson(json);

  // To Json
  Map<String, dynamic> toJson() => _$ProfileApiModelToJson(this);

  // from Entity
  factory ProfileApiModel.fromEntity(ProfileEntity entity) {
    return ProfileApiModel(
      name: entity.name,
      address: entity.address,
      phoneNumber: entity.phoneNumber,
      gender: entity.gender,
      age: entity.age,
      medicalHistory: entity.medicalHistory,
    );
  }

  // TO Entity
  ProfileEntity toEntity() {
    return ProfileEntity(
      name: name,
      address: address,
      phoneNumber: phoneNumber,
      gender: gender,
      age: age,
      medicalHistory: medicalHistory,
    );
  }
}
