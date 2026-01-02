import 'package:flutter/material.dart';
import 'package:mediconnect/features/dashboard/presentation/pages/view_hospitals_screen.dart';
import 'package:mediconnect/core/widgets/dashboard_card_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // View Hospitals Card
              DashboardCard(
                icon: 'assets/icons/view_hospital.png',
                title: 'View Hospitals',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ViewHospitalsScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Book Appointments Card
              DashboardCard(
                icon: 'assets/icons/book_appointment.png',
                title: 'Book Appointments',
                onTap: () {},
              ),
              const SizedBox(height: 16),
              // View Reports Card
              DashboardCard(
                icon: 'assets/icons/health_report.png',
                title: 'View Reports',
                onTap: () {},
              ),
              const SizedBox(height: 16),
              // ChatBot Card
              DashboardCard(
                icon: 'assets/icons/chatbot.png',
                title: 'ChatBot',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
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
      ),
    );
  }

  
}
