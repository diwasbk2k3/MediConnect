import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mediconnect/core/constants/hive_table_constant.dart';
import 'package:mediconnect/features/auth/data/models/auth_hive_model.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' show Platform;

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  // init
  Future<void> init() async {
    try {
      // Only initialize Hive for non-web platforms
      if (!kIsWeb) {
        final directory = await getApplicationCacheDirectory();
        final path = '${directory.path}/${HiveTableConstant.dbName}';
        Hive.init(path);
      } else {
        // For web, just initialize Hive without a path
        await Hive.initFlutter();
      }
      _registerAdapter();
      await openBoxes();
    } catch (e) {
      debugPrint('Error initializing Hive: $e');
      rethrow;
    }
  }

  // Register Adapter
  void _registerAdapter() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }
    // Register other adapters here
  }

  // Open Boxes
  Future<void> openBoxes() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
    await Hive.openBox('_user_cache');
  }

  // Close Boxes
  Future<void> close() async {
    await Hive.close();
  }

  // ==================== AUTH QUERIES ====================
  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstant.authTable);

  Future<AuthHiveModel> createAuth(AuthHiveModel model) async {
    await _authBox.put(model.authId, model);
    return model;
  }

  // Register
  Future<void> registerUser(AuthHiveModel model) async {
    await _authBox.put(model.authId, model);
  }

  // Login
  Future<AuthHiveModel?> loginUser(String email, String password) async {
    final users = _authBox.values.where(
      (user) => user.email == email && user.password == password,
    );
    if (users.isNotEmpty) {
      return users.first;
    }
    return null;
  }

  // Logout
  Future<void> logoutUser() async {}

  // Get Current User by authId
  AuthHiveModel? getCurrentUser(String authId) {
    return _authBox.get(authId);
  }

  // Get Current User from Cache (last logged in)
  Future<AuthHiveModel?> getCurrentUserFromCache() async {
    try {
      final box = Hive.box('_user_cache');
      final currentUserId = box.get('currentUserId');
      if (currentUserId != null) {
        return _authBox.get(currentUserId);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Set Current User Cache
  Future<void> setCurrentUserCache(AuthHiveModel user) async {
    try {
      final box = Hive.box('_user_cache');
      await box.put('currentUserId', user.authId);
    } catch (e) {
      debugPrint('Error caching user: $e');
    }
  }

  // Is Email Exists
  Future<bool> isEmailExists(String email) {
    final users = _authBox.values.where((user) => user.email == email);
    return Future.value(users.isNotEmpty);
  }
}
