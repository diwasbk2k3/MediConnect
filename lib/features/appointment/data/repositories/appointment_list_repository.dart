import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/core/services/connectivity/network_info.dart';
import 'package:mediconnect/features/appointment/data/datasources/remote/appointment_list_remote_datasource.dart';
import 'package:mediconnect/features/appointment/domain/entities/appointment_entity.dart';
import 'package:mediconnect/features/appointment/domain/repositories/appointment_list_repository.dart';

// Provider
final remoteAppointmentListRepositoryProvider =
    Provider<IAppointmentListRepository>((ref) {
  final networkInfo = ref.read(networkInfoProvider);
  final appointmentListRemoteDatasource =
      ref.read(appointmentListRemoteDatasourceProvider);
  return RemoteAppointmentListRepository(
    networkInfo: networkInfo,
    appointmentListRemoteDatasource: appointmentListRemoteDatasource,
  );
});

class RemoteAppointmentListRepository
    implements IAppointmentListRepository {
  final NetworkInfo _networkInfo;
  final AppointmentListRemoteDatasource _appointmentListRemoteDatasource;

  RemoteAppointmentListRepository({
    required NetworkInfo networkInfo,
    required AppointmentListRemoteDatasource appointmentListRemoteDatasource,
  })  : _networkInfo = networkInfo,
        _appointmentListRemoteDatasource = appointmentListRemoteDatasource;

  @override
  Future<Either<Failure, List<AppointmentEntity>>> getAppointmentsByStatus(
      String status) async {
    if (await _networkInfo.isConnected) {
      try {
        final appointments =
            await _appointmentListRemoteDatasource.getAppointmentsByStatus(status);
        return Right(
          appointments.map((appointment) => appointment.toEntity()).toList(),
        );
      } on DioException catch (err) {
        return Left(
          ApiFailure(
            message: err.message ?? "Failed to fetch appointments",
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

  @override
  Future<Either<Failure, bool>> cancelAppointment({
    required String appointmentId,
    required String cancellationReason,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        await _appointmentListRemoteDatasource.cancelAppointment(
          appointmentId: appointmentId,
          cancellationReason: cancellationReason,
        );
        return const Right(true);
      } on DioException catch (err) {
        return Left(
          ApiFailure(
            message: err.message ?? "Failed to cancel appointment",
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
