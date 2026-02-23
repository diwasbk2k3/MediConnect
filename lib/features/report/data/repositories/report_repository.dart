import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/core/services/connectivity/network_info.dart';
import 'package:mediconnect/features/report/data/datasources/report_remote_datasource.dart';
import 'package:mediconnect/features/report/domain/entities/report_entity.dart';
import 'package:mediconnect/features/report/domain/repositories/report_repository.dart';

// Provider
final remoteReportRepositoryProvider = Provider<IReportRepository>((ref) {
  final networkInfo = ref.read(networkInfoProvider);
  final reportRemoteDatasource = ref.read(reportRemoteDatasourceProvider);
  return RemoteReportRepository(
    networkInfo: networkInfo,
    reportRemoteDatasource: reportRemoteDatasource,
  );
});

class RemoteReportRepository implements IReportRepository {
  final NetworkInfo _networkInfo;
  final ReportRemoteDatasource _reportRemoteDatasource;

  RemoteReportRepository({
    required NetworkInfo networkInfo,
    required ReportRemoteDatasource reportRemoteDatasource,
  })  : _networkInfo = networkInfo,
        _reportRemoteDatasource = reportRemoteDatasource;

  @override
  Future<Either<Failure, ReportEntity>> getReportByAppointmentId(
      String appointmentId) async {
    if (await _networkInfo.isConnected) {
      try {
        final report =
            await _reportRemoteDatasource.getReportByAppointmentId(appointmentId);
        return Right(report.toEntity());
      } on DioException catch (err) {
        return Left(
          ApiFailure(
            message: err.message ?? "Failed to fetch report",
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
  Future<Either<Failure, List<ReportEntity>>> getAllReportsForPatient() async {
    if (await _networkInfo.isConnected) {
      try {
        final reports = await _reportRemoteDatasource.getAllReportsForPatient();
        return Right(
          reports.map((report) => report.toEntity()).toList(),
        );
      } on DioException catch (err) {
        return Left(
          ApiFailure(
            message: err.message ?? "Failed to fetch reports",
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
