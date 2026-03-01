// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hospital_cache_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HospitalCacheModelAdapter extends TypeAdapter<HospitalCacheModel> {
  @override
  final int typeId = 3;

  @override
  HospitalCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HospitalCacheModel(
      hospitalId: fields[0] as String?,
      name: fields[1] as String?,
      address: fields[2] as String?,
      phone: fields[3] as String?,
      description: fields[4] as String?,
      departments: (fields[5] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, dynamic>())
          ?.toList(),
      rating: fields[6] as double?,
      profileImageUrl: fields[7] as String?,
      newAppointmentCharge: fields[8] as double?,
      followUpAppointmentCharge: fields[9] as double?,
      cachedAt: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, HospitalCacheModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.hospitalId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.departments)
      ..writeByte(6)
      ..write(obj.rating)
      ..writeByte(7)
      ..write(obj.profileImageUrl)
      ..writeByte(8)
      ..write(obj.newAppointmentCharge)
      ..writeByte(9)
      ..write(obj.followUpAppointmentCharge)
      ..writeByte(10)
      ..write(obj.cachedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HospitalCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
