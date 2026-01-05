import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/app/app.dart';
import 'package:mediconnect/core/services/hive/hive_service.dart';
import 'package:mediconnect/core/services/storage/user_session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final hiveService = HiveService();
    await hiveService.init();
  } catch (e) {
    debugPrint('Error initializing Hive: $e');
  }
  // Shared Prefs
  final sharedPrefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(sharedPrefs)],
      child: MyApp(),
    ),
  );
}
