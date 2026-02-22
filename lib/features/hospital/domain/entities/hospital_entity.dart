import 'package:equatable/equatable.dart';

class HospitalEntity extends Equatable {
  final String? hospitalId;
  final String? name;
  final String? address;
  final String? phone;
  final String? description;
  final List<Map<String, dynamic>>? departments;
  final double? rating;
  final String? profileImageUrl;

  const HospitalEntity({
    this.hospitalId,
    this.name,
    this.address,
    this.phone,
    this.description,
    this.departments,
    this.rating,
    this.profileImageUrl,
  });

  HospitalEntity copyWith({
    String? hospitalId,
    String? name,
    String? address,
    String? phone,
    String? description,
    List<Map<String, dynamic>>? departments,
    double? rating,
    String? profileImageUrl,
  }) {
    return HospitalEntity(
      hospitalId: hospitalId ?? this.hospitalId,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      description: description ?? this.description,
      departments: departments ?? this.departments,
      rating: rating ?? this.rating,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  @override
  List<Object?> get props => [
    hospitalId,
    name,
    address,
    phone,
    description,
    departments,
    rating,
    profileImageUrl,
  ];
}
