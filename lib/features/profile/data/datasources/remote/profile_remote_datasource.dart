import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/api/api_client.dart';
import 'package:mediconnect/core/api/api_endpoints.dart';
import 'package:mediconnect/core/services/storage/jwt_service.dart';
import 'package:mediconnect/core/services/storage/token_service.dart';
import 'package:mediconnect/features/profile/data/datasources/profile_datasource.dart';
import 'package:mediconnect/features/profile/data/models/profile_api_model.dart';

// Provider
final profileRemoteDatasourceProvider = Provider<ProfileRemoteDatasource>((
  ref,
) {
  final apiClient = ref.read(apiClientProvider);
  final tokenService = ref.read(tokenServiceProvider);
  final jwtService = ref.read(jwtServiceProvider);
  return ProfileRemoteDatasource(
    apiClient: apiClient,
    tokenService: tokenService,
    jwtService: jwtService,
  );
});

class ProfileRemoteDatasource implements IProfileRemoteDatasource {
  final ApiClient _apiClient;
  final TokenService _tokenService;
  final JwtService _jwtService;

  ProfileRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
    required JwtService jwtService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService,
       _jwtService = jwtService;

  @override
  Future<Map<String, dynamic>> fetchPatientProfileData() async {
    final token = _tokenService.getToken();
    final patientId = _jwtService.getPatientIdFromToken();
    
    if (patientId == null) {
      throw Exception('Patient ID not found in token');
    }

    final response = await _apiClient.get(
      ApiEndpoints.getPatientProfileInfo(patientId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data["result"] as Map<String, dynamic>;
  }

  @override
  Future<String> updatePatientProfileImage(File image) async {
    final fileName = image.path.split('/').last;
    final multipartFile = await MultipartFile.fromFile(
      image.path,
      filename: fileName,
    );
    final formData = FormData.fromMap({"myfile": multipartFile});
    final token = _tokenService.getToken();
    final response = await _apiClient.patchFile(
      ApiEndpoints.updatePatientImage,
      formData: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data["result"];
  }

  @override
  Future<ProfileApiModel> createPatientProfile(ProfileApiModel profile) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.post(
      ApiEndpoints.createPatientProfile,
      data: profile.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return ProfileApiModel.fromJson(response.data['result']);
  }

  @override
  Future<ProfileApiModel> updatePatientProfileInfo(
    ProfileApiModel profile,
  ) async {
    final token = _tokenService.getToken();
    final patientId = _jwtService.getPatientIdFromToken();
    
    if (patientId == null) {
      throw Exception('Patient ID not found in token');
    }

    final response = await _apiClient.put(
      ApiEndpoints.updatePatientProfileInfo(patientId),
      data: profile.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return ProfileApiModel.fromJson(response.data['result']);
  }
}
