// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_cache_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileCacheModelAdapter extends TypeAdapter<ProfileCacheModel> {
  @override
  final int typeId = 5;

  @override
  ProfileCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileCacheModel(
      patientId: fields[0] as String?,
      name: fields[1] as String?,
      address: fields[2] as String?,
      phoneNumber: fields[3] as String?,
      gender: fields[4] as String?,
      age: fields[5] as int?,
      medicalHistory: fields[6] as String?,
      profileImageUrl: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileCacheModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.patientId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.gender)
      ..writeByte(5)
      ..write(obj.age)
      ..writeByte(6)
      ..write(obj.medicalHistory)
      ..writeByte(7)
      ..write(obj.profileImageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
