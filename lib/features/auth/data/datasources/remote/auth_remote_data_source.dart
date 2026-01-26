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
  Future<AuthApiModel?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

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
}
