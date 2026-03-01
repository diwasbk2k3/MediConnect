import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/core/services/connectivity/network_info.dart';
import 'package:mediconnect/core/services/cache/cache_service.dart';
import 'package:mediconnect/features/hospital/data/datasources/remote/hospital_remote_datasource.dart';
import 'package:mediconnect/features/hospital/domain/entities/hospital_entity.dart';
import 'package:mediconnect/features/hospital/domain/repositories/hospital_repository.dart';

// Provider
final remoteHospitalRepositoryProvider = Provider<IHospitalRepository>((ref) {
  final networkInfo = ref.read(networkInfoProvider);
  final hospitalRemoteDatasource = ref.read(hospitalRemoteDatasourceProvider);
  final cacheService = ref.read(cacheServiceProvider);
  return RemoteHospitalRepository(
    networkInfo: networkInfo,
    hospitalRemoteDatasource: hospitalRemoteDatasource,
    cacheService: cacheService,
  );
});

class RemoteHospitalRepository implements IHospitalRepository {
  final NetworkInfo _networkInfo;
  final HospitalRemoteDatasource _hospitalRemoteDatasource;
  final CacheService _cacheService;

  RemoteHospitalRepository({
    required NetworkInfo networkInfo,
    required HospitalRemoteDatasource hospitalRemoteDatasource,
    required CacheService cacheService,
  })  : _networkInfo = networkInfo,
        _hospitalRemoteDatasource = hospitalRemoteDatasource,
        _cacheService = cacheService;

  @override
  Future<Either<Failure, List<HospitalEntity>>> getAllApprovedHospitals() async {
    if (await _networkInfo.isConnected) {
      try {
        final hospitals = await _hospitalRemoteDatasource
            .getAllApprovedHospitals();
        final entities = hospitals.map((hospital) => hospital.toEntity()).toList();
        
        // Cache the successful response
        await _cacheService.cacheHospitals(entities);
        
        return Right(entities);
      } on DioException catch (err) {
        // If network error, try to use cached data
        final cachedHospitals = await _cacheService.getCachedHospitals();
        if (cachedHospitals.isNotEmpty) {
          return Right(cachedHospitals);
        }
        
        return Left(
          ApiFailure(
            message: err.message ?? "Failed to fetch hospitals",
            statusCode: err.response?.statusCode,
          ),
        );
      } catch (err) {
        // If other error, try to use cached data
        final cachedHospitals = await _cacheService.getCachedHospitals();
        if (cachedHospitals.isNotEmpty) {
          return Right(cachedHospitals);
        }
        
        return Left(ApiFailure(message: err.toString()));
      }
    } else {
      // No internet connection, try to use cached data
      final cachedHospitals = await _cacheService.getCachedHospitals();
      if (cachedHospitals.isNotEmpty) {
        return Right(cachedHospitals);
      }
      
      return Left(ApiFailure(message: "No Internet Connection and no cached data available"));
    }
  }

  @override
  Future<Either<Failure, HospitalEntity>> getHospitalProfileInfo(String hospitalId) async {
    if (await _networkInfo.isConnected) {
      try {
        final hospital = await _hospitalRemoteDatasource
            .getHospitalProfileInfo(hospitalId);
        final entity = hospital.toEntity();
        
        // Cache the successful response
        await _cacheService.cacheHospitalDetail(entity);
        
        return Right(entity);
      } on DioException catch (err) {
        // If network error, try to use cached data
        final cachedHospital = await _cacheService.getCachedHospitalDetail(hospitalId);
        if (cachedHospital != null) {
          return Right(cachedHospital);
        }
        
        return Left(
          ApiFailure(
            message: err.message ?? "Failed to fetch hospital",
            statusCode: err.response?.statusCode,
          ),
        );
      } catch (err) {
        // If other error, try to use cached data
        final cachedHospital = await _cacheService.getCachedHospitalDetail(hospitalId);
        if (cachedHospital != null) {
          return Right(cachedHospital);
        }
        
        return Left(ApiFailure(message: err.toString()));
      }
    } else {
      // No internet connection, try to use cached data
      final cachedHospital = await _cacheService.getCachedHospitalDetail(hospitalId);
      if (cachedHospital != null) {
        return Right(cachedHospital);
      }
      
      return Left(ApiFailure(message: "No Internet Connection and no cached data available"));
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
        
        // Update hospital rating in cache
        await _cacheService.updateHospitalRatingInCache(hospitalId, rating);
        
        return Right(rating);
      } on DioException catch (err) {
        // If network error, try to use cached hospital data
        final cachedHospital = await _cacheService.getCachedHospitalDetail(hospitalId);
        if (cachedHospital?.rating != null) {
          return Right(cachedHospital!.rating ?? 0.0);
        }
        
        return Left(
          ApiFailure(
            message: err.message ?? "Failed to fetch rating",
            statusCode: err.response?.statusCode,
          ),
        );
      } catch (err) {
        // If other error, try to use cached hospital data
        final cachedHospital = await _cacheService.getCachedHospitalDetail(hospitalId);
        if (cachedHospital?.rating != null) {
          return Right(cachedHospital!.rating ?? 0.0);
        }
        
        return Left(ApiFailure(message: err.toString()));
      }
    } else {
      // No internet connection, try to use cached hospital data
      final cachedHospital = await _cacheService.getCachedHospitalDetail(hospitalId);
      if (cachedHospital?.rating != null) {
        return Right(cachedHospital!.rating ?? 0.0);
      }
      
      return Left(ApiFailure(message: "No Internet Connection and no cached data available"));
    }
  }

  @override
  Future<Either<Failure, bool>> giveRatingToHospital({
    required String hospitalId,
    required int rating,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        await _hospitalRemoteDatasource.giveRatingToHospital(
          hospitalId: hospitalId,
          rating: rating,
        );
        return const Right(true);
      } on DioException catch (err) {
        return Left(
          ApiFailure(
            message: err.message ?? "Failed to submit rating",
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
