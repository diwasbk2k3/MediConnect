import 'package:flutter/material.dart';

class UpdatePatientProfileInfo extends StatefulWidget {
  final String name;
  final int age;
  final String gender;
  final String phone;
  final String address;
  final String medicalHistory;

  const UpdatePatientProfileInfo({
    super.key,
    required this.name,
    required this.age,
    required this.gender,
    required this.phone,
    required this.address,
    required this.medicalHistory,
  });

  @override
  State<UpdatePatientProfileInfo> createState() =>
      _UpdatePatientProfileInfoState();
}

class _UpdatePatientProfileInfoState extends State<UpdatePatientProfileInfo> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _medicalHistoryController = TextEditingController();

  String _selectedGender = 'male';

  @override
  void initState() {
    super.initState();

    // ✅ PREFILL DATA ONLY
    _nameController.text = widget.name;
    _ageController.text = widget.age.toString();
    _phoneController.text = widget.phone;
    _addressController.text = widget.address;
    _medicalHistoryController.text = widget.medicalHistory;
    _selectedGender = widget.gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _medicalHistoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("PERSONAL INFORMATION"),
              _card([
                _textField(
                  controller: _nameController,
                  label: "Full Name",
                  icon: Icons.person_outline,
                ),
                const Divider(height: 1, indent: 50),
                Row(
                  children: [
                    Expanded(
                      child: _textField(
                        controller: _ageController,
                        label: "Age",
                        icon: Icons.cake_outlined,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.grey.shade200,
                    ),
                    Expanded(child: _genderDropdown()),
                  ],
                ),
              ]),

              const SizedBox(height: 24),
              _sectionTitle("CONTACT DETAILS"),
              _card([
                _textField(
                  controller: _phoneController,
                  label: "Phone Number",
                  icon: Icons.phone_android_outlined,
                  keyboardType: TextInputType.phone,
                ),
                const Divider(height: 1, indent: 50),
                _textField(
                  controller: _addressController,
                  label: "Address",
                  icon: Icons.location_on_outlined,
                  maxLines: 2,
                ),
              ]),

              const SizedBox(height: 24),
              _sectionTitle("MEDICAL SUMMARY"),
              _card([
                _textField(
                  controller: _medicalHistoryController,
                  label: "Medical History",
                  icon: Icons.history_edu_outlined,
                  maxLines: 4,
                  hint: "Allergies, conditions, etc.",
                ),
              ]),
              const SizedBox(height: 24),
              _buildUpdateButton(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
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
      child: Column(children: children),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? hint,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
    );
  }

  Widget _genderDropdown() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedGender,
          isExpanded: true,
          items: const [
            DropdownMenuItem(value: 'male', child: Text('Male')),
            DropdownMenuItem(value: 'female', child: Text('Female')),
            DropdownMenuItem(value: 'others', child: Text('Others')),
          ],
          onChanged: (value) => setState(() => _selectedGender = value!),
        ),
      ),
    );
  }

  Widget _buildUpdateButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade800],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade800.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Handle update profile action here
            print("Updating profile...");
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // gradient shows through
          shadowColor: Colors.transparent, // no default shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'Update Profile',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
