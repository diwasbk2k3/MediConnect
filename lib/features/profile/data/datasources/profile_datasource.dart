import 'dart:io';

abstract interface class IProfileRemoteDatasource {
  Future<void> updatePatientProfileImage(File image);
  Future<Map<String, dynamic>> fetchPatientProfileData();
}