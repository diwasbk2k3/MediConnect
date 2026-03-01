import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/services/hive/hive_service.dart';
import 'package:mediconnect/features/hospital/data/models/hospital_cache_model.dart';
import 'package:mediconnect/features/hospital/domain/entities/hospital_entity.dart';
import 'package:mediconnect/features/appointment/data/models/appointment_cache_model.dart';
import 'package:mediconnect/features/appointment/domain/entities/appointment_entity.dart';
import 'package:mediconnect/features/profile/data/models/profile_cache_model.dart';
import 'package:mediconnect/features/profile/domain/entities/profile_entity.dart';

final cacheServiceProvider = Provider<CacheService>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return CacheService(hiveService: hiveService);
});

class CacheService {
  final HiveService _hiveService;

  CacheService({required HiveService hiveService}) : _hiveService = hiveService;

  // ==================== HOSPITAL CACHE ====================
  
  /// Cache hospital list from API response
  Future<void> cacheHospitals(List<HospitalEntity> hospitals) async {
    try {
      final models = hospitals
          .map((hospital) => HospitalCacheModel.fromEntity(hospital))
          .toList();
      await _hiveService.cacheHospitals(models);
    } catch (_) {
    }
  }

  /// Get cached hospitals
  Future<List<HospitalEntity>> getCachedHospitals() async {
    try {
      final models = await _hiveService.getCachedHospitals();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      print('Error retrieving cached hospitals: $e');
      return [];
    }
  }

  /// Cache single hospital detail
  Future<void> cacheHospitalDetail(HospitalEntity hospital) async {
    try {
      final model = HospitalCacheModel.fromEntity(hospital);
      await _hiveService.cacheHospital(model);
    } catch (_) {
    }
  }

  /// Get cached hospital detail by ID
  Future<HospitalEntity?> getCachedHospitalDetail(String hospitalId) async {
    try {
      final model = await _hiveService.getCachedHospital(hospitalId);
      return model?.toEntity();
    } catch (e) {
      return null;
    }
  }

  /// Update hospital rating in cache
  Future<void> updateHospitalRatingInCache(String hospitalId, double rating) async {
    try {
      final model = await _hiveService.getCachedHospital(hospitalId);
      if (model != null) {
        final updatedModel = model.copyWith(rating: rating);
        await _hiveService.cacheHospital(updatedModel);
      }
    } catch (_) {
    }
  }

  // ==================== APPOINTMENT CACHE ====================

  /// Cache appointment list from API response
  Future<void> cacheAppointments(List<AppointmentEntity> appointments) async {
    try {
      final models = appointments
          .map((appointment) => AppointmentCacheModel.fromEntity(appointment))
          .toList();
      await _hiveService.cacheAppointments(models);
    } catch (_) {
    }
  }

  /// Get cached appointments
  Future<List<AppointmentEntity>> getCachedAppointments() async {
    try {
      final models = await _hiveService.getCachedAppointments();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      return [];
    }
  }

  /// Cache single appointment
  Future<void> cacheAppointment(AppointmentEntity appointment) async {
    try {
      final model = AppointmentCacheModel.fromEntity(appointment);
      await _hiveService.cacheAppointment(model);
    } catch (_) {
    }
  }

  /// Get cached appointment by ID
  Future<AppointmentEntity?> getCachedAppointment(String appointmentId) async {
    try {
      final model = await _hiveService.getCachedAppointment(appointmentId);
      return model?.toEntity();
    } catch (e) {
      return null;
    }
  }

  /// Cache multiple appointments
  Future<void> cacheMultipleAppointments(List<AppointmentEntity> appointments) async {
    try {
      for (var appointment in appointments) {
        await cacheAppointment(appointment);
      }
    } catch (_) {
    }
  }

  // ==================== PROFILE CACHE ====================

  /// Cache patient profile (name and image)
  Future<void> cachePatientProfile(ProfileEntity profile) async {
    try {
      final model = ProfileCacheModel.fromEntity(profile);
      await _hiveService.cachePatientProfile(model);
    } catch (_) {
    }
  }

  /// Get cached patient profile
  Future<ProfileEntity?> getCachedPatientProfile() async {
    try {
      final model = await _hiveService.getCachedPatientProfile();
      return model?.toEntity();
    } catch (e) {
      return null;
    }
  }

  // ==================== CACHE MANAGEMENT ====================

  /// Check if hospital list cache is valid
  Future<bool> isHospitalListCacheValid({int validityHours = 24}) async {
    return await _hiveService.isCacheValid('hospitals', validityHours: validityHours);
  }

  /// Check if appointments cache is valid
  Future<bool> isAppointmentsCacheValid({int validityHours = 24}) async {
    return await _hiveService.isCacheValid('appointments', validityHours: validityHours);
  }

  /// Get the timestamp when hospital list was cached
  Future<DateTime?> getHospitalListCacheTime() async {
    return await _hiveService.getCacheTimestamp('hospitals');
  }

  /// Get the timestamp when appointments were last cached
  Future<DateTime?> getAppointmentsCacheTime() async {
    return await _hiveService.getCacheTimestamp('appointments');
  }

  /// Clear all application cache
  Future<void> clearAllCache() async {
    await _hiveService.clearAllCache();
  }

  /// Clear hospital cache
  Future<void> clearHospitalCache() async {
    await _hiveService.clearCacheByKey('hospitals');
  }

  /// Clear appointments cache
  Future<void> clearAppointmentsCache() async {
    await _hiveService.clearCacheByKey('appointments');
  }

  /// Clear specific hospital detail from cache
  Future<void> clearHospitalDetailCache(String hospitalId) async {
    await _hiveService.clearCacheByKey('hospital_$hospitalId');
  }
}
