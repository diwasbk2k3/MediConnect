import 'package:dartz/dartz.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/features/appointment/domain/entities/appointment_entity.dart';

abstract interface class IAppointmentListRepository {
  Future<Either<Failure, List<AppointmentEntity>>> getAppointmentsByStatus(
    String status,
  );
  Future<Either<Failure, bool>> cancelAppointment({
    required String appointmentId,
    required String cancellationReason,
  });
}
