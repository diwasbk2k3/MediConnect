import 'package:equatable/equatable.dart';
import 'package:mediconnect/features/hospital/domain/entities/hospital_entity.dart';

enum HospitalStatus { initial, loading, loaded, error }

class HospitalState extends Equatable {
  final HospitalStatus status;
  final List<HospitalEntity> hospitals;
  final List<HospitalEntity> filteredHospitals;
  final String? errorMessage;
  final String searchQuery;

  const HospitalState({
    this.status = HospitalStatus.initial,
    this.hospitals = const [],
    this.filteredHospitals = const [],
    this.errorMessage,
    this.searchQuery = '',
  });

  HospitalState copyWith({
    HospitalStatus? status,
    List<HospitalEntity>? hospitals,
    List<HospitalEntity>? filteredHospitals,
    String? errorMessage,
    String? searchQuery,
    bool resetErrorMessage = false,
  }) {
    return HospitalState(
      status: status ?? this.status,
      hospitals: hospitals ?? this.hospitals,
      filteredHospitals: filteredHospitals ?? this.filteredHospitals,
      errorMessage: resetErrorMessage ? null : (errorMessage ?? this.errorMessage),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [status, hospitals, filteredHospitals, errorMessage, searchQuery];
}
