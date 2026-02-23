import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/core/usecase/app_usecase.dart';
import 'package:mediconnect/features/report/data/repositories/report_repository.dart';
import 'package:mediconnect/features/report/domain/entities/report_entity.dart';
import 'package:mediconnect/features/report/domain/repositories/report_repository.dart';

final getAllReportsForPatientUsecaseProvider =
    Provider<GetAllReportsForPatientUsecase>((ref) {
  final repository = ref.read(remoteReportRepositoryProvider);
  return GetAllReportsForPatientUsecase(repository: repository);
});

class GetAllReportsForPatientUsecase
    implements UseCaseWithoutParams<List<ReportEntity>> {
  final IReportRepository _repository;

  GetAllReportsForPatientUsecase({required IReportRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, List<ReportEntity>>> call() async {
    return await _repository.getAllReportsForPatient();
  }
}
