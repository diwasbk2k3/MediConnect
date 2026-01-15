import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/features/auth/data/datasources/auth_datasource.dart';
import 'package:mediconnect/features/auth/data/datasources/local/auth_datasource.dart';
import 'package:mediconnect/features/auth/data/models/auth_hive_model.dart';
import 'package:mediconnect/features/auth/domain/entities/auth_entity.dart';
import 'package:mediconnect/features/auth/domain/repositories/auth_repository.dart';

// Provider implementation for Auth Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authDatasource = ref.watch(authLocalDatasourceProvider);
  return AuthRepository(authDatasource: authDatasource);
});

class AuthRepository implements IAuthRepository {
  final IAuthDatasource _authDatasource;

  AuthRepository({required IAuthDatasource authDatasource})
    : _authDatasource = authDatasource;

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async{
    try{
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
  Future<Either<Failure, AuthEntity>> login(String email, String password) async{
    try{
      final user = await _authDatasource.login(email, password);
      if (user) {
        final userModel = await _authDatasource.getCurrentUser();
        if (userModel != null) {
          final userEntity = userModel.toEntity();
          return Right(userEntity);
        } else {
          return Left(LocalDatabaseFailure(message: "Invalid email or password"));
        }
      } else {
        return Left(LocalDatabaseFailure(message: "Login failed"));
      }
    } catch (err) {
      return Left(LocalDatabaseFailure(message: err.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() {
    try{
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
  Future<Either<Failure, AuthEntity>> register(AuthEntity entity) async {
    try {
      // Convert entity to model
      final model = AuthHiveModel.fromEntity(entity);
      final result = await _authDatasource.register(model);
      if (result) {
        return Right(entity.copyWith(authId: model.authId));
      } else {
        return Left(LocalDatabaseFailure(message: "Registration failed"));
      }
    } catch (err) {
      return Left(LocalDatabaseFailure(message: err.toString()));
    }
  }
}