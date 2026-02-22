import 'package:equatable/equatable.dart';

class GiveRatingEntity extends Equatable {
  final String hospitalId;
  final int rating;

  const GiveRatingEntity({
    required this.hospitalId,
    required this.rating,
  });

  @override
  List<Object?> get props => [hospitalId, rating];
}
