import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/features/profile/presentation/view_model/profile_view_model.dart';

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;
  final bool isLongText;

  _InfoItem(this.icon, this.label, this.value, {this.isLongText = false});
}

class AboutPatientInfoScreen extends ConsumerStatefulWidget {
  const AboutPatientInfoScreen({super.key});

  @override
  ConsumerState<AboutPatientInfoScreen> createState() =>
      _AboutPatientInfoScreenState();
}

class _AboutPatientInfoScreenState extends ConsumerState<AboutPatientInfoScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch patient profile data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileViewModelProvider.notifier).fetchPatientProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text(
          "Personal Information",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(
              title: "Basic Details",
              items: [
                _InfoItem(
                  Icons.person_outline,
                  "Full Name",
                  profileState.name ?? "N/A",
                ),
                _InfoItem(
                  Icons.cake_outlined,
                  "Age",
                  "${profileState.age ?? 'N/A'} years",
                ),
                _InfoItem(
                  Icons.wc_outlined,
                  "Gender",
                  profileState.gender ?? "N/A",
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildInfoCard(
              title: "Contact Information",
              items: [
                _InfoItem(
                  Icons.phone_android_outlined,
                  "Phone",
                  profileState.phoneNumber ?? "N/A",
                ),
                _InfoItem(
                  Icons.location_on_outlined,
                  "Address",
                  profileState.address ?? "N/A",
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildInfoCard(
              title: "Medical Record",
              items: [
                _InfoItem(
                  Icons.history_edu_outlined,
                  "Medical History",
                  profileState.medicalHistory ?? "No history recorded",
                  isLongText: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<_InfoItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.1,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: items.map((item) {
              final isLast = items.indexOf(item) == items.length - 1;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: item.isLongText
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.center,
                      children: [
                        Icon(item.icon, color: Colors.blueAccent, size: 22),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.label,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.value,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    const Divider(height: 1, indent: 50, endIndent: 16),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
