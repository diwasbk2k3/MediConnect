import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediconnect/core/error/failures.dart';
import 'package:mediconnect/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:mediconnect/features/auth/presentation/state/forgot_password_state.dart';
import 'package:mediconnect/features/auth/presentation/view_model/forgot_password_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockForgotPasswordUsecase extends Mock implements ForgotPasswordUsecase {}

void main() {
  late MockForgotPasswordUsecase mockForgotPasswordUsecase;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(
      const ForgotPasswordUsecaseParams(email: 'fallback@example.com'),
    );
  });

  setUp(() {
    mockForgotPasswordUsecase = MockForgotPasswordUsecase();

    container = ProviderContainer(
      overrides: [
        forgotPasswordUsecaseProvider.overrideWithValue(
          mockForgotPasswordUsecase,
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  const tEmail = 'test@example.com';
  const tSuccessMessage = 'Password reset email sent!';
  const tErrorMessage = 'Email not found in our records';

  group('ForgotPasswordViewModel', () {
    group('initial state', () {
      test('should have initial state when created', () {
        // Act
        final state = container.read(forgotPasswordViewModelProvider);

        // Assert
        expect(
          state,
          const ForgotPasswordState(status: ForgotPasswordStatus.initial),
        );
        expect(state.status, ForgotPasswordStatus.initial);
        expect(state.successMessage, null);
        expect(state.errorMessage, null);
      });
    });

    group('sendPasswordResetEmail', () {
      test(
        'should update state to loading then success when email is sent',
        () async {
          // Arrange
          when(() => mockForgotPasswordUsecase(any()))
              .thenAnswer((_) async => const Right(tSuccessMessage));

          final notifier =
              container.read(forgotPasswordViewModelProvider.notifier);

          // Act
          await notifier.sendPasswordResetEmail(email: tEmail);

          // Assert
          final state = container.read(forgotPasswordViewModelProvider);
          expect(state.status, ForgotPasswordStatus.success);
          expect(state.successMessage, tSuccessMessage);
          expect(state.errorMessage, null);
          verify(() => mockForgotPasswordUsecase(
                const ForgotPasswordUsecaseParams(email: tEmail),
              )).called(1);
        },
      );

      test(
        'should pass correct email to usecase',
        () async {
          // Arrange
          when(() => mockForgotPasswordUsecase(any()))
              .thenAnswer((_) async => const Right(tSuccessMessage));

          final notifier =
              container.read(forgotPasswordViewModelProvider.notifier);

          // Act
          await notifier.sendPasswordResetEmail(email: tEmail);

          // Assert
          verify(() => mockForgotPasswordUsecase(
                const ForgotPasswordUsecaseParams(email: tEmail),
              )).called(1);
        },
      );

      test(
        'should update state to error when email is not found',
        () async {
          // Arrange
          const failure = ApiFailure(message: tErrorMessage);
          when(() => mockForgotPasswordUsecase(any()))
              .thenAnswer((_) async => const Left(failure));

          final notifier =
              container.read(forgotPasswordViewModelProvider.notifier);

          // Act
          await notifier.sendPasswordResetEmail(email: tEmail);

          // Assert
          final state = container.read(forgotPasswordViewModelProvider);
          expect(state.status, ForgotPasswordStatus.error);
          expect(state.errorMessage, tErrorMessage);
          expect(state.successMessage, null);
        },
      );

      test(
        'should update state to error on network failure',
        () async {
          // Arrange
          const failure =
              ApiFailure(message: 'No internet connection');
          when(() => mockForgotPasswordUsecase(any()))
              .thenAnswer((_) async => const Left(failure));

          final notifier =
              container.read(forgotPasswordViewModelProvider.notifier);

          // Act
          await notifier.sendPasswordResetEmail(email: tEmail);

          // Assert
          final state = container.read(forgotPasswordViewModelProvider);
          expect(state.status, ForgotPasswordStatus.error);
          expect(state.errorMessage, 'No internet connection');
        },
      );

      test(
        'should update state to error on server failure',
        () async {
          // Arrange
          const failure = ApiFailure(message: 'Server error occurred');
          when(() => mockForgotPasswordUsecase(any()))
              .thenAnswer((_) async => const Left(failure));

          final notifier =
              container.read(forgotPasswordViewModelProvider.notifier);

          // Act
          await notifier.sendPasswordResetEmail(email: tEmail);

          // Assert
          final state = container.read(forgotPasswordViewModelProvider);
          expect(state.status, ForgotPasswordStatus.error);
          expect(state.errorMessage, 'Server error occurred');
        },
      );

      test(
        'should handle multiple sequential email requests',
        () async {
          // Arrange
          when(() => mockForgotPasswordUsecase(any()))
              .thenAnswer((_) async => const Right(tSuccessMessage));

          final notifier =
              container.read(forgotPasswordViewModelProvider.notifier);

          // Act - First request
          await notifier.sendPasswordResetEmail(email: 'first@example.com');

          var state = container.read(forgotPasswordViewModelProvider);
          expect(state.status, ForgotPasswordStatus.success);

          // Act - Second request
          await notifier.sendPasswordResetEmail(email: 'second@example.com');

          state = container.read(forgotPasswordViewModelProvider);
          expect(state.status, ForgotPasswordStatus.success);

          // Assert
          verify(() => mockForgotPasswordUsecase(any())).called(2);
        },
      );

      test(
        'should preserve success message in state',
        () async {
          // Arrange
          const customMessage = 'Check your email for reset link';
          when(() => mockForgotPasswordUsecase(any()))
              .thenAnswer((_) async => const Right(customMessage));

          final notifier =
              container.read(forgotPasswordViewModelProvider.notifier);

          // Act
          await notifier.sendPasswordResetEmail(email: tEmail);

          // Assert
          final state = container.read(forgotPasswordViewModelProvider);
          expect(state.successMessage, customMessage);
        },
      );

      test(
        'should preserve error message in state',
        () async {
          // Arrange
          const customError = 'This email is already registered';
          const failure = ApiFailure(message: customError);
          when(() => mockForgotPasswordUsecase(any()))
              .thenAnswer((_) async => const Left(failure));

          final notifier =
              container.read(forgotPasswordViewModelProvider.notifier);

          // Act
          await notifier.sendPasswordResetEmail(email: tEmail);

          // Assert
          final state = container.read(forgotPasswordViewModelProvider);
          expect(state.errorMessage, customError);
        },
      );

      test(
        'should set loading status before calling usecase',
        () async {
          // Arrange
          when(() => mockForgotPasswordUsecase(any()))
              .thenAnswer((_) async => const Right(tSuccessMessage));

          final notifier =
              container.read(forgotPasswordViewModelProvider.notifier);

          // Act
          final future = notifier.sendPasswordResetEmail(email: tEmail);

          // Assert - should be loading state
          var state = container.read(forgotPasswordViewModelProvider);
          expect(
            state.status == ForgotPasswordStatus.loading ||
                state.status == ForgotPasswordStatus.success,
            isTrue,
          );

          await future;
        },
      );

      test(
        'should handle different valid email formats',
        () async {
          // Arrange
          when(() => mockForgotPasswordUsecase(any()))
              .thenAnswer((_) async => const Right(tSuccessMessage));

          final notifier =
              container.read(forgotPasswordViewModelProvider.notifier);

          const testEmails = [
            'user@example.com',
            'user.name@example.co.uk',
            'user+tag@test.org',
          ];

          // Act & Assert
          for (final email in testEmails) {
            await notifier.sendPasswordResetEmail(email: email);

            final state = container.read(forgotPasswordViewModelProvider);
            expect(state.status, ForgotPasswordStatus.success);

            verify(() => mockForgotPasswordUsecase(
                  ForgotPasswordUsecaseParams(email: email),
                )).called(greaterThan(0));
          }
        },
      );
    });

    group('resetState', () {
      test('should reset state to initial', () async {
        // Arrange
        when(() => mockForgotPasswordUsecase(any()))
            .thenAnswer((_) async => const Right(tSuccessMessage));

        final notifier =
            container.read(forgotPasswordViewModelProvider.notifier);

        // Act - Send email to change state
        await notifier.sendPasswordResetEmail(email: tEmail);

        var state = container.read(forgotPasswordViewModelProvider);
        expect(state.status, ForgotPasswordStatus.success);

        // Act - Reset state
        notifier.resetState();

        // Assert
        state = container.read(forgotPasswordViewModelProvider);
        expect(state.status, ForgotPasswordStatus.initial);
        expect(state.successMessage, null);
        expect(state.errorMessage, null);
      });

      test('should clear error message on reset', () async {
        // Arrange
        const failure = ApiFailure(message: 'Error occurred');
        when(() => mockForgotPasswordUsecase(any()))
            .thenAnswer((_) async => const Left(failure));

        final notifier =
            container.read(forgotPasswordViewModelProvider.notifier);

        // Act - Send email to trigger error
        await notifier.sendPasswordResetEmail(email: tEmail);

        var state = container.read(forgotPasswordViewModelProvider);
        expect(state.status, ForgotPasswordStatus.error);
        expect(state.errorMessage, isNotEmpty);

        // Act - Reset state
        notifier.resetState();

        // Assert
        state = container.read(forgotPasswordViewModelProvider);
        expect(state.errorMessage, null);
        expect(state.status, ForgotPasswordStatus.initial);
      });

      test('should clear success message on reset', () async {
        // Arrange
        when(() => mockForgotPasswordUsecase(any()))
            .thenAnswer((_) async => const Right(tSuccessMessage));

        final notifier =
            container.read(forgotPasswordViewModelProvider.notifier);

        // Act - Send email to set success
        await notifier.sendPasswordResetEmail(email: tEmail);

        var state = container.read(forgotPasswordViewModelProvider);
        expect(state.successMessage, isNotEmpty);

        // Act - Reset state
        notifier.resetState();

        // Assert
        state = container.read(forgotPasswordViewModelProvider);
        expect(state.successMessage, null);
        expect(state.status, ForgotPasswordStatus.initial);
      });
    });

    group('EdgeCases and Error Handling', () {
      test('should handle rapid successive requests', () async {
        // Arrange
        when(() => mockForgotPasswordUsecase(any()))
            .thenAnswer((_) async => const Right(tSuccessMessage));

        final notifier =
            container.read(forgotPasswordViewModelProvider.notifier);

        // Act - Send multiple requests rapidly
        await Future.wait([
          notifier.sendPasswordResetEmail(email: 'user1@example.com'),
          notifier.sendPasswordResetEmail(email: 'user2@example.com'),
        ]);

        // Assert
        final state = container.read(forgotPasswordViewModelProvider);
        expect(state.status, ForgotPasswordStatus.success);
      });

      test('should handle failure followed by success', () async {
        // Arrange
        when(() => mockForgotPasswordUsecase(any()))
            .thenAnswer((_) async => const Left(
              ApiFailure(message: 'First attempt failed'),
            ));
        
        final notifier =
            container.read(forgotPasswordViewModelProvider.notifier);

        // Act - First request fails
        await notifier.sendPasswordResetEmail(email: tEmail);

        var state = container.read(forgotPasswordViewModelProvider);
        expect(state.status, ForgotPasswordStatus.error);

        // Arrange - Setup mock for second call
        when(() => mockForgotPasswordUsecase(any()))
            .thenAnswer((_) async => const Right(tSuccessMessage));

        // Act - Second request succeeds
        await notifier.sendPasswordResetEmail(email: tEmail);

        // Assert
        state = container.read(forgotPasswordViewModelProvider);
        expect(state.status, ForgotPasswordStatus.success);
      });

      test('should maintain state immutability', () async {
        // Arrange
        when(() => mockForgotPasswordUsecase(any()))
            .thenAnswer((_) async => const Right(tSuccessMessage));

        // Act
        final initialState = container.read(forgotPasswordViewModelProvider);
        final notifier =
            container.read(forgotPasswordViewModelProvider.notifier);
        
        await notifier.sendPasswordResetEmail(email: tEmail);

        final updatedState = container.read(forgotPasswordViewModelProvider);

        // Assert - States should be different objects
        expect(identical(initialState, updatedState), isFalse);
        expect(initialState.status, ForgotPasswordStatus.initial);
        expect(updatedState.status, ForgotPasswordStatus.success);
      });
    });
  });
}
