import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/core/services/connectivity/network_info.dart';
import 'package:mediconnect/features/assistant/data/datasources/remote/assistant_remote_datasource.dart';
import 'package:mediconnect/features/assistant/domain/entities/assistant_message_entity.dart';
import 'package:mediconnect/features/assistant/domain/repositories/assistant_repository.dart';

// Provider
final assistantRepositoryProvider = Provider<AssistantRepository>((ref) {
  final networkInfo = ref.read(networkInfoProvider);
  final remoteDatasource = ref.read(assistantRemoteDatasourceProvider);
  return AssistantRepositoryImpl(
    networkInfo: networkInfo,
    remoteDatasource: remoteDatasource,
  );
});

class AssistantRepositoryImpl implements AssistantRepository {
  final NetworkInfo _networkInfo;
  final AssistantRemoteDatasource _remoteDatasource;

  AssistantRepositoryImpl({
    required NetworkInfo networkInfo,
    required AssistantRemoteDatasource remoteDatasource,
  })  : _networkInfo = networkInfo,
        _remoteDatasource = remoteDatasource;

  @override
  Future<Either<Failure, AssistantMessageEntity>> askMedicalAssistant(
    String question,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDatasource.askMedicalAssistant(question);
        return Right(model.toEntity());
      } on DioException catch (err) {
        return Left(
          ApiFailure(
            message: err.message ?? "Failed to get medical assistant response",
            statusCode: err.response?.statusCode,
          ),
        );
      } catch (err) {
        return Left(ApiFailure(message: err.toString()));
      }
    } else {
      return Left(ApiFailure(message: "No Internet Connection"));
    }
  }
}
