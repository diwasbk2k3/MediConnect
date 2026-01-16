import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/core/services/connectivity/network_info.dart';
import 'package:mediconnect/features/auth/data/datasources/auth_datasource.dart';
import 'package:mediconnect/features/auth/data/datasources/local/auth_datasource.dart';
import 'package:mediconnect/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:mediconnect/features/auth/data/models/auth_api_model.dart';
import 'package:mediconnect/features/auth/data/models/auth_hive_model.dart';
import 'package:mediconnect/features/auth/domain/entities/auth_entity.dart';
import 'package:mediconnect/features/auth/domain/repositories/auth_repository.dart';

// Provider implementation for Auth Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authDatasource = ref.read(authLocalDatasourceProvider);
  final authRemoteDataSource = ref.read(authRemoteDatasoureProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return AuthRepository(
    authDatasource: authDatasource,
    authRemoteDataSource: authRemoteDataSource,
    networkInfo: networkInfo,
  );
});

class AuthRepository implements IAuthRepository {
  final IAuthLocalDatasource _authDatasource;
  final IAuthRemoteDatasource _authRemoteDataSource;
  final INetworkInfo _networkInfo;

  AuthRepository({
    required IAuthLocalDatasource authDatasource,
    required IAuthRemoteDatasource authRemoteDataSource,
    required INetworkInfo networkInfo,
  }) : _authDatasource = authDatasource,
       _authRemoteDataSource = authRemoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      final user = await _authDatasource.getCurrentUser();
      if (user != null) {
        final userEntity = user.toEntity();
        return Right(userEntity);
      } else {
        return Left(LocalDatabaseFailure(message: "No user logged in"));
      }
    } catch (err) {
      return Left(LocalDatabaseFailure(message: err.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _authRemoteDataSource.login(email, password);

        final entity = apiModel.toEntity();
        
        return Right(entity);

      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data["message"] ?? "Login failed",
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (err) {
        return Left(ApiFailure(message: err.toString()));
      }
    } else {
      try {
        final user = await _authDatasource.login(email, password);
        if (user) {
          final userModel = await _authDatasource.getCurrentUser();
          if (userModel != null) {
            final userEntity = userModel.toEntity();
            return Right(userEntity);
          } else {
            return Left(
              LocalDatabaseFailure(message: "Invalid email or password"),
            );
          }
        } else {
          return Left(LocalDatabaseFailure(message: "Login failed"));
        }
      } catch (err) {
        return Left(LocalDatabaseFailure(message: err.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> logout() {
    try {
      return _authDatasource.logout().then((result) {
        if (result) {
          return Right(true);
        } else {
          return Left(LocalDatabaseFailure(message: "Logout failed"));
        }
      });
    } catch (err) {
      return Future.value(Left(LocalDatabaseFailure(message: err.toString())));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> register(AuthEntity user) async {
    if (await _networkInfo.isConnected) {
      try {
        // Go to remote
        final apiModel = AuthApiModel.fromEntity(user);
        final result = await _authRemoteDataSource.register(apiModel);
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
      try {
        // Convert entity to model
        final model = AuthHiveModel.fromEntity(user);
        final result = await _authDatasource.register(model);
        if (result) {
          return Right(user.copyWith(authId: model.authId));
        } else {
          return Left(LocalDatabaseFailure(message: "Registration failed"));
        }
      } catch (err) {
        return Left(LocalDatabaseFailure(message: err.toString()));
      }
    }
  }
}
