import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/features/profile/domain/entities/profile_entity.dart';
import 'package:mediconnect/features/profile/domain/repositories/profile_repository.dart';
import 'package:mediconnect/features/profile/domain/usecases/update_patient_profile_info_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements IProfileRepository {}

void main() {
  late UpdatePatientProfileInfoUsecase usecase;
  late MockProfileRepository mockRepository;

  setUp(() {
    mockRepository = MockProfileRepository();
    usecase = UpdatePatientProfileInfoUsecase(profileRepository: mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(
      const ProfileEntity(
        name: 'fallback',
        address: 'fallback',
        phoneNumber: '0000000000',
        gender: 'Male',
        age: 30,
      ),
    );
  });

  const tName = 'Jane Doe';
  const tAddress = '456 Oak Street, Boston';
  const tPhoneNumber = '8765432109';
  const tGender = 'Female';
  const tAge = 32;
  const tMedicalHistory = 'No known allergies, Hypertension';
  const tPatientId = 'patient_456';

  final tProfileEntity = const ProfileEntity(
    patientId: tPatientId,
    name: tName,
    address: tAddress,
    phoneNumber: tPhoneNumber,
    gender: tGender,
    age: tAge,
    medicalHistory: tMedicalHistory,
  );

  group('UpdatePatientProfileInfoUsecase', () {
    test(
      'should return ProfileEntity when update is successful',
      () async {
        // Arrange
        final params = const UpdatePatientProfileInfoUsecaseParams(
          name: tName,
          address: tAddress,
          phoneNumber: tPhoneNumber,
          gender: tGender,
          age: tAge,
          medicalHistory: tMedicalHistory,
        );

        when(() => mockRepository.updatePatientProfileInfo(any()))
            .thenAnswer((_) async => Right(tProfileEntity));

        // Act
        final result = await usecase.call(params);

        // Assert
        expect(result, Right(tProfileEntity));
        verify(() => mockRepository.updatePatientProfileInfo(any())).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return failure when repository update fails',
      () async {
        // Arrange
        final params = const UpdatePatientProfileInfoUsecaseParams(
          name: tName,
          address: tAddress,
          phoneNumber: tPhoneNumber,
          gender: tGender,
          age: tAge,
        );

        const tFailure = ApiFailure(message: 'Failed to update profile');

        when(() => mockRepository.updatePatientProfileInfo(any()))
            .thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await usecase.call(params);

        // Assert
        expect(result, Left(tFailure));
        verify(() => mockRepository.updatePatientProfileInfo(any())).called(1);
      },
    );

    test(
      'should update profile with only name',
      () async {
        // Arrange
        final params = const UpdatePatientProfileInfoUsecaseParams(
          name: 'New Name',
        );

        final expectedEntity = const ProfileEntity(name: 'New Name');

        when(() => mockRepository.updatePatientProfileInfo(any()))
            .thenAnswer((_) async => Right(expectedEntity));

        // Act
        final result = await usecase.call(params);

        // Assert
        expect(result, Right(expectedEntity));
        verify(() => mockRepository.updatePatientProfileInfo(any())).called(1);
      },
    );

    test(
      'should update age successfully',
      () async {
        // Arrange
        final params = const UpdatePatientProfileInfoUsecaseParams(age: 40);

        final expectedEntity = const ProfileEntity(age: 40);

        when(() => mockRepository.updatePatientProfileInfo(any()))
            .thenAnswer((_) async => Right(expectedEntity));

        // Act
        final result = await usecase.call(params);

        // Assert
        expect(result, Right(expectedEntity));
        verify(() => mockRepository.updatePatientProfileInfo(any())).called(1);
      },
    );

    test(
      'should update phone number successfully',
      () async {
        // Arrange
        const newPhone = '9999999999';
        final params = const UpdatePatientProfileInfoUsecaseParams(
          phoneNumber: newPhone,
        );

        final expectedEntity = const ProfileEntity(phoneNumber: newPhone);

        when(() => mockRepository.updatePatientProfileInfo(any()))
            .thenAnswer((_) async => Right(expectedEntity));

        // Act
        final result = await usecase.call(params);

        // Assert
        expect(result, Right(expectedEntity));
        verify(() => mockRepository.updatePatientProfileInfo(any())).called(1);
      },
    );

    test(
      'should update address successfully',
      () async {
        // Arrange
        const newAddress = '999 New Address Street';
        final params = const UpdatePatientProfileInfoUsecaseParams(
          address: newAddress,
        );

        final expectedEntity = const ProfileEntity(address: newAddress);

        when(() => mockRepository.updatePatientProfileInfo(any()))
            .thenAnswer((_) async => Right(expectedEntity));

        // Act
        final result = await usecase.call(params);

        // Assert
        expect(result, Right(expectedEntity));
        verify(() => mockRepository.updatePatientProfileInfo(any())).called(1);
      },
    );

    test(
      'should update gender successfully',
      () async {
        // Arrange
        final params =
            const UpdatePatientProfileInfoUsecaseParams(gender: 'Female');

        final expectedEntity = const ProfileEntity(gender: 'Female');

        when(() => mockRepository.updatePatientProfileInfo(any()))
            .thenAnswer((_) async => Right(expectedEntity));

        // Act
        final result = await usecase.call(params);

        // Assert
        expect(result, Right(expectedEntity));
        verify(() => mockRepository.updatePatientProfileInfo(any())).called(1);
      },
    );

    test(
      'should update medical history successfully',
      () async {
        // Arrange
        const newHistory = 'Asthma, Eczema';
        final params = const UpdatePatientProfileInfoUsecaseParams(
          medicalHistory: newHistory,
        );

        final expectedEntity = const ProfileEntity(medicalHistory: newHistory);

        when(() => mockRepository.updatePatientProfileInfo(any()))
            .thenAnswer((_) async => Right(expectedEntity));

        // Act
        final result = await usecase.call(params);

        // Assert
        expect(result, Right(expectedEntity));
        verify(() => mockRepository.updatePatientProfileInfo(any())).called(1);
      },
    );

    test(
      'should update all profile fields successfully',
      () async {
        // Arrange
        final params = const UpdatePatientProfileInfoUsecaseParams(
          name: tName,
          address: tAddress,
          phoneNumber: tPhoneNumber,
          gender: tGender,
          age: tAge,
          medicalHistory: tMedicalHistory,
        );

        when(() => mockRepository.updatePatientProfileInfo(any()))
            .thenAnswer((_) async => Right(tProfileEntity));

        // Act
        final result = await usecase.call(params);

        // Assert
        expect(result, Right(tProfileEntity));
        verify(() => mockRepository.updatePatientProfileInfo(any())).called(1);
      },
    );

    test(
      'should return network failure when connection fails',
      () async {
        // Arrange
        final params = const UpdatePatientProfileInfoUsecaseParams(
          name: 'Updated Name',
        );

        const tFailure = ApiFailure(message: 'Network error');

        when(() => mockRepository.updatePatientProfileInfo(any()))
            .thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await usecase.call(params);

        // Assert
        expect(result, Left(tFailure));
        verify(() => mockRepository.updatePatientProfileInfo(any())).called(1);
      },
    );

    test(
      'should handle update with empty params',
      () async {
        // Arrange
        final params = const UpdatePatientProfileInfoUsecaseParams();

        final expectedEntity = const ProfileEntity();

        when(() => mockRepository.updatePatientProfileInfo(any()))
            .thenAnswer((_) async => Right(expectedEntity));

        // Act
        final result = await usecase.call(params);

        // Assert
        expect(result, Right(expectedEntity));
        verify(() => mockRepository.updatePatientProfileInfo(any())).called(1);
      },
    );

    test(
      'should correctly create ProfileEntity from params',
      () async {
        // Arrange
        final params = const UpdatePatientProfileInfoUsecaseParams(
          name: tName,
          age: tAge,
          phoneNumber: tPhoneNumber,
        );

        when(() => mockRepository.updatePatientProfileInfo(any()))
            .thenAnswer((_) async => Right(tProfileEntity));

        // Act
        await usecase.call(params);

        // Assert - verify the entity passed to repository matches expected values
        final capturedEntity = verify(
          () => mockRepository.updatePatientProfileInfo(captureAny()),
        ).captured.single as ProfileEntity;

        expect(capturedEntity.name, equals(tName));
        expect(capturedEntity.age, equals(tAge));
        expect(capturedEntity.phoneNumber, equals(tPhoneNumber));
      },
    );
  });
}
