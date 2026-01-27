import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/core/usecase/app_usecase.dart';
import 'package:mediconnect/features/profile/data/repositories/profile_repository.dart';
import 'package:mediconnect/features/profile/domain/repositories/profile_repository.dart';

// Provider
final fetchPatientProfileUsecaseProvider = Provider<FetchPatientProfileDataUsecase>((ref) {
  final repository = ref.read(remoteProfileRepositoryProvider);
  return FetchPatientProfileDataUsecase(repository: repository);
});

class FetchPatientProfileDataUsecase implements UseCaseWithoutParams<Map<String, dynamic>> {
  final IProfileRemoteRepository _repository;

  FetchPatientProfileDataUsecase({required IProfileRemoteRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, Map<String, dynamic>>> call() {
    return _repository.fetchPatientProfileData();
  }
}
