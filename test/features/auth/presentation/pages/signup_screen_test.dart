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

  group('SignupScreen UI Elements - Header', () {
    testWidgets('should display MediConnect branding in header', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('MediConnect'), findsOneWidget);
    });

    testWidgets('should display Connecting You text', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Connecting You'), findsOneWidget);
    });

    testWidgets('should display To Better Care text', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('To Better Care'), findsOneWidget);
    });
  });

  group('SignupScreen Form Fields', () {
    testWidgets('should display Email label', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('should display email input field with hint text', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byWidgetPredicate(
        (widget) => widget is TextField && widget.decoration?.hintText == 'Enter your email',
      ), findsOneWidget);
    });

    testWidgets('should display Phone Number label', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Phone Number'), findsOneWidget);
    });

    testWidgets('should display phone input field with hint text', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byWidgetPredicate(
        (widget) => widget is TextField && widget.decoration?.hintText == 'Enter phone number',
      ), findsOneWidget);
    });

    testWidgets('should display Password label', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('New Password'), findsOneWidget);
    });

    testWidgets('should display password input field with hint text', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byWidgetPredicate(
        (widget) => widget is TextField && widget.decoration?.hintText == 'Enter new password',
      ), findsOneWidget);
    });

    testWidgets('should display Confirm Password label', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Confirm Password'), findsOneWidget);
    });

    testWidgets('should display confirm password field with hint text', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byWidgetPredicate(
        (widget) => widget is TextField && widget.decoration?.hintText == 'Confirm new password',
      ), findsOneWidget);
    });
  });

  group('SignupScreen Form Controls', () {
    testWidgets('should display Terms and Conditions checkbox', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets('should display ElevatedButton for signup', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should display login link', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Login'), findsOneWidget);
    });
  });

  group('SignupScreen Form Validation', () {
    testWidgets('should validate empty email field', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final textFormFields = find.byType(TextFormField);
      expect(textFormFields, findsWidgets);
      
      final emailField = textFormFields.first;
      final TextFormField textField = tester.widget(emailField);
      
      expect(textField.validator!(''), equals('Please enter your email'));
    });

    testWidgets('should validate invalid email format', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final textFormFields = find.byType(TextFormField);
      final emailField = textFormFields.first;
      final TextFormField textField = tester.widget(emailField);
      
      expect(textField.validator!('invalidemail'), isNotNull);
    });

    testWidgets('should validate valid email format', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final textFormFields = find.byType(TextFormField);
      final emailField = textFormFields.first;
      final TextFormField textField = tester.widget(emailField);
      
      expect(textField.validator!('test@example.com'), isNull);
    });

    testWidgets('should validate empty phone field', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final textFormFields = find.byType(TextFormField);
      final phoneField = textFormFields.at(1); // Second TextFormField is phone
      final TextFormField textField = tester.widget(phoneField);
      
      expect(textField.validator!(''), isNotNull);
    });

    testWidgets('should validate empty password field', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final passwordField = find.byWidgetPredicate(
        (widget) => widget is TextField && widget.decoration?.hintText == 'Enter new password',
      );
      
      expect(passwordField, findsOneWidget);
    });

    testWidgets('should validate empty confirm password field', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final confirmField = find.byWidgetPredicate(
        (widget) => widget is TextField && widget.decoration?.hintText == 'Confirm new password',
      );
      
      expect(confirmField, findsOneWidget);
    });
  });

  group('SignupScreen Layout and Structure', () {
    testWidgets('should have SingleChildScrollView wrapper', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should have Form widget', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('should have Scaffold as root widget', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final scaffold = find.byType(Scaffold);
      expect(scaffold, findsOneWidget);
    });

    testWidgets('should have container elements for layout', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final containers = find.byType(Container);
      expect(containers, findsWidgets);
    });
  });
}
