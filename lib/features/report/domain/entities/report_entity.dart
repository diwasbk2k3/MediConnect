import 'package:equatable/equatable.dart';

class ReportEntity extends Equatable {
  final String? reportId;
  final String? appointmentId;
  final String? reportUrl;
  final String? remarks;
  final String? hospitalUsername;
  final String? department;
  final String? appointmentDate;
  final String? appointmentTime;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ReportEntity({
    this.reportId,
    this.appointmentId,
    this.reportUrl,
    this.remarks,
    this.hospitalUsername,
    this.department,
    this.appointmentDate,
    this.appointmentTime,
    this.createdAt,
    this.updatedAt,
  });

  ReportEntity copyWith({
    String? reportId,
    String? appointmentId,
    String? reportUrl,
    String? remarks,
    String? hospitalUsername,
    String? department,
    String? appointmentDate,
    String? appointmentTime,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReportEntity(
      reportId: reportId ?? this.reportId,
      appointmentId: appointmentId ?? this.appointmentId,
      reportUrl: reportUrl ?? this.reportUrl,
      remarks: remarks ?? this.remarks,
      hospitalUsername: hospitalUsername ?? this.hospitalUsername,
      department: department ?? this.department,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        reportId,
        appointmentId,
        reportUrl,
        remarks,
        hospitalUsername,
        department,
        appointmentDate,
        appointmentTime,
        createdAt,
        updatedAt,
      ];
}
