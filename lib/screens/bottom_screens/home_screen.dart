import 'package:flutter/material.dart';
import 'package:mediconnect/screens/view_hospitals_screen.dart';
import 'package:mediconnect/core/widgets/dashboard_card_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
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
    );
  }
}
