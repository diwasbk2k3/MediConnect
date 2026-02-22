import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String? patientId;
  final String? name;
  final String? address;
  final String? phoneNumber;
  final String? gender;
  final int? age;
  final String? medicalHistory;

  const ProfileEntity({
    this.patientId,
    this.name,
    this.address,
    this.phoneNumber,
    this.gender,
    this.age,
    this.medicalHistory
  });

  ProfileEntity copyWith({
    String? patientId,
    String? name,
    String? address,
    String? phoneNumber,
    String? gender,
    int? age,
    String? medicalHistory,
  }) {
    return ProfileEntity(
      patientId: patientId ?? this.patientId,
      name: name ?? this.name,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      medicalHistory: medicalHistory ?? this.medicalHistory,
    );
  }

  @override
  List<Object?> get props => [
    patientId,
    name,
    address,
    phoneNumber,
    gender,
    age,
    medicalHistory,
  ];
}