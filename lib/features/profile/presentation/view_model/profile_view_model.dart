import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/features/profile/domain/usecases/update_patient_image_usecase.dart';
import 'package:mediconnect/features/profile/presentation/state/profile_state.dart';

final profileViewModelProvider =
    NotifierProvider<ProfileViewModel, ProfileState>(
  ProfileViewModel.new,
);

class ProfileViewModel extends Notifier<ProfileState> {
  late final UpdatePatientImageUsecase
      _updatePatientProfileImageUsecase;

  @override
  ProfileState build() {
    _updatePatientProfileImageUsecase =
        ref.read(updatePatientProfileImageUsecaseProvider);

    return const ProfileState();
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
