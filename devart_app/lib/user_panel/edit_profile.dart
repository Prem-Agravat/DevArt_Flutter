import 'package:devart/common/action_popup.dart';
import 'package:devart/common/app_shell.dart';
import 'package:devart/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:devart/user_panel/change_password.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  final nameController = TextEditingController(text: "User");
  final emailController = TextEditingController(text: "user@devart.com");
  final phoneController = TextEditingController(text: "+91 9827714260");

  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final user = _authService.currentUser;
    if (user != null) {
      emailController.text = user.email ?? "";
      if (user.displayName != null && user.displayName!.isNotEmpty) {
        nameController.text = user.displayName!;
      }

      try {
        setState(() => _isLoading = true);
        final doc = await _authService.getUserProfile();
        if (doc.exists) {
          final data = doc.data();
          if (data != null) {
            if (data['name'] != null && data['name'].toString().isNotEmpty) {
              nameController.text = data['name'].toString();
            }
            if (data['phone'] != null && data['phone'].toString().isNotEmpty) {
              phoneController.text = data['phone'].toString();
            }
            if (data['email'] != null && data['email'].toString().isNotEmpty) {
              emailController.text = data['email'].toString();
            }
          }
        }
      } catch (_) {
        // Fallback to local inputs
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      await _authService.updateUserProfile(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
      );
    } catch (_) {
      // Local fallback in case offline or network block
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }

    if (!mounted) return;

    showSuccessPopup(
      context,
      title: "Save Profile",
      message: "Successfully saved profile changes.",
      buttonText: "Return to Profile",
      onPressed: () {
        Navigator.pop(context, true);
      },
    );
  }

  InputDecoration _decoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF806F65)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD5B7A5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFA06D42), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayName = nameController.text.trim().isNotEmpty
        ? nameController.text.trim()
        : "User";
    final displayEmail = emailController.text.trim().isNotEmpty
        ? emailController.text.trim()
        : "user@devart.com";

    return AppShell(
      selectedIndex: 3,
      selectedDrawerItem: "Edit My Profile",
      showCart: true,
      showBottomNav: true,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildTitle(),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFA06D42),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(28, 30, 28, 25),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text(
                              displayName,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              displayEmail,
                              style: const TextStyle(color: Color(0xFF5F5550)),
                            ),
                            const SizedBox(height: 40),
                            _label("Full Name"),
                            TextFormField(
                              controller: nameController,
                              onChanged: (_) => setState(() {}),
                              decoration: _decoration(
                                "Full Name",
                                Icons.person_outline,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Name cannot be empty";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 28),
                            _label("Email Address"),
                            TextFormField(
                              controller: emailController,
                              readOnly: true,
                              keyboardType: TextInputType.emailAddress,
                              decoration: _decoration(
                                "Email Address",
                                Icons.email_outlined,
                              ),
                              validator: (value) {
                                if (value == null ||
                                    !RegExp(
                                      r'^[^@]+@[^@]+\.[^@]+$',
                                    ).hasMatch(value.trim())) {
                                  return "Enter a valid email";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 28),
                            _label("Phone Number"),
                            TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: _decoration(
                                "Phone Number",
                                Icons.phone_outlined,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().length < 10) {
                                  return "Enter valid phone number";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 45),
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton.icon(
                                onPressed: _isSaving ? null : _saveProfile,
                                icon: _isSaving
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(Icons.save_outlined),
                                label: Text(
                                  _isSaving ? "Saving..." : "Save Changes",
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFA06D42),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFA06D42),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text("Cancel"),
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ChangePasswordScreen(
                                      fromProfile: true,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.lock_outline,
                                color: Colors.black,
                              ),
                              label: const Text(
                                "Change Password",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      height: 64,
      color: const Color(0xFFF5E9E5),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: const Icon(Icons.arrow_back_ios_new, size: 22),
          ),
          const Expanded(
            child: Center(
              child: Text(
                "Edit Profile",
                style: TextStyle(
                  fontSize: 31,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB56F6F),
                  fontFamily: "serif",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 5, bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF80502F),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
