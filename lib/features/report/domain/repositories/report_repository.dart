import 'package:dartz/dartz.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/features/report/domain/entities/report_entity.dart';

abstract class IReportRepository {
  Future<Either<Failure, ReportEntity>> getReportByAppointmentId(
      String appointmentId);
  Future<Either<Failure, List<ReportEntity>>> getAllReportsForPatient();
}
