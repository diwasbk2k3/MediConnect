import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/features/profile/domain/repositories/profile_repository.dart';
import 'package:mediconnect/features/profile/domain/usecases/fetch_patient_profile_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements IProfileRepository {}

void main() {
  late FetchPatientProfileDataUsecase usecase;
  late MockProfileRepository mockRepository;

  setUp(() {
    mockRepository = MockProfileRepository();
    usecase = FetchPatientProfileDataUsecase(repository: mockRepository);
  });

  group('FetchPatientProfileDataUsecase', () {
    test(
      'should return patient profile data when repository call is successful',
      () async {
        // Arrange
        final tProfileData = {
          'patientId': 'patient_123',
          'name': 'John Doe',
          'age': 28,
          'gender': 'Male',
          'phoneNumber': '9876543210',
          'address': '123 Main Street',
          'medicalHistory': 'Diabetes',
        };

        when(() => mockRepository.fetchPatientProfileData())
            .thenAnswer((_) async => Right(tProfileData));

        // Act
        final result = await usecase.call();

        // Assert
        expect(result, Right(tProfileData));
        verify(() => mockRepository.fetchPatientProfileData()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return failure when repository call fails',
      () async {
        // Arrange
        const tFailure = ApiFailure(message: 'Failed to fetch profile');

        when(() => mockRepository.fetchPatientProfileData())
            .thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await usecase.call();

        // Assert
        expect(result, Left(tFailure));
        verify(() => mockRepository.fetchPatientProfileData()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return profile data with all fields when available',
      () async {
        // Arrange
        final tProfileData = {
          'patientId': 'patient_456',
          'name': 'Jane Smith',
          'age': 35,
          'gender': 'Female',
          'phoneNumber': '8765432109',
          'address': '456 Oak Avenue, Boston',
          'medicalHistory': 'Hypertension, Cholesterol',
          'profileImageUrl': 'https://example.com/image.jpg',
        };

        when(() => mockRepository.fetchPatientProfileData())
            .thenAnswer((_) async => Right(tProfileData));

        // Act
        final result = await usecase.call();

        // Assert
        expect(result, Right(tProfileData));
        expect(result.getOrElse(() => {}), contains('profileImageUrl'));
        verify(() => mockRepository.fetchPatientProfileData()).called(1);
      },
    );

    test(
      'should return empty map when no profile exists',
      () async {
        // Arrange
        final tEmptyData = <String, dynamic>{};

        when(() => mockRepository.fetchPatientProfileData())
            .thenAnswer((_) async => Right(tEmptyData));

        // Act
        final result = await usecase.call();

        // Assert
        expect(result, Right(tEmptyData));
        expect(result.getOrElse(() => {}), isEmpty);
        verify(() => mockRepository.fetchPatientProfileData()).called(1);
      },
    );

    test(
      'should return network failure when connection fails',
      () async {
        // Arrange
        const tFailure = ApiFailure(message: 'Network error');

        when(() => mockRepository.fetchPatientProfileData())
            .thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await usecase.call();

        // Assert
        expect(result, Left(tFailure));
        verify(() => mockRepository.fetchPatientProfileData()).called(1);
      },
    );

    test(
      'should call repository multiple times if called multiple times',
      () async {
        // Arrange
        final tProfileData = {
          'name': 'John Doe',
          'age': 28,
        };

        when(() => mockRepository.fetchPatientProfileData())
            .thenAnswer((_) async => Right(tProfileData));

        // Act
        await usecase.call();
        await usecase.call();
        await usecase.call();

        // Assert
        verify(() => mockRepository.fetchPatientProfileData()).called(3);
      },
    );

    test(
      'should return data with correct structure containing required fields',
      () async {
        // Arrange
        final tProfileData = {
          'patientId': 'patient_789',
          'name': 'Alex Johnson',
          'age': 45,
          'gender': 'Male',
          'phoneNumber': '5555555555',
          'address': '789 Elm Street',
        };

        when(() => mockRepository.fetchPatientProfileData())
            .thenAnswer((_) async => Right(tProfileData));

        // Act
        final result = await usecase.call();
        final data = result.getOrElse(() => {});

        // Assert
        expect(data, isA<Map<String, dynamic>>());
        expect(data['patientId'], equals('patient_789'));
        expect(data['name'], equals('Alex Johnson'));
        expect(data['age'], equals(45));
      },
    );

    test(
      'should handle null values in profile data',
      () async {
        // Arrange
        final tProfileData = {
          'patientId': 'patient_000',
          'name': 'Test User',
          'age': null,
          'gender': null,
          'phoneNumber': null,
          'address': null,
          'medicalHistory': null,
        };

        when(() => mockRepository.fetchPatientProfileData())
            .thenAnswer((_) async => Right(tProfileData));

        // Act
        final result = await usecase.call();

        // Assert
        expect(result, Right(tProfileData));
        expect(result.getOrElse(() => {})['age'], isNull);
        verify(() => mockRepository.fetchPatientProfileData()).called(1);
      },
    );

    test(
      'should return unauthorized failure when user not authenticated',
      () async {
        // Arrange
        const tFailure = ApiFailure(message: 'Unauthorized');

        when(() => mockRepository.fetchPatientProfileData())
            .thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await usecase.call();

        // Assert
        expect(result, Left(tFailure));
        verify(() => mockRepository.fetchPatientProfileData()).called(1);
      },
    );

    test(
      'should handle large profile data successfully',
      () async {
        // Arrange
        final tProfileData = {
          'patientId': 'patient_999',
          'name': 'Long Name Patient',
          'age': 60,
          'gender': 'Female',
          'phoneNumber': '1234567890',
          'address': 'Very Long Address with Multiple Lines and Details',
          'medicalHistory': 'Multiple allergies: Penicillin, Shellfish, Peanuts; Conditions: Type 2 Diabetes, Arthritis, Sleep Apnea',
          'previousVisits': 15,
          'medications': ['Metformin', 'Lisinopril', 'Atorvastatin'],
        };

        when(() => mockRepository.fetchPatientProfileData())
            .thenAnswer((_) async => Right(tProfileData));

        // Act
        final result = await usecase.call();

        // Assert
        expect(result, Right(tProfileData));
        expect(result.getOrElse(() => {})['medicalHistory'], contains('Diabetes'));
        verify(() => mockRepository.fetchPatientProfileData()).called(1);
      },
    );
  });
}
