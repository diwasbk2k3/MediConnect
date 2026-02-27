import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediconnect/features/profile/presentation/pages/update_patient_profile_info.dart';
import 'package:mediconnect/features/profile/presentation/state/profile_state.dart';
import 'package:mediconnect/features/profile/presentation/view_model/profile_view_model.dart';

// Mock ProfileViewModel for testing
class MockProfileViewModelUpdate extends ProfileViewModel {
  @override
  ProfileState build() {
    return const ProfileState(
      status: ProfileStatus.loaded,
      patientId: 'patient123',
      name: 'John Doe',
      age: 28,
      gender: 'Male',
      address: '123 Main St',
      phoneNumber: '9876543210',
    );
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

  Future<void> mockUpdateProfile({
    required String name,
    required String address,
    required String phoneNumber,
    required int age,
  }) async {
    state = const ProfileState(status: ProfileStatus.updated);
  }
}

void main() {
  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        profileViewModelProvider.overrideWith(
          () => MockProfileViewModelUpdate(),
        ),
      ],
      child: const MaterialApp(
        home: UpdatePatientProfileInfo(name: 'John Doe', age: 28, gender: 'male', phone: '9876543210', address: '123 Main St', medicalHistory: '',),
      ),
    );
  }

  group('UpdatePatientProfileInfo - Widget Tests', () {
    
    testWidgets('Header and AppBar Elements', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, isNotNull);
      
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, Colors.white);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
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
      expect(find.text('Update Profile'), findsOneWidget);
      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('Name Field with Pre-filled Data', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final formFields = find.byType(TextFormField);
      final nameField = formFields.first;
      
      final nameWidget = tester.widget<TextFormField>(nameField);
      expect(nameWidget.initialValue, isNotNull);

      await tester.enterText(nameField, 'Jane Smith');
      await tester.pump();
      expect(find.text('Jane Smith'), findsOneWidget);

      await tester.enterText(nameField, 'John Updated');
      await tester.pump();
      expect(find.text('John Updated'), findsOneWidget);
      
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('Age Field Validation', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final formFields = find.byType(TextFormField);
      expect(formFields, findsWidgets);
      expect(find.text('Age'), findsOneWidget);
      
      if (formFields.evaluate().length > 1) {
        final ageField = formFields.at(1);
        final ageWidget = tester.widget<TextFormField>(ageField);
        expect(ageWidget.initialValue, isNotNull);

        await tester.enterText(ageField, '30');
        await tester.pump();
        expect(find.text('30'), findsOneWidget);

        await tester.enterText(ageField, '35');
        await tester.pump();
        expect(find.text('35'), findsOneWidget);
      }
      
      expect(find.byType(TextFormField), findsWidgets);
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('Phone and Address Fields', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('Residential Address'), findsOneWidget);

      final formFields = find.byType(TextFormField);
      expect(formFields, findsWidgets);

      if (formFields.evaluate().length > 2) {
        final phoneField = formFields.at(2);
        const newPhone = '8765432109';
        await tester.enterText(phoneField, newPhone);
        await tester.pump();
        expect(find.text(newPhone), findsOneWidget);

        if (formFields.evaluate().length > 3) {
          final addressField = formFields.at(3);
          const newAddress = '456 Oak Ave';
          await tester.enterText(addressField, newAddress);
          await tester.pump();
          expect(find.text(newAddress), findsOneWidget);
        }
      }

      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
      expect(find.text('Edit Profile'), findsOneWidget);
    });

    testWidgets('Update Profile Button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Update Profile'), findsOneWidget);

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);

      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(TextFormField), findsWidgets);
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('Form Field Pre-population with Existing Data', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final formFields = find.byType(TextFormField);
      expect(formFields, findsWidgets);

      final nameField = tester.widget<TextFormField>(formFields.first);
      expect(nameField.initialValue, isNotNull);

      if (formFields.evaluate().length > 1) {
        final ageField = tester.widget<TextFormField>(formFields.at(1));
        expect(ageField.initialValue, isNotNull);

        if (formFields.evaluate().length > 2) {
          final phoneField = tester.widget<TextFormField>(formFields.at(2));
          expect(phoneField.initialValue, isNotNull);
        }
      }

      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Text Input and Data Modification', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      const newName = 'Updated Name';
      const newAge = '40';
      const newPhone = '5555555555';

      final formFields = find.byType(TextFormField);
      expect(formFields, findsWidgets);

      await tester.enterText(formFields.first, newName);
      await tester.pump();
      expect(find.text(newName), findsOneWidget);

      if (formFields.evaluate().length > 1) {
        await tester.enterText(formFields.at(1), newAge);
        await tester.pump();
        expect(find.text(newAge), findsOneWidget);

        if (formFields.evaluate().length > 2) {
          await tester.enterText(formFields.at(2), newPhone);
          await tester.pump();
          expect(find.text(newPhone), findsOneWidget);
        }
      }

      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
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
      expect(find.byType(Text), findsWidgets);
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('Initial State and Display', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Age'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('Residential Address'), findsOneWidget);
      expect(find.text('Update Profile'), findsOneWidget);

      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.byType(TextFormField), findsWidgets);
    });
  });
}
