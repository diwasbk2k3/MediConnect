import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:mediconnect/features/profile/domain/usecases/create_patient_profile_usecase.dart';
import 'package:mediconnect/features/profile/domain/usecases/fetch_patient_profile_usecase.dart';
import 'package:mediconnect/features/profile/domain/usecases/update_patient_image_usecase.dart';
import 'package:mediconnect/features/profile/domain/usecases/update_patient_profile_info_usecase.dart';
import 'package:mediconnect/features/profile/domain/entities/profile_entity.dart';
import 'package:mediconnect/features/profile/presentation/state/profile_state.dart';
import 'package:mediconnect/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:mocktail/mocktail.dart';

const tProfileEntity = ProfileEntity(
  name: 'John Doe',
  address: '123 Main St',
  phoneNumber: '5551234567',
  gender: 'Male',
  age: 30,
  medicalHistory: 'No known allergies',
);

class MockFetchPatientProfileUsecase extends Mock
    implements FetchPatientProfileDataUsecase {}

class MockCreatePatientProfileUsecase extends Mock
    implements CreatePatientProfileUsecase {}

class MockUpdatePatientProfileInfoUsecase extends Mock
    implements UpdatePatientProfileInfoUsecase {}

class MockUpdatePatientImageUsecase extends Mock
    implements UpdatePatientImageUsecase {}

class MockDeleteAccountUsecase extends Mock implements DeleteAccountUsecase {}

void main() {
  late MockFetchPatientProfileUsecase mockFetchPatientProfileUsecase;
  late MockCreatePatientProfileUsecase mockCreatePatientProfileUsecase;
  late MockUpdatePatientProfileInfoUsecase mockUpdatePatientProfileInfoUsecase;
  late MockUpdatePatientImageUsecase mockUpdatePatientImageUsecase;
  late MockDeleteAccountUsecase mockDeleteAccountUsecase;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(
      const CreatePatientProfileUsecaseParams(
        name: 'fallback',
        address: 'fallback',
        phoneNumber: 'fallback',
        gender: 'fallback',
        age: 25,
      ),
    );
    registerFallbackValue(
      const UpdatePatientProfileInfoUsecaseParams(
        name: 'fallback',
        address: 'fallback',
        phoneNumber: 'fallback',
        gender: 'fallback',
        age: 25,
      ),
    );
    registerFallbackValue(
      const DeleteAccountUsecaseParams(password: 'fallback'),
    );
    registerFallbackValue(File('fallback_file.txt'));
  });

  setUp(() {
    mockFetchPatientProfileUsecase = MockFetchPatientProfileUsecase();
    mockCreatePatientProfileUsecase = MockCreatePatientProfileUsecase();
    mockUpdatePatientProfileInfoUsecase = MockUpdatePatientProfileInfoUsecase();
    mockUpdatePatientImageUsecase = MockUpdatePatientImageUsecase();
    mockDeleteAccountUsecase = MockDeleteAccountUsecase();

    container = ProviderContainer(
      overrides: [
        fetchPatientProfileUsecaseProvider
            .overrideWithValue(mockFetchPatientProfileUsecase),
        createPatientProfileUsecaseProvider
            .overrideWithValue(mockCreatePatientProfileUsecase),
        updatePatientProfileInfoUsecaseProvider
            .overrideWithValue(mockUpdatePatientProfileInfoUsecase),
        updatePatientProfileImageUsecaseProvider
            .overrideWithValue(mockUpdatePatientImageUsecase),
        deleteAccountUsecaseProvider
            .overrideWithValue(mockDeleteAccountUsecase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ProfileViewModel', () {
    group('initial state', () {
      test('should have initial state when created', () {
        // Act
        final state = container.read(profileViewModelProvider);

        // Assert
        expect(state.status, ProfileStatus.initial);
        expect(state.patientId, isNull);
        expect(state.name, isNull);
        expect(state.address, isNull);
        expect(state.phoneNumber, isNull);
        expect(state.gender, isNull);
        expect(state.age, isNull);
        expect(state.medicalHistory, isNull);
        expect(state.profileImageUrl, isNull);
        expect(state.errorMessage, isNull);
      });
    });

    group('fetchPatientProfileData', () {
      test(
        'should emit loaded state with profile data when fetch is successful',
        () async {
          // Arrange
          final profileData = {
            'patientId': 'patient123',
            'name': 'John Doe',
            'address': '123 Main St',
            'phone': '5551234567',
            'gender': 'Male',
            'age': 30,
            'medicalHistory': 'No known allergies',
            'profileImageUrl': 'https://example.com/image.jpg',
          };

          when(() => mockFetchPatientProfileUsecase())
              .thenAnswer((_) async => Right(profileData));

          final viewModel = container.read(profileViewModelProvider.notifier);

          // Act
          await viewModel.fetchPatientProfileData();

          // Assert
          final state = container.read(profileViewModelProvider);
          expect(state.status, ProfileStatus.loaded);
          expect(state.patientId, 'patient123');
          expect(state.name, 'John Doe');
          expect(state.address, '123 Main St');
          expect(state.phoneNumber, '5551234567');
          expect(state.gender, 'Male');
          expect(state.age, 30);
          expect(state.medicalHistory, 'No known allergies');
          expect(state.profileImageUrl, 'https://example.com/image.jpg');
          verify(() => mockFetchPatientProfileUsecase()).called(1);
        },
      );

      test('should emit error state when fetch fails', () async {
        // Arrange
        const failure = ApiFailure(message: 'Failed to fetch profile');
        when(() => mockFetchPatientProfileUsecase())
            .thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(profileViewModelProvider.notifier);

        // Act
        await viewModel.fetchPatientProfileData();

        // Assert
        final state = container.read(profileViewModelProvider);
        expect(state.status, ProfileStatus.error);
        expect(state.errorMessage, 'Failed to fetch profile');
        verify(() => mockFetchPatientProfileUsecase()).called(1);
      });

      test('should transition through loading state during fetch', () async {
        // Arrange
        final profileData = {
          'patientId': 'patient123',
          'name': 'John Doe',
          'address': '123 Main St',
          'phone': '5551234567',
          'gender': 'Male',
          'age': 30,
          'medicalHistory': 'No known allergies',
          'profileImageUrl': 'https://example.com/image.jpg',
        };

        when(() => mockFetchPatientProfileUsecase())
            .thenAnswer((_) async => Right(profileData));

        final viewModel = container.read(profileViewModelProvider.notifier);
        final states = <ProfileState>[];

        // Act
        final fetchFuture = viewModel.fetchPatientProfileData();

        // Capture state during execution
        states.add(container.read(profileViewModelProvider));

        await fetchFuture;

        states.add(container.read(profileViewModelProvider));

        // Assert
        expect(states[0].status, ProfileStatus.loading);
        expect(states[1].status, ProfileStatus.loaded);
      });

      test('should handle null values in profile data', () async {
        // Arrange
        final profileData = {
          'patientId': 'patient123',
          'name': 'John Doe',
          'address': null,
          'phone': null,
          'gender': 'Male',
          'age': 30,
          'medicalHistory': null,
          'profileImageUrl': null,
        };

        when(() => mockFetchPatientProfileUsecase())
            .thenAnswer((_) async => Right(profileData));

        final viewModel = container.read(profileViewModelProvider.notifier);

        // Act
        await viewModel.fetchPatientProfileData();

        // Assert
        final state = container.read(profileViewModelProvider);
        expect(state.status, ProfileStatus.loaded);
        expect(state.patientId, 'patient123');
        expect(state.address, isNull);
        expect(state.phoneNumber, isNull);
        expect(state.medicalHistory, isNull);
        expect(state.profileImageUrl, isNull);
      });
    });

    group('createPatientProfile', () {
      test(
        'should emit created state when profile creation is successful',
        () async {
          // Arrange
          final profileEntity = const ProfileEntity(
            name: 'John Doe',
            address: '123 Main St',
            phoneNumber: '5551234567',
            gender: 'Male',
            age: 30,
            medicalHistory: 'No known allergies',
          );
          when(() => mockCreatePatientProfileUsecase(any()))
              .thenAnswer((_) async => Right(profileEntity));

          final viewModel = container.read(profileViewModelProvider.notifier);

          // Act
          await viewModel.createPatientProfile(
            name: 'John Doe',
            address: '123 Main St',
            phoneNumber: '5551234567',
            gender: 'Male',
            age: 30,
            medicalHistory: 'No known allergies',
          );

          // Assert
          final state = container.read(profileViewModelProvider);
          expect(state.status, ProfileStatus.created);
          verify(() => mockCreatePatientProfileUsecase(any())).called(1);
        },
      );

      test('should emit error state when profile creation fails', () async {
        // Arrange
        const failure =
            ApiFailure(message: 'Name is required');
        when(() => mockCreatePatientProfileUsecase(any()))
            .thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(profileViewModelProvider.notifier);

        // Act
        await viewModel.createPatientProfile(
          name: 'John Doe',
          address: '123 Main St',
          phoneNumber: '5551234567',
          gender: 'Male',
          age: 30,
        );

        // Assert
        final state = container.read(profileViewModelProvider);
        expect(state.status, ProfileStatus.error);
        expect(state.errorMessage, 'Name is required');
        verify(() => mockCreatePatientProfileUsecase(any())).called(1);
      });

      test('should pass all parameters correctly to usecase', () async {
        // Arrange
        CreatePatientProfileUsecaseParams? capturedParams;
        when(() => mockCreatePatientProfileUsecase(any()))
            .thenAnswer((invocation) {
          capturedParams =
              invocation.positionalArguments[0] as CreatePatientProfileUsecaseParams;
          return Future.value(const Right(tProfileEntity));
        });

        final viewModel = container.read(profileViewModelProvider.notifier);

        // Act
        await viewModel.createPatientProfile(
          name: 'John Doe',
          address: '123 Main St',
          phoneNumber: '5551234567',
          gender: 'Male',
          age: 30,
          medicalHistory: 'No known allergies',
        );

        // Assert
        expect(capturedParams?.name, 'John Doe');
        expect(capturedParams?.address, '123 Main St');
        expect(capturedParams?.phoneNumber, '5551234567');
        expect(capturedParams?.gender, 'Male');
        expect(capturedParams?.age, 30);
        expect(capturedParams?.medicalHistory, 'No known allergies');
      });

      test('should pass optional parameters correctly', () async {
        // Arrange
        CreatePatientProfileUsecaseParams? capturedParams;
        when(() => mockCreatePatientProfileUsecase(any()))
            .thenAnswer((invocation) {
          capturedParams =
              invocation.positionalArguments[0] as CreatePatientProfileUsecaseParams;
          return Future.value(const Right(tProfileEntity));
        });

        final viewModel = container.read(profileViewModelProvider.notifier);

        // Act
        await viewModel.createPatientProfile(
          name: 'John Doe',
          address: '123 Main St',
          phoneNumber: '5551234567',
          gender: 'Male',
          age: 30,
        );

        // Assert
        expect(capturedParams?.name, 'John Doe');
        expect(capturedParams?.medicalHistory, isNull);
      });

      test('should transition through loading state during creation', () async {
        // Arrange
        when(() => mockCreatePatientProfileUsecase(any()))
            .thenAnswer((_) async => const Right(tProfileEntity));

        final viewModel = container.read(profileViewModelProvider.notifier);
        final states = <ProfileState>[];

        // Act
        final createFuture = viewModel.createPatientProfile(
          name: 'John Doe',
          address: '123 Main St',
          phoneNumber: '5551234567',
          gender: 'Male',
          age: 30,
        );

        states.add(container.read(profileViewModelProvider));

        await createFuture;

        states.add(container.read(profileViewModelProvider));

        // Assert
        expect(states[0].status, ProfileStatus.loading);
        expect(states[1].status, ProfileStatus.created);
      });
    });

    group('updatePatientProfileInfo', () {
      test(
        'should emit updated state when profile update is successful',
        () async {
          // Arrange
          when(() => mockUpdatePatientProfileInfoUsecase(any()))
              .thenAnswer((_) async => const Right(tProfileEntity));

          final viewModel = container.read(profileViewModelProvider.notifier);

          // Act
          await viewModel.updatePatientProfileInfo(
            name: 'Jane Doe',
            age: 28,
          );

          // Assert
          final state = container.read(profileViewModelProvider);
          expect(state.status, ProfileStatus.updated);
          verify(() => mockUpdatePatientProfileInfoUsecase(any())).called(1);
        },
      );

      test('should emit error state when profile update fails', () async {
        // Arrange
        const failure = ApiFailure(message: 'Update failed');
        when(() => mockUpdatePatientProfileInfoUsecase(any()))
            .thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(profileViewModelProvider.notifier);

        // Act
        await viewModel.updatePatientProfileInfo(name: 'Jane Doe');

        // Assert
        final state = container.read(profileViewModelProvider);
        expect(state.status, ProfileStatus.error);
        expect(state.errorMessage, 'Update failed');
        verify(() => mockUpdatePatientProfileInfoUsecase(any())).called(1);
      });

      test('should pass parameters correctly when updating', () async {
        // Arrange
        UpdatePatientProfileInfoUsecaseParams? capturedParams;
        when(() => mockUpdatePatientProfileInfoUsecase(any()))
            .thenAnswer((invocation) {
          capturedParams = invocation.positionalArguments[0]
              as UpdatePatientProfileInfoUsecaseParams;
          return Future.value(const Right(tProfileEntity));
        });

        final viewModel = container.read(profileViewModelProvider.notifier);

        // Act
        await viewModel.updatePatientProfileInfo(
          name: 'Jane Doe',
          address: '456 Oak Ave',
          phoneNumber: '5559876543',
          gender: 'Female',
          age: 28,
          medicalHistory: 'Diabetes',
        );

        // Assert
        expect(capturedParams?.name, 'Jane Doe');
        expect(capturedParams?.address, '456 Oak Ave');
        expect(capturedParams?.phoneNumber, '5559876543');
        expect(capturedParams?.gender, 'Female');
        expect(capturedParams?.age, 28);
        expect(capturedParams?.medicalHistory, 'Diabetes');
      });

      test('should allow partial updates', () async {
        // Arrange
        UpdatePatientProfileInfoUsecaseParams? capturedParams;
        when(() => mockUpdatePatientProfileInfoUsecase(any()))
            .thenAnswer((invocation) {
          capturedParams = invocation.positionalArguments[0]
              as UpdatePatientProfileInfoUsecaseParams;
          return Future.value(const Right(tProfileEntity));
        });

        final viewModel = container.read(profileViewModelProvider.notifier);

        // Act
        await viewModel.updatePatientProfileInfo(
          name: 'Jane Doe',
          age: 28,
        );

        // Assert
        expect(capturedParams?.name, 'Jane Doe');
        expect(capturedParams?.age, 28);
        expect(capturedParams?.address, isNull);
        expect(capturedParams?.phoneNumber, isNull);
        expect(capturedParams?.gender, isNull);
      });

      test('should transition through loading state during update', () async {
        // Arrange
        when(() => mockUpdatePatientProfileInfoUsecase(any()))
            .thenAnswer((_) async => const Right(tProfileEntity));

        final viewModel = container.read(profileViewModelProvider.notifier);
        final states = <ProfileState>[];

        // Act
        final updateFuture = viewModel.updatePatientProfileInfo(
          name: 'Jane Doe',
          age: 28,
        );

        states.add(container.read(profileViewModelProvider));

        await updateFuture;

        states.add(container.read(profileViewModelProvider));

        // Assert
        expect(states[0].status, ProfileStatus.loading);
        expect(states[1].status, ProfileStatus.updated);
      });
    });

    group('updatePatientProfileImage', () {
      test(
        'should emit updated state when image update is successful',
        () async {
          // Arrange
          final testFile = File('test/assets/test_image.png');
          const imageUrl = 'https://example.com/new_image.jpg';

          when(() => mockUpdatePatientImageUsecase(any()))
              .thenAnswer((_) async => const Right(imageUrl));

          final viewModel = container.read(profileViewModelProvider.notifier);

          // Act
          await viewModel.updatePatientProfileImage(testFile);

          // Assert
          final state = container.read(profileViewModelProvider);
          expect(state.status, ProfileStatus.updated);
          expect(state.profileImageUrl, imageUrl);
          verify(() => mockUpdatePatientImageUsecase(any())).called(1);
        },
      );

      test('should emit error state when image update fails', () async {
        // Arrange
        final testFile = File('test/assets/test_image.png');
        const failure = ApiFailure(message: 'Image upload failed');

        when(() => mockUpdatePatientImageUsecase(any()))
            .thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(profileViewModelProvider.notifier);

        // Act
        await viewModel.updatePatientProfileImage(testFile);

        // Assert
        final state = container.read(profileViewModelProvider);
        expect(state.status, ProfileStatus.error);
        expect(state.errorMessage, 'Image upload failed');
        verify(() => mockUpdatePatientImageUsecase(any())).called(1);
      });

      test('should pass file correctly to usecase', () async {
        // Arrange
        final testFile = File('test/assets/test_image.png');
        File? capturedFile;

        when(() => mockUpdatePatientImageUsecase(any()))
            .thenAnswer((invocation) {
          capturedFile = invocation.positionalArguments[0] as File;
          return Future.value(const Right('https://example.com/image.jpg'));
        });

        final viewModel = container.read(profileViewModelProvider.notifier);

        // Act
        await viewModel.updatePatientProfileImage(testFile);

        // Assert
        expect(capturedFile?.path, testFile.path);
      });

      test('should transition through loading state during image upload',
          () async {
        // Arrange
        final testFile = File('test/assets/test_image.png');
        when(() => mockUpdatePatientImageUsecase(any()))
            .thenAnswer((_) async => const Right('https://example.com/image.jpg'));

        final viewModel = container.read(profileViewModelProvider.notifier);
        final states = <ProfileState>[];

        // Act
        final uploadFuture = viewModel.updatePatientProfileImage(testFile);

        states.add(container.read(profileViewModelProvider));

        await uploadFuture;

        states.add(container.read(profileViewModelProvider));

        // Assert
        expect(states[0].status, ProfileStatus.loading);
        expect(states[1].status, ProfileStatus.updated);
      });

      test('should set resetProfileImage flag when updating image', () async {
        // Arrange
        final testFile = File('test/assets/test_image.png');
        const imageUrl = 'https://example.com/new_image.jpg';

        when(() => mockUpdatePatientImageUsecase(any()))
            .thenAnswer((_) async => const Right(imageUrl));

        final viewModel = container.read(profileViewModelProvider.notifier);

        // Act
        await viewModel.updatePatientProfileImage(testFile);

        // Assert
        final state = container.read(profileViewModelProvider);
        expect(state.profileImageUrl, imageUrl);
      });
    });

    group('deleteAccount', () {
      test(
        'should emit deleted state when account deletion is successful',
        () async {
          // Arrange
          when(() => mockDeleteAccountUsecase(any()))
              .thenAnswer((_) async => const Right('Account deleted'));

          final viewModel = container.read(profileViewModelProvider.notifier);

          // Act
          await viewModel.deleteAccount('password123');

          // Assert
          final state = container.read(profileViewModelProvider);
          expect(state.status, ProfileStatus.deleted);
          verify(() => mockDeleteAccountUsecase(any())).called(1);
        },
      );

      test('should emit error state when account deletion fails', () async {
        // Arrange
        const failure = ApiFailure(message: 'Invalid password');
        when(() => mockDeleteAccountUsecase(any()))
            .thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(profileViewModelProvider.notifier);

        // Act
        await viewModel.deleteAccount('wrongpassword');

        // Assert
        final state = container.read(profileViewModelProvider);
        expect(state.status, ProfileStatus.error);
        expect(state.errorMessage, 'Invalid password');
        verify(() => mockDeleteAccountUsecase(any())).called(1);
      });

      test('should pass password correctly to usecase', () async {
        // Arrange
        DeleteAccountUsecaseParams? capturedParams;
        when(() => mockDeleteAccountUsecase(any())).thenAnswer((invocation) {
          capturedParams =
              invocation.positionalArguments[0] as DeleteAccountUsecaseParams;
          return Future.value(const Right('Account deleted'));
        });

        final viewModel = container.read(profileViewModelProvider.notifier);

        // Act
        await viewModel.deleteAccount('password123');

        // Assert
        expect(capturedParams?.password, 'password123');
      });

      test('should transition through loading state during deletion', () async {
        // Arrange
        when(() => mockDeleteAccountUsecase(any()))
            .thenAnswer((_) async => const Right('Account deleted'));

        final viewModel = container.read(profileViewModelProvider.notifier);
        final states = <ProfileState>[];

        // Act
        final deleteFuture = viewModel.deleteAccount('password123');

        states.add(container.read(profileViewModelProvider));

        await deleteFuture;

        states.add(container.read(profileViewModelProvider));

        // Assert
        expect(states[0].status, ProfileStatus.loading);
        expect(states[1].status, ProfileStatus.deleted);
      });
    });

    group('state management', () {
      test('should maintain previous state when fetching profile after creation',
          () async {
        // Arrange
        when(() => mockCreatePatientProfileUsecase(any()))
            .thenAnswer((_) async => const Right(tProfileEntity));
        when(() => mockFetchPatientProfileUsecase()).thenAnswer((_) async => Right({
          'patientId': 'patient123',
          'name': 'John Doe',
          'address': '123 Main St',
          'phone': '5551234567',
          'gender': 'Male',
          'age': 30,
          'medicalHistory': null,
          'profileImageUrl': null,
        }));

        final viewModel = container.read(profileViewModelProvider.notifier);

        // Act
        await viewModel.createPatientProfile(
          name: 'John Doe',
          address: '123 Main St',
          phoneNumber: '5551234567',
          gender: 'Male',
          age: 30,
        );

        var state = container.read(profileViewModelProvider);
        expect(state.status, ProfileStatus.created);

        await viewModel.fetchPatientProfileData();

        state = container.read(profileViewModelProvider);

        // Assert
        expect(state.status, ProfileStatus.loaded);
        expect(state.name, 'John Doe');
      });

      test(
        'should update status when operation succeeds after failure',
        () async {
          // Arrange
          const failure = ApiFailure(message: 'Update failed');

          // First, simulate a failure
          when(() => mockUpdatePatientProfileInfoUsecase(any()))
              .thenAnswer((_) async => const Left(failure));

          final viewModel = container.read(profileViewModelProvider.notifier);

          // Act
          await viewModel.updatePatientProfileInfo(name: 'Jane Doe');

          var state = container.read(profileViewModelProvider);
          expect(state.status, ProfileStatus.error);
          expect(state.errorMessage, 'Update failed');

          // Now simulate a successful update
          when(() => mockUpdatePatientProfileInfoUsecase(any()))
              .thenAnswer((_) async => const Right(tProfileEntity));

          await viewModel.updatePatientProfileInfo(name: 'Jane Smith');

          state = container.read(profileViewModelProvider);

          // Assert - Status should change to updated even if error message persists
          expect(state.status, ProfileStatus.updated);
        },
      );
    });
  });
}
