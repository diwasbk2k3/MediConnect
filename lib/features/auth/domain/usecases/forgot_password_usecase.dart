import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/core/usecase/app_usecase.dart';
import 'package:mediconnect/features/auth/data/repositories/auth_repository.dart';
import 'package:mediconnect/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordUsecaseParams extends Equatable {
  final String email;

  const ForgotPasswordUsecaseParams({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}

// Provider
final forgotPasswordUsecaseProvider = Provider<ForgotPasswordUsecase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return ForgotPasswordUsecase(repository: repository);
});

class ForgotPasswordUsecase implements UseCaseWithParams<void, ForgotPasswordUsecaseParams> {
  final IAuthRepository _repository;

  ForgotPasswordUsecase({required IAuthRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, String>> call(ForgotPasswordUsecaseParams params) {
    return _repository.sendPasswordResetEmail(params.email);
  }
}
