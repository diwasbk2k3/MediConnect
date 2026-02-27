import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/features/profile/domain/repositories/profile_repository.dart';
import 'package:mediconnect/features/profile/domain/usecases/update_patient_image_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements IProfileRepository {}

class MockFile extends Mock implements File {}

void main() {
  late UpdatePatientImageUsecase usecase;
  late MockProfileRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(MockFile());
  });

  setUp(() {
    mockRepository = MockProfileRepository();
    usecase = UpdatePatientImageUsecase(repository: mockRepository);
  });

  group('UpdatePatientImageUsecase', () {
    test(
      'should return image URL when upload is successful',
      () async {
        // Arrange
        final mockFile = MockFile();
        const tImageUrl = 'https://example.com/images/patient_123.jpg';

        when(() => mockRepository.updatePatientProfileImage(any()))
            .thenAnswer((_) async => const Right(tImageUrl));

        // Act
        final result = await usecase.call(mockFile);

        // Assert
        expect(result, const Right(tImageUrl));
        verify(() => mockRepository.updatePatientProfileImage(any()))
            .called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return failure when repository upload fails',
      () async {
        // Arrange
        final mockFile = MockFile();
        const tFailure = ApiFailure(message: 'Failed to upload image');

        when(() => mockRepository.updatePatientProfileImage(any()))
            .thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await usecase.call(mockFile);

        // Assert
        expect(result, Left(tFailure));
        verify(() => mockRepository.updatePatientProfileImage(any()))
            .called(1);
      },
    );

    test(
      'should return network failure when connection fails',
      () async {
        // Arrange
        final mockFile = MockFile();
        const tFailure = ApiFailure(message: 'Network error');

        when(() => mockRepository.updatePatientProfileImage(any()))
            .thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await usecase.call(mockFile);

        // Assert
        expect(result, Left(tFailure));
        verify(() => mockRepository.updatePatientProfileImage(any()))
            .called(1);
      },
    );

    test(
      'should return failure for invalid file',
      () async {
        // Arrange
        final mockFile = MockFile();
        const tFailure = ApiFailure(message: 'Invalid file');

        when(() => mockRepository.updatePatientProfileImage(any()))
            .thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await usecase.call(mockFile);

        // Assert
        expect(result, Left(tFailure));
        verify(() => mockRepository.updatePatientProfileImage(any()))
            .called(1);
      },
    );

    test(
      'should return properly formatted image URL',
      () async {
        // Arrange
        final mockFile = MockFile();
        const tImageUrl = 'https://api.example.com/v1/images/med_patient_001.jpg';

        when(() => mockRepository.updatePatientProfileImage(any()))
            .thenAnswer((_) async => Right(tImageUrl));

        // Act
        final result = await usecase.call(mockFile);

        // Assert
        expect(result, Right(tImageUrl));
        expect(result.getOrElse(() => ''), contains('example.com'));
        expect(result.getOrElse(() => ''), contains('.jpg'));
      },
    );

    test(
      'should handle multiple image uploads',
      () async {
        // Arrange
        final mockFile1 = MockFile();
        final mockFile2 = MockFile();
        const tImageUrl = 'https://example.com/image.jpg';

        when(() => mockRepository.updatePatientProfileImage(any()))
            .thenAnswer((_) async => Right(tImageUrl));

        // Act
        final result1 = await usecase.call(mockFile1);
        final result2 = await usecase.call(mockFile2);

        // Assert
        expect(result1, Right(tImageUrl));
        expect(result2, Right(tImageUrl));
        verify(() => mockRepository.updatePatientProfileImage(any()))
            .called(2);
      },
    );

    test(
      'should return failure when file size exceeds limit',
      () async {
        // Arrange
        final mockFile = MockFile();
        const tFailure = ApiFailure(message: 'File size exceeded');

        when(() => mockRepository.updatePatientProfileImage(any()))
            .thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await usecase.call(mockFile);

        // Assert
        expect(result, Left(tFailure));
        verify(() => mockRepository.updatePatientProfileImage(any()))
            .called(1);
      },
    );

    test(
      'should return failure for unsupported file format',
      () async {
        // Arrange
        final mockFile = MockFile();
        const tFailure = ApiFailure(message: 'Unsupported file format');

        when(() => mockRepository.updatePatientProfileImage(any()))
            .thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await usecase.call(mockFile);

        // Assert
        expect(result, Left(tFailure));
      },
    );

    test(
      'should pass file correctly to repository',
      () async {
        // Arrange
        final mockFile = MockFile();
        const tImageUrl = 'https://example.com/image.jpg';

        when(() => mockRepository.updatePatientProfileImage(any()))
            .thenAnswer((_) async => Right(tImageUrl));

        // Act
        await usecase.call(mockFile);

        // Assert - verify the file was passed
        final captured = verify(
          () => mockRepository.updatePatientProfileImage(captureAny()),
        ).captured.single;

        expect(captured, mockFile);
      },
    );

    test(
      'should return unauthorized failure when user not authenticated',
      () async {
        // Arrange
        final mockFile = MockFile();
        const tFailure = ApiFailure(message: 'Unauthorized');

        when(() => mockRepository.updatePatientProfileImage(any()))
            .thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await usecase.call(mockFile);

        // Assert
        expect(result, Left(tFailure));
        verify(() => mockRepository.updatePatientProfileImage(any()))
            .called(1);
      },
    );

    test(
      'should handle empty image URL response',
      () async {
        // Arrange
        final mockFile = MockFile();
        const tImageUrl = '';

        when(() => mockRepository.updatePatientProfileImage(any()))
            .thenAnswer((_) async => Right(tImageUrl));

        // Act
        final result = await usecase.call(mockFile);

        // Assert
        expect(result, Right(tImageUrl));
        expect(result.getOrElse(() => 'default'), isEmpty);
      },
    );

    test(
      'should return failure on storage error',
      () async {
        // Arrange
        final mockFile = MockFile();
        const tFailure = ApiFailure(message: 'Storage error');

        when(() => mockRepository.updatePatientProfileImage(any()))
            .thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await usecase.call(mockFile);

        // Assert
        expect(result, Left(tFailure));
        verify(() => mockRepository.updatePatientProfileImage(any()))
            .called(1);
      },
    );
  });
}
