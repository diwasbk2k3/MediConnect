import 'package:flutter/material.dart';
import 'package:mediconnect/features/dashboard/presentation/pages/view_hospitals_screen.dart';
import 'package:mediconnect/core/widgets/dashboard_card_widget.dart';
import 'package:mediconnect/features/report/presentation/pages/reports_list_screen.dart';
import 'package:mediconnect/features/assistant/presentation/pages/medical_assistant_screen.dart';

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
    
            // View Reports Card
            DashboardCard(
              icon: 'assets/icons/health_report.png',
              title: 'View Reports',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReportsListScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
    
            // Medical Assistant Card
            DashboardCard(
              icon: 'assets/icons/chatbot.png',
              title: 'Medical Assistant',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MedicalAssistantScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ),
    );
  }
}
