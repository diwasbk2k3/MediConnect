import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mediconnect/core/utils/snackbar_utils.dart';
import 'package:mediconnect/features/auth/data/datasources/local/auth_datasource.dart';
import 'package:mediconnect/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:mediconnect/features/auth/presentation/pages/login_screen.dart';
import 'package:mediconnect/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileScreenUI extends ConsumerStatefulWidget {
  const ProfileScreenUI({super.key});

  @override
  ConsumerState<ProfileScreenUI> createState() => _ProfileScreenUIState();
}

class _ProfileScreenUIState extends ConsumerState<ProfileScreenUI> {
  final List<XFile> _selectedMedia = [];
  final ImagePicker _imagePicker = ImagePicker();

  Future<bool> _takPermissionFromUser(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog();
      return false;
    }

    return false;
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (contex) => AlertDialog(
        title: Text("Permission Required"),
        content: Text(
          "This feature requires camera/gallery access. Please enable it in settings.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  // Code for Camera
  Future<void> _pickFromCamera() async {
    final hasPermission = await _takPermissionFromUser(Permission.camera);
    if (!hasPermission) {
      return;
    }

    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _selectedMedia.clear();
        _selectedMedia.add(image);
      });
      // upload image to server
      await ref.read(profileViewModelProvider.notifier).updatePatientProfileImage(File(image.path));
    }
  }

  // Code for Gallery
  Future<void> _pickFromGallery({bool allowMultiple = false}) async {
    try {
      if (allowMultiple) {
        final List<XFile> images = await _imagePicker.pickMultiImage(
          imageQuality: 80,
        );
        if (images.isNotEmpty) {
          setState(() {
            _selectedMedia.clear();
            _selectedMedia.addAll(images);
          });
        }
      } else {
        final XFile? image = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );
        if (image != null) {
            setState(() {
              _selectedMedia.clear();
              _selectedMedia.add(image);
            });
            // upload image to server
            await ref.read(profileViewModelProvider.notifier).updatePatientProfileImage(File(image.path));
        }
      }
    } catch (err) {
      debugPrint("Gallery Error $err");
      if (mounted) {
        SnackbarUtils.showError(context, "Failed to access gallery.");
      }
    }
  }

  // Code for DialogBox: showDialog for menu
  Future<void> _pickMedia() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text("Open Camera"),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromCamera();
                },
              ),
              ListTile(
                leading: Icon(Icons.browse_gallery),
                title: Text("Open Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildProfileHeader(),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("ACCOUNT SETTINGS"),
                  _buildMenuTile(
                    icon: Icons.person_rounded,
                    title: "About Me",
                    subtitle: "Personal information and bio",
                    color: Colors.blue,
                    onTap: () {},
                  ),
                  _buildMenuTile(
                    icon: Icons.lock_rounded,
                    title: "Change Password",
                    subtitle: "Update your security credentials",
                    color: Colors.orange,
                    onTap: () {},
                  ),
                  const SizedBox(height: 15),
                  _buildSectionTitle("ACTIONS"),
                  _buildMenuTile(
                    icon: Icons.logout_rounded,
                    title: "Logout",
                    subtitle: "Sign out of your account safely",
                    color: Colors.red,
                    isDestructive: true,
                    onTap: () => _handleLogout(context, ref),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Colors.grey[200],
                backgroundImage: _selectedMedia.isNotEmpty
                    ? FileImage(File(_selectedMedia.first.path))
                          as ImageProvider
                    : const AssetImage("assets/images/profile.png"),
              ),
            ),
            GestureDetector(
              onTap: _pickMedia,
              child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        const Text(
          "DIWAS BISHWOKARMA",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
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
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDestructive ? Colors.red : Colors.black87,
          ),
        ),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Colors.grey,
        ),
      ),
    );
  }

  // Logout directly inside UI
  void _handleLogout(BuildContext context, WidgetRef ref) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Logout"),
        content: const Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Read both datasources
      final authRemoteDatasource = ref.read(authRemoteDatasoureProvider);
      final authLocalDatasource = ref.read(authLocalDatasourceProvider);

      try {
        // Call remote logout
        await authRemoteDatasource.logout();

        // Call local logout
        await authLocalDatasource.logout();

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      } catch (e) {
        // Optional: show error message if either fails
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Logout failed: $e")));
      }
    }
  }
}
