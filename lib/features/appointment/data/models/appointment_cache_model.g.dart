// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_cache_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppointmentCacheModelAdapter extends TypeAdapter<AppointmentCacheModel> {
  @override
  final int typeId = 4;

  @override
  AppointmentCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppointmentCacheModel(
      appointmentId: fields[0] as String?,
      patientId: fields[1] as String?,
      hospitalId: fields[2] as String?,
      hospitalName: fields[3] as String?,
      department: fields[4] as String?,
      appointmentType: fields[5] as String?,
      appointmentDate: fields[6] as String?,
      appointmentTime: fields[7] as String?,
      paymentAmount: fields[8] as double?,
      status: fields[9] as String?,
      cancellationReason: fields[10] as String?,
      createdAt: fields[11] as DateTime?,
      updatedAt: fields[12] as DateTime?,
      cachedAt: fields[13] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AppointmentCacheModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.appointmentId)
      ..writeByte(1)
      ..write(obj.patientId)
      ..writeByte(2)
      ..write(obj.hospitalId)
      ..writeByte(3)
      ..write(obj.hospitalName)
      ..writeByte(4)
      ..write(obj.department)
      ..writeByte(5)
      ..write(obj.appointmentType)
      ..writeByte(6)
      ..write(obj.appointmentDate)
      ..writeByte(7)
      ..write(obj.appointmentTime)
      ..writeByte(8)
      ..write(obj.paymentAmount)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.cancellationReason)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt)
      ..writeByte(13)
      ..write(obj.cachedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppointmentCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
