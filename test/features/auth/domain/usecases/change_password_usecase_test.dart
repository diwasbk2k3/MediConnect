import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/features/auth/domain/repositories/auth_repository.dart';
import 'package:mediconnect/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late ChangePasswordUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = ChangePasswordUsecase(repository: mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(
      const ChangePasswordUsecaseParams(
        currentPassword: 'fallback',
        newPassword: 'fallback',
        confirmPassword: 'fallback',
      ),
    );
  });

  const tCurrentPassword = 'oldPassword123';
  const tNewPassword = 'newPassword123';
  const tConfirmPassword = 'newPassword123';
  const tSuccessMessage = 'Password changed successfully';

  group('ChangePasswordUsecase', () {
    test('should return success message when password is changed successfully',
        () async {
      // Arrange
      when(() => mockRepository.changePassword(
            tCurrentPassword,
            tNewPassword,
            tConfirmPassword,
          )).thenAnswer((_) async => const Right(tSuccessMessage));

      // Act
      final result = await usecase(
        const ChangePasswordUsecaseParams(
          currentPassword: tCurrentPassword,
          newPassword: tNewPassword,
          confirmPassword: tConfirmPassword,
        ),
      );

      // Assert
      expect(result, const Right(tSuccessMessage));
      verify(() => mockRepository.changePassword(
            tCurrentPassword,
            tNewPassword,
            tConfirmPassword,
          )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass correct passwords to repository', () async {
      // Arrange
      when(() => mockRepository.changePassword(
            tCurrentPassword,
            tNewPassword,
            tConfirmPassword,
          )).thenAnswer((_) async => const Right(tSuccessMessage));

      // Act
      await usecase(
        const ChangePasswordUsecaseParams(
          currentPassword: tCurrentPassword,
          newPassword: tNewPassword,
          confirmPassword: tConfirmPassword,
        ),
      );

      // Assert
      verify(() => mockRepository.changePassword(
            tCurrentPassword,
            tNewPassword,
            tConfirmPassword,
          )).called(1);
    });

    test('should return failure when current password is incorrect', () async {
      // Arrange
      const failure = ApiFailure(message: 'Current password is incorrect');
      when(() => mockRepository.changePassword(
            any(),
            any(),
            any(),
          )).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(
        const ChangePasswordUsecaseParams(
          currentPassword: tCurrentPassword,
          newPassword: tNewPassword,
          confirmPassword: tConfirmPassword,
        ),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.changePassword(
            tCurrentPassword,
            tNewPassword,
            tConfirmPassword,
          )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when passwords do not match', () async {
      // Arrange
      const failure =
          ApiFailure(message: 'New password and confirm password do not match');
      when(() => mockRepository.changePassword(
            any(),
            any(),
            any(),
          )).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(
        const ChangePasswordUsecaseParams(
          currentPassword: tCurrentPassword,
          newPassword: tNewPassword,
          confirmPassword: 'differentPassword123',
        ),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.changePassword(
            tCurrentPassword,
            tNewPassword,
            'differentPassword123',
          )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ApiFailure when there is no internet', () async {
      // Arrange
      const failure = ApiFailure(message: 'No internet connection');
      when(() => mockRepository.changePassword(
            any(),
            any(),
            any(),
          )).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(
        const ChangePasswordUsecaseParams(
          currentPassword: tCurrentPassword,
          newPassword: tNewPassword,
          confirmPassword: tConfirmPassword,
        ),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.changePassword(
            tCurrentPassword,
            tNewPassword,
            tConfirmPassword,
          )).called(1);
    });
  });

  group('ChangePasswordUsecaseParams', () {
    test('should have correct props with all values', () {
      // Arrange
      const params = ChangePasswordUsecaseParams(
        currentPassword: tCurrentPassword,
        newPassword: tNewPassword,
        confirmPassword: tConfirmPassword,
      );

      // Assert
      expect(params.props, [
        tCurrentPassword,
        tNewPassword,
        tConfirmPassword,
      ]);
    });

    test('two params with same values should be equal', () {
      // Arrange
      const params1 = ChangePasswordUsecaseParams(
        currentPassword: tCurrentPassword,
        newPassword: tNewPassword,
        confirmPassword: tConfirmPassword,
      );
      const params2 = ChangePasswordUsecaseParams(
        currentPassword: tCurrentPassword,
        newPassword: tNewPassword,
        confirmPassword: tConfirmPassword,
      );

      // Assert
      expect(params1, params2);
    });

    test('two params with different values should not be equal', () {
      // Arrange
      const params1 = ChangePasswordUsecaseParams(
        currentPassword: tCurrentPassword,
        newPassword: tNewPassword,
        confirmPassword: tConfirmPassword,
      );
      const params2 = ChangePasswordUsecaseParams(
        currentPassword: 'differentOldPassword',
        newPassword: tNewPassword,
        confirmPassword: tConfirmPassword,
      );

      // Assert
      expect(params1, isNot(params2));
    });
  });
}
