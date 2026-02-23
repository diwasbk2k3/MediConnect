// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'give_rating_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GiveRatingModel _$GiveRatingModelFromJson(Map<String, dynamic> json) =>
    GiveRatingModel(
      rating: (json['rating'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$GiveRatingModelToJson(GiveRatingModel instance) =>
    <String, dynamic>{
      'rating': instance.rating,
    };
