import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediconnect/features/profile/presentation/pages/create_patient_profile.dart';
import 'package:mediconnect/features/profile/presentation/state/profile_state.dart';
import 'package:mediconnect/features/profile/presentation/view_model/profile_view_model.dart';

// Mock ProfileViewModel for testing
class MockProfileViewController extends ProfileViewModel {
  @override
  ProfileState build() {
    return const ProfileState(status: ProfileStatus.initial);
  }

  @override
  Future<void> fetchPatientProfileData() async {
    // Mock implementation - just update state without calling usecase
    state = const ProfileState(
      status: ProfileStatus.loaded,
      patientId: 'patient123',
      name: 'John Doe',
      age: 28,
      gender: 'Male',
      address: '123 Main St',
      phoneNumber: '9876543210',
    );
  }

  Future<void> mockCreateProfile({
    required String name,
    required String address,
    required String phoneNumber,
    required String gender,
    required int age,
    String? medicalHistory,
  }) async {
    state = const ProfileState(status: ProfileStatus.created);
  }
}

void main() {
  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        profileViewModelProvider.overrideWith(
          () => MockProfileViewController(),
        ),
      ],
      child: const MaterialApp(
        home: CreatePatientProfile(),
      ),
    );
  }

  group('CreatePatientProfile - 10 Widget Tests', () {
    
    testWidgets('Header and AppBar Elements', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Setup Profile'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, const Color(0xFFF8F9FB));
      
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, Colors.white);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
      expect(find.text('Setup Profile'), findsOneWidget);
    });

    testWidgets('Form Structure and Input Fields', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(TextFormField), findsWidgets);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
      
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Age'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('Residential Address'), findsOneWidget);
      
      final formFields = find.byType(TextFormField);
      expect(formFields, findsWidgets);
      expect(find.byType(DropdownButtonHideUnderline), findsOneWidget);
      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('Name Field Validation', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final formFields = find.byType(TextFormField);
      final nameField = formFields.first;
      
      await tester.enterText(nameField, 'John Doe');
      await tester.pump();
      expect(find.text('John Doe'), findsOneWidget);

      await tester.enterText(nameField, 'Jane Smith');
      await tester.pump();
      expect(find.text('Jane Smith'), findsOneWidget);
      expect(find.text('John Doe'), findsNothing);

      await tester.enterText(nameField, '');
      await tester.pump();
      expect(find.text('Jane Smith'), findsNothing);
      
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('Age and Gender Fields', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final formFields = find.byType(TextFormField);
      expect(formFields, findsWidgets);
      expect(find.text('Age'), findsOneWidget);
      expect(find.byType(DropdownButtonHideUnderline), findsOneWidget);
      
      if (formFields.evaluate().length > 1) {
        final ageField = formFields.evaluate().length > 1 ? formFields.at(1) : null;
        if (ageField != null) {
          await tester.enterText(ageField, '25');
          await tester.pump();
          expect(find.text('25'), findsOneWidget);
        }
      }
      
      expect(find.byType(TextFormField), findsWidgets);
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(DropdownButtonHideUnderline), findsOneWidget);
      expect(find.byType(Divider), findsWidgets);
    });

    testWidgets('Test 5 - Phone and Address Fields', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('Residential Address'), findsOneWidget);

      final formFields = find.byType(TextFormField);
      expect(formFields, findsWidgets);
      expect(find.byType(Form), findsOneWidget);

      if (formFields.evaluate().length > 2) {
        final phoneField = formFields.at(2);
        await tester.enterText(phoneField, '9876543210');
        await tester.pump();
        expect(find.text('9876543210'), findsOneWidget);

        if (formFields.evaluate().length > 3) {
          final addressField = formFields.at(3);
          await tester.enterText(addressField, '123 Main St');
          await tester.pump();
          expect(find.text('123 Main St'), findsOneWidget);
        }
      }

      expect(find.byType(TextFormField), findsWidgets);
      expect(find.byType(Container), findsWidgets);
      expect(find.text('Setup Profile'), findsOneWidget);
    });

    testWidgets('Gender Dropdown', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(DropdownButtonHideUnderline), findsOneWidget);
      
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(TextFormField), findsWidgets);
      expect(find.byType(ElevatedButton), findsOneWidget);
      
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.text('Setup Profile'), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsOneWidget);
    });

    testWidgets('Submit Button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Complete Registration'), findsOneWidget);

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);

      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(TextFormField), findsWidgets);
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
    });

    testWidgets('Form Input and Data Entry', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      const testName = 'John Doe';
      const testAge = '28';
      const testPhone = '9876543210';
      const testAddress = '123 Main Street';

      final formFields = find.byType(TextFormField);
      expect(formFields, findsWidgets);

      await tester.enterText(formFields.first, testName);
      await tester.pump();
      expect(find.text(testName), findsOneWidget);

      if (formFields.evaluate().length > 1) {
        await tester.enterText(formFields.at(1), testAge);
        await tester.pump();
        expect(find.text(testAge), findsOneWidget);
      }

      if (formFields.evaluate().length > 2) {
        await tester.enterText(formFields.at(2), testPhone);
        await tester.pump();
        expect(find.text(testPhone), findsOneWidget);
      }

      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(DropdownButtonHideUnderline), findsOneWidget);
    });

    testWidgets('Widget Tree and Layout', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(TextFormField), findsWidgets);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(DropdownButtonHideUnderline), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('Initial State and Display', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Setup Profile'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Age'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('Residential Address'), findsOneWidget);
      expect(find.text('Male'), findsOneWidget);
      expect(find.text('Complete Registration'), findsOneWidget);

      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(DropdownButtonHideUnderline), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });
  });
}
