import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/core/usecase/app_usecase.dart';
import 'package:mediconnect/features/hospital/data/repositories/hospital_repository.dart';
import 'package:mediconnect/features/hospital/domain/entities/hospital_entity.dart';
import 'package:mediconnect/features/hospital/domain/repositories/hospital_repository.dart';

// Provider
final getHospitalProfileInfoUsecaseProvider =
    Provider<GetHospitalProfileInfoUsecase>((ref) {
  final repository = ref.read(remoteHospitalRepositoryProvider);
  return GetHospitalProfileInfoUsecase(repository: repository);
});

class GetHospitalProfileInfoUsecaseParams extends Equatable {
  final String hospitalId;

  const GetHospitalProfileInfoUsecaseParams({required this.hospitalId});

  @override
  List<Object?> get props => [hospitalId];
}

class GetHospitalProfileInfoUsecase
    implements UseCaseWithParams<HospitalEntity, GetHospitalProfileInfoUsecaseParams> {
  final IHospitalRepository _repository;

  GetHospitalProfileInfoUsecase({required IHospitalRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, HospitalEntity>> call(
      GetHospitalProfileInfoUsecaseParams params) {
    return _repository.getHospitalProfileInfo(params.hospitalId);
  }
}
