import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:mediconnect/core/error/failures.dart';

abstract interface class IProfileRemoteRepository {
  Future<Either<Failure, String>> updatePatientProfileImage(File image);
  Future<Either<Failure, Map<String, dynamic>>> fetchPatientProfileData();
}
