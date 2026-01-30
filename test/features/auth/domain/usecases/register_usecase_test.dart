import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/features/auth/domain/entities/auth_entity.dart';
import 'package:mediconnect/features/auth/domain/repositories/auth_repository.dart';
import 'package:mediconnect/features/auth/domain/usecases/register_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late RegisterUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = RegisterUsecase(authRepository: mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(
      const AuthEntity(
        email: 'fallback@email.com',
        password: 'fallback',
        confirmPassword: 'fallback',
      ),
    );
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tConfirmPassword = 'password123';
  const tPhoneNumber = '1234567890';
  const tTermsAgreed = true;

  group('RegisterUsecase', () {
    test('should return AuthEntity when registration is successful', () async {
      // Arrange
      const tAuthEntity = AuthEntity(
        authId: 'user123',
        email: tEmail,
        password: tPassword,
        confirmPassword: tConfirmPassword,
        phoneNumber: tPhoneNumber,
        termsAgreed: tTermsAgreed,
      );

      when(
        () => mockRepository.register(any()),
      ).thenAnswer((_) async => const Right(tAuthEntity));

      // Act
      final result = await usecase(
        const RegisterUsecaseParams(
          email: tEmail,
          password: tPassword,
          confirmPassword: tConfirmPassword,
          phoneNumber: tPhoneNumber,
          termsAgreed: tTermsAgreed,
        ),
      );

      // Assert
      expect(result, const Right(tAuthEntity));
      verify(() => mockRepository.register(any())).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass AuthEntity with correct values to repository', () async {
      // Arrange
      AuthEntity? capturedEntity;
      when(() => mockRepository.register(any())).thenAnswer((invocation) {
        capturedEntity = invocation.positionalArguments[0] as AuthEntity;
        return Future.value(
          Right(
            AuthEntity(
              email: capturedEntity?.email,
              password: capturedEntity?.password,
              confirmPassword: capturedEntity?.confirmPassword,
              phoneNumber: capturedEntity?.phoneNumber,
              termsAgreed: capturedEntity?.termsAgreed,
            ),
          ),
        );
      });

      // Act
      await usecase(
        const RegisterUsecaseParams(
          email: tEmail,
          password: tPassword,
          confirmPassword: tConfirmPassword,
          phoneNumber: tPhoneNumber,
          termsAgreed: tTermsAgreed,
        ),
      );

      // Assert
      expect(capturedEntity?.email, tEmail);
      expect(capturedEntity?.password, tPassword);
      expect(capturedEntity?.confirmPassword, tConfirmPassword);
      expect(capturedEntity?.phoneNumber, tPhoneNumber);
      expect(capturedEntity?.termsAgreed, tTermsAgreed);
    });

    test('should handle optional parameters correctly', () async {
      // Arrange
      AuthEntity? capturedEntity;
      when(() => mockRepository.register(any())).thenAnswer((invocation) {
        capturedEntity = invocation.positionalArguments[0] as AuthEntity;
        return Future.value(
          Right(
            AuthEntity(
              email: capturedEntity?.email,
              password: capturedEntity?.password,
              confirmPassword: capturedEntity?.confirmPassword,
              phoneNumber: capturedEntity?.phoneNumber,
              termsAgreed: capturedEntity?.termsAgreed,
            ),
          ),
        );
      });

      // Act
      await usecase(
        const RegisterUsecaseParams(
          email: tEmail,
          password: tPassword,
          confirmPassword: tConfirmPassword,
          phoneNumber: tPhoneNumber,
          termsAgreed: tTermsAgreed,
        ),
      );

      // Assert
      expect(capturedEntity?.phoneNumber, tPhoneNumber);
      expect(capturedEntity?.termsAgreed, tTermsAgreed);
    });

    test('should return failure when registration fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Email already exists');
      when(
        () => mockRepository.register(any()),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(
        const RegisterUsecaseParams(
          email: tEmail,
          password: tPassword,
          confirmPassword: tConfirmPassword,
          termsAgreed: tTermsAgreed,
        ),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.register(any())).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ApiFailure when there is no internet', () async {
      // Arrange
      const failure = ApiFailure(message: 'No internet connection');
      when(
        () => mockRepository.register(any()),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(
        const RegisterUsecaseParams(
          email: tEmail,
          password: tPassword,
          confirmPassword: tConfirmPassword,
          termsAgreed: tTermsAgreed,
        ),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.register(any())).called(1);
    });
  });

  group('RegisterUsecaseParams', () {
    test('should have correct props with all values', () {
      // Arrange
      const params = RegisterUsecaseParams(
        email: tEmail,
        password: tPassword,
        confirmPassword: tConfirmPassword,
        phoneNumber: tPhoneNumber,
        termsAgreed: tTermsAgreed,
      );

      // Assert
      expect(params.props, [
        tEmail,
        tPassword,
        tPhoneNumber,
        tTermsAgreed,
      ]);
    });

    test('two params with same values should be equal', () {
      // Arrange
      const params1 = RegisterUsecaseParams(
        email: tEmail,
        password: tPassword,
        confirmPassword: tConfirmPassword,
        phoneNumber: tPhoneNumber,
        termsAgreed: tTermsAgreed,
      );
      const params2 = RegisterUsecaseParams(
        email: tEmail,
        password: tPassword,
        confirmPassword: tConfirmPassword,
        phoneNumber: tPhoneNumber,
        termsAgreed: tTermsAgreed,
      );

      // Assert
      expect(params1, params2);
    });
  });
}