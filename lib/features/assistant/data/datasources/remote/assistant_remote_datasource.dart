import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/api/api_client.dart';
import 'package:mediconnect/core/api/api_endpoints.dart';
import 'package:mediconnect/core/services/storage/token_service.dart';
import 'package:mediconnect/features/assistant/data/datasources/assistant_datasource.dart';
import 'package:mediconnect/features/assistant/data/models/assistant_message_model.dart';
import 'package:dio/dio.dart';

// Provider
final assistantRemoteDatasourceProvider = Provider<AssistantRemoteDatasource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  final tokenService = ref.read(tokenServiceProvider);
  return AssistantRemoteDatasource(
    apiClient: apiClient,
    tokenService: tokenService,
  );
});

class AssistantRemoteDatasource implements IAssistantDatasource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  AssistantRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  })  : _apiClient = apiClient,
        _tokenService = tokenService;

  @override
  Future<AssistantMessageModel> askMedicalAssistant(String question) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.post(
      ApiEndpoints.askMedicalAssistant,
      data: {'question': question},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final Map<String, dynamic> data = response.data is Map 
        ? (response.data as Map<String, dynamic>)
        : {};
        
    return AssistantMessageModel.fromJson({
      ...data,
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'role': 'bot',
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}
