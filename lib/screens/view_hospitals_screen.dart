import 'package:flutter/material.dart';

class ViewHospitalsScreen extends StatefulWidget {
  const ViewHospitalsScreen({super.key});

  @override
  State<ViewHospitalsScreen> createState() => _ViewHospitalsScreenState();
}

class Hospital {
  final String name;
  final String location;
  final String description;
  final String imagePath;

  Hospital({
    required this.name,
    required this.location,
    required this.description,
    required this.imagePath,
  });
}

class _ViewHospitalsScreenState extends State<ViewHospitalsScreen> {
  final List<Hospital> hospitals = [
    Hospital(
      name: 'Ship Int. Hospital',
      location: 'Dhibazo, Kathmandu',
      description:
          'Ship International Hospital is a well-established healthcare center located in the heart of Dhibazo, Kathmandu...',
      imagePath: 'assets/images/ship_international_hospital.png',
    ),
    Hospital(
      name: 'Maternity Hospital',
      location: 'Baneshwor, Kathmandu',
      description:
          'Ship International Hospital is a well-established healthcare center located in the heart of Dhibazo, Kathmandu...',
      imagePath: 'assets/images/maternity_hospital.png',
    ),
    Hospital(
      name: 'City Care Hospital',
      location: 'Kumariapti, Lalitpur',
      description:
          'Ship International Hospital is a well-established healthcare center located in the heart of Dhibazo, Kathmandu...',
      imagePath: 'assets/icons/city_care_hospittal.png',
    ),
    Hospital(
      name: 'Himalaya Hospital',
      location: 'Janagihat, Lalitpur',
      description:
          'Ship International Hospital is a well-established healthcare center located in the heart of Dhibazo, Kathmandu...',
      imagePath: 'assets/images/himalaya_hospital.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // "Available Hospitals" text
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Available Hospitals',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Hospital List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: hospitals.length,
              itemBuilder: (context, index) {
                return _buildHospitalCard(hospitals[index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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

  Widget _buildHospitalCard(Hospital hospital) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Hospital Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.asset(
              hospital.imagePath,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          // Hospital Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hospital Name
                  Text(
                    hospital.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Location
                  Text(
                    hospital.location,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Description
                  Text(
                    hospital.description,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          // View More Button
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SizedBox(
              width: 70,
              height: 32,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4FA3F5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: EdgeInsets.zero,
                  elevation: 0,
                ),
                onPressed: () {},
                child: const Text(
                  'View More',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
