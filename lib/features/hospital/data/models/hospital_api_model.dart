import 'package:json_annotation/json_annotation.dart';
import 'package:mediconnect/features/hospital/domain/entities/hospital_entity.dart';

part 'hospital_api_model.g.dart';

@JsonSerializable(includeIfNull: false)
class HospitalApiModel {
  final String? hospitalId;
  final String? name;
  final String? address;
  final String? phone;
  final String? description;
  final List<Map<String, dynamic>>? departments;
  final String? profileImageUrl;
  final double? newAppointmentCharge;
  final double? followUpAppointmentCharge;

  HospitalApiModel({
    this.hospitalId,
    this.name,
    this.address,
    this.phone,
    this.description,
    this.departments,
    this.profileImageUrl,
    this.newAppointmentCharge,
    this.followUpAppointmentCharge,
  });

  // From Json
  factory HospitalApiModel.fromJson(Map<String, dynamic> json) =>
      _$HospitalApiModelFromJson(json);

  // To Json
  Map<String, dynamic> toJson() => _$HospitalApiModelToJson(this);
 
  // To Entity
  HospitalEntity toEntity() {
    return HospitalEntity(
      hospitalId: hospitalId,
      name: name,
      address: address,
      phone: phone,
      description: description,
      departments: departments,
      profileImageUrl: profileImageUrl,
      newAppointmentCharge: newAppointmentCharge,
      followUpAppointmentCharge: followUpAppointmentCharge,
    );
  }
}