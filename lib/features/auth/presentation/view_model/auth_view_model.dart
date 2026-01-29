import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:mediconnect/features/auth/domain/usecases/login_usecase.dart';
import 'package:mediconnect/features/auth/domain/usecases/register_usecase.dart';
import 'package:mediconnect/features/auth/presentation/state/auth_state.dart';

// Provider implementation for AuthViewModel
final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  () => AuthViewModel(),
);

class AuthViewModel extends Notifier<AuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;
  late final ChangePasswordUsecase _changePasswordUsecase;

  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    _changePasswordUsecase = ref.read(changePasswordUsecaseProvider);
    return const AuthState();
  }

  // Register method
  Future<void> register({
    required String email,
    required String password,
    required String confirmPassword,
    required bool termsAgreed,
    String? phoneNumber,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    final params = RegisterUsecaseParams(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      phoneNumber: phoneNumber,
      termsAgreed: termsAgreed,
    );
    final result = await _registerUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (authEntity) {
        state = state.copyWith(status: AuthStatus.registered);
      },
    );
  }

  // Login method
  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(status: AuthStatus.loading);
    final params = LoginUseCaseParams(email: email, password: password);
    final result = await _loginUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (authEntity) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          authEntity: authEntity,
        );
      },
    );
  }

  // Change Password method
  Future<void> changePassword({required String currentPassword, required String newPassword, required String confirmPassword}) async {
    state = state.copyWith(status: AuthStatus.loading);
    final params = ChangePasswordUsecaseParams(currentPassword: currentPassword, newPassword: newPassword, confirmPassword: confirmPassword);
    final result = await _changePasswordUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (message) {
        state = state.copyWith(
          status: AuthStatus.passwordChanged
        );
      },
    );
  }
}
