import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static const bool isPhysicalDevice = false;

  static const String compIpAddress = "192.168.18.6";

  static String get baseUrl {
    if (isPhysicalDevice) {
      return 'http://$compIpAddress:4200/api';
    }
    // if android
    if (kIsWeb) {
      return 'http://localhost:4200/api';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:4200/api';
    } else if (Platform.isIOS) {
      return 'http://localhost:4200/api';
    } else {
      return 'http://localhost:4200/api';
    }
  }

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ============ Auth Endpoints ============
  static const String userLogin = '/auth/login';
  static const String userRegister = '/auth/signup';
  static const String changePassword = '/auth/update-password';

  // ============ Profile Endpoints ============
  static String getPatientProfileInfo(String patientId) => '/profile/patient/$patientId';
  static const String createPatientProfile = '/profile/patient/create';
  static String updatePatientProfileInfo(String patientId) => '/profile/patient/update-info/$patientId';
  static const String updatePatientImage = '/profile/image/patient/update';
}
