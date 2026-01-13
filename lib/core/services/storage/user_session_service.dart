import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Shared pref provider for user session management
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

// Provider for UserSessionService
final userSessionServiceProvider = Provider<UserSessionService>((ref) {
  return UserSessionService(prefs: ref.read(sharedPreferencesProvider));
});

class UserSessionService {
  // Implementation of user session management
  final SharedPreferences _prefs;
  UserSessionService({required SharedPreferences prefs}) : _prefs = prefs;

  // Keys for storing data
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyAuthId = 'auth_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserPhoneNumber = 'user_phone_number';

  // Store user session data
  Future<void> storeUserSession({
    required bool isLoggedIn,
    required String authId,
    required String email,
    required String? phoneNumber,
  }) async {
    await _prefs.setBool(_keyIsLoggedIn, isLoggedIn);
    await _prefs.setString(_keyAuthId, authId);
    await _prefs.setString(_keyUserEmail, email);
    if (phoneNumber != null) {
      await _prefs.setString(_keyUserPhoneNumber, phoneNumber);
    }
  }

  // Clear user session data
  Future<void> clearUserSession() async {
    await _prefs.remove(_keyIsLoggedIn);
    await _prefs.remove(_keyAuthId);
    await _prefs.remove(_keyUserEmail);
    await _prefs.remove(_keyUserPhoneNumber);
  }

  // Getters for user session data
  bool isLoggedIn() {
    return _prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  String? getAuthId() {
    return _prefs.getString(_keyAuthId);
  }

  String? getUserEmail() {
    return _prefs.getString(_keyUserEmail);
  }

  String? getUserPhoneNumber() {
    return _prefs.getString(_keyUserPhoneNumber);
  }
}
