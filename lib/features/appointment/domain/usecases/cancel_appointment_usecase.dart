import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/core/usecase/app_usecase.dart';
import 'package:mediconnect/features/appointment/data/repositories/appointment_list_repository.dart';
import 'package:mediconnect/features/appointment/domain/repositories/appointment_list_repository.dart';

// Provider
final cancelAppointmentUsecaseProvider =
    Provider<CancelAppointmentUsecase>((ref) {
  final repository = ref.read(remoteAppointmentListRepositoryProvider);
  return CancelAppointmentUsecase(repository: repository);
});

class CancelAppointmentUsecaseParams extends Equatable {
  final String appointmentId;
  final String cancellationReason;

  const CancelAppointmentUsecaseParams({
    required this.appointmentId,
    required this.cancellationReason,
  });

  @override
  List<Object?> get props => [appointmentId, cancellationReason];
}

class CancelAppointmentUsecase
    implements UseCaseWithParams<bool, CancelAppointmentUsecaseParams> {
  final IAppointmentListRepository _repository;

  CancelAppointmentUsecase({required IAppointmentListRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, bool>> call(
      CancelAppointmentUsecaseParams params) async {
    return await _repository.cancelAppointment(
      appointmentId: params.appointmentId,
      cancellationReason: params.cancellationReason,
    );
  }
}
