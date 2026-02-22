import 'package:json_annotation/json_annotation.dart';
import 'package:mediconnect/features/hospital/domain/entities/give_rating_entity.dart';

part 'give_rating_model.g.dart';

@JsonSerializable()
class GiveRatingModel {
  @JsonKey(defaultValue: 0)
  final int rating;

  GiveRatingModel({required this.rating});

  factory GiveRatingModel.fromJson(Map<String, dynamic> json) =>
      _$GiveRatingModelFromJson(json);

  Map<String, dynamic> toJson() => _$GiveRatingModelToJson(this);

  GiveRatingEntity toEntity() =>
      GiveRatingEntity(hospitalId: '', rating: rating);
}
