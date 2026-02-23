import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/core/usecase/app_usecase.dart';
import 'package:mediconnect/features/report/data/repositories/report_repository.dart';
import 'package:mediconnect/features/report/domain/entities/report_entity.dart';
import 'package:mediconnect/features/report/domain/repositories/report_repository.dart';

final getReportByAppointmentIdUsecaseProvider =
    Provider<GetReportByAppointmentIdUsecase>((ref) {
  final repository = ref.read(remoteReportRepositoryProvider);
  return GetReportByAppointmentIdUsecase(repository: repository);
});

class GetReportByAppointmentIdUsecaseParams extends Equatable {
  final String appointmentId;

  const GetReportByAppointmentIdUsecaseParams({
    required this.appointmentId,
  });

  @override
  List<Object?> get props => [appointmentId];
}

class GetReportByAppointmentIdUsecase
    implements UseCaseWithParams<ReportEntity,
        GetReportByAppointmentIdUsecaseParams> {
  final IReportRepository _repository;

  GetReportByAppointmentIdUsecase({required IReportRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, ReportEntity>> call(
      GetReportByAppointmentIdUsecaseParams params) async {
    return await _repository.getReportByAppointmentId(params.appointmentId);
  }
}
