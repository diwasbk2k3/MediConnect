import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mediconnect/core/constants/hive_table_constant.dart';
import 'package:mediconnect/features/auth/data/models/auth_hive_model.dart';
import 'package:mediconnect/features/hospital/data/models/hospital_cache_model.dart';
import 'package:mediconnect/features/appointment/data/models/appointment_cache_model.dart';
import 'package:mediconnect/features/profile/data/models/profile_cache_model.dart';
import 'package:path_provider/path_provider.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  // init
  Future<void> init() async {
    try {
      // Only initialize Hive for non-web platforms
      if (!kIsWeb) {
        final directory = await getApplicationCacheDirectory();
        final path = '${directory.path}/${HiveTableConstant.dbName}';
        Hive.init(path);
      } else {
        // For web, just initialize Hive without a path
        await Hive.initFlutter();
      }
      _registerAdapter();
      await openBoxes();
    } catch (e) {
      debugPrint('Error initializing Hive: $e');
      rethrow;
    }
  }

  // Register Adapter
  void _registerAdapter() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.hospitalCacheTypeId)) {
      Hive.registerAdapter(HospitalCacheModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.appointmentCacheTypeId)) {
      Hive.registerAdapter(AppointmentCacheModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.profileCacheTypeId)) {
      Hive.registerAdapter(ProfileCacheModelAdapter());
    }
    // Register other adapters here
  }

  // Open Boxes
  Future<void> openBoxes() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
    await Hive.openBox<HospitalCacheModel>(HiveTableConstant.hospitalCacheTable);
    await Hive.openBox<AppointmentCacheModel>(HiveTableConstant.appointmentCacheTable);
    await Hive.openBox<ProfileCacheModel>(HiveTableConstant.profileCacheTable);
    await Hive.openBox(HiveTableConstant.cacheMetadataTable);
    await Hive.openBox('_user_cache');
  }

  // Close Boxes
  Future<void> close() async {
    await Hive.close();
  }

  // ==================== AUTH QUERIES ====================
  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstant.authTable);

  Future<AuthHiveModel> createAuth(AuthHiveModel model) async {
    await _authBox.put(model.authId, model);
    return model;
  }

  // Register
  Future<void> registerUser(AuthHiveModel model) async {
    await _authBox.put(model.authId, model);
  }

  // Login
  Future<AuthHiveModel?> loginUser(String email, String password) async {
    final users = _authBox.values.where(
      (user) => user.email == email && user.password == password,
    );
    if (users.isNotEmpty) {
      return users.first;
    }
    return null;
  }

  // Logout
  Future<void> logoutUser() async {
    try{
      final box = Hive.box('_user_cache');
      await box.delete('currentUserId');
    }catch(err){
      debugPrint('Error during logout: $err');
    }
  }

  // Get Current User by authId
  AuthHiveModel? getCurrentUser(String authId) {
    return _authBox.get(authId);
  }

  // Get Current User from Cache (last logged in)
  Future<AuthHiveModel?> getCurrentUserFromCache() async {
    try {
      final box = Hive.box('_user_cache');
      final currentUserId = box.get('currentUserId');
      if (currentUserId != null) {
        return _authBox.get(currentUserId);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Set Current User Cache
  Future<void> setCurrentUserCache(AuthHiveModel user) async {
    try {
      final box = Hive.box('_user_cache');
      await box.put('currentUserId', user.authId);
    } catch (e) {
      debugPrint('Error caching user: $e');
    }
  }

  // Is Email Exists
  Future<bool> isEmailExists(String email) {
    final users = _authBox.values.where((user) => user.email == email);
    return Future.value(users.isNotEmpty);
  }

  // ==================== HOSPITAL CACHE QUERIES ====================
  Box<HospitalCacheModel> get _hospitalCacheBox =>
      Hive.box<HospitalCacheModel>(HiveTableConstant.hospitalCacheTable);

  // Cache all hospitals
  Future<void> cacheHospitals(List<HospitalCacheModel> hospitals) async {
    try {
      await _hospitalCacheBox.clear();
      final Map<String, HospitalCacheModel> hospitalMap = {
        for (var hospital in hospitals) hospital.hospitalId ?? '': hospital
      };
      await _hospitalCacheBox.putAll(hospitalMap);
      await _updateCacheMetadata('hospitals');
    } catch (e) {
      debugPrint('Error caching hospitals: $e');
    }
  }

  // Get cached hospitals
  Future<List<HospitalCacheModel>> getCachedHospitals() async {
    try {
      return _hospitalCacheBox.values.toList();
    } catch (e) {
      debugPrint('Error retrieving cached hospitals: $e');
      return [];
    }
  }

  // Cache single hospital
  Future<void> cacheHospital(HospitalCacheModel hospital) async {
    try {
      await _hospitalCacheBox.put(hospital.hospitalId ?? '', hospital);
      await _updateCacheMetadata('hospital_${hospital.hospitalId}');
    } catch (e) {
      debugPrint('Error caching hospital: $e');
    }
  }

  // Get cached hospital by ID
  Future<HospitalCacheModel?> getCachedHospital(String hospitalId) async {
    try {
      return _hospitalCacheBox.get(hospitalId);
    } catch (e) {
      debugPrint('Error retrieving cached hospital: $e');
      return null;
    }
  }

  // ==================== APPOINTMENT CACHE QUERIES ====================
  Box<AppointmentCacheModel> get _appointmentCacheBox =>
      Hive.box<AppointmentCacheModel>(HiveTableConstant.appointmentCacheTable);

  // Cache all appointments (clear old, cache new)
  // Note: We cache appointments with their status to keep them organized
  Future<void> cacheAppointments(List<AppointmentCacheModel> appointments) async {
    try {
      // Get the status from the first appointment (all should have same status from API)
      final appointmentStatus = appointments.isNotEmpty 
          ? appointments.first.status 
          : null;
      
      debugPrint('HiveService: Caching ${appointments.length} appointments with status: $appointmentStatus');
      
      // For status-based caching, we clear only appointments with the same status
      // This prevents mixing scheduled, completed, and cancelled appointments
      if (appointmentStatus != null) {
        // Remove old appointments with the same status
        final allCached = _appointmentCacheBox.values.toList();
        for (var appointment in allCached) {
          if (appointment.status == appointmentStatus) {
            final index = _appointmentCacheBox.keys
                .toList()
                .indexOf(appointment.appointmentId ?? '');
            if (index != -1) {
              await _appointmentCacheBox.deleteAt(index);
            }
          }
        }
      }
      
      final Map<String, AppointmentCacheModel> appointmentMap = {
        for (var appointment in appointments)
          appointment.appointmentId ?? '': appointment
      };
      debugPrint('HiveService: Storing ${appointmentMap.length} appointments to Hive');
      await _appointmentCacheBox.putAll(appointmentMap);
      await _updateCacheMetadata('appointments');
      debugPrint('HiveService: Successfully cached ${appointments.length} appointments with status: $appointmentStatus');
    } catch (e) {
      debugPrint('HiveService Error caching appointments: $e');
    }
  }

  // Get cached appointments
  Future<List<AppointmentCacheModel>> getCachedAppointments() async {
    try {
      debugPrint('HiveService: Retrieving appointments from cache');
      final cached = _appointmentCacheBox.values.toList();
      debugPrint('HiveService: Found ${cached.length} cached appointments');
      return cached;
    } catch (e) {
      debugPrint('HiveService Error retrieving cached appointments: $e');
      return [];
    }
  }

  // Cache single appointment
  Future<void> cacheAppointment(AppointmentCacheModel appointment) async {
    try {
      await _appointmentCacheBox.put(appointment.appointmentId ?? '', appointment);
      await _updateCacheMetadata('appointment_${appointment.appointmentId}');
    } catch (e) {
      debugPrint('Error caching appointment: $e');
    }
  }

  // Get cached appointment by ID
  Future<AppointmentCacheModel?> getCachedAppointment(String appointmentId) async {
    try {
      return _appointmentCacheBox.get(appointmentId);
    } catch (e) {
      debugPrint('Error retrieving cached appointment: $e');
      return null;
    }
  }

  // ==================== PROFILE CACHE QUERIES ====================
  Box<ProfileCacheModel> get _profileCacheBox =>
      Hive.box<ProfileCacheModel>(HiveTableConstant.profileCacheTable);

  // Cache patient profile
  Future<void> cachePatientProfile(ProfileCacheModel profile) async {
    try {
      await _profileCacheBox.put('patient_profile', profile);
      await _updateCacheMetadata('patient_profile');
      debugPrint('HiveService: Patient profile cached');
    } catch (e) {
      debugPrint('HiveService Error caching patient profile: $e');
    }
  }

  // Get cached patient profile
  Future<ProfileCacheModel?> getCachedPatientProfile() async {
    try {
      debugPrint('HiveService: Retrieving patient profile from cache');
      final profile = _profileCacheBox.get('patient_profile');
      if (profile != null) {
        debugPrint('HiveService: Found cached patient profile');
      }
      return profile;
    } catch (e) {
      debugPrint('HiveService Error retrieving cached patient profile: $e');
      return null;
    }
  }

  // ==================== CACHE METADATA ====================
  Box get _metadataBox => Hive.box(HiveTableConstant.cacheMetadataTable);

  Future<void> _updateCacheMetadata(String key) async {
    try {
      await _metadataBox.put('${key}_timestamp', DateTime.now().toIso8601String());
    } catch (e) {
      debugPrint('Error updating cache metadata: $e');
    }
  }

  Future<DateTime?> getCacheTimestamp(String key) async {
    try {
      final timestamp = _metadataBox.get('${key}_timestamp');
      if (timestamp != null) {
        return DateTime.parse(timestamp);
      }
    } catch (e) {
      debugPrint('Error retrieving cache timestamp: $e');
    }
    return null;
  }

  // Check if cache is still valid (less than specified hours)
  Future<bool> isCacheValid(String key, {int validityHours = 24}) async {
    try {
      final timestamp = await getCacheTimestamp(key);
      if (timestamp == null) return false;
      
      final now = DateTime.now();
      final difference = now.difference(timestamp).inHours;
      return difference < validityHours;
    } catch (e) {
      debugPrint('Error checking cache validity: $e');
      return false;
    }
  }

  // Clear all cache
  Future<void> clearAllCache() async {
    try {
      await _hospitalCacheBox.clear();
      await _appointmentCacheBox.clear();
      await _profileCacheBox.clear();
      await _metadataBox.clear();
      debugPrint('All cache cleared successfully');
    } catch (e) {
      debugPrint('Error clearing cache: $e');
    }
  }

  // Clear specific cache by key
  Future<void> clearCacheByKey(String key) async {
    try {
      await _metadataBox.delete('${key}_timestamp');
      debugPrint('Cache key $key cleared successfully');
    } catch (e) {
      debugPrint('Error clearing cache key: $e');
    }
  }
}
