import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/core/usecase/app_usecase.dart';
import 'package:mediconnect/features/profile/data/repositories/profile_repository.dart';
import 'package:mediconnect/features/profile/domain/repositories/profile_repository.dart';

// Provider
final updatePatientProfileImageUsecaseProvider = Provider<UpdatePatientImageUsecase>((ref){
  final repository = ref.read(remoteProfileRepositoryProvider);
  return UpdatePatientImageUsecase(repository: repository);
});

class UpdatePatientImageUsecase implements UseCaseWithParams<String, File> {
  final IProfileRepository _repository;

  UpdatePatientImageUsecase({required IProfileRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, String>> call(File params) {
    return _repository.updatePatientProfileImage(params);
  }
}
