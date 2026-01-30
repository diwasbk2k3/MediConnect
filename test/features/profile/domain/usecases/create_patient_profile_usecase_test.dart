import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/features/profile/domain/entities/profile_entity.dart';
import 'package:mediconnect/features/profile/domain/repositories/profile_repository.dart';
import 'package:mediconnect/features/profile/domain/usecases/create_patient_profile_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements IProfileRepository {}

void main() {
  late CreatePatientProfileUsecase usecase;
  late MockProfileRepository mockRepository;

  setUp(() {
    mockRepository = MockProfileRepository();
    usecase = CreatePatientProfileUsecase(profileRepository: mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(
      const ProfileEntity(
        name: 'fallback',
        address: 'fallback',
        phoneNumber: '0000000000',
        gender: 'Male',
        age: 30,
        medicalHistory: 'fallback',
      ),
    );
  });

  const tName = 'John Doe';
  const tAddress = '123 Main Street, City';
  const tPhoneNumber = '9876543210';
  const tGender = 'Male';
  const tAge = 30;
  const tMedicalHistory = 'No known allergies';
  const tPatientId = 'patient_123';

  const tProfileEntity = ProfileEntity(
    patientId: tPatientId,
    name: tName,
    address: tAddress,
    phoneNumber: tPhoneNumber,
    gender: tGender,
    age: tAge,
    medicalHistory: tMedicalHistory,
  );

  group('CreatePatientProfileUsecase', () {
    test('should return ProfileEntity when profile is created successfully',
        () async {
      // Arrange
      when(() => mockRepository.createPatientProfile(any()))
          .thenAnswer((_) async => const Right(tProfileEntity));

      // Act
      final result = await usecase(
        const CreatePatientProfileUsecaseParams(
          name: tName,
          address: tAddress,
          phoneNumber: tPhoneNumber,
          gender: tGender,
          age: tAge,
          medicalHistory: tMedicalHistory,
        ),
      );

      // Assert
      expect(result, const Right(tProfileEntity));
      verify(() => mockRepository.createPatientProfile(any())).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass ProfileEntity with correct values to repository',
        () async {
      // Arrange
      ProfileEntity? capturedEntity;
      when(() => mockRepository.createPatientProfile(any()))
          .thenAnswer((invocation) {
        capturedEntity = invocation.positionalArguments[0] as ProfileEntity;
        return Future.value(
          Right(
            ProfileEntity(
              patientId: tPatientId,
              name: capturedEntity?.name,
              address: capturedEntity?.address,
              phoneNumber: capturedEntity?.phoneNumber,
              gender: capturedEntity?.gender,
              age: capturedEntity?.age,
              medicalHistory: capturedEntity?.medicalHistory,
            ),
          ),
        );
      });

      // Act
      await usecase(
        const CreatePatientProfileUsecaseParams(
          name: tName,
          address: tAddress,
          phoneNumber: tPhoneNumber,
          gender: tGender,
          age: tAge,
          medicalHistory: tMedicalHistory,
        ),
      );

      // Assert
      expect(capturedEntity?.name, tName);
      expect(capturedEntity?.address, tAddress);
      expect(capturedEntity?.phoneNumber, tPhoneNumber);
      expect(capturedEntity?.gender, tGender);
      expect(capturedEntity?.age, tAge);
      expect(capturedEntity?.medicalHistory, tMedicalHistory);
    });

    test('should handle all optional parameters correctly', () async {
      // Arrange
      ProfileEntity? capturedEntity;
      when(() => mockRepository.createPatientProfile(any()))
          .thenAnswer((invocation) {
        capturedEntity = invocation.positionalArguments[0] as ProfileEntity;
        return Future.value(
          Right(
            ProfileEntity(
              patientId: tPatientId,
              name: capturedEntity?.name,
              address: capturedEntity?.address,
              phoneNumber: capturedEntity?.phoneNumber,
              gender: capturedEntity?.gender,
              age: capturedEntity?.age,
              medicalHistory: capturedEntity?.medicalHistory,
            ),
          ),
        );
      });

      // Act
      await usecase(
        const CreatePatientProfileUsecaseParams(
          name: tName,
          address: tAddress,
          phoneNumber: tPhoneNumber,
          gender: tGender,
          age: tAge,
          medicalHistory: tMedicalHistory,
        ),
      );

      // Assert
      expect(capturedEntity?.name, isNotNull);
      expect(capturedEntity?.address, isNotNull);
      expect(capturedEntity?.phoneNumber, isNotNull);
      expect(capturedEntity?.gender, isNotNull);
      expect(capturedEntity?.age, isNotNull);
      expect(capturedEntity?.medicalHistory, isNotNull);
    });

    test('should return failure when profile creation fails', () async {
      // Arrange
      const failure =
          ApiFailure(message: 'Failed to create patient profile');
      when(() => mockRepository.createPatientProfile(any()))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(
        const CreatePatientProfileUsecaseParams(
          name: tName,
          address: tAddress,
          phoneNumber: tPhoneNumber,
          gender: tGender,
          age: tAge,
          medicalHistory: tMedicalHistory,
        ),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.createPatientProfile(any())).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ApiFailure when there is no internet', () async {
      // Arrange
      const failure = ApiFailure(message: 'No internet connection');
      when(() => mockRepository.createPatientProfile(any()))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(
        const CreatePatientProfileUsecaseParams(
          name: tName,
          address: tAddress,
          phoneNumber: tPhoneNumber,
          gender: tGender,
          age: tAge,
          medicalHistory: tMedicalHistory,
        ),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.createPatientProfile(any())).called(1);
    });
  });

  group('CreatePatientProfileUsecaseParams', () {
    test('should have correct props with all values', () {
      // Arrange
      const params = CreatePatientProfileUsecaseParams(
        name: tName,
        address: tAddress,
        phoneNumber: tPhoneNumber,
        gender: tGender,
        age: tAge,
        medicalHistory: tMedicalHistory,
      );

      // Assert
      expect(params.props, [
        tName,
        tAddress,
        tPhoneNumber,
        tGender,
        tAge,
        tMedicalHistory,
      ]);
    });

    test('two params with same values should be equal', () {
      // Arrange
      const params1 = CreatePatientProfileUsecaseParams(
        name: tName,
        address: tAddress,
        phoneNumber: tPhoneNumber,
        gender: tGender,
        age: tAge,
        medicalHistory: tMedicalHistory,
      );
      const params2 = CreatePatientProfileUsecaseParams(
        name: tName,
        address: tAddress,
        phoneNumber: tPhoneNumber,
        gender: tGender,
        age: tAge,
        medicalHistory: tMedicalHistory,
      );

      // Assert
      expect(params1, params2);
    });

    test('two params with different values should not be equal', () {
      // Arrange
      const params1 = CreatePatientProfileUsecaseParams(
        name: tName,
        address: tAddress,
        phoneNumber: tPhoneNumber,
        gender: tGender,
        age: tAge,
        medicalHistory: tMedicalHistory,
      );
      const params2 = CreatePatientProfileUsecaseParams(
        name: 'Jane Doe',
        address: tAddress,
        phoneNumber: tPhoneNumber,
        gender: tGender,
        age: tAge,
        medicalHistory: tMedicalHistory,
      );

      // Assert
      expect(params1, isNot(params2));
    });
  });
}


