import 'dart:io';
import 'package:equatable/equatable.dart';

enum ProfileStatus { initial, loading, loaded, error, updated, deleted }

class ProfileState extends Equatable {
  final ProfileStatus status;

  final String? patientId;
  final String? name;
  final String? address;
  final String? phone;
  final String? gender;
  final int? age;
  final String? medicalHistory;

  // uploaded image file (local): store image name temporarily after upload
  final File? profileImage;

  // uploaded image url/name from server
  final String? profileImageUrl;

  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.patientId,
    this.name,
    this.address,
    this.phone,
    this.gender,
    this.age,
    this.medicalHistory,
    this.profileImage,
    this.profileImageUrl,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    String? patientId,
    String? name,
    String? address,
    String? phone,
    String? gender,
    int? age,
    String? medicalHistory,
    File? profileImage,
    bool resetProfileImage = false,
    String? profileImageUrl,
    bool resetProfileImageUrl = false,
    String? errorMessage,
    bool resetErrorMessage = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      patientId: patientId ?? this.patientId,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      profileImage: resetProfileImage
          ? null
          : (profileImage ?? this.profileImage),
      profileImageUrl: resetProfileImageUrl
          ? null
          : (profileImageUrl ?? this.profileImageUrl),
      errorMessage: resetErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    patientId,
    name,
    address,
    phone,
    gender,
    age,
    medicalHistory,
    profileImage,
    profileImageUrl,
    errorMessage,
  ];
}
