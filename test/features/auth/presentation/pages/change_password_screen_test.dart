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

  group('ChangePasswordScreen - Widget Tests', () {
    
    testWidgets('Header and AppBar Elements', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Change Password'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, isNotNull);
      
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, isNotNull);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.text('CHANGE PASSWORD'), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('Form Structure and Password Fields', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
      
      expect(find.text('Current Password'), findsOneWidget);
      expect(find.text('New Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      
      final formFields = find.byType(TextFormField);
      final currentPasswordField = tester.widget<TextFormField>(formFields.at(0));
      final newPasswordField = tester.widget<TextFormField>(formFields.at(1));
      final confirmPasswordField = tester.widget<TextFormField>(formFields.at(2));
      
      expect(currentPasswordField.validator, isNotNull);
      expect(newPasswordField.validator, isNotNull);
      expect(confirmPasswordField.validator, isNotNull);
    });

    testWidgets('Current Password Field Validation', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final formFields = find.byType(TextFormField);
      final currentPasswordField = formFields.at(0);
      
      await tester.enterText(currentPasswordField, 'oldpassword123');
      await tester.pump();
      expect(find.text('oldpassword123'), findsOneWidget);

      await tester.enterText(currentPasswordField, 'different123');
      await tester.pump();
      expect(find.text('different123'), findsOneWidget);
      expect(find.text('oldpassword123'), findsNothing);

      await tester.enterText(currentPasswordField, '');
      await tester.pump();
      expect(find.text('different123'), findsNothing);
      
      expect(find.text('Current Password'), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsWidgets);
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(Divider), findsWidgets);
    });

    testWidgets('New Password Field Validation', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final formFields = find.byType(TextFormField);
      final newPasswordField = formFields.at(1);
      
      expect(find.text('New Password'), findsOneWidget);
      
      await tester.enterText(newPasswordField, 'newpass123');
      await tester.pump();
      expect(find.text('newpass123'), findsOneWidget);

      await tester.enterText(newPasswordField, 'anotherpass456');
      await tester.pump();
      expect(find.text('anotherpass456'), findsOneWidget);
      expect(find.text('newpass123'), findsNothing);

      await tester.enterText(newPasswordField, '');
      await tester.pump();
      
      expect(find.byIcon(Icons.lock_outline), findsWidgets);
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(Divider), findsWidgets);
    });

    testWidgets('Confirm Password Field Validation', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final formFields = find.byType(TextFormField);
      final confirmPasswordField = formFields.at(2);
      
      expect(find.text('Confirm Password'), findsOneWidget);
      
      await tester.enterText(confirmPasswordField, 'newpass123');
      await tester.pump();
      expect(find.text('Confirm Password'), findsOneWidget);

      await tester.enterText(confirmPasswordField, 'different789');
      await tester.pump();

      await tester.enterText(confirmPasswordField, '');
      await tester.pump();
      
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.byIcon(Icons.lock_outline), findsWidgets);
      expect(find.byType(Divider), findsWidgets);
      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('Password Field Labels and Text', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Current Password'), findsOneWidget);
      expect(find.text('New Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('Update Password'), findsOneWidget);

      final formFields = find.byType(TextFormField);
      await tester.enterText(formFields.at(0), 'oldpass123');
      await tester.pump();
      expect(find.text('oldpass123'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsWidgets);
    });

    testWidgets('Update Password Button', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Update Password'), findsOneWidget);

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);

      final formFields = find.byType(TextFormField);
      await tester.enterText(formFields.at(0), 'oldpassword123');
      await tester.enterText(formFields.at(1), 'newpassword123');
      await tester.enterText(formFields.at(2), 'newpassword123');
      await tester.pump();

      expect(find.text('oldpassword123'), findsOneWidget);
      expect(find.text('newpassword123'), findsWidgets);
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(3));
    });

    testWidgets('Text Input and Data Entry', (tester) async {
      await tester.pumpWidget(createTestWidget());

      const currentPass = 'MyCurrentPassword123';
      const newPass = 'MyNewPassword456';
      const confirmPass = 'MyNewPassword456';

      final formFields = find.byType(TextFormField);

      await tester.enterText(formFields.at(0), currentPass);
      await tester.pump();
      expect(find.text(currentPass), findsOneWidget);

      await tester.enterText(formFields.at(1), newPass);
      await tester.pump();

      await tester.enterText(formFields.at(2), confirmPass);
      await tester.pump();

      expect(find.text(newPass), findsWidgets);
      
      await tester.enterText(formFields.at(0), '');
      await tester.pump();
      expect(find.text(currentPass), findsNothing);

      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Widget Tree and Layout', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(Divider), findsWidgets);
      expect(find.byType(Text), findsWidgets);
      expect(find.byIcon(Icons.lock_outline), findsWidgets);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('Initial State and Structure', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Change Password'), findsOneWidget);
      expect(find.text('CHANGE PASSWORD'), findsOneWidget);
      expect(find.text('Current Password'), findsOneWidget);
      expect(find.text('New Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('Update Password'), findsOneWidget);

      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });
  });
}
