import 'package:autohub/screens/home/navbar.dart';
import 'package:autohub/helper/firestore_helper.dart';
import 'package:autohub/helper/storage_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({super.key});

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isLoading = false;
  bool _isUploadingImage = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      _showErrorDialog('Failed to pick image: $e');
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2C2C2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose Profile Picture',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFFFFB347)),
              title: const Text(
                'Camera',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: Color(0xFFFFB347),
              ),
              title: const Text(
                'Gallery',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            if (_selectedImage != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Remove Photo',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedImage = null;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      final userEmail = FirebaseAuth.instance.currentUser?.email;

      if (userId == null) {
        _showErrorDialog('User not found. Please login again.');
        return;
      }

      String? photoUrl;

      // Upload profile picture if selected
      if (_selectedImage != null) {
        setState(() {
          _isUploadingImage = true;
        });

        photoUrl = await StorageHelper.instance.uploadProfilePicture(
          _selectedImage!,
        );

        if (photoUrl == null) {
          if (mounted) {
            _showErrorDialog(
              'Failed to upload profile picture. Please try again.',
            );
          }
          return;
        }
      }

      // Save profile to Firestore
      final success = await FirestoreHelper.instance.updateUserProfile(
        userId: userId,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        photoUrl: photoUrl,
      );

      if (!mounted) return;

      if (success) {
        // Save login state and mark first launch as complete
        var sharedPrefs = await SharedPreferences.getInstance();
        await sharedPrefs.setBool("Login", true);
        await sharedPrefs.setBool("isFirstLaunch", false);
        await sharedPrefs.setString("userEmail", userEmail ?? '');

        // Navigate to home screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Navbar()),
          (route) => false,
        );
      } else {
        _showErrorDialog('Failed to save profile. Please try again.');
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('An error occurred: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isUploadingImage = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Error', style: TextStyle(color: Colors.white)),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Color(0xFFFFB347))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/Cover.png", fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black,
                    Colors.black,
                    Colors.black.withOpacity(0.8),
                  ],
                  stops: const [0.0, 0.7, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Container(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back arrow
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Profile Setup text
                        RichText(
                          text: const TextSpan(
                            text: 'Profile ',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                              fontFamily: "Hegarty",
                            ),
                            children: [
                              TextSpan(
                                text: 'Setup',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xFFFFB347),
                                  fontFamily: "Hegarty",
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                        // Profile Image Section
                        Center(
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 70,
                                    backgroundColor: Colors.grey[800],
                                    backgroundImage: _selectedImage != null
                                        ? FileImage(_selectedImage!)
                                              as ImageProvider
                                        : null,
                                    child: _selectedImage == null
                                        ? const Icon(
                                            Icons.person,
                                            size: 50,
                                            color: Colors.white54,
                                          )
                                        : null,
                                  ),
                                  if (_isUploadingImage)
                                    Positioned.fill(
                                      child: CircleAvatar(
                                        radius: 70,
                                        backgroundColor: Colors.black54,
                                        child: const CircularProgressIndicator(
                                          color: Color(0xFFFFB347),
                                        ),
                                      ),
                                    ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFFB347),
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        onPressed: _showImageSourceDialog,
                                        icon: const Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              TextButton(
                                onPressed: _showImageSourceDialog,
                                child: Text(
                                  _selectedImage != null
                                      ? 'Change Photo'
                                      : 'Upload Photo',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFFFFB347),
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Color(0xFFFFB347),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),
                        // Name field
                        const Text(
                          'Full Name',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _nameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Enter your full name',
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 14,
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                color: Color(0xFFFFB347),
                                width: 1,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 24),
                        // Phone Number field
                        const Text(
                          'Phone Number',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: '+92 300 1234567',
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 14,
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                color: Color(0xFFFFB347),
                                width: 1,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 24),
                        // Address field
                        const Text(
                          'Address',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _addressController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Enter your address',
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 14,
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                color: Color(0xFFFFB347),
                                width: 1,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 35),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFB347),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 0,
                            ),
                            onPressed: _isLoading ? null : _saveProfile,
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Save Profile',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
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
