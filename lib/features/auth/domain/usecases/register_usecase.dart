import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/core/usecase/app_usecase.dart';
import 'package:mediconnect/features/auth/data/repositories/auth_repository.dart';
import 'package:mediconnect/features/auth/domain/entities/auth_entity.dart';
import 'package:mediconnect/features/auth/domain/repositories/auth_repository.dart';

class RegisterUsecaseParams extends Equatable {
  final String fullName;
  final String email;
  final String password;
  final String? address;
  final String? phoneNumber;

  const RegisterUsecaseParams({
    required this.fullName,
    required this.email,
    required this.password,
    this.address,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [
    fullName,
    email,
    password,
    address,
    phoneNumber,
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
      fullName: params.fullName,
      email: params.email,
      password: params.password,
      address: params.address ?? '',
      phoneNumber: params.phoneNumber,
    );
    return _authRepository.register(entity);
  }
}