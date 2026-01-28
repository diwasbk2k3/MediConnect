import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/core/usecase/app_usecase.dart';
import 'package:mediconnect/features/profile/data/repositories/profile_repository.dart';
import 'package:mediconnect/features/profile/domain/entities/profile_entity.dart';
import 'package:mediconnect/features/profile/domain/repositories/profile_repository.dart';

class UpdatePatientProfileInfoUsecaseParams extends Equatable {
  final String? name;
  final String? address;
  final String? phoneNumber;
  final String? gender;
  final int? age;
  final String? medicalHistory;

  const UpdatePatientProfileInfoUsecaseParams({
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
final updatePatientProfileInfoUsecaseProvider = Provider<UpdatePatientProfileInfoUsecase>((ref) {
  final profileRepository = ref.watch(remoteProfileRepositoryProvider);
  return UpdatePatientProfileInfoUsecase(profileRepository: profileRepository);
});

class UpdatePatientProfileInfoUsecase implements UseCaseWithParams<ProfileEntity, UpdatePatientProfileInfoUsecaseParams> {
  final IProfileRemoteRepository _profileRepository;

  UpdatePatientProfileInfoUsecase({required IProfileRemoteRepository profileRepository})
    : _profileRepository = profileRepository;
  @override
  Future<Either<Failure, ProfileEntity>> call(
    UpdatePatientProfileInfoUsecaseParams params,
  ) {
    final entity = ProfileEntity(
      name: params.name,
      address: params.address,
      gender: params.address,
      age: params.age,
      medicalHistory: params.medicalHistory,
    );
    return _profileRepository.updatePatientProfileInfo(entity);
  }
}
