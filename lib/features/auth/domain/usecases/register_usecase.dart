import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/core/usecase/app_usecase.dart';
import 'package:mediconnect/features/auth/data/repositories/auth_repository.dart';
import 'package:mediconnect/features/auth/domain/entities/auth_entity.dart';
import 'package:mediconnect/features/auth/domain/repositories/auth_repository.dart';

class RegisterUsecaseParams extends Equatable {
  final String email;
  final String password;
  final String confirmPassword;
  final String? phoneNumber;
  final bool ? termsAgreed;

  const RegisterUsecaseParams({
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.phoneNumber,
    required this.termsAgreed
  });

  @override
  List<Object?> get props => [
    email,
    password,
    phoneNumber,
    termsAgreed
  ];
}

// Provider implementation for Register Usecase
final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return RegisterUsecase(authRepository: authRepository);
});

class RegisterUsecase implements UseCaseWithParams<AuthEntity, RegisterUsecaseParams>{
  final IAuthRepository _authRepository;

  RegisterUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, AuthEntity>> call(RegisterUsecaseParams params) {
    final entity = AuthEntity(
      email: params.email,
      password: params.password,
      confirmPassword: params.confirmPassword,
      phoneNumber: params.phoneNumber,
      termsAgreed: params.termsAgreed
    );
    return _authRepository.register(entity);
  }
}