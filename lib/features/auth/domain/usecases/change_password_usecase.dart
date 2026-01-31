import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/core/usecase/app_usecase.dart';
import 'package:mediconnect/features/auth/data/repositories/auth_repository.dart';
import 'package:mediconnect/features/auth/domain/repositories/auth_repository.dart';

class ChangePasswordUsecaseParams extends Equatable {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  const ChangePasswordUsecaseParams({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword, confirmPassword];
}

// Provider
final changePasswordUsecaseProvider = Provider<ChangePasswordUsecase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return ChangePasswordUsecase(repository: repository);
});

class ChangePasswordUsecase implements UseCaseWithParams<void, ChangePasswordUsecaseParams> {
  final IAuthRepository _repository;

  ChangePasswordUsecase({required IAuthRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, String>> call(ChangePasswordUsecaseParams params) {
    return _repository.changePassword(
      params.currentPassword,
      params.newPassword,
      params.confirmPassword,
    );
  }
}
