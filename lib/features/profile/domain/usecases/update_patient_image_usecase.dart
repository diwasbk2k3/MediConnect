import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/core/usecase/app_usecase.dart';
import 'package:mediconnect/features/profile/data/repositories/profile_repository.dart';
import 'package:mediconnect/features/profile/domain/repositories/profile_repository.dart';

// Provider
final updatePatientProfileImage = Provider<UpdatePatientImageUsecase>((ref){
  final repository = ref.read(remoteProfileRepositoryProvider);
  return UpdatePatientImageUsecase(repository: repository);
});

class UpdatePatientImageUsecase implements UseCaseWithParams<void, File> {
  final IProfileRemoteRepository _repository;

  UpdatePatientImageUsecase({required IProfileRemoteRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, void>> call(File params) {
    return _repository.updatePatientProfileImage(params);
  }
}
