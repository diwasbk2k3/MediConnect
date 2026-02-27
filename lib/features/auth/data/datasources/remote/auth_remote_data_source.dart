import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/api/api_client.dart';
import 'package:mediconnect/core/api/api_endpoints.dart';
import 'package:mediconnect/core/services/storage/token_service.dart';
import 'package:mediconnect/core/services/storage/user_session_service.dart';
import 'package:mediconnect/features/auth/data/datasources/auth_datasource.dart';
import 'package:mediconnect/features/auth/data/models/auth_api_model.dart';

// Provider
final authRemoteDatasoureProvider = Provider<IAuthRemoteDatasource>((ref) {
  return AuthRemoteDataSource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class AuthRemoteDataSource implements IAuthRemoteDatasource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;
  final TokenService _tokenService;

  AuthRemoteDataSource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _userSessionService = userSessionService,
       _tokenService = tokenService;


  @override
  Future<AuthApiModel> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.userLogin,
      data: {"email": email, "password": password},
    );

    if (response.data["success"] == true) {
      final authModel = AuthApiModel.fromJson(response.data);

      // Save to session
      await _userSessionService.storeUserSession(
        isLoggedIn: true,
        email: email,
      );

      // Save token
      final token = response.data['token'] as String?;
      await _tokenService.saveToken(token!);

      return authModel;
    }

    throw Exception(response.data["message"] ?? "Login failed");
  }

  @override
  Future<void> logout() async {
    try {
      await _userSessionService.clearUserSession();
      await _tokenService.removeToken();
    } catch (_) {
    }
  }

  @override
  Future<AuthApiModel> register(AuthApiModel user) async {
    final response = await _apiClient.post(
      ApiEndpoints.userRegister,
      data: user.toJson(),
    );

    if (response.data["success"] == true) {
      final userData = response.data["data"];
      if (userData != null && userData is Map<String, dynamic>) {
        return AuthApiModel.fromJson(userData);
      }
      return user;
    }
    return user;
  }
  
  @override
  Future<String> changePassword(String currentPassword, String newPassword, String confirmPassword) async{
    final token = _tokenService.getToken();
    final response = await _apiClient.put(
      ApiEndpoints.changePassword,
      data: {
        "currentPassword": currentPassword,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );  
    return response.data["message"];
  }
  
  @override
  Future<String> deleteAccount(String password) async {
    final token = _tokenService.getToken();
    final response = await _apiClient.delete(
      ApiEndpoints.deleteUserAccount,
      data: {"password": password},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    
    // Clear session and token after successful deletion
    await _userSessionService.clearUserSession();
    await _tokenService.removeToken();
    
    return response.data["message"];
  }

  @override
  Future<String> sendPasswordResetEmail(String email) async {
    final response = await _apiClient.post(
      ApiEndpoints.sendPasswordResetEmail,
      data: {"email": email},
    );

    if (response.data["success"] == true) {
      return response.data["message"] ?? "Password reset email sent successfully";
    }

    throw Exception(response.data["message"] ?? "Failed to send reset email");
  }
}