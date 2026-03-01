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
      departments: _departmentsFromJson(json['departments'] as List?),
      profileImageUrl: json['profileImageUrl'] as String?,
      newAppointmentCharge: (json['newAppointmentCharge'] as num?)?.toDouble(),
      followUpAppointmentCharge:
          (json['followUpAppointmentCharge'] as num?)?.toDouble(),
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
  writeNotNull('departments', _departmentsToJson(instance.departments));
  writeNotNull('profileImageUrl', instance.profileImageUrl);
  writeNotNull('newAppointmentCharge', instance.newAppointmentCharge);
  writeNotNull('followUpAppointmentCharge', instance.followUpAppointmentCharge);
  return val;
}
