import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/services/hive/hive_service.dart';
import 'package:mediconnect/core/services/storage/user_session_service.dart';
import 'package:mediconnect/features/auth/data/datasources/auth_datasource.dart';
import 'package:mediconnect/features/auth/data/models/auth_hive_model.dart';

// Provide implementation for Auth Local Datasource
final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  final userSessionService = ref.read(userSessionServiceProvider);
  return AuthLocalDatasource(
    hiveService: hiveService,
    userSessionService: userSessionService,
  );
});

class AuthLocalDatasource implements IAuthDatasource {
  final HiveService _hiveService;
  final UserSessionService _userSessionService;

  AuthLocalDatasource({
    required HiveService hiveService,
    required UserSessionService userSessionService,
  }) : _hiveService = hiveService,
       _userSessionService = userSessionService;

  @override
  Future<AuthHiveModel?> getCurrentUser() async {
    try {
      return await _hiveService.getCurrentUserFromCache();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isEmailExists(String email) async {
    try {
      return await _hiveService.isEmailExists(email);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> login(String email, String password) async {
    try {
      final user = await _hiveService.loginUser(email, password);
      // Store session data if login is successful
      if (user != null) {
        await _userSessionService.storeUserSession(
          isLoggedIn: true,
          authId: user.authId!,
          fullName: user.fullName,
          email: user.email,
          phoneNumber: user.phoneNumber,
          address: user.address,
          profilePicture: user.profilePicture,
        );
      }
      return user != null;
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await _hiveService.logoutUser();
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  Future<bool> register(AuthHiveModel model) async {
    try {
      // Check if email already exists
      final emailExists = await _hiveService.isEmailExists(model.email);
      if (emailExists) {
        throw Exception('Email already registered');
      }
      await _hiveService.registerUser(model);
      // Cache the current user
      await _hiveService.setCurrentUserCache(model);
      return Future.value(true);
    } catch (e) {
      rethrow;
    }
  }
}
