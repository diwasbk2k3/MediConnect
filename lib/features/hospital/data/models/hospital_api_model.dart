import 'package:json_annotation/json_annotation.dart';
import 'package:mediconnect/features/hospital/domain/entities/hospital_entity.dart';

part 'hospital_api_model.g.dart';

// Custom converter for departments list
List<Map<String, dynamic>>? _departmentsFromJson(List<dynamic>? json) {
  if (json == null) return null;
  return json.map((e) {
    if (e is Map<String, dynamic>) {
      return e;
    } else if (e is Map) {
      return Map<String, dynamic>.from(e);
    }
    return <String, dynamic>{};
  }).toList();
}

List<dynamic>? _departmentsToJson(List<Map<String, dynamic>>? value) {
  return value;
}

@JsonSerializable(includeIfNull: false)
class HospitalApiModel {
  final String? hospitalId;
  final String? name;
  final String? address;
  final String? phone;
  final String? description;
  @JsonKey(fromJson: _departmentsFromJson, toJson: _departmentsToJson)
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
      departments: _safeDepartments(departments),
      profileImageUrl: profileImageUrl,
      newAppointmentCharge: newAppointmentCharge,
      followUpAppointmentCharge: followUpAppointmentCharge,
    );
  }

  // Helper method to safely handle departments from JSON
  static List<Map<String, dynamic>>? _safeDepartments(
    List<Map<String, dynamic>>? departments,
  ) {
    if (departments == null) return null;
    return departments.map((dept) {
      return dept;
    }).toList();
  }
}