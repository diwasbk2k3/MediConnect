import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/core/usecase/app_usecase.dart';
import 'package:mediconnect/features/auth/data/repositories/auth_repository.dart';
import 'package:mediconnect/features/auth/domain/repositories/auth_repository.dart';

class DeleteAccountUsecaseParams extends Equatable {
  final String password;

  const DeleteAccountUsecaseParams({
    required this.password,
  });

  @override
  List<Object?> get props => [password];
}

// Provider
final deleteAccountUsecaseProvider = Provider<DeleteAccountUsecase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return DeleteAccountUsecase(repository: repository);
});

class DeleteAccountUsecase implements UseCaseWithParams<String, DeleteAccountUsecaseParams> {
  final IAuthRepository _repository;

  DeleteAccountUsecase({required IAuthRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, String>> call(DeleteAccountUsecaseParams params) {
    return _repository.deleteAccount(params.password);
  }
}
