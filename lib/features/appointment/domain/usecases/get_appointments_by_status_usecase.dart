import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/core/usecase/app_usecase.dart';
import 'package:mediconnect/features/appointment/data/repositories/appointment_list_repository.dart';
import 'package:mediconnect/features/appointment/domain/entities/appointment_entity.dart';
import 'package:mediconnect/features/appointment/domain/repositories/appointment_list_repository.dart';

// Provider
final getAppointmentsByStatusUsecaseProvider =
    Provider<GetAppointmentsByStatusUsecase>((ref) {
  final repository = ref.read(remoteAppointmentListRepositoryProvider);
  return GetAppointmentsByStatusUsecase(repository: repository);
});

class GetAppointmentsByStatusUsecaseParams extends Equatable {
  final String status;

  const GetAppointmentsByStatusUsecaseParams({
    required this.status,
  });

  @override
  List<Object?> get props => [status];
}

class GetAppointmentsByStatusUsecase implements
    UseCaseWithParams<List<AppointmentEntity>,
        GetAppointmentsByStatusUsecaseParams> {
  final IAppointmentListRepository _repository;

  GetAppointmentsByStatusUsecase({required IAppointmentListRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, List<AppointmentEntity>>> call(
      GetAppointmentsByStatusUsecaseParams params) async {
    return await _repository.getAppointmentsByStatus(params.status);
  }
}
