import 'package:equatable/equatable.dart';

enum RatingFormStatus { initial, loading, success, error }

class RatingFormState extends Equatable {
  final RatingFormStatus status;
  final int selectedRating;
  final String? errorMessage;

  const RatingFormState({
    this.status = RatingFormStatus.initial,
    this.selectedRating = 0,
    this.errorMessage,
  });

  RatingFormState copyWith({
    RatingFormStatus? status,
    int? selectedRating,
    String? errorMessage,
  }) {
    return RatingFormState(
      status: status ?? this.status,
      selectedRating: selectedRating ?? this.selectedRating,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, selectedRating, errorMessage];
}
