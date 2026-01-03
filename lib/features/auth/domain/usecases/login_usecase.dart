import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/core/usecase/app_usecase.dart';
import 'package:mediconnect/features/auth/data/repositories/auth_repository.dart';
import 'package:mediconnect/features/auth/domain/entities/auth_entity.dart';
import 'package:mediconnect/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCaseParams extends Equatable {
  final String email;
  final String password;

  const LoginUseCaseParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

// Provider implementation for Login Usecase
final loginUsecaseProvider = Provider<LoginUsecase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return LoginUsecase(authRepository: authRepository);
});

class LoginUsecase
    implements UseCaseWithParams<AuthEntity, LoginUseCaseParams> {
  final IAuthRepository _authRepository;

  LoginUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, AuthEntity>> call(LoginUseCaseParams params) {
    return _authRepository.login(params.email, params.password);
  }
}