import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/features/report/domain/usecases/get_all_reports_for_patient_usecase.dart';
import 'package:mediconnect/features/report/domain/usecases/get_report_by_appointment_id_usecase.dart';
import 'package:mediconnect/features/report/presentation/state/report_state.dart';

final reportViewModelProvider =
    NotifierProvider<ReportViewModel, ReportState>(
        () => ReportViewModel());

class ReportViewModel extends Notifier<ReportState> {
  late final GetReportByAppointmentIdUsecase _getReportByAppointmentIdUsecase;
  late final GetAllReportsForPatientUsecase _getAllReportsForPatientUsecase;

  @override
  ReportState build() {
    _getReportByAppointmentIdUsecase = ref.read(getReportByAppointmentIdUsecaseProvider);
    _getAllReportsForPatientUsecase = ref.read(getAllReportsForPatientUsecaseProvider);
    return const ReportState();
  }

  Future<void> getReportByAppointmentId(String appointmentId) async {
    state = state.copyWith(status: ReportStatus.loading);

    final result = await _getReportByAppointmentIdUsecase(
      GetReportByAppointmentIdUsecaseParams(appointmentId: appointmentId),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ReportStatus.error,
          errorMessage: failure.message,
        );
      },
      (report) {
        state = state.copyWith(
          status: ReportStatus.success,
          report: report,
        );
      },
    );
  }

  Future<void> getAllReportsForPatient() async {
    state = state.copyWith(status: ReportStatus.loading);

    final result = await _getAllReportsForPatientUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ReportStatus.error,
          errorMessage: failure.message,
        );
      },
      (reports) {
        state = state.copyWith(
          status: ReportStatus.success,
          reports: reports,
        );
      },
    );
  }

  void reset() {
    state = const ReportState();
  }
}
