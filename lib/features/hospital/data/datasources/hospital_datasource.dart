import 'package:mediconnect/features/hospital/data/models/hospital_api_model.dart';

abstract interface class IHospitalRemoteDatasource {
  Future<List<HospitalApiModel>> getAllApprovedHospitals();
  Future<HospitalApiModel> getHospitalProfileInfo(String hospitalId);
  Future<Map<String, dynamic>> getAverageRatingOfHospital(String hospitalId);
  Future<Map<String, dynamic>> giveRatingToHospital({required String hospitalId,required int rating});
}