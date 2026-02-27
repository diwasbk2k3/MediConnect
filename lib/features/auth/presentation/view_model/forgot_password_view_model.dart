import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:mediconnect/features/auth/presentation/state/forgot_password_state.dart';

// Provider implementation for ForgotPasswordViewModel
final forgotPasswordViewModelProvider =
    NotifierProvider<ForgotPasswordViewModel, ForgotPasswordState>(
  () => ForgotPasswordViewModel(),
);

class ForgotPasswordViewModel extends Notifier<ForgotPasswordState> {
  late final ForgotPasswordUsecase _forgotPasswordUsecase;

  @override
  ForgotPasswordState build() {
    _forgotPasswordUsecase = ref.read(forgotPasswordUsecaseProvider);
    return const ForgotPasswordState();
  }

  // Send Password Reset Email method
  Future<void> sendPasswordResetEmail({required String email}) async {
    state = state.copyWith(status: ForgotPasswordStatus.loading);
    final params = ForgotPasswordUsecaseParams(email: email);
    final result = await _forgotPasswordUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: ForgotPasswordStatus.error,
          errorMessage: failure.message,
        );
      },
      (message) {
        state = state.copyWith(
          status: ForgotPasswordStatus.success,
          successMessage: message,
        );
      },
    );
  }

  // Reset state
  void resetState() {
    state = const ForgotPasswordState();
  }
}
