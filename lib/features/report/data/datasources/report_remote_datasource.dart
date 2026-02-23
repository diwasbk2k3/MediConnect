import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/api/api_client.dart';
import 'package:mediconnect/core/api/api_endpoints.dart';
import 'package:mediconnect/core/services/storage/token_service.dart';
import 'package:mediconnect/core/services/storage/jwt_service.dart';
import 'package:mediconnect/features/report/data/datasources/report_datasource.dart';
import 'package:mediconnect/features/report/data/models/report_api_model.dart';

// Provider
final reportRemoteDatasourceProvider = Provider<ReportRemoteDatasource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  final tokenService = ref.read(tokenServiceProvider);
  final jwtService = ref.read(jwtServiceProvider);
  return ReportRemoteDatasource(
    apiClient: apiClient,
    tokenService: tokenService,
    jwtService: jwtService,
  );
});

class ReportRemoteDatasource implements IReportDatasource {
  final ApiClient _apiClient;
  final TokenService _tokenService;
  final JwtService _jwtService;

  ReportRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
    required JwtService jwtService,
  })  : _apiClient = apiClient,
        _tokenService = tokenService,
        _jwtService = jwtService;

  @override
  Future<ReportApiModel> getReportByAppointmentId(
      String appointmentId) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.get(
      ApiEndpoints.getReportByAppointmentId(appointmentId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final dynamic resultData = response.data["result"];
    final Map<String, dynamic> report = resultData is Map ? resultData.cast<String, dynamic>() : {};
    return ReportApiModel.fromJson(report);
  }

  @override
  Future<List<ReportApiModel>> getAllReportsForPatient() async {
    final token = _tokenService.getToken();
    final patientId = _jwtService.getPatientIdFromToken();

    if (patientId == null || patientId.isEmpty) {
      throw Exception('Patient ID not found in token');
    }

    final response = await _apiClient.get(
      ApiEndpoints.getReportsByPatient(patientId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final dynamic resultData = response.data["result"];
    if (resultData == null) return [];
    
    final List<dynamic> result = resultData is List ? resultData : [];
    return result
        .map((report) => ReportApiModel.fromJson(report as Map<String, dynamic>))
        .toList();
  }
}
