import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/features/auth/domain/entities/auth_entity.dart';
import 'package:mediconnect/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:mediconnect/features/auth/domain/usecases/login_usecase.dart';
import 'package:mediconnect/features/auth/domain/usecases/register_usecase.dart';
import 'package:mediconnect/features/auth/presentation/state/auth_state.dart';
import 'package:mediconnect/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockChangePasswordUsecase extends Mock implements ChangePasswordUsecase {}

void main() {
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLoginUsecase mockLoginUsecase;
  late MockChangePasswordUsecase mockChangePasswordUsecase;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(
      const RegisterUsecaseParams(
        email: 'fallback@email.com',
        password: 'fallback',
        confirmPassword: 'fallback',
        phoneNumber: 'fallback',
        termsAgreed: true,
      ),
    );
    registerFallbackValue(
      const LoginUseCaseParams(email: 'fallback@email.com', password: 'fallback'),
    );
    registerFallbackValue(
      const ChangePasswordUsecaseParams(
        currentPassword: 'fallback',
        newPassword: 'fallback',
        confirmPassword: 'fallback',
      ),
    );
  });

  setUp(() {
    mockRegisterUsecase = MockRegisterUsecase();
    mockLoginUsecase = MockLoginUsecase();
    mockChangePasswordUsecase = MockChangePasswordUsecase();

    container = ProviderContainer(
      overrides: [
        registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
        changePasswordUsecaseProvider.overrideWithValue(
          mockChangePasswordUsecase,
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  const tUser = AuthEntity(
    email: 'test@example.com',
    password: 'password123',
    confirmPassword: 'password123',
    phoneNumber: '1234567890',
    termsAgreed: true,
  );

  group('AuthViewModel', () {
    group('initial state', () {
      test('should have initial state when created', () {
        // Act
        final state = container.read(authViewModelProvider);

        // Assert
        expect(state.status, AuthStatus.initial);
        expect(state.authEntity, isNull);
        expect(state.errorMessage, isNull);
      });
    });

    group('register', () {
      test(
        'should emit registered state when registration is successful',
        () async {
          // Arrange
          when(
            () => mockRegisterUsecase(any()),
          ).thenAnswer((_) async => const Right(tUser));

          final viewModel = container.read(authViewModelProvider.notifier);

          // Act
          await viewModel.register(
            email: 'test@example.com',
            password: 'password123',
            confirmPassword: 'password123',
            termsAgreed: true,
          );

          // Assert
          final state = container.read(authViewModelProvider);
          expect(state.status, AuthStatus.registered);
          verify(() => mockRegisterUsecase(any())).called(1);
        },
      );

      test('should emit error state when registration fails', () async {
        // Arrange
        const failure = ApiFailure(message: 'Email already exists');
        when(
          () => mockRegisterUsecase(any()),
        ).thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(authViewModelProvider.notifier);

        // Act
        await viewModel.register(
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'password123',
          termsAgreed: true,
        );

        // Assert
        final state = container.read(authViewModelProvider);
        expect(state.status, AuthStatus.error);
        expect(state.errorMessage, 'Email already exists');
        verify(() => mockRegisterUsecase(any())).called(1);
      });

      test('should pass optional parameters correctly', () async {
        // Arrange
        RegisterUsecaseParams? capturedParams;
        when(() => mockRegisterUsecase(any())).thenAnswer((invocation) {
          capturedParams = invocation.positionalArguments[0] as RegisterUsecaseParams;
          return Future.value(const Right(tUser));
        });

        final viewModel = container.read(authViewModelProvider.notifier);

        // Act
        await viewModel.register(
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'password123',
          termsAgreed: true,
          phoneNumber: '1234567890',
        );

        // Assert
        expect(capturedParams?.phoneNumber, '1234567890');
        expect(capturedParams?.termsAgreed, true);
      });

      test('should transition through loading state during registration', () async {
        // Arrange
        final states = <AuthState>[];
        when(
          () => mockRegisterUsecase(any()),
        ).thenAnswer((_) async => const Right(tUser));

        final viewModel = container.read(authViewModelProvider.notifier);

        // Act
        final registerFuture = viewModel.register(
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'password123',
          termsAgreed: true,
        );

        // Capture state during execution
        states.add(container.read(authViewModelProvider));

        await registerFuture;

        states.add(container.read(authViewModelProvider));

        // Assert
        expect(states[0].status, AuthStatus.loading);
        expect(states[1].status, AuthStatus.registered);
      });
    });

    group('login', () {
      test(
        'should emit authenticated state with user when login is successful',
        () async {
          // Arrange
          when(
            () => mockLoginUsecase(any()),
          ).thenAnswer((_) async => const Right(tUser));

          final viewModel = container.read(authViewModelProvider.notifier);

          // Act
          await viewModel.login(
            email: 'test@example.com',
            password: 'password123',
          );

          // Assert
          final state = container.read(authViewModelProvider);
          expect(state.status, AuthStatus.authenticated);
          expect(state.authEntity, tUser);
          verify(() => mockLoginUsecase(any())).called(1);
        },
      );

      test('should emit error state when login fails', () async {
        // Arrange
        const failure = ApiFailure(message: 'Invalid credentials');
        when(
          () => mockLoginUsecase(any()),
        ).thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(authViewModelProvider.notifier);

        // Act
        await viewModel.login(
          email: 'test@example.com',
          password: 'password123',
        );

        // Assert
        final state = container.read(authViewModelProvider);
        expect(state.status, AuthStatus.error);
        expect(state.errorMessage, 'Invalid credentials');
        verify(() => mockLoginUsecase(any())).called(1);
      });

      test('should pass correct credentials to usecase', () async {
        // Arrange
        LoginUseCaseParams? capturedParams;
        when(() => mockLoginUsecase(any())).thenAnswer((invocation) {
          capturedParams = invocation.positionalArguments[0] as LoginUseCaseParams;
          return Future.value(const Right(tUser));
        });

        final viewModel = container.read(authViewModelProvider.notifier);

        // Act
        await viewModel.login(
          email: 'test@example.com',
          password: 'password123',
        );

        // Assert
        expect(capturedParams?.email, 'test@example.com');
        expect(capturedParams?.password, 'password123');
      });

      test('should transition through loading state during login', () async {
        // Arrange
        final states = <AuthState>[];
        when(
          () => mockLoginUsecase(any()),
        ).thenAnswer((_) async => const Right(tUser));

        final viewModel = container.read(authViewModelProvider.notifier);

        // Act
        states.add(container.read(authViewModelProvider));

        final loginFuture = viewModel.login(
          email: 'test@example.com',
          password: 'password123',
        );

        states.add(container.read(authViewModelProvider));

        await loginFuture;

        states.add(container.read(authViewModelProvider));

        // Assert
        expect(states[1].status, AuthStatus.loading);
        expect(states[2].status, AuthStatus.authenticated);
      });
    });

    group('changePassword', () {
      test(
        'should emit passwordChanged state when password change is successful',
        () async {
          // Arrange
          when(
            () => mockChangePasswordUsecase(any()),
          ).thenAnswer((_) async => const Right('Password changed successfully'));

          final viewModel = container.read(authViewModelProvider.notifier);

          // Act
          await viewModel.changePassword(
            currentPassword: 'oldPassword123',
            newPassword: 'newPassword123',
            confirmPassword: 'newPassword123',
          );

          // Assert
          final state = container.read(authViewModelProvider);
          expect(state.status, AuthStatus.passwordChanged);
          verify(() => mockChangePasswordUsecase(any())).called(1);
        },
      );

      test('should emit error state when password change fails', () async {
        // Arrange
        const failure = ApiFailure(message: 'Current password is incorrect');
        when(
          () => mockChangePasswordUsecase(any()),
        ).thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(authViewModelProvider.notifier);

        // Act
        await viewModel.changePassword(
          currentPassword: 'oldPassword123',
          newPassword: 'newPassword123',
          confirmPassword: 'newPassword123',
        );

        // Assert
        final state = container.read(authViewModelProvider);
        expect(state.status, AuthStatus.error);
        expect(state.errorMessage, 'Current password is incorrect');
        verify(() => mockChangePasswordUsecase(any())).called(1);
      });

      test('should pass correct parameters to usecase', () async {
        // Arrange
        ChangePasswordUsecaseParams? capturedParams;
        when(() => mockChangePasswordUsecase(any())).thenAnswer((invocation) {
          capturedParams = invocation.positionalArguments[0] as ChangePasswordUsecaseParams;
          return Future.value(const Right('Password changed successfully'));
        });

        final viewModel = container.read(authViewModelProvider.notifier);

        // Act
        await viewModel.changePassword(
          currentPassword: 'oldPassword123',
          newPassword: 'newPassword123',
          confirmPassword: 'newPassword123',
        );

        // Assert
        expect(capturedParams?.currentPassword, 'oldPassword123');
        expect(capturedParams?.newPassword, 'newPassword123');
        expect(capturedParams?.confirmPassword, 'newPassword123');
      });

      test('should transition through loading state during password change', () async {
        // Arrange
        final states = <AuthState>[];
        when(
          () => mockChangePasswordUsecase(any()),
        ).thenAnswer((_) async => const Right('Password changed successfully'));

        final viewModel = container.read(authViewModelProvider.notifier);

        // Act
        states.add(container.read(authViewModelProvider));

        final changePasswordFuture = viewModel.changePassword(
          currentPassword: 'oldPassword123',
          newPassword: 'newPassword123',
          confirmPassword: 'newPassword123',
        );

        states.add(container.read(authViewModelProvider));

        await changePasswordFuture;

        states.add(container.read(authViewModelProvider));

        // Assert
        expect(states[1].status, AuthStatus.loading);
        expect(states[2].status, AuthStatus.passwordChanged);
      });
    });
  });

  group('AuthState', () {
    test('should have correct initial values', () {
      // Arrange
      const state = AuthState();

      // Assert
      expect(state.status, AuthStatus.initial);
      expect(state.authEntity, isNull);
      expect(state.errorMessage, isNull);
    });

    test('copyWith should update specified fields', () {
      // Arrange
      const state = AuthState();

      // Act
      final newState = state.copyWith(
        status: AuthStatus.authenticated,
        authEntity: tUser,
      );

      // Assert
      expect(newState.status, AuthStatus.authenticated);
      expect(newState.authEntity, tUser);
      expect(newState.errorMessage, isNull);
    });

    test('copyWith should preserve existing values when not specified', () {
      // Arrange
      const state = AuthState(
        status: AuthStatus.authenticated,
        authEntity: tUser,
        errorMessage: 'error',
      );

      // Act
      final newState = state.copyWith(status: AuthStatus.loading);

      // Assert
      expect(newState.status, AuthStatus.loading);
      expect(newState.authEntity, tUser);
      expect(newState.errorMessage, 'error');
    });

    test('props should contain all fields', () {
      // Arrange
      const state = AuthState(
        status: AuthStatus.authenticated,
        authEntity: tUser,
        errorMessage: 'error',
      );

      // Assert
      expect(state.props, [AuthStatus.authenticated, tUser, 'error']);
    });

    test('two states with same values should be equal', () {
      // Arrange
      const state1 = AuthState(status: AuthStatus.authenticated, authEntity: tUser);
      const state2 = AuthState(status: AuthStatus.authenticated, authEntity: tUser);

      // Assert
      expect(state1, state2);
    });

    test('copyWith with null errorMessage should clear error', () {
      // Arrange
      const state = AuthState(
        status: AuthStatus.error,
        errorMessage: 'error',
      );

      // Act
      final newState = state.copyWith(
        status: AuthStatus.initial,
        errorMessage: null,
      );

      // Assert
      expect(newState.errorMessage, isNull);
      expect(newState.status, AuthStatus.initial);
    });
  });
}
