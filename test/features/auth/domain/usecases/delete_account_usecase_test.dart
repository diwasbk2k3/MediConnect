import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/features/auth/domain/repositories/auth_repository.dart';
import 'package:mediconnect/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late DeleteAccountUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = DeleteAccountUsecase(repository: mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(
      const DeleteAccountUsecaseParams(
        password: 'fallback',
      ),
    );
  });

  const tPassword = 'password123';
  const tSuccessMessage = 'Account deleted successfully';

  group('DeleteAccountUsecase', () {
    test('should return success message when account is deleted successfully',
        () async {
      // Arrange
      when(() => mockRepository.deleteAccount(tPassword))
          .thenAnswer((_) async => const Right(tSuccessMessage));

      // Act
      final result = await usecase(
        const DeleteAccountUsecaseParams(password: tPassword),
      );

      // Assert
      expect(result, const Right(tSuccessMessage));
      verify(() => mockRepository.deleteAccount(tPassword)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass correct password to repository', () async {
      // Arrange
      when(() => mockRepository.deleteAccount(tPassword))
          .thenAnswer((_) async => const Right(tSuccessMessage));

      // Act
      await usecase(
        const DeleteAccountUsecaseParams(password: tPassword),
      );

      // Assert
      verify(() => mockRepository.deleteAccount(tPassword)).called(1);
    });

    test('should return failure when password is incorrect', () async {
      // Arrange
      const failure = ApiFailure(message: 'Password is incorrect');
      when(() => mockRepository.deleteAccount(any()))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(
        const DeleteAccountUsecaseParams(password: tPassword),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.deleteAccount(tPassword)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ApiFailure when there is no internet', () async {
      // Arrange
      const failure = ApiFailure(message: 'No internet connection');
      when(() => mockRepository.deleteAccount(any()))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(
        const DeleteAccountUsecaseParams(password: tPassword),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.deleteAccount(tPassword)).called(1);
    });

    test('should return failure when account does not exist', () async {
      // Arrange
      const failure = ApiFailure(message: 'Account not found');
      when(() => mockRepository.deleteAccount(any()))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(
        const DeleteAccountUsecaseParams(password: tPassword),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.deleteAccount(tPassword)).called(1);
    });
  });

  group('DeleteAccountUsecaseParams', () {
    test('should have correct props with all values', () {
      // Arrange
      const params = DeleteAccountUsecaseParams(password: tPassword);

      // Assert
      expect(params.props, [tPassword]);
    });

    test('two params with same values should be equal', () {
      // Arrange
      const params1 = DeleteAccountUsecaseParams(password: tPassword);
      const params2 = DeleteAccountUsecaseParams(password: tPassword);

      // Assert
      expect(params1, params2);
    });

    test('two params with different values should not be equal', () {
      // Arrange
      const params1 = DeleteAccountUsecaseParams(password: tPassword);
      const params2 = DeleteAccountUsecaseParams(password: 'different');

      // Assert
      expect(params1, isNot(params2));
    });
  });
}
