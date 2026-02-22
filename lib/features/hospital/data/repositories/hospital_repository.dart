import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/core/services/connectivity/network_info.dart';
import 'package:mediconnect/features/hospital/data/datasources/remote/hospital_remote_datasource.dart';
import 'package:mediconnect/features/hospital/domain/entities/hospital_entity.dart';
import 'package:mediconnect/features/hospital/domain/repositories/hospital_repository.dart';

// Provider
final remoteHospitalRepositoryProvider = Provider<IHospitalRepository>((ref) {
  final networkInfo = ref.read(networkInfoProvider);
  final hospitalRemoteDatasource = ref.read(hospitalRemoteDatasourceProvider);
  return RemoteHospitalRepository(
    networkInfo: networkInfo,
    hospitalRemoteDatasource: hospitalRemoteDatasource,
  );
});

class RemoteHospitalRepository implements IHospitalRepository {
  final NetworkInfo _networkInfo;
  final HospitalRemoteDatasource _hospitalRemoteDatasource;

  RemoteHospitalRepository({
    required NetworkInfo networkInfo,
    required HospitalRemoteDatasource hospitalRemoteDatasource,
  })  : _networkInfo = networkInfo,
        _hospitalRemoteDatasource = hospitalRemoteDatasource;

  @override
  Future<Either<Failure, List<HospitalEntity>>> getAllApprovedHospitals() async {
    if (await _networkInfo.isConnected) {
      try {
        final hospitals = await _hospitalRemoteDatasource
            .getAllApprovedHospitals();
        return Right(
          hospitals.map((hospital) => hospital.toEntity()).toList(),
        );
      } on DioException catch (err) {
        return Left(
          ApiFailure(
            message: err.message ?? "Failed to fetch hospitals",
            statusCode: err.response?.statusCode,
          ),
        );
      } catch (err) {
        return Left(ApiFailure(message: err.toString()));
      }
    } else {
      return Left(ApiFailure(message: "No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, HospitalEntity>> getHospitalProfileInfo(String hospitalId) async {
    if (await _networkInfo.isConnected) {
      try {
        final hospital = await _hospitalRemoteDatasource
            .getHospitalProfileInfo(hospitalId);
        return Right(hospital.toEntity());
      } on DioException catch (err) {
        return Left(
          ApiFailure(
            message: err.message ?? "Failed to fetch hospital",
            statusCode: err.response?.statusCode,
          ),
        );
      } catch (err) {
        return Left(ApiFailure(message: err.toString()));
      }
    } else {
      return Left(ApiFailure(message: "No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, double>> getAverageRatingOfHospital(
      String hospitalId) async {
    if (await _networkInfo.isConnected) {
      try {
        final ratingData = await _hospitalRemoteDatasource
            .getAverageRatingOfHospital(hospitalId);
        final rating = (ratingData['averageRating'] as num?)?.toDouble() ?? 0.0;
        return Right(rating);
      } on DioException catch (err) {
        return Left(
          ApiFailure(
            message: err.message ?? "Failed to fetch rating",
            statusCode: err.response?.statusCode,
          ),
        );
      } catch (err) {
        return Left(ApiFailure(message: err.toString()));
      }
    } else {
      return Left(ApiFailure(message: "No Internet Connection"));
    }
  }
}
