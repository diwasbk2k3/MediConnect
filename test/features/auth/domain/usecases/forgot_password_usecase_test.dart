import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/features/auth/domain/repositories/auth_repository.dart';
import 'package:mediconnect/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late ForgotPasswordUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = ForgotPasswordUsecase(repository: mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(
      const ForgotPasswordUsecaseParams(email: 'fallback@example.com'),
    );
  });

  const tEmail = 'test@example.com';
  const tSuccessMessage = 'Password reset email sent!';

  group('ForgotPasswordUsecase', () {
    group('sendPasswordResetEmail', () {
      test('should return success message when email is sent successfully',
          () async {
        // Arrange
        when(() => mockRepository.sendPasswordResetEmail(tEmail))
            .thenAnswer((_) async => const Right(tSuccessMessage));

        // Act
        final result = await usecase(
          const ForgotPasswordUsecaseParams(email: tEmail),
        );

        // Assert
        expect(result, const Right(tSuccessMessage));
        verify(() => mockRepository.sendPasswordResetEmail(tEmail)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should pass correct email to repository', () async {
        // Arrange
        when(() => mockRepository.sendPasswordResetEmail(tEmail))
            .thenAnswer((_) async => const Right(tSuccessMessage));

        // Act
        await usecase(
          const ForgotPasswordUsecaseParams(email: tEmail),
        );

        // Assert
        verify(() => mockRepository.sendPasswordResetEmail(tEmail)).called(1);
      });

      test('should return failure when email does not exist', () async {
        // Arrange
        const failure =
            ApiFailure(message: 'Email not found in our records');
        when(() => mockRepository.sendPasswordResetEmail(any()))
            .thenAnswer((_) async => const Left(failure));

        // Act
        final result = await usecase(
          const ForgotPasswordUsecaseParams(email: tEmail),
        );

        // Assert
        expect(result, const Left(failure));
        verify(() => mockRepository.sendPasswordResetEmail(tEmail)).called(1);
      });

      test('should return failure when network error occurs', () async {
        // Arrange
        const failure = ApiFailure(
            message: 'No internet connection. Please try again.');
        when(() => mockRepository.sendPasswordResetEmail(any()))
            .thenAnswer((_) async => const Left(failure));

        // Act
        final result = await usecase(
          const ForgotPasswordUsecaseParams(email: tEmail),
        );

        // Assert
        expect(result, const Left(failure));
      });

      test('should return failure on server error', () async {
        // Arrange
        const failure = ApiFailure(
            message: 'Server error occurred. Please try again later.');
        when(() => mockRepository.sendPasswordResetEmail(any()))
            .thenAnswer((_) async => const Left(failure));

        // Act
        final result = await usecase(
          const ForgotPasswordUsecaseParams(email: tEmail),
        );

        // Assert
        expect(result, const Left(failure));
      });

      test('should handle valid email formats', () async {
        // Arrange
        const validEmails = [
          'user@example.com',
          'user.name@example.co.uk',
          'user+tag@test.org',
        ];

        for (final email in validEmails) {
          when(() => mockRepository.sendPasswordResetEmail(email))
              .thenAnswer((_) async => const Right(tSuccessMessage));

          // Act
          final result = await usecase(
            ForgotPasswordUsecaseParams(email: email),
          );

          // Assert
          expect(result, const Right(tSuccessMessage));
          verify(() => mockRepository.sendPasswordResetEmail(email))
              .called(1);
        }
      });

      test('should return correct failure message for each scenario',
          () async {
        // Arrange
        const emailNotFoundFailure =
            ApiFailure(message: 'Email not found in our records');
        const networkFailure = ApiFailure(
            message: 'No internet connection. Please try again.');

        when(() => mockRepository.sendPasswordResetEmail('notfound@test.com'))
            .thenAnswer((_) async => const Left(emailNotFoundFailure));

        when(() => mockRepository.sendPasswordResetEmail('offline@test.com'))
            .thenAnswer((_) async => const Left(networkFailure));

        // Act & Assert
        final result1 = await usecase(
          const ForgotPasswordUsecaseParams(email: 'notfound@test.com'),
        );
        expect(
            result1.fold((l) => l.message, (r) => null),
            equals('Email not found in our records'));

        final result2 = await usecase(
          const ForgotPasswordUsecaseParams(email: 'offline@test.com'),
        );
        expect(
            result2.fold((l) => l.message, (r) => null),
            equals('No internet connection. Please try again.'));
      });
    });
  });
}
