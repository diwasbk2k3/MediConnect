// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hospital_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HospitalApiModel _$HospitalApiModelFromJson(Map<String, dynamic> json) =>
    HospitalApiModel(
      hospitalId: json['hospitalId'] as String?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      description: json['description'] as String?,
      departments: (json['departments'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      profileImageUrl: json['profileImageUrl'] as String?,
    );

Map<String, dynamic> _$HospitalApiModelToJson(HospitalApiModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('hospitalId', instance.hospitalId);
  writeNotNull('name', instance.name);
  writeNotNull('address', instance.address);
  writeNotNull('phone', instance.phone);
  writeNotNull('description', instance.description);
  writeNotNull('departments', instance.departments);
  writeNotNull('profileImageUrl', instance.profileImageUrl);
  return val;
}
