import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/features/appointment/domain/usecases/book_appointment_usecase.dart';
import 'package:mediconnect/features/appointment/domain/usecases/cancel_appointment_usecase.dart';
import 'package:mediconnect/features/appointment/domain/usecases/get_appointments_by_status_usecase.dart';
import 'package:mediconnect/features/appointment/presentation/state/appointment_state.dart';

// Provider
final appointmentViewModelProvider =
    NotifierProvider<AppointmentViewModel, AppointmentState>(
        () => AppointmentViewModel());

class AppointmentViewModel extends Notifier<AppointmentState> {
  late final BookAppointmentUsecase _bookAppointmentUsecase;
  late final GetAppointmentsByStatusUsecase _getAppointmentsByStatusUsecase;
  late final CancelAppointmentUsecase _cancelAppointmentUsecase;

  @override
  AppointmentState build() {
    _bookAppointmentUsecase = ref.read(bookAppointmentUsecaseProvider);
    _getAppointmentsByStatusUsecase = ref.read(getAppointmentsByStatusUsecaseProvider);
    _cancelAppointmentUsecase = ref.read(cancelAppointmentUsecaseProvider);
    return const AppointmentState();
  }

  /// Book an appointment with selected hospital
  Future<void> bookAppointment({
    required String hospitalId,
    required String department,
    required String appointmentType,
    required String appointmentDate,
    required String appointmentTime,
    required double paymentAmount,
  }) async {
    state = state.copyWith(
      status: AppointmentStatus.loading,
      resetMessages: true,
    );

    final result = await _bookAppointmentUsecase(
      BookAppointmentUsecaseParams(
        hospitalId: hospitalId,
        department: department,
        appointmentType: appointmentType,
        appointmentDate: appointmentDate,
        appointmentTime: appointmentTime,
        paymentAmount: paymentAmount,
      ),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AppointmentStatus.error,
          errorMessage: failure.message,
        );
      },
      (appointment) {
        state = state.copyWith(
          status: AppointmentStatus.success,
          appointment: appointment,
          successMessage: 'Appointment booked successfully!',
        );
      },
    );
  }

  /// Get appointments by status (not-visited or visited)
  Future<void> getAppointmentsByStatus(String status) async {
    state = state.copyWith(
      status: AppointmentStatus.loading,
      resetMessages: true,
    );

    final result = await _getAppointmentsByStatusUsecase(
      GetAppointmentsByStatusUsecaseParams(status: status),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AppointmentStatus.error,
          errorMessage: failure.message,
        );
      },
      (appointments) {
        state = state.copyWith(
          status: AppointmentStatus.success,
          appointments: appointments,
        );
      },
    );
  }

  /// Cancel appointment with reason
  Future<void> cancelAppointment({
    required String appointmentId,
    required String cancellationReason,
  }) async {
    state = state.copyWith(
      status: AppointmentStatus.loading,
      resetMessages: true,
    );

    final result = await _cancelAppointmentUsecase(
      CancelAppointmentUsecaseParams(
        appointmentId: appointmentId,
        cancellationReason: cancellationReason,
      ),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AppointmentStatus.error,
          errorMessage: failure.message,
        );
      },
      (_) {
        state = state.copyWith(
          status: AppointmentStatus.success,
          successMessage: 'Appointment cancelled successfully!',
        );
      },
    );
  }

  /// Reset state messages
  void resetMessages() {
    state = state.copyWith(resetMessages: true);
  }

  /// Reset state to initial
  void resetState() {
    state = const AppointmentState();
  }
}
