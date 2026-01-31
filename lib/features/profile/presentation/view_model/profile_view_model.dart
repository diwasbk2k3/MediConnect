import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/features/profile/domain/usecases/create_patient_profile_usecase.dart';
import 'package:mediconnect/features/profile/domain/usecases/fetch_patient_profile_usecase.dart';
import 'package:mediconnect/features/profile/domain/usecases/update_patient_image_usecase.dart';
import 'package:mediconnect/features/profile/domain/usecases/update_patient_profile_info_usecase.dart';
import 'package:mediconnect/features/profile/presentation/state/profile_state.dart';

final profileViewModelProvider =
    NotifierProvider<ProfileViewModel, ProfileState>(() => ProfileViewModel());

class ProfileViewModel extends Notifier<ProfileState> {
  late final UpdatePatientImageUsecase _updatePatientProfileImageUsecase;
  late final FetchPatientProfileDataUsecase _fetchPatientProfileUsecase;
  late final CreatePatientProfileUsecase _createPatientProfileUsecase;
  late final UpdatePatientProfileInfoUsecase _updatePatientProfileInfoUsecase;
  @override
  ProfileState build() {
    _updatePatientProfileImageUsecase = ref.read(
      updatePatientProfileImageUsecaseProvider,
    );
    _fetchPatientProfileUsecase = ref.read(fetchPatientProfileUsecaseProvider);
    _createPatientProfileUsecase = ref.read(
      createPatientProfileUsecaseProvider,
    );
    _updatePatientProfileInfoUsecase = ref.read(
      updatePatientProfileInfoUsecaseProvider,
    );

    return const ProfileState();
  }

  /// Fetch patient profile data from server
  Future<void> fetchPatientProfileData() async {
    state = state.copyWith(status: ProfileStatus.loading);

    final result = await _fetchPatientProfileUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        );
      },
      (profileData) {
        state = state.copyWith(
          status: ProfileStatus.loaded,
          patientId: profileData['patientId'] as String?,
          name: profileData['name'] as String?,
          address: profileData['address'] as String?,
          phoneNumber: profileData['phone'] as String?,
          gender: profileData['gender'] as String?,
          age: profileData['age'] as int?,
          medicalHistory: profileData['medicalHistory'] as String?,
          profileImageUrl: profileData['profileImageUrl'] as String?,
        );
      },
    );
  }

  // Create patient profile
  Future<void> createPatientProfile({
    required String name,
    required String address,
    required String phoneNumber,
    required String gender,
    required int age,
    String? medicalHistory,
  }) async {
    state = state.copyWith(status: ProfileStatus.loading);

    final params = CreatePatientProfileUsecaseParams(
      name: name,
      address: address,
      phoneNumber: phoneNumber,
      gender: gender,
      age: age,
      medicalHistory: medicalHistory,
    );
    final result = await _createPatientProfileUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        );
      },
      (profileEntity) {
        state = state.copyWith(status: ProfileStatus.created);
      },
    );
  }

  // Update patient profile info
  Future<void> updatePatientProfileInfo({
    String? name,
    String? address,
    String? phoneNumber,
    String? gender,
    int? age, 
    String? medicalHistory
  })async{
    state = state.copyWith(status: ProfileStatus.loading);

    final params = UpdatePatientProfileInfoUsecaseParams(
      name: name,
      address: address,
      phoneNumber: phoneNumber,
      gender: gender,
      age: age,
      medicalHistory: medicalHistory
    );
    final result = await _updatePatientProfileInfoUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        );
      },
      (profileEntity) {
        state = state.copyWith(status: ProfileStatus.updated);
      },
    );
  }
  

  /// Update patient profile image
  Future<void> updatePatientProfileImage(File image) async {
    state = state.copyWith(status: ProfileStatus.loading);

    final result = await _updatePatientProfileImageUsecase(image);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        );
      },
      (imageUrl) {
        state = state.copyWith(
          status: ProfileStatus.updated,
          profileImageUrl: imageUrl,
          resetProfileImage: true,
        );
      },
    );
  }
}
