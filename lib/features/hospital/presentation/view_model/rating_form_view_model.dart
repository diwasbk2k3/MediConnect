import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/features/hospital/domain/usecases/give_rating_usecase.dart';
import 'package:mediconnect/features/hospital/presentation/state/rating_form_state.dart';

// Provider
final ratingFormNotifierProvider =
    StateNotifierProvider<RatingFormNotifier, RatingFormState>((ref) {
  final giveRatingUsecase = ref.read(giveRatingUsecaseProvider);
  return RatingFormNotifier(giveRatingUsecase: giveRatingUsecase);
});

class RatingFormNotifier extends StateNotifier<RatingFormState> {
  final GiveRatingUsecase _giveRatingUsecase;

  RatingFormNotifier({required GiveRatingUsecase giveRatingUsecase})
      : _giveRatingUsecase = giveRatingUsecase,
        super(const RatingFormState());

  void setRating(int rating) {
    super.state = state.copyWith(selectedRating: rating);
  }

  Future<void> submitRating(String hospitalId) async {
    if (state.selectedRating == 0) {
      super.state = state.copyWith(
        status: RatingFormStatus.error,
        errorMessage: 'Please select a rating',
      );
      return;
    }

    super.state = state.copyWith(status: RatingFormStatus.loading);

    final result = await _giveRatingUsecase(
      GiveRatingUsecaseParams(
        hospitalId: hospitalId,
        rating: state.selectedRating,
      ),
    );

    result.fold(
      (failure) {
        super.state = state.copyWith(
          status: RatingFormStatus.error,
          errorMessage: failure.message,
        );
      },
      (success) {
        super.state = state.copyWith(
          status: RatingFormStatus.success,
          errorMessage: null,
        );
      },
    );
  }

  void resetForm() {
    super.state = const RatingFormState();
  }
}