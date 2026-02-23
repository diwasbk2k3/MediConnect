import 'package:json_annotation/json_annotation.dart';
import 'package:mediconnect/features/appointment/domain/entities/appointment_entity.dart';

part 'appointment_api_model.g.dart';

// Converter function to handle hospitalId if it comes as a Map or String
String? _hospitalIdConverter(dynamic value) {
  if (value is String) {
    return value;
  } else if (value is Map<String, dynamic>) {
    return value['_id'] as String?;
  }
  return null;
}

@JsonSerializable(includeIfNull: false)
class AppointmentApiModel {
  @JsonKey(name: '_id')
  final String? appointmentId;
  final String? patientId;
  @JsonKey(fromJson: _hospitalIdConverter)
  final String? hospitalId;
  final String? department;
  final String? appointmentType;
  final String? appointmentDate;
  final String? appointmentTime;
  final double? paymentAmount;
  final String? paymentMethod;
  final String? paymentStatus;
  final String? status;
  final String? cancellationReason;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Extractors
  String? get hospitalName => null; // Can be set later if needed

  AppointmentApiModel({
    this.appointmentId,
    this.patientId,
    this.hospitalId,
    this.department,
    this.appointmentType,
    this.appointmentDate,
    this.appointmentTime,
    this.paymentAmount,
    this.paymentMethod,
    this.paymentStatus,
    this.status,
    this.cancellationReason,
    this.createdAt,
    this.updatedAt,
  });

  // From Json
  factory AppointmentApiModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentApiModelFromJson(json);

  // To Json
  Map<String, dynamic> toJson() => _$AppointmentApiModelToJson(this);

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
}
