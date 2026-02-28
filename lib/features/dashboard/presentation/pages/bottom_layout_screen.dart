import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/features/dashboard/presentation/pages/bottom_screens/appointment_screen.dart';
import 'package:mediconnect/features/dashboard/presentation/pages/bottom_screens/home_screen.dart';
import 'package:mediconnect/features/dashboard/presentation/pages/bottom_screens/profile_screen.dart';
import 'package:mediconnect/features/auth/data/datasources/local/auth_datasource.dart';
import 'package:mediconnect/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:mediconnect/features/auth/presentation/pages/login_screen.dart';
import 'package:mediconnect/features/sensors/presentation/widgets/hidden_sensor_listener.dart';

class BottomLayoutScreen extends ConsumerStatefulWidget {
  const BottomLayoutScreen({super.key});

  @override
  ConsumerState<BottomLayoutScreen> createState() => _BottomLayoutScreenState();
}

class _BottomLayoutScreenState extends ConsumerState<BottomLayoutScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _lstBottomScreen;

  @override
  void initState() {
    super.initState();
    _lstBottomScreen = [
      const HomeScreen(),
      const AppointmentScreen(),
      const ProfileScreen(),
    ];
  }

  Future<void> _handleLogout() async {
    // Read both datasources from riverpod
    final authRemoteDatasource = ref.read(authRemoteDatasoureProvider);
    final authLocalDatasource = ref.read(authLocalDatasourceProvider);

    try {
      // Call remote logout
      await authRemoteDatasource.logout();

      // Call local logout
      await authLocalDatasource.logout();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Logout failed: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return HiddenSensorListener(
      onShakeLogout: _handleLogout,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              Image.asset(
                'assets/icons/logo.png',
                width: 42,
                height: 42,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              const Text(
                'MediConnect',
                style: TextStyle(
                  color: Color(0xFF4FA3F5),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          centerTitle: false,
        ),
        body: _lstBottomScreen[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Appointment',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
