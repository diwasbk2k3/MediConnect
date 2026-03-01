import 'package:hive_flutter/hive_flutter.dart';
import 'package:mediconnect/core/constants/hive_table_constant.dart';
import 'package:mediconnect/features/appointment/domain/entities/appointment_entity.dart';

part 'appointment_cache_model.g.dart';

@HiveType(typeId: HiveTableConstant.appointmentCacheTypeId)
class AppointmentCacheModel extends HiveObject {
  @HiveField(0)
  String? appointmentId;

  @HiveField(1)
  String? patientId;

  @HiveField(2)
  String? hospitalId;

  @HiveField(3)
  String? hospitalName;

  @HiveField(4)
  String? department;

  @HiveField(5)
  String? appointmentType;

  @HiveField(6)
  String? appointmentDate;

  @HiveField(7)
  String? appointmentTime;

  @HiveField(8)
  double? paymentAmount;

  @HiveField(9)
  String? status;

  @HiveField(10)
  String? cancellationReason;

  @HiveField(11)
  DateTime? createdAt;

  @HiveField(12)
  DateTime? updatedAt;

  @HiveField(13)
  DateTime? cachedAt;

  AppointmentCacheModel({
    this.appointmentId,
    this.patientId,
    this.hospitalId,
    this.hospitalName,
    this.department,
    this.appointmentType,
    this.appointmentDate,
    this.appointmentTime,
    this.paymentAmount,
    this.status,
    this.cancellationReason,
    this.createdAt,
    this.updatedAt,
    DateTime? cachedAt,
  }) : cachedAt = cachedAt ?? DateTime.now();

  // From Entity
  factory AppointmentCacheModel.fromEntity(AppointmentEntity entity) {
    return AppointmentCacheModel(
      appointmentId: entity.appointmentId,
      patientId: entity.patientId,
      hospitalId: entity.hospitalId,
      hospitalName: entity.hospitalName,
      department: entity.department,
      appointmentType: entity.appointmentType,
      appointmentDate: entity.appointmentDate,
      appointmentTime: entity.appointmentTime,
      paymentAmount: entity.paymentAmount,
      status: entity.status,
      cancellationReason: entity.cancellationReason,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      cachedAt: DateTime.now(),
    );
  }

  // To Entity
  AppointmentEntity toEntity() {
    return AppointmentEntity(
      appointmentId: appointmentId,
      patientId: patientId,
      hospitalId: hospitalId,
      hospitalName: hospitalName,
      department: department,
      appointmentType: appointmentType,
      appointmentDate: appointmentDate,
      appointmentTime: appointmentTime,
      paymentAmount: paymentAmount,
      status: status,
      cancellationReason: cancellationReason,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Copy with
  AppointmentCacheModel copyWith({
    String? appointmentId,
    String? patientId,
    String? hospitalId,
    String? hospitalName,
    String? department,
    String? appointmentType,
    String? appointmentDate,
    String? appointmentTime,
    double? paymentAmount,
    String? status,
    String? cancellationReason,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? cachedAt,
  }) {
    return AppointmentCacheModel(
      appointmentId: appointmentId ?? this.appointmentId,
      patientId: patientId ?? this.patientId,
      hospitalId: hospitalId ?? this.hospitalId,
      hospitalName: hospitalName ?? this.hospitalName,
      department: department ?? this.department,
      appointmentType: appointmentType ?? this.appointmentType,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      paymentAmount: paymentAmount ?? this.paymentAmount,
      status: status ?? this.status,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }
}
