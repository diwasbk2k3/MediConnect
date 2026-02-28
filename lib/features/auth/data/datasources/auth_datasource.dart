import 'package:mediconnect/features/auth/data/models/auth_api_model.dart';
import 'package:mediconnect/features/auth/data/models/auth_hive_model.dart';

abstract interface class IAuthLocalDatasource {
  Future<bool> register(AuthHiveModel model);
  Future<bool> login(String email, String password);
  Future<AuthHiveModel?> getCurrentUser();
  Future<bool> logout();
}

abstract interface class IAuthRemoteDatasource {
  Future<AuthApiModel> register(AuthApiModel model);
  Future<AuthApiModel> login(String email, String password);
  Future<String> changePassword(String currentPassword, String newPassword, String confirmPassword);
  Future<void> logout();
  Future<String> deleteAccount(String password);
  Future<String> sendPasswordResetEmail(String email);
}