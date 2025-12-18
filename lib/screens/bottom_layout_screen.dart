import 'package:flutter/material.dart';
import 'package:mediconnect/screens/bottom_screens/appointment_screen.dart';
import 'package:mediconnect/screens/bottom_screens/home_screen.dart';
import 'package:mediconnect/screens/bottom_screens/profile_screen.dart';

int _selectedIndex = 0;
List<Widget> lstBottomScreen = [
  const HomeScreen(),
  const AppointmentScreen(),
  const ProfileScreen(),
];

class BottomLayoutScreen extends StatefulWidget {
  const BottomLayoutScreen({super.key});

  @override
  State<BottomLayoutScreen> createState() => _BottomLayoutScreenState();
}

class _BottomLayoutScreenState extends State<BottomLayoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/icons/logo.png',
              width: 35,
              height: 35,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            const Text(
              'MediConnect',
              style: TextStyle(
                color: Color(0xFF4FA3F5),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: lstBottomScreen[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
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
        onTap: (index) => {
          setState((){
            _selectedIndex = index;
          })
        },
      ),
    );
  }
}
