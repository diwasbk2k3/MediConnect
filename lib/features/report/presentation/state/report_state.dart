import 'package:equatable/equatable.dart';
import 'package:mediconnect/features/report/domain/entities/report_entity.dart';

enum ReportStatus {
  initial,
  loading,
  success,
  error,
}

class ReportState extends Equatable {
  final ReportStatus status;
  final ReportEntity? report;
  final List<ReportEntity> reports;
  final String? errorMessage;

  const ReportState({
    this.status = ReportStatus.initial,
    this.report,
    this.reports = const [],
    this.errorMessage,
  });

  ReportState copyWith({
    ReportStatus? status,
    ReportEntity? report,
    List<ReportEntity>? reports,
    String? errorMessage,
  }) {
    return ReportState(
      status: status ?? this.status,
      report: report ?? this.report,
      reports: reports ?? this.reports,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, report, reports, errorMessage];
}
