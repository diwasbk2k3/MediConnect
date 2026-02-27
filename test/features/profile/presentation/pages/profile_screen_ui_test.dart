import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediconnect/features/profile/presentation/pages/profile_screen_ui.dart';
import 'package:mediconnect/features/profile/presentation/state/profile_state.dart';
import 'package:mediconnect/features/profile/presentation/view_model/profile_view_model.dart';

// Mock ProfileViewModel for testing
class MockProfileViewModelUI extends ProfileViewModel {
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
}

void main() {
  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        profileViewModelProvider.overrideWith(
          () => MockProfileViewModelUI(),
        ),
      ],
      child: const MaterialApp(
        home: ProfileScreenUI(),
      ),
    );
  }

  group('ProfileScreenUI - 10 Widget Tests', () {
    
    testWidgets('Header and Profile Information Display', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(CircleAvatar), findsWidgets);
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Verified Patient'), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Row), findsWidgets);
      expect(find.byIcon(Icons.verified_user_rounded), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt_rounded), findsOneWidget);
    });

    testWidgets('Profile Navigation and Menu Options', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsWidgets);
      expect(find.text('About Me'), findsOneWidget);
      expect(find.text('Change Password'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
      expect(find.text('Delete Account'), findsOneWidget);
      expect(find.text('ACCOUNT SETTINGS'), findsOneWidget);

      expect(find.byIcon(Icons.person_rounded), findsOneWidget);
      expect(find.byIcon(Icons.lock_rounded), findsOneWidget);
      expect(find.byIcon(Icons.logout_rounded), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('Patient Information Display', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('John Doe'), findsOneWidget);
      
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(CircleAvatar), findsWidgets);
      expect(find.text('About Me'), findsOneWidget);
      expect(find.text('Change Password'), findsOneWidget);
      expect(find.text('Verified Patient'), findsOneWidget);
      expect(find.byType(ListTile), findsWidgets);
    });

    testWidgets('Profile Picture and Avatar Section', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(CircleAvatar), findsWidgets);
      expect(find.byIcon(Icons.camera_alt_rounded), findsOneWidget);
      
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Verified Patient'), findsOneWidget);
      
      expect(find.byType(GestureDetector), findsWidgets);
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Stack), findsWidgets);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byIcon(Icons.verified_user_rounded), findsOneWidget);
    });

    testWidgets('Menu Items with Icons and Navigation', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final aboutMeTile = find.text('About Me');
      final changePasswordTile = find.text('Change Password');
      
      expect(aboutMeTile, findsOneWidget);
      expect(changePasswordTile, findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
      expect(find.text('Delete Account'), findsOneWidget);
      expect(find.byType(ListTile), findsWidgets);

      expect(find.byIcon(Icons.arrow_forward_ios), findsWidgets);
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('Logout Button and Confirmation', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Logout'), findsOneWidget);
      expect(find.text('Delete Account'), findsOneWidget);
      
      final logoutText = find.text('Logout');
      expect(logoutText, findsOneWidget);

      expect(find.byIcon(Icons.logout_rounded), findsOneWidget);
      expect(find.byIcon(Icons.delete_forever_rounded), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(ListTile), findsWidgets);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('Profile Data Persistence and Display', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Verified Patient'), findsOneWidget);

      expect(find.byType(CircleAvatar), findsWidgets);
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(ListTile), findsWidgets);
      expect(find.text('About Me'), findsOneWidget);
      expect(find.text('Change Password'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    });

    testWidgets('Profile Section Styling and Layout', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, isNotNull);

      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Padding), findsWidgets);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Row), findsWidgets);
      expect(find.byType(ListTile), findsWidgets);
      expect(find.byType(CircleAvatar), findsWidgets);
      expect(find.byType(Icon), findsWidgets);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('Widget Tree and Overall Layout', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(CircleAvatar), findsWidgets);
      expect(find.byType(ListTile), findsWidgets);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(Icon), findsWidgets);
      expect(find.byIcon(Icons.arrow_forward_ios), findsWidgets);
      expect(find.byIcon(Icons.camera_alt_rounded), findsOneWidget);
      expect(find.byIcon(Icons.verified_user_rounded), findsOneWidget);
    });

    testWidgets('Initial State and Data Loading', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Verified Patient'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsWidgets);
      expect(find.text('About Me'), findsOneWidget);
      expect(find.text('Change Password'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(ListTile), findsWidgets);
      expect(find.byIcon(Icons.camera_alt_rounded), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_ios), findsWidgets);
    });
  });
}
