import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/core/services/connectivity/network_info.dart';
import 'package:mediconnect/features/profile/data/datasources/remote/profile_remote_datasource.dart';
import 'package:mediconnect/features/profile/data/models/profile_api_model.dart';
import 'package:mediconnect/features/profile/domain/entities/profile_entity.dart';
import 'package:mediconnect/features/profile/domain/repositories/profile_repository.dart';

// Provider
final remoteProfileRepositoryProvider = Provider<IProfileRemoteRepository>((
  ref,
) {
  final networkInfo = ref.read(networkInfoProvider);
  final profileRemoteDatasource = ref.read(profileRemoteDatasourceProvider);
  return RemoteProfileRepository(
    networkInfo: networkInfo,
    profileRemoteDatasource: profileRemoteDatasource,
  );
});

class RemoteProfileRepository implements IProfileRemoteRepository {
  final NetworkInfo _networkInfo;
  final ProfileRemoteDatasource _profileRemoteDatasource;

  RemoteProfileRepository({
    required NetworkInfo networkInfo,
    required ProfileRemoteDatasource profileRemoteDatasource,
  }) : _networkInfo = networkInfo,
       _profileRemoteDatasource = profileRemoteDatasource;

  @override
  Future<Either<Failure, Map<String, dynamic>>>
  fetchPatientProfileData() async {
    if (await _networkInfo.isConnected) {
      try {
        final profileData = await _profileRemoteDatasource
            .fetchPatientProfileData();
        return Right(profileData);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: "No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, String>> updatePatientProfileImage(File image) async {
    if (await _networkInfo.isConnected) {
      try {
        final fileName = await _profileRemoteDatasource
            .updatePatientProfileImage(image);
        return Right(fileName);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: "No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> createPatientProfile(ProfileEntity profile) async {
    if (await _networkInfo.isConnected) {
      try {
        // Go to remote
        final apiModel = ProfileApiModel.fromEntity(profile);
        final result = await _profileRemoteDatasource.createPatientProfile(
          apiModel,
        );
        return Right(result.toEntity());
      } on DioException catch (err) {
        return Left(
          ApiFailure(
            message: err.message ?? "Registration failed",
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
