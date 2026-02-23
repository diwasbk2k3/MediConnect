import 'package:mediconnect/features/report/data/models/report_api_model.dart';

abstract class IReportDatasource {
  Future<ReportApiModel> getReportByAppointmentId(String appointmentId);
  Future<List<ReportApiModel>> getAllReportsForPatient();
}
