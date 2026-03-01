import 'package:hive_flutter/hive_flutter.dart';
import 'package:mediconnect/core/constants/hive_table_constant.dart';
import 'package:mediconnect/features/hospital/domain/entities/hospital_entity.dart';

part 'hospital_cache_model.g.dart';

@HiveType(typeId: HiveTableConstant.hospitalCacheTypeId)
class HospitalCacheModel extends HiveObject {
  @HiveField(0)
  String? hospitalId;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? address;

  @HiveField(3)
  String? phone;

  @HiveField(4)
  String? description;

  @HiveField(5)
  List<Map<String, dynamic>>? departments;

  @HiveField(6)
  double? rating;

  @HiveField(7)
  String? profileImageUrl;

  @HiveField(8)
  double? newAppointmentCharge;

  @HiveField(9)
  double? followUpAppointmentCharge;

  @HiveField(10)
  DateTime? cachedAt;

  HospitalCacheModel({
    this.hospitalId,
    this.name,
    this.address,
    this.phone,
    this.description,
    this.departments,
    this.rating,
    this.profileImageUrl,
    this.newAppointmentCharge,
    this.followUpAppointmentCharge,
    DateTime? cachedAt,
  }) : cachedAt = cachedAt ?? DateTime.now();

  // From Entity
  factory HospitalCacheModel.fromEntity(HospitalEntity entity) {
    return HospitalCacheModel(
      hospitalId: entity.hospitalId,
      name: entity.name,
      address: entity.address,
      phone: entity.phone,
      description: entity.description,
      departments: _convertDepartments(entity.departments),
      rating: entity.rating,
      profileImageUrl: entity.profileImageUrl,
      newAppointmentCharge: entity.newAppointmentCharge,
      followUpAppointmentCharge: entity.followUpAppointmentCharge,
      cachedAt: DateTime.now(),
    );
  }

  // To Entity
  HospitalEntity toEntity() {
    return HospitalEntity(
      hospitalId: hospitalId,
      name: name,
      address: address,
      phone: phone,
      description: description,
      departments: _safeDepartments(departments),
      rating: rating,
      profileImageUrl: profileImageUrl,
      newAppointmentCharge: newAppointmentCharge,
      followUpAppointmentCharge: followUpAppointmentCharge,
    );
  }

  // Helper method to safely convert departments to List<Map<String, dynamic>>
  static List<Map<String, dynamic>>? _convertDepartments(
    List<Map<String, dynamic>>? departments,
  ) {
    if (departments == null) return null;
    return departments
        .map((dept) => Map<String, dynamic>.from(dept))
        .toList();
  }

  // Helper method to safely handle departments when converting from cache
  static List<Map<String, dynamic>>? _safeDepartments(
    List<Map<String, dynamic>>? departments,
  ) {
    if (departments == null) return null;
    return departments
        .map((dept) {
          if (dept is Map<String, dynamic>) {
            return dept;
          }
          // Handle case where it comes as Map<dynamic, dynamic>
          return Map<String, dynamic>.from(dept);
        })
        .toList();
  }

  // Copy with
  HospitalCacheModel copyWith({
    String? hospitalId,
    String? name,
    String? address,
    String? phone,
    String? description,
    List<Map<String, dynamic>>? departments,
    double? rating,
    String? profileImageUrl,
    double? newAppointmentCharge,
    double? followUpAppointmentCharge,
    DateTime? cachedAt,
  }) {
    return HospitalCacheModel(
      hospitalId: hospitalId ?? this.hospitalId,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      description: description ?? this.description,
      departments: departments ?? this.departments,
      rating: rating ?? this.rating,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      newAppointmentCharge: newAppointmentCharge ?? this.newAppointmentCharge,
      followUpAppointmentCharge: followUpAppointmentCharge ?? this.followUpAppointmentCharge,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }
}
