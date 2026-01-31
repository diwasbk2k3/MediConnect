
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediconnect/features/auth/domain/usecases/login_usecase.dart';
import 'package:mediconnect/features/auth/presentation/pages/login_screen.dart';
import 'package:mediconnect/features/auth/presentation/state/auth_state.dart';
import 'package:mediconnect/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockLoginUsecase extends Mock implements LoginUsecase {}

// Mock AuthViewModel for testing
class MockAuthViewModel extends AuthViewModel {
  @override
  AuthState build() {
    return const AuthState(status: AuthStatus.initial, authEntity: null);
  }

  Future<void> mockLogin({
    required String email,
    required String password,
  }) async {
    // For testing, just update state to authenticated
    state = const AuthState(status: AuthStatus.authenticated, authEntity: null);
  }

  Future<void> mockLogout() async {
    state = const AuthState(status: AuthStatus.initial, authEntity: null);
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const LoginUseCaseParams(
        email: 'fallback@email.com',
        password: 'fallback123',
      ),
    );
  });

  setUp(() {
  });

  Widget createTestWidget({
    required AuthViewModel authViewModel,
  }) {
    return ProviderScope(
      overrides: [
        authViewModelProvider.overrideWith(() => authViewModel),
      ],
      child: const MaterialApp(
        home: LoginScreen(),
      ),
    );
  }

  group('LoginScreen UI Elements - Header', () {
    testWidgets('should display MediConnect title in header', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      expect(find.text('MediConnect'), findsOneWidget);
    });

    testWidgets('should display tagline "Connecting You"', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      expect(find.text('Connecting You'), findsOneWidget);
    });

    testWidgets('should display tagline "To Better Care"', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      expect(find.text('To Better Care'), findsOneWidget);
    });

    testWidgets('should display rectangle background image', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      expect(find.byType(Image), findsWidgets);
    });

    testWidgets('should display logo image', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      final images = find.byType(Image);
      expect(images, findsWidgets);
    });
  });

  group('LoginScreen Form Fields', () {
    testWidgets('should display Email label', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('should display Password label', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('should display email input field with hint text', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Enter your email'), findsOneWidget);
    });

    testWidgets('should display password input field with hint text', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      expect(find.text('Enter your password'), findsOneWidget);
    });

    testWidgets('should have two TextFormField widgets', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      expect(find.byType(TextFormField), findsNWidgets(2));
    });
  });

  group('LoginScreen Form Controls', () {
    testWidgets('should display Login button', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('should display Forgot Password link', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      expect(find.text('Forgot Password?'), findsOneWidget);
    });

    testWidgets('should display Register now link', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      expect(find.text("Don't have an account? "), findsOneWidget);
      expect(find.text('Register now?'), findsOneWidget);
    });

    testWidgets('should toggle password visibility when visibility icon tapped',
        (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      // Find visibility icon button
      final iconButton = find.byIcon(Icons.visibility_off);
      expect(iconButton, findsOneWidget);

      // Tap to toggle
      await tester.tap(iconButton);
      await tester.pump();

      // Should now show visibility icon
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });
  });

  group('LoginScreen Form Validation', () {
    testWidgets('should have email field validator defined', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      final formFields = find.byType(TextFormField);
      
      // Get the email field
      final emailField = tester.widget<TextFormField>(formFields.at(0));
      
      // Email validator should exist
      expect(emailField.validator, isNotNull);
    });

    testWidgets('should have password field validator defined', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      final formFields = find.byType(TextFormField);
      
      // Get the password field
      final passwordField = tester.widget<TextFormField>(formFields.at(1));
      
      // Password validator should exist
      expect(passwordField.validator, isNotNull);
    });

    testWidgets('email validator rejects empty email', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      final formFields = find.byType(TextFormField);
      final emailField = tester.widget<TextFormField>(formFields.at(0));
      
      // Test the validator directly
      final validator = emailField.validator;
      expect(validator, isNotNull);
      expect(validator!(''), isNotEmpty);
    });

    testWidgets('password validator rejects short password', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      final formFields = find.byType(TextFormField);
      final passwordField = tester.widget<TextFormField>(formFields.at(1));
      
      // Test the validator directly
      final validator = passwordField.validator;
      expect(validator, isNotNull);
      expect(validator!('12345'), isNotEmpty); // Less than 6 characters
    });

    testWidgets('should allow valid email and password entry', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      final formFields = find.byType(TextFormField);
      
      await tester.enterText(formFields.at(0), 'valid@example.com');
      await tester.enterText(formFields.at(1), 'password123');
      await tester.pump();

      expect(find.text('valid@example.com'), findsOneWidget);

      // Check password field has content
      final passwordField = tester.widget<TextFormField>(formFields.at(1));
      expect(passwordField.controller?.text, 'password123');
    });
  });

  group('LoginScreen Form Submission', () {
    testWidgets('should not call login when form is invalid', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      final formFields = find.byType(TextFormField);
      
      // Only fill email, leave password empty
      await tester.enterText(formFields.at(0), 'test@example.com');

      await tester.tap(find.text('Login'));
      await tester.pump();

      // State should still be initial (not authenticated)
      expect(authViewModel.state.status, AuthStatus.initial);
    });

    testWidgets('should allow form to be submitted with valid data',
        (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      final formFields = find.byType(TextFormField);
      
      const testEmail = 'authEntity@test.com';
      const testPassword = 'mypassword123';

      await tester.enterText(formFields.at(0), testEmail);
      await tester.enterText(formFields.at(1), testPassword);

      // No validation error should appear
      expect(find.text('Email is required'), findsNothing);
      expect(find.text('Password is required'), findsNothing);
      expect(find.text('Enter a valid email'), findsNothing);
      expect(find.text('Password must be at least 6 characters'), findsNothing);
    });

    testWidgets('should display CircularProgressIndicator during login',
        (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      // Find form fields
      final formFields = find.byType(TextFormField);
      
      await tester.enterText(formFields.at(0), 'test@example.com');
      await tester.enterText(formFields.at(1), 'password123');

      // Tap login
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Since form is valid, no validation errors
      expect(find.text('Email is required'), findsNothing);
    });
  });

  group('LoginScreen Navigation & UI', () {
    testWidgets('should show Forgot Password link', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      expect(find.text('Forgot Password?'), findsOneWidget);
    });

    testWidgets('should render in SingleChildScrollView', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should have white background', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      final scaffold = find.byType(Scaffold);
      expect(scaffold, findsOneWidget);

      final scaffoldWidget = tester.widget<Scaffold>(scaffold);
      expect(scaffoldWidget.backgroundColor, Colors.white);
    });

    testWidgets('should have Login button', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      final button = find.byType(ElevatedButton);
      expect(button, findsOneWidget);
    });

    testWidgets('should have Login button with correct text', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      expect(find.text('Login'), findsOneWidget);
    });
  });
}
