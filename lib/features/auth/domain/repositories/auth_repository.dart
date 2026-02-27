import 'package:dartz/dartz.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/features/auth/domain/entities/auth_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, AuthEntity>> register(AuthEntity authEntity);
  Future<Either<Failure, AuthEntity>> login(String email, String password);
  Future<Either<Failure, AuthEntity>> getCurrentUser();
  Future<Either<Failure, String>> changePassword(String currentPassword, String newPassword, String confirmPassword); 
  Future<Either<Failure, bool>> logout();
  Future<Either<Failure, String>> deleteAccount(String password);
  Future<Either<Failure, String>> sendPasswordResetEmail(String email);
}