import 'package:mediconnect/features/appointment/data/models/appointment_api_model.dart';

abstract interface class IAppointmentListRemoteDatasource {
  Future<List<AppointmentApiModel>> getAppointmentsByStatus(String status);
  Future<void> cancelAppointment({
    required String appointmentId,
    required String cancellationReason,
  });
}
