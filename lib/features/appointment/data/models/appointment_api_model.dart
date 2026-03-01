import 'package:json_annotation/json_annotation.dart';
import 'package:mediconnect/features/appointment/domain/entities/appointment_entity.dart';

part 'appointment_api_model.g.dart';

// Converter to keep hospital object intact for later extraction
Map<String, dynamic>? _hospitalObjectConverter(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  return null;
}

@JsonSerializable(includeIfNull: false)
class AppointmentApiModel {
  @JsonKey(name: '_id')
  final String? appointmentId;
  final String? patientId;
  @JsonKey(name: 'hospitalId', fromJson: _hospitalObjectConverter)
  final Map<String, dynamic>? _hospitalObj;
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

  // Extract hospital ID from object
  String? get hospitalId => 
    _hospitalObj?['_id'] is String ? _hospitalObj!['_id'] as String? : null;
  
  // Extract hospital name/username from object
  String? get hospitalName => 
    _hospitalObj?['username'] is String ? _hospitalObj!['username'] as String? : null;

  AppointmentApiModel({
    this.appointmentId,
    this.patientId,
    Map<String, dynamic>? hospitalObj,
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
  }) : _hospitalObj = hospitalObj;

  // From Json
  factory AppointmentApiModel.fromJson(Map<String, dynamic> json) {
    final model = _$AppointmentApiModelFromJson(json);
    
    // Handle both cases: hospitalId can be an object (from fetch) or a string (from booking)
    Map<String, dynamic>? hospitalObj;
    final hospitalIdValue = json['hospitalId'];
    
    if (hospitalIdValue is Map<String, dynamic>) {
      // Case 1: hospitalId is an object (from fetch appointments endpoint)
      hospitalObj = hospitalIdValue;
    } else if (hospitalIdValue is String) {
      // Case 2: hospitalId is a string (from booking appointment endpoint)
      // Convert simple string ID to object format
      hospitalObj = {'_id': hospitalIdValue};
    }
    
    return AppointmentApiModel(
      appointmentId: model.appointmentId,
      patientId: model.patientId,
      hospitalObj: hospitalObj,
      department: model.department,
      appointmentType: model.appointmentType,
      appointmentDate: model.appointmentDate,
      appointmentTime: model.appointmentTime,
      paymentAmount: model.paymentAmount,
      paymentMethod: model.paymentMethod,
      paymentStatus: model.paymentStatus,
      status: model.status,
      cancellationReason: model.cancellationReason,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

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
