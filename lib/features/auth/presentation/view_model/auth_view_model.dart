import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    return const AuthState();
  }

  // Register method
  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    String? phoneNumber,
    String? address,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    final params = RegisterUsecaseParams(
      fullName: fullName,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      address: address,
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
}
