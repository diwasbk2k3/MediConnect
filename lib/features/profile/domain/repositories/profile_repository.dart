import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/features/profile/domain/entities/profile_entity.dart';

abstract interface class IProfileRepository {
  Future<Either<Failure, Map<String, dynamic>>> fetchPatientProfileData();
  Future<Either<Failure, ProfileEntity>> createPatientProfile(ProfileEntity profileEntity);
  Future<Either<Failure, ProfileEntity>> updatePatientProfileInfo(ProfileEntity profileEntity);
  Future<Either<Failure, String>> updatePatientProfileImage(File image);
}
