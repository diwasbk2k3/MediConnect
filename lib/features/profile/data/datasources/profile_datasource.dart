import 'dart:io';

import 'package:mediconnect/features/profile/data/models/profile_api_model.dart';

abstract interface class IProfileRemoteDatasource {
  Future<Map<String, dynamic>> fetchPatientProfileData();
  Future<ProfileApiModel> createPatientProfile(ProfileApiModel model);
  Future<ProfileApiModel> updatePatientProfileInfo(ProfileApiModel model);
  Future<void> updatePatientProfileImage(File image);
}
