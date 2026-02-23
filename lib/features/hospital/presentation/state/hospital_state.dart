import 'package:equatable/equatable.dart';
import 'package:mediconnect/features/hospital/domain/entities/hospital_entity.dart';

enum HospitalStatus { initial, loading, loaded, error }

class HospitalState extends Equatable {
  final HospitalStatus status;
  final List<HospitalEntity> hospitals;
  final String? errorMessage;

  const HospitalState({
    this.status = HospitalStatus.initial,
    this.hospitals = const [],
    this.errorMessage,
  });

  HospitalState copyWith({
    HospitalStatus? status,
    List<HospitalEntity>? hospitals,
    String? errorMessage,
    bool resetErrorMessage = false,
  }) {
    return HospitalState(
      status: status ?? this.status,
      hospitals: hospitals ?? this.hospitals,
      errorMessage: resetErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, hospitals, errorMessage];
}
