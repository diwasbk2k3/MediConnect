import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/api/api_client.dart';
import 'package:mediconnect/core/api/api_endpoints.dart';
import 'package:mediconnect/core/services/storage/token_service.dart';
import 'package:mediconnect/features/appointment/data/datasources/appointment_list_datasource.dart';
import 'package:mediconnect/features/appointment/data/models/appointment_api_model.dart';

// Provider
final appointmentListRemoteDatasourceProvider =
    Provider<AppointmentListRemoteDatasource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  final tokenService = ref.read(tokenServiceProvider);
  return AppointmentListRemoteDatasource(
    apiClient: apiClient,
    tokenService: tokenService,
  );
});

class AppointmentListRemoteDatasource
    implements IAppointmentListRemoteDatasource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  AppointmentListRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  })  : _apiClient = apiClient,
        _tokenService = tokenService;

  @override
  Future<List<AppointmentApiModel>> getAppointmentsByStatus(
      String status) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.get(
      ApiEndpoints.getAppointmentsByStatusForPatient(status),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final dynamic resultData = response.data["result"];
    if (resultData == null) return [];
    
    final List<dynamic> result = resultData is List ? resultData : [];
    return result
        .map((appointment) =>
            AppointmentApiModel.fromJson(appointment as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> cancelAppointment({
    required String appointmentId,
    required String cancellationReason,
  }) async {
    final token = _tokenService.getToken();

    await _apiClient.patch(
      ApiEndpoints.cancelAppointment(appointmentId),
      data: {'cancellationReason': cancellationReason},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
