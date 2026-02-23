import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/core/services/connectivity/network_info.dart';
import 'package:mediconnect/features/appointment/data/datasources/remote/appointment_remote_datasource.dart';
import 'package:mediconnect/features/appointment/domain/entities/appointment_entity.dart';
import 'package:mediconnect/features/appointment/domain/repositories/appointment_repository.dart';

// Provider
final remoteAppointmentRepositoryProvider = Provider<IAppointmentRepository>((ref) {
  final networkInfo = ref.read(networkInfoProvider);
  final appointmentRemoteDatasource = ref.read(appointmentRemoteDatasourceProvider);
  return RemoteAppointmentRepository(
    networkInfo: networkInfo,
    appointmentRemoteDatasource: appointmentRemoteDatasource,
  );
});

class RemoteAppointmentRepository implements IAppointmentRepository {
  final NetworkInfo _networkInfo;
  final AppointmentRemoteDatasource _appointmentRemoteDatasource;

  RemoteAppointmentRepository({
    required NetworkInfo networkInfo,
    required AppointmentRemoteDatasource appointmentRemoteDatasource,
  })  : _networkInfo = networkInfo,
        _appointmentRemoteDatasource = appointmentRemoteDatasource;

  @override
  Future<Either<Failure, AppointmentEntity>> bookAppointment({
    required String hospitalId,
    required String department,
    required String appointmentType,
    required String appointmentDate,
    required String appointmentTime,
    required double paymentAmount,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final appointment = await _appointmentRemoteDatasource.bookAppointment(
          hospitalId: hospitalId,
          department: department,
          appointmentType: appointmentType,
          appointmentDate: appointmentDate,
          appointmentTime: appointmentTime,
          paymentAmount: paymentAmount,
        );
        return Right(appointment.toEntity());
      } on DioException catch (err) {
        return Left(
          ApiFailure(
            message: err.message ?? "Failed to book appointment",
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
