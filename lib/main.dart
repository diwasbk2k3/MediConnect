import 'package:flutter/material.dart';
import 'package:mediconnect/app/app.dart';
import 'package:mediconnect/core/services/hive/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final hiveService = HiveService();
    await hiveService.init();
  } catch (e) {
    debugPrint('Error initializing Hive: $e');
  }
  runApp(const MyApp());
}
