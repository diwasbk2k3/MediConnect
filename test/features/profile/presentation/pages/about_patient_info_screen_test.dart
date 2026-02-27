import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediconnect/features/profile/presentation/pages/about_patient_info_screen.dart';
import 'package:mediconnect/features/profile/presentation/state/profile_state.dart';
import 'package:mediconnect/features/profile/presentation/view_model/profile_view_model.dart';

// Mock ProfileViewModel for testing
class MockProfileViewModelAbout extends ProfileViewModel {
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
      medicalHistory: 'Diabetes, Hypertension',
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
      medicalHistory: 'Diabetes, Hypertension',
    );
  }
}

void main() {
  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        profileViewModelProvider.overrideWith(
          () => MockProfileViewModelAbout(),
        ),
      ],
      child: const MaterialApp(
        home: AboutPatientInfoScreen(),
      ),
    );
  }

  group('AboutPatientInfoScreen - Widget Tests', () {
    
    testWidgets('Test 1 - Header and Title Display', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Personal Information'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, isNotNull);
      
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, Colors.white);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
      expect(find.text('BASIC DETAILS'), findsOneWidget);
    });

    testWidgets('Patient Information Display', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('28 years'), findsOneWidget);
      expect(find.text('Male'), findsOneWidget);
      expect(find.text('9876543210'), findsOneWidget);
      expect(find.text('123 Main St'), findsOneWidget);
      
      expect(find.text('Full Name'), findsWidgets);
      expect(find.text('Age'), findsWidgets);
      expect(find.text('Gender'), findsWidgets);
      expect(find.text('Phone'), findsWidgets);
      expect(find.text('Address'), findsWidgets);
    });

    testWidgets('Patient Name Section', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Full Name'), findsWidgets);
      
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
      expect(find.byIcon(Icons.person_outline), findsWidgets);
    });

    testWidgets('Age and Gender Section', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('28 years'), findsOneWidget);
      expect(find.text('Male'), findsOneWidget);
      expect(find.text('Age'), findsWidgets);
      expect(find.text('Gender'), findsWidgets);
      
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(Row), findsWidgets);
      expect(find.byIcon(Icons.cake_outlined), findsWidgets);
      expect(find.byIcon(Icons.wc_outlined), findsWidgets);
    });

    testWidgets('Contact Information Section', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('9876543210'), findsOneWidget);
      expect(find.text('Phone'), findsWidgets);
      expect(find.text('123 Main St'), findsOneWidget);
      expect(find.text('Address'), findsWidgets);
      
      expect(find.byType(Container), findsWidgets);
      expect(find.byIcon(Icons.phone_android_outlined), findsWidgets);
      expect(find.byIcon(Icons.location_on_outlined), findsWidgets);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Medical History Section', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Diabetes, Hypertension'), findsOneWidget);
      expect(find.text('Medical History'), findsOneWidget);
      
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Text), findsWidgets);
      expect(find.byIcon(Icons.history_edu_outlined), findsWidgets);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Information Cards Layout', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(Padding), findsWidgets);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Row), findsWidgets);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('Icon Display and Representation', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.person_outline), findsWidgets);
      expect(find.byIcon(Icons.cake_outlined), findsWidgets);
      expect(find.byIcon(Icons.wc_outlined), findsWidgets);
      expect(find.byIcon(Icons.phone_android_outlined), findsWidgets);
      expect(find.byIcon(Icons.location_on_outlined), findsWidgets);
      expect(find.byIcon(Icons.history_edu_outlined), findsWidgets);
      expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
      
      expect(find.byType(Icon), findsWidgets);
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Widget Tree and Overall Layout', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(Row), findsWidgets);
      expect(find.byType(Icon), findsWidgets);
      expect(find.byType(Padding), findsWidgets);
      expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
    });

    testWidgets('Initial State and Data Loading', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Personal Information'), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('28 years'), findsOneWidget);
      expect(find.text('Male'), findsOneWidget);
      expect(find.text('9876543210'), findsOneWidget);
      expect(find.text('123 Main St'), findsOneWidget);
      expect(find.text('Diabetes, Hypertension'), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });
  });
}
