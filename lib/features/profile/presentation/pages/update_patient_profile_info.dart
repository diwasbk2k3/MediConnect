import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/core/utils/snackbar_utils.dart';
import 'package:mediconnect/features/dashboard/presentation/pages/bottom_layout_screen.dart';
import 'package:mediconnect/features/profile/presentation/state/profile_state.dart';
import 'package:mediconnect/features/profile/presentation/view_model/profile_view_model.dart';

class UpdatePatientProfileInfo extends ConsumerStatefulWidget {
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
  ConsumerState<UpdatePatientProfileInfo> createState() =>
      _UpdatePatientProfileInfoState();
}

class _UpdatePatientProfileInfoState
    extends ConsumerState<UpdatePatientProfileInfo> {
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

    // Prefill data
    _nameController.text = widget.name;
    _ageController.text = widget.age.toString();
    _phoneController.text = widget.phone;
    _addressController.text = widget.address;
    _medicalHistoryController.text = widget.medicalHistory;
    _selectedGender = widget.gender;
  }

  void _handlleUpdateProfile() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(profileViewModelProvider.notifier)
          .updatePatientProfileInfo(
            name: _nameController.text,
            address: _addressController.text,
            phoneNumber: _phoneController.text,
            gender: _selectedGender,
            age: int.parse(_ageController.text),
            medicalHistory: _medicalHistoryController.text,
          );
    }
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
    final profileState = ref.watch(profileViewModelProvider);
    ref.listen<ProfileState>(profileViewModelProvider, (previous, next) {
      if (next.status == ProfileStatus.error) {
        SnackbarUtils.showError(
          context,
          next.errorMessage ?? 'Profile update failed',
        );
      } else if (previous?.status != ProfileStatus.updated &&
          next.status == ProfileStatus.updated) {
        SnackbarUtils.showSuccess(context, 'Profile updated successfully');
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomLayoutScreen()),
          );
        });
      }
    });

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
              _buildSectionTitle("PERSONAL INFORMATION"),
              _buildInputCard([
                _buildTextField(
                  controller: _nameController,
                  label: "Full Name",
                  icon: Icons.person_outline_rounded,
                  validator: (v) => v!.isEmpty ? "Enter your name" : null,
                ),
                const Divider(height: 1, indent: 50),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _ageController,
                        label: "Age",
                        icon: Icons.cake_outlined,
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return "Age is required.";
                          }
                          final age = int.tryParse(v);
                          if (age == null || age <= 0) {
                            return "Enter a valid age.";
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.grey.shade200,
                    ),
                    Expanded(child: _buildGenderDropdown()),
                  ],
                ),
              ]),

              const SizedBox(height: 25),
              _buildSectionTitle("CONTACT DETAILS"),
              _buildInputCard([
                _buildTextField(
                  controller: _phoneController,
                  label: "Phone Number",
                  icon: Icons.phone_android_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return "Phone number is required.";
                    }
                    if (v.length < 10) {
                      return "Enter a valid phone number with 10 digits.";
                    }
                    return null;
                  },
                ),
                const Divider(height: 1, indent: 50),
                _buildTextField(
                  controller: _addressController,
                  label: "Residential Address",
                  icon: Icons.location_on_outlined,
                  maxLines: 2,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? "Address is required."
                      : null,
                ),
              ]),

              const SizedBox(height: 25),
              _buildSectionTitle("MEDICAL SUMMARY"),
              _buildInputCard([
                _buildTextField(
                  controller: _medicalHistoryController,
                  label: "Medical History",
                  icon: Icons.history_edu_outlined,
                  maxLines: 4,
                  hint: "Allergies, chronic conditions, etc.",
                ),
              ]),

              const SizedBox(height: 40),
              _buildUpdateButton(profileState),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedGender,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.grey.shade400,
          ),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          items: const [
            DropdownMenuItem(value: 'male', child: Text('Male')),
            DropdownMenuItem(value: 'female', child: Text('Female')),
            DropdownMenuItem(value: 'others', child: Text('Others')),
          ],
          onChanged: (newValue) => setState(() => _selectedGender = newValue!),
        ),
      ),
    );
  }

  Widget _buildUpdateButton(ProfileState profileState) {
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
        onPressed: profileState.status == ProfileStatus.loading
            ? null
            : _handlleUpdateProfile, // disables button when loading
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          profileState.status == ProfileStatus.loading
              ? 'Updating...'
              : 'Update Profile',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? hint,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade300, fontSize: 13),
        prefixIcon: Icon(icon, color: Colors.blue.shade400, size: 20),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildInputCard(List<Widget> children) {
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
}
