// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentApiModel _$AppointmentApiModelFromJson(Map<String, dynamic> json) =>
    AppointmentApiModel(
      appointmentId: json['_id'] as String?,
      patientId: json['patientId'] as String?,
      hospitalId: _hospitalIdConverter(json['hospitalId']),
      department: json['department'] as String?,
      appointmentType: json['appointmentType'] as String?,
      appointmentDate: json['appointmentDate'] as String?,
      appointmentTime: json['appointmentTime'] as String?,
      paymentAmount: (json['paymentAmount'] as num?)?.toDouble(),
      paymentMethod: json['paymentMethod'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
      status: json['status'] as String?,
      cancellationReason: json['cancellationReason'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AppointmentApiModelToJson(AppointmentApiModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.appointmentId);
  writeNotNull('patientId', instance.patientId);
  writeNotNull('hospitalId', instance.hospitalId);
  writeNotNull('department', instance.department);
  writeNotNull('appointmentType', instance.appointmentType);
  writeNotNull('appointmentDate', instance.appointmentDate);
  writeNotNull('appointmentTime', instance.appointmentTime);
  writeNotNull('paymentAmount', instance.paymentAmount);
  writeNotNull('paymentMethod', instance.paymentMethod);
  writeNotNull('paymentStatus', instance.paymentStatus);
  writeNotNull('status', instance.status);
  writeNotNull('cancellationReason', instance.cancellationReason);
  writeNotNull('createdAt', instance.createdAt?.toIso8601String());
  writeNotNull('updatedAt', instance.updatedAt?.toIso8601String());
  return val;
}
