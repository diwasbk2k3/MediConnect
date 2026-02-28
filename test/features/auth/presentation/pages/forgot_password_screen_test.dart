import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediconnect/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:mediconnect/features/auth/presentation/state/forgot_password_state.dart';
import 'package:mediconnect/features/auth/presentation/view_model/forgot_password_view_model.dart';

// Mock ForgotPasswordViewModel for testing
class MockForgotPasswordViewModel extends ForgotPasswordViewModel {
  @override
  ForgotPasswordState build() {
    return const ForgotPasswordState(status: ForgotPasswordStatus.initial);
  }

  Future<void> mockSendPasswordResetEmailLoading() async {
    state = const ForgotPasswordState(status: ForgotPasswordStatus.loading);
  }

  Future<void> mockSendPasswordResetEmailError({
    required String email,
    required String errorMessage,
  }) async {
    state = ForgotPasswordState(
      status: ForgotPasswordStatus.error,
      errorMessage: errorMessage,
    );
  }
}

void main() {
  Widget createTestWidget({
    required ForgotPasswordViewModel forgotPasswordViewModel,
  }) {
    return ProviderScope(
      overrides: [
        forgotPasswordViewModelProvider
            .overrideWith(() => forgotPasswordViewModel),
      ],
      child: const MaterialApp(
        home: ForgotPasswordScreen(),
      ),
    );
  }

  group('ForgotPasswordScreen - Widget Tests', () {
    testWidgets('Header and AppBar Elements', (tester) async {
      await tester.pumpWidget(createTestWidget(
        forgotPasswordViewModel: MockForgotPasswordViewModel(),
      ));

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Reset Password'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, Colors.white);
      
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, isNotNull);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.text('Reset Your Password'), findsOneWidget);
    });

    testWidgets('Form Structure and Email Field', (tester) async {
      await tester.pumpWidget(createTestWidget(
        forgotPasswordViewModel: MockForgotPasswordViewModel(),
      ));

      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(Padding), findsWidgets);
      
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Enter your email address'), findsOneWidget);
      
      final emailField = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(emailField.validator, isNotNull);
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('Email Validation Empty and Invalid', (tester) async {
      await tester.pumpWidget(createTestWidget(
        forgotPasswordViewModel: MockForgotPasswordViewModel(),
      ));

      final emailField = tester.widget<TextFormField>(find.byType(TextFormField));
      final validator = emailField.validator;

      expect(validator, isNotNull);
      expect(validator!(''), isNotEmpty);
      expect(validator('invalidemail'), isNotEmpty);
      expect(validator('test'), isNotEmpty);
      expect(validator('notanemail'), isNotEmpty);
      expect(validator('test.email'), isNotEmpty);
      
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Enter your email address'), findsOneWidget);
    });

    testWidgets('Email Validation Valid Format', (tester) async {
      await tester.pumpWidget(createTestWidget(
        forgotPasswordViewModel: MockForgotPasswordViewModel(),
      ));

      final emailField = tester.widget<TextFormField>(find.byType(TextFormField));
      final validator = emailField.validator;

      expect(validator, isNotNull);
      expect(validator!('test@example.com'), isNull);
      expect(validator('user.name@test.co.uk'), isNull);
      expect(validator('name+tag@domain.org'), isNull);
      expect(validator('contact@mysite.io'), isNull);
      
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Reset Your Password'), findsOneWidget);
      expect(find.text('Enter your email address'), findsOneWidget);
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('Text Input and Data Entry', (tester) async {
      await tester.pumpWidget(createTestWidget(
        forgotPasswordViewModel: MockForgotPasswordViewModel(),
      ));

      const testEmail = 'user@example.com';
      final emailField = find.byType(TextFormField);
      
      await tester.enterText(emailField, testEmail);
      await tester.pump();
      expect(find.text(testEmail), findsOneWidget);

      const newEmail = 'different@email.com';
      await tester.enterText(emailField, newEmail);
      await tester.pump();
      expect(find.text(newEmail), findsOneWidget);
      expect(find.text(testEmail), findsNothing);

      await tester.enterText(emailField, '');
      await tester.pump();
      expect(find.text(newEmail), findsNothing);
      
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('Send Reset Link Button', (tester) async {
      await tester.pumpWidget(createTestWidget(
        forgotPasswordViewModel: MockForgotPasswordViewModel(),
      ));

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Send Reset Link'), findsOneWidget);

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);

      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(Padding), findsWidgets);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Bottom Navigation Links', (tester) async {
      await tester.pumpWidget(createTestWidget(
        forgotPasswordViewModel: MockForgotPasswordViewModel(),
      ));

      expect(find.text('Know your password? '), findsOneWidget);
      expect(find.text('Return to login'), findsOneWidget);
      
      expect(find.byType(GestureDetector), findsWidgets);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(RichText), findsWidgets);
      
      expect(find.text('Reset Your Password'), findsOneWidget);
      expect(find.text('Send Reset Link'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Subtitle and Helper Text', (tester) async {
      await tester.pumpWidget(createTestWidget(
        forgotPasswordViewModel: MockForgotPasswordViewModel(),
      ));

      expect(find.text('Reset Your Password'), findsOneWidget);
      expect(find.text('Enter your email address to receive a password reset link'), findsOneWidget);
      
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Enter your email address'), findsOneWidget);
      expect(find.text('Send Reset Link'), findsOneWidget);
      
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Reset Password'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('Widget Tree and Layout', (tester) async {
      await tester.pumpWidget(createTestWidget(
        forgotPasswordViewModel: MockForgotPasswordViewModel(),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Padding), findsWidgets);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(GestureDetector), findsWidgets);
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('Initial State and Display', (tester) async {
      final mockViewModel = MockForgotPasswordViewModel();
      await tester.pumpWidget(createTestWidget(
        forgotPasswordViewModel: mockViewModel,
      ));

      expect(mockViewModel.state.status, ForgotPasswordStatus.initial);
      expect(find.text('Reset Your Password'), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Send Reset Link'), findsOneWidget);
      expect(find.text('Know your password? '), findsOneWidget);
      expect(find.text('Return to login'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Reset Password'), findsOneWidget);
    });
  });
}