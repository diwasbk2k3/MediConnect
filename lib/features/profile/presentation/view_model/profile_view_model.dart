import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/features/profile/domain/usecases/fetch_patient_profile_usecase.dart';
import 'package:mediconnect/features/profile/domain/usecases/update_patient_image_usecase.dart';
import 'package:mediconnect/features/profile/presentation/state/profile_state.dart';

final profileViewModelProvider =
    NotifierProvider<ProfileViewModel, ProfileState>(
  ProfileViewModel.new,
);

class ProfileViewModel extends Notifier<ProfileState> {
  late final UpdatePatientImageUsecase
      _updatePatientProfileImageUsecase;
  late final FetchPatientProfileDataUsecase _fetchPatientProfileUsecase;

  @override
  ProfileState build() {
    _updatePatientProfileImageUsecase =
        ref.read(updatePatientProfileImageUsecaseProvider);
    _fetchPatientProfileUsecase =
        ref.read(fetchPatientProfileUsecaseProvider);

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
          phone: profileData['phone'] as String?,
          gender: profileData['gender'] as String?,
          age: profileData['age'] as int?,
          medicalHistory: profileData['medicalHistory'] as String?,
          profileImageUrl: profileData['profileImageUrl'] as String?,
        );
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

  /// Clear error message
  void clearError() {
    state = state.copyWith(resetErrorMessage: true);
  }

  /// Reset profile state (optional helper)
  void resetProfileState() {
    state = state.copyWith(
      status: ProfileStatus.initial,
      resetProfileImage: true,
      resetProfileImageUrl: true,
      resetErrorMessage: true,
    );
  }
}
