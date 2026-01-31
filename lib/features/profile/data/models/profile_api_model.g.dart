// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileApiModel _$ProfileApiModelFromJson(Map<String, dynamic> json) =>
    ProfileApiModel(
      name: json['name'] as String?,
      address: json['address'] as String?,
      phoneNumber: json['phone'] as String?,
      gender: json['gender'] as String?,
      age: (json['age'] as num?)?.toInt(),
      medicalHistory: json['medicalHistory'] as String?,
    );

Map<String, dynamic> _$ProfileApiModelToJson(ProfileApiModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('address', instance.address);
  writeNotNull('phone', instance.phoneNumber);
  writeNotNull('gender', instance.gender);
  writeNotNull('age', instance.age);
  writeNotNull('medicalHistory', instance.medicalHistory);
  return val;
}
