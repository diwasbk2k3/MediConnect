import 'dart:io';

abstract interface class IProfileRemoteDatasource {
  Future<Map<String, dynamic>> fetchPatientProfileData();
  Future<void>  createPatientProfile(Map<String, dynamic> profileData);
  Future<void> updatePatientProfileImage(File image);
}