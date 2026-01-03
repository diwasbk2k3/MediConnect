import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mediconnect/core/constants/hive_table_constant.dart';
import 'package:mediconnect/features/auth/data/models/auth_hive_model.dart';
import 'package:path_provider/path_provider.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  // init
  Future<void> init() async {
    final directory = await getApplicationCacheDirectory();
    final path = '${directory.path}/${HiveTableConstant.dbName}';
    Hive.init(path);
    _registerAdapter();
    await openBoxes();
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

  // Get Current User
  AuthHiveModel? getCurrentUser(String authId) {
    return _authBox.get(authId);
  }

  // Is Email Exists
  Future<bool> isEmailExists(String email) {
    final users = _authBox.values.where((user) => user.email == email);
    return Future.value(users.isNotEmpty);
  }
}
