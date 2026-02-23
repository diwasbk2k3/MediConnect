import 'package:equatable/equatable.dart';
import 'package:mediconnect/features/appointment/domain/entities/appointment_entity.dart';

enum AppointmentStatus { initial, loading, success, error }

class AppointmentState extends Equatable {
  final AppointmentStatus status;
  final AppointmentEntity? appointment;
  final List<AppointmentEntity> appointments;
  final String? successMessage;
  final String? errorMessage;

  const AppointmentState({
    this.status = AppointmentStatus.initial,
    this.appointment,
    this.appointments = const [],
    this.successMessage,
    this.errorMessage,
  });

  AppointmentState copyWith({
    AppointmentStatus? status,
    AppointmentEntity? appointment,
    List<AppointmentEntity>? appointments,
    String? successMessage,
    String? errorMessage,
    bool resetMessages = false,
  }) {
    return AppointmentState(
      status: status ?? this.status,
      appointment: appointment ?? this.appointment,
      appointments: appointments ?? this.appointments,
      successMessage: resetMessages ? null : (successMessage ?? this.successMessage),
      errorMessage: resetMessages ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, appointment, appointments, successMessage, errorMessage];
}
