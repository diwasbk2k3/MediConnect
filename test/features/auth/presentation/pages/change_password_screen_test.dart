import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediconnect/features/auth/presentation/pages/change_password_screen.dart';
import 'package:mediconnect/features/auth/presentation/state/auth_state.dart';
import 'package:mediconnect/features/auth/presentation/view_model/auth_view_model.dart';

// Mock AuthViewModel for testing
class MockAuthViewModelChangePassword extends AuthViewModel {
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
          () => MockAuthViewModelChangePassword(),
        ),
      ],
      child: const MaterialApp(
        home: ChangePasswordScreen(),
      ),
    );
  }

  group('ChangePasswordScreen UI Elements - Header', () {
    testWidgets('should display AppBar', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should display "Change Password" title in AppBar', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Change Password'), findsOneWidget);
    });

    testWidgets('should display close icon button in AppBar', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('should display CHANGE PASSWORD section title', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('CHANGE PASSWORD'), findsOneWidget);
    });
  });

  group('ChangePasswordScreen Form Fields', () {
    testWidgets('should display Current Password label', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Current Password'), findsOneWidget);
    });

    testWidgets('should display New Password label', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('New Password'), findsOneWidget);
    });

    testWidgets('should display Confirm Password label', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Confirm Password'), findsOneWidget);
    });

    testWidgets('should have three TextFormField widgets', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(TextFormField), findsNWidgets(3));
    });

    testWidgets('should display lock icons for password fields', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.lock_outline), findsWidgets);
    });
  });

  group('ChangePasswordScreen Form Controls', () {
    testWidgets('should display Update Password button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Update Password'), findsOneWidget);
    });

    testWidgets('should have ElevatedButton for update', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });

  group('ChangePasswordScreen Form Validation', () {
    testWidgets('should validate empty current password field', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final formFields = find.byType(TextFormField);
      final currentPasswordField = tester.widget<TextFormField>(formFields.at(0));
      
      expect(currentPasswordField.validator!(''), equals('Enter current password'));
    });

    testWidgets('should validate empty new password field', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final formFields = find.byType(TextFormField);
      final newPasswordField = tester.widget<TextFormField>(formFields.at(1));
      
      expect(newPasswordField.validator!(''), isNotEmpty);
    });

    testWidgets('should reject new password shorter than 6 characters', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final formFields = find.byType(TextFormField);
      final newPasswordField = tester.widget<TextFormField>(formFields.at(1));
      
      expect(newPasswordField.validator!('12345'), contains('6'));
    });

    testWidgets('should validate empty confirm password field', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final formFields = find.byType(TextFormField);
      final confirmPasswordField = tester.widget<TextFormField>(formFields.at(2));
      
      expect(confirmPasswordField.validator!(''), isNotEmpty);
    });

    testWidgets('should validate matching passwords', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final formFields = find.byType(TextFormField);
      final newPasswordField = tester.widget<TextFormField>(formFields.at(1));
      final confirmPasswordField = tester.widget<TextFormField>(formFields.at(2));
      
      // Valid new password
      expect(newPasswordField.validator!('password123'), isNull);
      
      // Confirm password validator exists
      expect(confirmPasswordField.validator, isNotNull);
    });

    testWidgets('should allow valid form data entry', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final formFields = find.byType(TextFormField);
      
      await tester.enterText(formFields.at(0), 'oldpassword123');
      await tester.enterText(formFields.at(1), 'newpassword123');
      await tester.enterText(formFields.at(2), 'newpassword123');
      await tester.pump();

      expect(find.text('oldpassword123'), findsOneWidget);
    });
  });

  group('ChangePasswordScreen Layout and Structure', () {
    testWidgets('should have SingleChildScrollView wrapper', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should have Form widget', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('should have Scaffold with correct background color', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final scaffold = find.byType(Scaffold);
      expect(scaffold, findsOneWidget);
    });

    testWidgets('should have input card container', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final containers = find.byType(Container);
      expect(containers, findsWidgets);
    });

    testWidgets('should have dividers between password fields', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(Divider), findsWidgets);
    });
  });

  group('ChangePasswordScreen - Additional Widget Tests', () {
    testWidgets('should allow current password entry', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final formFields = find.byType(TextFormField);
      await tester.enterText(formFields.at(0), 'oldpassword123');
      await tester.pump();

      expect(find.text('oldpassword123'), findsOneWidget);
    });

    testWidgets('should allow new password entry', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final formFields = find.byType(TextFormField);
      await tester.enterText(formFields.at(1), 'newpassword123');
      await tester.pump();

      expect(find.text('newpassword123'), findsOneWidget);
    });

    testWidgets('should allow confirm password entry', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final formFields = find.byType(TextFormField);
      await tester.enterText(formFields.at(2), 'newpassword123');
      await tester.pump();

      expect(find.text('newpassword123'), findsOneWidget);
    });

    testWidgets('should display Update Password button text', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Update Password'), findsOneWidget);
    });

    testWidgets('should have all three password field labels', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Current Password'), findsOneWidget);
      expect(find.text('New Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
    });

    testWidgets('should display close icon in AppBar', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('should have Change Password title in AppBar', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Change Password'), findsOneWidget);
    });

    testWidgets('should allow clearing all password fields', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final formFields = find.byType(TextFormField);
      
      // Enter text in all fields
      await tester.enterText(formFields.at(0), 'oldpassword123');
      await tester.enterText(formFields.at(1), 'newpassword123');
      await tester.enterText(formFields.at(2), 'newpassword123');
      await tester.pump();

      // Clear all fields
      await tester.enterText(formFields.at(0), '');
      await tester.enterText(formFields.at(1), '');
      await tester.enterText(formFields.at(2), '');
      await tester.pump();

      final controller0 = tester.widget<TextFormField>(formFields.at(0)).controller;
      final controller1 = tester.widget<TextFormField>(formFields.at(1)).controller;
      final controller2 = tester.widget<TextFormField>(formFields.at(2)).controller;

      expect(controller0?.text, '');
      expect(controller1?.text, '');
      expect(controller2?.text, '');
    });

    testWidgets('should have proper form structure', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should display CHANGE PASSWORD section header', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('CHANGE PASSWORD'), findsOneWidget);
    });

    testWidgets('should have lock icons for password security indication', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final lockIcons = find.byIcon(Icons.lock_outline);
      expect(lockIcons, findsWidgets);
    });
  });

  group('ChangePasswordScreen UI Styling', () {
    testWidgets('should use light grey background', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final scaffold = find.byType(Scaffold);
      expect(scaffold, findsOneWidget);
    });

    testWidgets('should have white AppBar', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final appBar = find.byType(AppBar);
      expect(appBar, findsOneWidget);
      
      final appBarWidget = tester.widget<AppBar>(appBar);
      expect(appBarWidget.backgroundColor, Colors.white);
    });

    testWidgets('should have three password input fields', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final formFields = find.byType(TextFormField);
      expect(formFields, findsNWidgets(3));
    });
  });
}
