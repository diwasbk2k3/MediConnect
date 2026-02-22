import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/core/usecase/app_usecase.dart';
import 'package:mediconnect/features/hospital/data/repositories/hospital_repository.dart';
import 'package:mediconnect/features/hospital/domain/entities/hospital_entity.dart';
import 'package:mediconnect/features/hospital/domain/repositories/hospital_repository.dart';

// Provider
final getAllApprovedHospitalsUsecaseProvider =
    Provider<GetAllApprovedHospitalsUsecase>((ref) {
  final repository = ref.read(remoteHospitalRepositoryProvider);
  return GetAllApprovedHospitalsUsecase(repository: repository);
});

class GetAllApprovedHospitalsUsecase
    implements UseCaseWithoutParams<List<HospitalEntity>> {
  final IHospitalRepository _repository;

  GetAllApprovedHospitalsUsecase({required IHospitalRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, List<HospitalEntity>>> call() {
    return _repository.getAllApprovedHospitals();
  }
}
