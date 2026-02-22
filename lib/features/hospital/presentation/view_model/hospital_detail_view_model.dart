import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/features/hospital/domain/entities/hospital_entity.dart';
import 'package:mediconnect/features/hospital/domain/usecases/get_hospital_profile_info_usecase.dart';

final hospitalDetailViewModelProvider =
    FutureProvider.family<HospitalEntity, String>((ref, hospitalId) async {
  final usecase = ref.read(getHospitalProfileInfoUsecaseProvider);
  final result = await usecase(
    GetHospitalProfileInfoUsecaseParams(hospitalId: hospitalId),
  );

  return result.fold(
    (failure) => throw Exception(failure.message),
    (hospital) => hospital,
  );
});
