import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/api/api_client.dart';
import 'package:mediconnect/core/api/api_endpoints.dart';
import 'package:mediconnect/core/services/storage/token_service.dart';
import 'package:mediconnect/features/profile/data/datasources/profile_datasource.dart';

// Provider
final profileRemoteDatasourceProvider = Provider<ProfileRemoteDatasource>((
  ref,
) {
  final apiClient = ref.read(apiClientProvider);
  final tokenService = ref.read(tokenServiceProvider);
  return ProfileRemoteDatasource(
    apiClient: apiClient,
    tokenService: tokenService,
  );
});

class ProfileRemoteDatasource implements IProfileRemoteDatasource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  ProfileRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<Map<String, dynamic>> fetchPatientProfileData() {
    // TODO: implement fetchProfile
    throw UnimplementedError();
  }

  @override
  Future<void> updatePatientProfileImage(File image) {
    final fileName = image.path.split('/').last;
    final formData = FormData.fromMap({
      "itemPhoto": MultipartFile.fromFile(image.path, filename: fileName),
    });

    // Get token from the token service
    final token = _tokenService.getToken();

    final response = _apiClient.uploadFile(
      ApiEndpoints.updatePatientImage,
      formData: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.then((res) {
      if (res.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to upload profile image');
      }
    });
  }
}
