import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static const bool isPhysicalDevice = true;

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
  static const String deleteUserAccount = '/auth/delete-account';
  static const String sendPasswordResetEmail = '/auth/send-password-reset-email';

  // ============ Profile Endpoints ============
  static String getPatientProfileInfo(String patientId) => '/profile/patient/$patientId';
  static const String createPatientProfile = '/profile/patient/create';
  static String updatePatientProfileInfo(String patientId) => '/profile/patient/update-info/$patientId';
  static const String updatePatientImage = '/profile/image/patient/update';
  
  // ============ Hospital Endpoints ============
  static const String getAllApprovedHospitals = "/profile/hospital/approved";
  static String getHospitalProfileInfo(String hospitalId) => '/profile/hospital/$hospitalId';

  // ============ Appointment Endpoints ============
  static String bookAppointment(String hospitalId) => '/appointment/booking/$hospitalId';
  static String getAppointmentsByStatusForPatient(String status) => '/appointment/patient?status=$status';
  static String visitedHospitalsByPatient(String patientId) => '/appointment/patient/visited-hospitals/$patientId';
  static String cancelAppointment(String appointmentId) => '/appointment/cancel-booking/$appointmentId';

  // ============ Report Endpoints ============
  static String getReportByAppointmentId(String appointmentId) => '/report/$appointmentId';
  static String getReportsByPatient(String patientId) => '/report/patient/$patientId';

  // ============ Rating Endpoints ============
  static String giveRatingToHospital(String hospitalId)=> '/rating/give/$hospitalId';
  static String averageRatingOfHospital(String hospitalId)=> '/rating/received-by-hospital/$hospitalId';

  // ============ Medical Assistant ============
  static String askMedicalAssistant = '/ai/ask';
}