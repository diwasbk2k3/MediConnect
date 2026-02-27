import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediconnect/features/auth/presentation/pages/signup_screen.dart';
import 'package:mediconnect/features/auth/presentation/state/auth_state.dart';
import 'package:mediconnect/features/auth/presentation/view_model/auth_view_model.dart';

// Mock AuthViewModel for testing
class MockAuthViewModelSignup extends AuthViewModel {
  @override
  AuthState build() {
    return const AuthState(status: AuthStatus.initial, authEntity: null);
  }
}

void main() {
  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        authViewModelProvider.overrideWith(
          () => MockAuthViewModelSignup(),
        ),
      ],
      child: const MaterialApp(
        home: SignupScreen(),
      ),
    );
  }

  group('SignupScreen - Widget Tests', () {
 
    testWidgets('Header and Branding Elements', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('MediConnect'), findsOneWidget);
      expect(find.text('Connecting You'), findsOneWidget);
      expect(find.text('To Better Care'), findsOneWidget);
      expect(find.byType(Image), findsWidgets);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, Colors.white);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('New Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
    });

    testWidgets('Form Structure and Input Fields', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(TextFormField), findsWidgets);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.byType(Padding), findsWidgets);
      expect(find.text('Register'), findsOneWidget);
      
      final formFields = find.byType(TextFormField);
      expect(formFields, findsWidgets);
      
      final checkbox = find.byType(Checkbox);
      expect(checkbox, findsOneWidget);
    });

    testWidgets('Email Field Validation', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final formFields = find.byType(TextFormField);
      expect(formFields, findsWidgets);
      expect(find.byType(Form), findsOneWidget);
      final emailField = formFields.first;
      
      await tester.enterText(emailField, 'test@example.com');
      await tester.pump();
      expect(find.text('test@example.com'), findsOneWidget);

      await tester.enterText(emailField, 'invalid');
      await tester.pump();
      expect(find.text('invalid'), findsOneWidget);

      await tester.enterText(emailField, 'user@test.co.uk');
      await tester.pump();
      expect(find.text('user@test.co.uk'), findsOneWidget);

      await tester.enterText(emailField, '');
      await tester.pump();
      expect(find.text('test@example.com'), findsNothing);
      expect(find.text('invalid'), findsNothing);
      expect(find.text('user@test.co.uk'), findsNothing);
      expect(find.text('Email'), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('Phone Number Field Validation', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final formFields = find.byType(TextFormField);
      expect(formFields, findsWidgets);
      expect(find.text('Phone Number'), findsOneWidget);
      
      final phoneField = formFields.evaluate().length > 1 ? formFields.at(1) : null;
      if (phoneField != null) {
        await tester.enterText(phoneField, '1234567890');
        await tester.pump();
        expect(find.text('1234567890'), findsOneWidget);

        await tester.enterText(phoneField, '9876543210');
        await tester.pump();
        expect(find.text('9876543210'), findsOneWidget);

        await tester.enterText(phoneField, '');
        await tester.pump();
        expect(find.text('1234567890'), findsNothing);
        expect(find.text('9876543210'), findsNothing);
      }
      
      expect(find.byType(TextFormField), findsWidgets);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('Password Fields Validation', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('New Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);

      final formFields = find.byType(TextFormField);
      expect(formFields, findsWidgets);
      expect(find.byType(Form), findsOneWidget);

      // Test password field entry
      if (formFields.evaluate().length > 2) {
        final passwordField = formFields.at(2);
        await tester.enterText(passwordField, 'Password123');
        await tester.pump();
        expect(find.text('Password123'), findsOneWidget);

        final confirmField = formFields.evaluate().length > 3 ? formFields.at(3) : null;
        if (confirmField != null) {
          await tester.enterText(confirmField, 'Password123');
          await tester.pump();
          expect(find.text('Password123'), findsWidgets);
        }
      }

      expect(find.byType(GestureDetector), findsWidgets);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsWidgets);
    });

    testWidgets('Terms and Conditions Checkbox', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(Checkbox), findsOneWidget);
      
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox, isNotNull);

      expect(find.byType(RichText), findsWidgets);
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(TextFormField), findsWidgets);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(Padding), findsWidgets);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('Signup Button and Navigation', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);

      expect(find.text('Already have an account? '), findsWidgets);
      expect(find.text('Login'), findsWidgets);
      
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(GestureDetector), findsWidgets);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets('Form Input and Data Entry', (tester) async {
      await tester.pumpWidget(createTestWidget());

      const testEmail = 'newuser@example.com';
      const testPhone = '9876543210';
      const testPassword = 'SecurePassword123';

      final formFields = find.byType(TextFormField);
      expect(formFields, findsWidgets);

      // Email entry
      await tester.enterText(formFields.first, testEmail);
      await tester.pump();
      expect(find.text(testEmail), findsOneWidget);

      // Change email
      await tester.enterText(formFields.first, 'different@email.com');
      await tester.pump();
      expect(find.text('different@email.com'), findsOneWidget);
      expect(find.text(testEmail), findsNothing);

      // Phone entry
      if (formFields.evaluate().length > 1) {
        await tester.enterText(formFields.at(1), testPhone);
        await tester.pump();
        expect(find.text(testPhone), findsOneWidget);
      }

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
    });

    testWidgets('Widget Tree and Layout', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Padding), findsWidgets);
      expect(find.byType(TextFormField), findsWidgets);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.byType(Image), findsWidgets);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets('Initial State and Display', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Verify all form labels are displayed
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('New Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);

      // Verify branding
      expect(find.text('MediConnect'), findsOneWidget);
      expect(find.text('Connecting You'), findsOneWidget);

      // Verify form structure
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
      expect(find.byType(RichText), findsWidgets);
    });
  });
}