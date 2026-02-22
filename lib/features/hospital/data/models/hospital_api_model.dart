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

  HospitalApiModel({
    this.hospitalId,
    this.name,
    this.address,
    this.phone,
    this.description,
    this.departments,
  });

  // From Json
  factory HospitalApiModel.fromJson(Map<String, dynamic> json) =>
      _$HospitalApiModelFromJson(json);

  // To Json
  Map<String, dynamic> toJson() => _$HospitalApiModelToJson(this);

  // To Entity (without rating)
  HospitalEntity toEntity({double? rating}) {
    return HospitalEntity(
      hospitalId: hospitalId,
      name: name,
      address: address,
      phone: phone,
      description: description,
      departments: departments,
      rating: rating,
    );
  }
}
