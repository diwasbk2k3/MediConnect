import 'package:equatable/equatable.dart';

class AppointmentEntity extends Equatable {
  final String? appointmentId;
  final String? patientId;
  final String? hospitalId;
  final String? hospitalName;
  final String? department;
  final String? appointmentType;
  final String? appointmentDate;
  final String? appointmentTime;
  final double? paymentAmount;
  final String? status;
  final String? cancellationReason;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AppointmentEntity({
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
  });

  AppointmentEntity copyWith({
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
  }) {
    return AppointmentEntity(
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
    );
  }

  // Convert to cache model for offline storage
  // Note: Uses AppointmentCacheModel.fromEntity() to avoid circular imports

  @override
  List<Object?> get props => [
    appointmentId,
    patientId,
    hospitalId,
    hospitalName,
    department,
    appointmentType,
    appointmentDate,
    appointmentTime,
    paymentAmount,
    status,
    cancellationReason,
    createdAt,
    updatedAt,
  ];
}
