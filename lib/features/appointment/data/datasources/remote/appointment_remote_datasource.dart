import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/api/api_client.dart';
import 'package:mediconnect/core/api/api_endpoints.dart';
import 'package:mediconnect/core/services/storage/token_service.dart';
import 'package:mediconnect/features/appointment/data/datasources/appointment_datasource.dart';
import 'package:mediconnect/features/appointment/data/models/appointment_api_model.dart';

// Provider
final appointmentRemoteDatasourceProvider =
    Provider<AppointmentRemoteDatasource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  final tokenService = ref.read(tokenServiceProvider);
  return AppointmentRemoteDatasource(
    apiClient: apiClient,
    tokenService: tokenService,
  );
});

class AppointmentRemoteDatasource implements IAppointmentRemoteDatasource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  AppointmentRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  })  : _apiClient = apiClient,
        _tokenService = tokenService;

  @override
  Future<AppointmentApiModel> bookAppointment({
    required String hospitalId,
    required String department,
    required String appointmentType,
    required String appointmentDate,
    required String appointmentTime,
    required double paymentAmount,
  }) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.post(
      ApiEndpoints.bookAppointment(hospitalId),
      data: {
        'department': department,
        'appointmentType': appointmentType,
        'appointmentDate': appointmentDate,
        'appointmentTime': appointmentTime,
        'paymentAmount': paymentAmount,
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    // Check if success is true
    if (response.data["success"] == true) {
      final resultData = response.data["result"];
      
      // Handle case where result might be a string (needs to be parsed)
      if (resultData is String) {
        try {
          final parsed = jsonDecode(resultData);
          return AppointmentApiModel.fromJson(parsed as Map<String, dynamic>);
        } catch (e) {
          throw Exception("Failed to parse result JSON: $e");
        }
      } else if (resultData is Map<String, dynamic>) {
        return AppointmentApiModel.fromJson(resultData);
      } else {
        throw Exception("Unexpected result type: ${resultData.runtimeType}");
      }
    }
    
    // If success is false, throw exception with backend message
    throw Exception(response.data["message"] ?? "Failed to book appointment");
  }
}
