import 'package:mediconnect/features/report/domain/entities/report_entity.dart';

class ReportApiModel {
  final String? reportId;
  final String? appointmentId;
  final String? hospitalUsername;
  final String? department;
  final String? appointmentDate;
  final String? appointmentTime;
  final String? reportUrl;
  final String? remarks;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ReportApiModel({
    this.reportId,
    this.appointmentId,
    this.hospitalUsername,
    this.department,
    this.appointmentDate,
    this.appointmentTime,
    this.reportUrl,
    this.remarks,
    this.createdAt,
    this.updatedAt,
  });

  factory ReportApiModel.fromJson(Map<String, dynamic> json) {
    final appointmentId = json['appointmentId'] as Map<String, dynamic>?;
    
    return ReportApiModel(
      reportId: json['_id'] as String?,
      appointmentId: appointmentId?['_id'] as String?,
      hospitalUsername: _extractHospitalUsername(appointmentId),
      department: appointmentId?['department'] as String?,
      appointmentDate: appointmentId?['appointmentDate'] as String?,
      appointmentTime: appointmentId?['appointmentTime'] as String?,
      reportUrl: json['reportUrl'] as String?,
      remarks: json['remarks'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': reportId,
      'appointmentId': appointmentId,
      'reportUrl': reportUrl,
      'remarks': remarks,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  ReportEntity toEntity() {
    return ReportEntity(
      reportId: reportId,
      appointmentId: appointmentId,
      reportUrl: reportUrl,
      remarks: remarks,
      hospitalUsername: hospitalUsername,
      department: department,
      appointmentDate: appointmentDate,
      appointmentTime: appointmentTime,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

// Helper to extract hospital username from nested appointmentId object
String? _extractHospitalUsername(Map<String, dynamic>? appointmentId) {
  if (appointmentId == null) return null;
  final hospitalData = appointmentId['hospitalId'] as Map<String, dynamic>?;
  return hospitalData?['username'] as String?;
}
