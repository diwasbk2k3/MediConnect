
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

  group('LoginScreen - Widget Tests', () {
    testWidgets('Header and Branding Elements', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      expect(find.text('MediConnect'), findsOneWidget);
      expect(find.text('Connecting You'), findsOneWidget);
      expect(find.text('To Better Care'), findsOneWidget);
      expect(find.byType(Image), findsWidgets);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, Colors.white);
      expect(find.byType(AppBar), findsNothing); // LoginScreen has no AppBar
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text("Don't have an account? "), findsOneWidget);
    });

    testWidgets('Form Structure and Widgets', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Column), findsWidgets);
      final formFields = find.byType(TextFormField);
      final emailField = tester.widget<TextFormField>(formFields.at(0));
      final passwordField = tester.widget<TextFormField>(formFields.at(1));
      expect(emailField.validator, isNotNull);
      expect(passwordField.validator, isNotNull);
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('Email Field Validation', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      final emailField = find.byType(TextFormField).first;
      final formFields = find.byType(TextFormField);
      final emailWidget = tester.widget<TextFormField>(formFields.at(0));
      final validator = emailWidget.validator;

      expect(validator, isNotNull);
      expect(validator!(''), isNotEmpty); // Empty email
      expect(validator('invalid'), isNotEmpty); // Invalid format
      expect(validator('test@example.com'), isNull); // Valid email
      expect(validator('user@test.co.uk'), isNull); // Valid format

      await tester.enterText(emailField, 'test@example.com');
      await tester.pump();
      expect(find.text('test@example.com'), findsOneWidget);

      await tester.enterText(emailField, 'invalid');
      await tester.pump();
      expect(find.text('invalid'), findsOneWidget);

      await tester.enterText(emailField, '');
      await tester.pump();
      expect(find.text('test@example.com'), findsNothing);
      expect(find.text('invalid'), findsNothing);
    });

    testWidgets('Password Field Validation', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      final passwordField = find.byType(TextFormField).at(1);
      final formFields = find.byType(TextFormField);
      final passwordWidget = tester.widget<TextFormField>(formFields.at(1));
      final validator = passwordWidget.validator;

      expect(validator, isNotNull);
      expect(validator!(''), isNotEmpty); // Empty password
      expect(validator('12345'), isNotEmpty); // Too short
      expect(validator('password123'), isNull); // Valid

      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      final passwordController = passwordWidget.controller;
      expect(passwordController?.text, isNotEmpty);

      await tester.enterText(passwordField, '');
      await tester.pump();
      expect(passwordController?.text, '');
      expect(validator(''), isNotEmpty);
    });

    testWidgets('Password Visibility Toggle', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      var visibilityIcon = find.byIcon(Icons.visibility_off);
      expect(visibilityIcon, findsOneWidget);

      await tester.tap(visibilityIcon);
      await tester.pump();
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsNothing);

      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.pump();
      
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('Login Button and Form Submission', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);

      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.pump();

      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(authViewModel.state.status, AuthStatus.initial);
    });

    testWidgets('Navigation and Help Links', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text("Don't have an account? "), findsOneWidget);
      expect(find.text('Register now?'), findsOneWidget);
      
      final forgotPasswordLink = find.text('Forgot Password?');
      expect(forgotPasswordLink, findsOneWidget);
      
      final registerLink = find.text('Register now?');
      expect(registerLink, findsOneWidget);
      
      expect(find.byType(GestureDetector), findsWidgets);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('Text Input and Data Entry', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).at(1);

      const testEmail = 'user@example.com';
      const testPassword = 'MyPassword123';

      await tester.enterText(emailField, testEmail);
      await tester.pump();
      expect(find.text(testEmail), findsOneWidget);

      await tester.enterText(passwordField, testPassword);
      await tester.pump();

      final passwordWidget = tester.widget<TextFormField>(passwordField);
      expect(passwordWidget.controller?.text, testPassword);

      await tester.enterText(emailField, '');
      await tester.pump();
      expect(find.text(testEmail), findsNothing);

      await tester.enterText(emailField, 'new@email.com');
      await tester.pump();
      expect(find.text('new@email.com'), findsOneWidget);
      expect(find.text(testEmail), findsNothing);
    });

    testWidgets('Widget Tree and Hierarchy', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(Image), findsWidgets);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(GestureDetector), findsWidgets);
      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('Initial State and Conditions', (tester) async {
      final authViewModel = MockAuthViewModel();
      await tester.pumpWidget(createTestWidget(authViewModel: authViewModel));

      expect(authViewModel.state.status, AuthStatus.initial);
      expect(authViewModel.state.authEntity, isNull);
      expect(authViewModel.state.errorMessage, isNull);
      
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('MediConnect'), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });
  });
}
