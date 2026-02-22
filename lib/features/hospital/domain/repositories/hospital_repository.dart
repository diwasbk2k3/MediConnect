import 'package:dartz/dartz.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/features/hospital/domain/entities/hospital_entity.dart';

abstract interface class IHospitalRepository {
  Future<Either<Failure, List<HospitalEntity>>> getAllApprovedHospitals();
  Future<Either<Failure, HospitalEntity>> getHospitalProfileInfo(String hospitalId);
  Future<Either<Failure, double>> getAverageRatingOfHospital(String hospitalId);
  Future<Either<Failure, bool>> giveRatingToHospital({required String hospitalId,required int rating});
}
