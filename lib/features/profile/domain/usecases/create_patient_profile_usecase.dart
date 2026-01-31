import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/core/usecase/app_usecase.dart';
import 'package:mediconnect/features/profile/data/repositories/profile_repository.dart';
import 'package:mediconnect/features/profile/domain/entities/profile_entity.dart';
import 'package:mediconnect/features/profile/domain/repositories/profile_repository.dart';

class CreatePatientProfileUsecaseParams extends Equatable {
  final String? name;
  final String? address;
  final String? phoneNumber;
  final String? gender;
  final int? age;
  final String? medicalHistory;

  const CreatePatientProfileUsecaseParams({
    this.name,
    this.address,
    this.phoneNumber,
    this.gender,
    this.age,
    this.medicalHistory,
  });

  @override
  List<Object?> get props => [
    name,
    address,
    phoneNumber,
    gender,
    age,
    medicalHistory,
  ];
}

// Provider implementation for Create Patient Profile Usecase
final createPatientProfileUsecaseProvider = Provider<CreatePatientProfileUsecase>((ref) {
  final profileRepository = ref.watch(remoteProfileRepositoryProvider);
  return CreatePatientProfileUsecase(profileRepository: profileRepository);
});

class CreatePatientProfileUsecase implements UseCaseWithParams<ProfileEntity,   CreatePatientProfileUsecaseParams>{
  final IProfileRepository _profileRepository;

  CreatePatientProfileUsecase({required IProfileRepository profileRepository})
    : _profileRepository = profileRepository;

  @override
  Future<Either<Failure, ProfileEntity>> call(CreatePatientProfileUsecaseParams params) {
    final entity = ProfileEntity(
      name: params.name,
      address: params.address,
      phoneNumber: params.phoneNumber , 
      gender: params.gender,  
      age: params.age,
      medicalHistory: params.medicalHistory,
    );
    return _profileRepository.createPatientProfile(entity);
  }
}