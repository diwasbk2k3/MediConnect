import 'package:dartz/dartz.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/features/appointment/domain/entities/appointment_entity.dart';

abstract interface class IAppointmentRepository {
  Future<Either<Failure, AppointmentEntity>> bookAppointment({
    required String hospitalId,
    required String department,
    required String appointmentType,
    required String appointmentDate,
    required String appointmentTime,
    required double paymentAmount,
  });
}
