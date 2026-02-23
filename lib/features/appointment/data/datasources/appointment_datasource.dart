import 'package:mediconnect/features/appointment/data/models/appointment_api_model.dart';

abstract interface class IAppointmentRemoteDatasource {
  Future<AppointmentApiModel> bookAppointment({
    required String hospitalId,
    required String department,
    required String appointmentType,
    required String appointmentDate,
    required String appointmentTime,
    required double paymentAmount,
  });
}
