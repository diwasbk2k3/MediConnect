import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/core/usecase/app_usecase.dart';
import 'package:mediconnect/features/hospital/data/repositories/hospital_repository.dart';
import 'package:mediconnect/features/hospital/domain/repositories/hospital_repository.dart';

// Provider
final getAverageRatingUsecaseProvider =
    Provider<GetAverageRatingUsecase>((ref) {
  final repository = ref.read(remoteHospitalRepositoryProvider);
  return GetAverageRatingUsecase(repository: repository);
});

class GetAverageRatingUsecaseParams extends Equatable {
  final String hospitalId;

  const GetAverageRatingUsecaseParams({required this.hospitalId});

  @override
  List<Object?> get props => [hospitalId];
}

class GetAverageRatingUsecase
    implements UseCaseWithParams<double, GetAverageRatingUsecaseParams> {
  final IHospitalRepository _repository;

  GetAverageRatingUsecase({required IHospitalRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, double>> call(GetAverageRatingUsecaseParams params) {
    return _repository.getAverageRatingOfHospital(params.hospitalId);
  }
}
