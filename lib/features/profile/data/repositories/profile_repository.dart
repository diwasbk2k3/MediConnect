import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/api/api_endpoints.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/core/services/connectivity/network_info.dart';
import 'package:mediconnect/core/services/cache/cache_service.dart';
import 'package:mediconnect/features/profile/data/datasources/remote/profile_remote_datasource.dart';
import 'package:mediconnect/features/profile/data/models/profile_api_model.dart';
import 'package:mediconnect/features/profile/domain/entities/profile_entity.dart';
import 'package:mediconnect/features/profile/domain/repositories/profile_repository.dart';
import 'package:path_provider/path_provider.dart';

// Provider
final remoteProfileRepositoryProvider = Provider<IProfileRepository>((
  ref,
) {
  final networkInfo = ref.read(networkInfoProvider);
  final profileRemoteDatasource = ref.read(profileRemoteDatasourceProvider);
  final cacheService = ref.read(cacheServiceProvider);
  return RemoteProfileRepository(
    networkInfo: networkInfo,
    profileRemoteDatasource: profileRemoteDatasource,
    cacheService: cacheService,
  );
});

class RemoteProfileRepository implements IProfileRepository {
  final NetworkInfo _networkInfo;
  final ProfileRemoteDatasource _profileRemoteDatasource;
  final CacheService _cacheService;

  RemoteProfileRepository({
    required NetworkInfo networkInfo,
    required ProfileRemoteDatasource profileRemoteDatasource,
    required CacheService cacheService,
  }) : _networkInfo = networkInfo,
       _profileRemoteDatasource = profileRemoteDatasource,
       _cacheService = cacheService;

  /// Download and cache image locally
  Future<String?> _downloadAndCacheProfileImage(String? imageUrl) async {
    if (imageUrl == null || imageUrl.isEmpty) return null;
    
    try {
      // If it's already a local file path, return it as is
      if (imageUrl.startsWith('/') || imageUrl.contains('profile_images')) {
        return imageUrl;
      }

      final cacheDir = await getApplicationCacheDirectory();
      final profileImageDir = Directory('${cacheDir.path}/profile_images');
      if (!await profileImageDir.exists()) {
        await profileImageDir.create(recursive: true);
      }

      // Extract filename from URL or create one
      final fileName = imageUrl.split('/').last.isEmpty 
          ? 'profile_image.jpg' 
          : imageUrl.split('/').last;
      final filePath = '${profileImageDir.path}/$fileName';

      // Check if URL is complete (has http/https)
      String fullUrl = imageUrl;
      if (!imageUrl.startsWith('http')) {
        // Construct full URL from relative path
        // ApiEndpoints.baseUrl already includes /api, so just append the image path
        fullUrl = '${ApiEndpoints.baseUrl}/$imageUrl';
      }
      
      // Download the image
      final dio = Dio();
      await dio.download(fullUrl, filePath);
      return filePath;
    } catch (e) {
      return imageUrl; // Return original URL if download fails
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> fetchPatientProfileData() async {
    if (await _networkInfo.isConnected) {
      try {
        final profileData = await _profileRemoteDatasource
            .fetchPatientProfileData();
        
        // Cache the profile data after successful fetch
        if (profileData.isNotEmpty) {
          // Download and cache the profile image locally
          String? cachedImagePath;
          final imageUrl = profileData['profileImageUrl'] as String?;
          if (imageUrl != null && imageUrl.isNotEmpty) {
            cachedImagePath = await _downloadAndCacheProfileImage(imageUrl);
          }

          final profileEntity = ProfileEntity(
            patientId: profileData['patientId'] as String?,
            name: profileData['name'] as String?,
            address: profileData['address'] as String?,
            phoneNumber: profileData['phone'] as String?,
            gender: profileData['gender'] as String?,
            age: profileData['age'] as int?,
            medicalHistory: profileData['medicalHistory'] as String?,
            profileImageUrl: cachedImagePath ?? imageUrl,
          );
          await _cacheService.cachePatientProfile(profileEntity);
          
          // Return with local image path
          profileData['profileImageUrl'] = cachedImagePath ?? imageUrl;
        }
        
        return Right(profileData);
      } on DioException catch (err) {
        // On error, try to return cached profile
        final cachedProfile = await _cacheService.getCachedPatientProfile();
        if (cachedProfile != null) {
          return Right({
            'patientId': cachedProfile.patientId,
            'name': cachedProfile.name,
            'address': cachedProfile.address,
            'phone': cachedProfile.phoneNumber,
            'gender': cachedProfile.gender,
            'age': cachedProfile.age,
            'medicalHistory': cachedProfile.medicalHistory,
            'profileImageUrl': cachedProfile.profileImageUrl,
          });
        }
        return Left(ApiFailure(message: err.message ?? "Failed to fetch profile"));
      } catch (e) {
        // On error, try to return cached profile
        final cachedProfile = await _cacheService.getCachedPatientProfile();
        if (cachedProfile != null) {
          return Right({
            'patientId': cachedProfile.patientId,
            'name': cachedProfile.name,
            'address': cachedProfile.address,
            'phone': cachedProfile.phoneNumber,
            'gender': cachedProfile.gender,
            'age': cachedProfile.age,
            'medicalHistory': cachedProfile.medicalHistory,
            'profileImageUrl': cachedProfile.profileImageUrl,
          });
        }
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      // Offline: Try to return cached profile
      final cachedProfile = await _cacheService.getCachedPatientProfile();
      if (cachedProfile != null) {
        return Right({
          'patientId': cachedProfile.patientId,
          'name': cachedProfile.name,
          'address': cachedProfile.address,
          'phone': cachedProfile.phoneNumber,
          'gender': cachedProfile.gender,
          'age': cachedProfile.age,
          'medicalHistory': cachedProfile.medicalHistory,
          'profileImageUrl': cachedProfile.profileImageUrl,
        });
      }
      return Left(ApiFailure(message: "No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, String>> updatePatientProfileImage(File image) async {
    if (await _networkInfo.isConnected) {
      try {
        final fileName = await _profileRemoteDatasource
            .updatePatientProfileImage(image);
        return Right(fileName);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: "No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> createPatientProfile(ProfileEntity profileEntity) async {
    if (await _networkInfo.isConnected) {
      try {
        // Go to remote
        final apiModel = ProfileApiModel.fromEntity(profileEntity);
        final result = await _profileRemoteDatasource.createPatientProfile(apiModel);
        var entity = result.toEntity();
        
        // Download and cache the profile image locally
        if (entity.profileImageUrl != null && entity.profileImageUrl!.isNotEmpty) {
          final cachedImagePath = await _downloadAndCacheProfileImage(entity.profileImageUrl);
          if (cachedImagePath != null) {
            entity = entity.copyWith(profileImageUrl: cachedImagePath);
          }
        }
        
        // Cache the profile after successful creation
        await _cacheService.cachePatientProfile(entity);
        
        return Right(entity);
      } on DioException catch (err) {
        return Left(
          ApiFailure(
            message: err.message ?? "Registration failed",
            statusCode: err.response?.statusCode,
          ),
        );
      } catch (err) {
        return Left(ApiFailure(message: err.toString()));
      }
    } else {
      return Left(ApiFailure(message: "No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updatePatientProfileInfo(ProfileEntity profileEntity) async {
    if(await _networkInfo.isConnected ){
      try{
        final apiModel = ProfileApiModel.fromEntity(profileEntity);
        final result = await _profileRemoteDatasource.updatePatientProfileInfo(apiModel);
        var entity = result.toEntity();
        
        // Download and cache the profile image locally
        if (entity.profileImageUrl != null && entity.profileImageUrl!.isNotEmpty) {
          final cachedImagePath = await _downloadAndCacheProfileImage(entity.profileImageUrl);
          if (cachedImagePath != null) {
            entity = entity.copyWith(profileImageUrl: cachedImagePath);
          }
        }
        
        // Cache the updated profile
        await _cacheService.cachePatientProfile(entity);
        
        return Right(entity);
      }on DioException catch (err){
        return Left( ApiFailure(message: err.message ?? "Failed to update profile info!",statusCode: err.response?.statusCode));
      }catch (err){
        return Left(ApiFailure(message: err.toString()));
      }
    }else{
      return Left(ApiFailure(message: "No Internet Connection"));
    }
  }
}
