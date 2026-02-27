import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/features/hospital/domain/usecases/get_all_approved_hospitals_usecase.dart';
import 'package:mediconnect/features/hospital/domain/usecases/get_average_rating_usecase.dart';
import 'package:mediconnect/features/hospital/presentation/state/hospital_state.dart';

// Provider
final hospitalViewModelProvider =
    NotifierProvider<HospitalViewModel, HospitalState>(
        () => HospitalViewModel());

class HospitalViewModel extends Notifier<HospitalState> {
  late final GetAllApprovedHospitalsUsecase _getAllApprovedHospitalsUsecase;
  late final GetAverageRatingUsecase _getAverageRatingUsecase;

  @override
  HospitalState build() {
    _getAllApprovedHospitalsUsecase =
        ref.read(getAllApprovedHospitalsUsecaseProvider);
    _getAverageRatingUsecase = ref.read(getAverageRatingUsecaseProvider);
    return const HospitalState();
  }

  /// Fetch all approved hospitals with their ratings
  Future<void> fetchAllApprovedHospitals() async {
    state = state.copyWith(status: HospitalStatus.loading);

    final result = await _getAllApprovedHospitalsUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: HospitalStatus.error,
          errorMessage: failure.message,
        );
      },
      (hospitals) async {
        // Fetch ratings for each hospital
        final hospitalsWithRatings = await Future.wait(
          hospitals.map((hospital) async {
            final ratingResult = await _getAverageRatingUsecase(
              GetAverageRatingUsecaseParams(
                hospitalId: hospital.hospitalId ?? '',
              ),
            );

            return ratingResult.fold(
              (failure) => hospital.copyWith(rating: 0.0),
              (rating) => hospital.copyWith(rating: rating),
            );
          }),
        );

        state = state.copyWith(
          status: HospitalStatus.loaded,
          hospitals: hospitalsWithRatings,
          filteredHospitals: hospitalsWithRatings,
        );
      },
    );
  }

  /// Search hospitals by name, address, or description
  void searchHospitals(String query) {
    state = state.copyWith(searchQuery: query);

    if (query.isEmpty) {
      // If search is empty, show all hospitals
      state = state.copyWith(filteredHospitals: state.hospitals);
    } else {
      // Filter hospitals based on search query
      final filtered = state.hospitals.where((hospital) {
        final name = hospital.name?.toLowerCase() ?? '';
        final address = hospital.address?.toLowerCase() ?? '';
        final description = hospital.description?.toLowerCase() ?? '';
        final searchLower = query.toLowerCase();

        return name.contains(searchLower) ||
            address.contains(searchLower) ||
            description.contains(searchLower);
      }).toList();

      state = state.copyWith(filteredHospitals: filtered);
    }
  }
}
