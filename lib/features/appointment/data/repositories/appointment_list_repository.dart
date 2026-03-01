import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/core/services/connectivity/network_info.dart';
import 'package:mediconnect/core/services/cache/cache_service.dart';
import 'package:mediconnect/features/appointment/data/datasources/remote/appointment_list_remote_datasource.dart';
import 'package:mediconnect/features/appointment/domain/entities/appointment_entity.dart';
import 'package:mediconnect/features/appointment/domain/repositories/appointment_list_repository.dart';

// Provider
final remoteAppointmentListRepositoryProvider =
    Provider<IAppointmentListRepository>((ref) {
  final networkInfo = ref.read(networkInfoProvider);
  final appointmentListRemoteDatasource =
      ref.read(appointmentListRemoteDatasourceProvider);
  final cacheService = ref.read(cacheServiceProvider);
  return RemoteAppointmentListRepository(
    networkInfo: networkInfo,
    appointmentListRemoteDatasource: appointmentListRemoteDatasource,
    cacheService: cacheService,
  );
});

class RemoteAppointmentListRepository
    implements IAppointmentListRepository {
  final NetworkInfo _networkInfo;
  final AppointmentListRemoteDatasource _appointmentListRemoteDatasource;
  final CacheService _cacheService;

  RemoteAppointmentListRepository({
    required NetworkInfo networkInfo,
    required AppointmentListRemoteDatasource appointmentListRemoteDatasource,
    required CacheService cacheService,
  })  : _networkInfo = networkInfo,
        _appointmentListRemoteDatasource = appointmentListRemoteDatasource,
        _cacheService = cacheService;

  @override
  Future<Either<Failure, List<AppointmentEntity>>> getAppointmentsByStatus(
      String status) async {
    if (await _networkInfo.isConnected) {
      try {
        debugPrint('Fetching appointments with status: $status');
        final appointments =
            await _appointmentListRemoteDatasource.getAppointmentsByStatus(status);
        final entities = appointments.map((appointment) => appointment.toEntity()).toList();
        
        // Cache the successful API response (cacheService handles the conversion internally)
        await _cacheService.cacheAppointments(entities);
        
        return Right(entities);
      } on DioException catch (err) {
        // On error, try to return cached appointments with matching status
        final cachedAppointments = await _cacheService.getCachedAppointments();
        // Filter cached appointments by the requested status
        final filteredAppointments = cachedAppointments
            .where((apt) => apt.status == _mapStatusToServerStatus(status))
            .toList();
        if (filteredAppointments.isNotEmpty) {
          return Right(filteredAppointments);
        }
        
        return Left(
          ApiFailure(
            message: err.message ?? "Failed to fetch appointments",
            statusCode: err.response?.statusCode,
          ),
        );
      } catch (err) {
        // On error, try to return cached appointments with matching status
        final cachedAppointments = await _cacheService.getCachedAppointments();
        // Filter cached appointments by the requested status
        final filteredAppointments = cachedAppointments
            .where((apt) => apt.status == _mapStatusToServerStatus(status))
            .toList();
        if (filteredAppointments.isNotEmpty) {
          return Right(filteredAppointments);
        }
        
        return Left(ApiFailure(message: err.toString()));
      }
    } else {
      // Offline: Try to return cached appointments with matching status
      final cachedAppointments = await _cacheService.getCachedAppointments();
      // Filter cached appointments by the requested status
      final filteredAppointments = cachedAppointments
          .where((apt) => apt.status == _mapStatusToServerStatus(status))
          .toList();
      if (filteredAppointments.isNotEmpty) {
        return Right(filteredAppointments);
      }
      
      debugPrint('Offline: No cached appointments available with status: $status');
      return Left(ApiFailure(message: "No Internet Connection"));
    }
  }

  /// Map UI status to server API status
  String _mapStatusToServerStatus(String uiStatus) {
    switch (uiStatus) {
      case 'not-visited':
        return 'not-visited';
      case 'visited':
        return 'visited';
      case 'cancelled':
        return 'cancelled';
      default:
        return uiStatus;
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
