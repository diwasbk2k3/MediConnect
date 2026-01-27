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

Map<String, dynamic> _$ProfileApiModelToJson(ProfileApiModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'phone': instance.phoneNumber,
      'gender': instance.gender,
      'age': instance.age,
      'medicalHistory': instance.medicalHistory,
    };
