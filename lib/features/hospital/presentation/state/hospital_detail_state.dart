import 'package:equatable/equatable.dart';
import 'package:mediconnect/features/hospital/domain/entities/hospital_entity.dart';

enum HospitalDetailStatus { initial, loading, loaded, error }

class HospitalDetailState extends Equatable {
  final HospitalDetailStatus status;
  final HospitalEntity? hospital;
  final String? errorMessage;

  const HospitalDetailState({
    this.status = HospitalDetailStatus.initial,
    this.hospital,
    this.errorMessage,
  });

  HospitalDetailState copyWith({
    HospitalDetailStatus? status,
    HospitalEntity? hospital,
    String? errorMessage,
    bool resetErrorMessage = false,
  }) {
    return HospitalDetailState(
      status: status ?? this.status,
      hospital: hospital ?? this.hospital,
      errorMessage: resetErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, hospital, errorMessage];
}
