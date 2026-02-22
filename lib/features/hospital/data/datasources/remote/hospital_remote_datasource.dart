import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/api/api_client.dart';
import 'package:mediconnect/core/api/api_endpoints.dart';
import 'package:mediconnect/core/services/storage/token_service.dart';
import 'package:mediconnect/features/hospital/data/datasources/hospital_datasource.dart';
import 'package:mediconnect/features/hospital/data/models/hospital_api_model.dart';

// Provider
final hospitalRemoteDatasourceProvider = Provider<HospitalRemoteDatasource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  final tokenService = ref.read(tokenServiceProvider);
  return HospitalRemoteDatasource(
    apiClient: apiClient,
    tokenService: tokenService,
  );
});

class HospitalRemoteDatasource implements IHospitalRemoteDatasource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  HospitalRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  })  : _apiClient = apiClient,
        _tokenService = tokenService;

  @override
  Future<List<HospitalApiModel>> getAllApprovedHospitals() async {
    final token = _tokenService.getToken();
    
    final response = await _apiClient.get(
      ApiEndpoints.getAllApprovedHospitals,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    
    final List<dynamic> result = response.data["result"] as List<dynamic>;
    return result
        .map((hospital) =>
            HospitalApiModel.fromJson(hospital as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Map<String, dynamic>> getAverageRatingOfHospital(
      String hospitalId) async {
    final token = _tokenService.getToken();
    
    final response = await _apiClient.get(
      ApiEndpoints.averageRatingOfHospital(hospitalId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data["result"] as Map<String, dynamic>;
  }
}
