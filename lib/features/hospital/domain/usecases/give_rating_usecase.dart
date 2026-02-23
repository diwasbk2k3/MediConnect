import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/core/usecase/app_usecase.dart';
import 'package:mediconnect/features/hospital/data/repositories/hospital_repository.dart';
import 'package:mediconnect/features/hospital/domain/repositories/hospital_repository.dart';

// Provider
final giveRatingUsecaseProvider = Provider<GiveRatingUsecase>((ref) {
  final repository = ref.read(remoteHospitalRepositoryProvider);
  return GiveRatingUsecase(hospitalRepository: repository);
});

class GiveRatingUsecaseParams extends Equatable {
  final String hospitalId;
  final int rating;

  const GiveRatingUsecaseParams({
    required this.hospitalId,
    required this.rating,
  });

  @override
  List<Object?> get props => [hospitalId, rating];
}

class GiveRatingUsecase
    implements UseCaseWithParams<bool, GiveRatingUsecaseParams> {
  final IHospitalRepository _hospitalRepository;

  GiveRatingUsecase({required IHospitalRepository hospitalRepository})
    : _hospitalRepository = hospitalRepository;

  @override
  Future<Either<Failure, bool>> call(GiveRatingUsecaseParams params) async {
    return await _hospitalRepository.giveRatingToHospital(
      hospitalId: params.hospitalId,
      rating: params.rating,
    );
  }
}
