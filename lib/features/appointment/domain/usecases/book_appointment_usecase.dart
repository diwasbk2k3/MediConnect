import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/core/usecase/app_usecase.dart';
import 'package:mediconnect/features/appointment/data/repositories/appointment_repository.dart';
import 'package:mediconnect/features/appointment/domain/entities/appointment_entity.dart';
import 'package:mediconnect/features/appointment/domain/repositories/appointment_repository.dart';

// Provider
final bookAppointmentUsecaseProvider = Provider<BookAppointmentUsecase>((ref) {
  final repository = ref.read(remoteAppointmentRepositoryProvider);
  return BookAppointmentUsecase(repository: repository);
});

class BookAppointmentUsecaseParams extends Equatable {
  final String hospitalId;
  final String department;
  final String appointmentType;
  final String appointmentDate;
  final String appointmentTime;
  final double paymentAmount;

  const BookAppointmentUsecaseParams({
    required this.hospitalId,
    required this.department,
    required this.appointmentType,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.paymentAmount,
  });

  @override
  List<Object?> get props => [
    hospitalId,
    department,
    appointmentType,
    appointmentDate,
    appointmentTime,
    paymentAmount,
  ];
}

class BookAppointmentUsecase
    implements UseCaseWithParams<AppointmentEntity, BookAppointmentUsecaseParams> {
  final IAppointmentRepository _repository;

  BookAppointmentUsecase({required IAppointmentRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, AppointmentEntity>> call(
      BookAppointmentUsecaseParams params) async {
    return await _repository.bookAppointment(
      hospitalId: params.hospitalId,
      department: params.department,
      appointmentType: params.appointmentType,
      appointmentDate: params.appointmentDate,
      appointmentTime: params.appointmentTime,
      paymentAmount: params.paymentAmount,
    );
  }
}
