import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:devart/resource/resource.dart';
import 'package:devart/services/auth_service.dart';
import 'package:devart/common/app_shell.dart';

class ChangePasswordScreen extends StatefulWidget {
  final bool fromProfile;

  const ChangePasswordScreen({
    super.key,
    this.fromProfile = true,
  });

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _currentPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final success = await context.read<AuthService>().changePassword(
            _currentPasswordController.text,
            _passwordController.text,
          );

      if (!mounted) return;

      if (success) {
        _showSuccessDialog();
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      final message = switch (e.code) {
        'wrong-password' || 'invalid-credential' => 'Current password is incorrect.',
        'weak-password' => 'New password is too weak.',
        'requires-recent-login' => 'Please sign out and sign in again before changing password.',
        _ => e.message ?? 'Could not update password.',
      };
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 30),
          child: Container(
            padding: const EdgeInsets.fromLTRB(25, 30, 25, 25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFD5E7FF),
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    size: 42,
                    color: Color(0xFF4D7298),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Password Updated!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Your password has been updated\nsuccessfully.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      Navigator.pop(context, true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppResources.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Return to Profile",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration({
    required IconData icon,
    String? hint,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF8B7B72)),
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD8C2B5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppResources.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required IconData icon,
    required String emptyMessage,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: false,
      decoration: _inputDecoration(
        icon: icon,
        hint: "Enter password",
      ),
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return emptyMessage;
            }

            if (value.length < 6) {
              return "Password must be at least 6 characters";
            }

            return null;
          },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      selectedIndex: 3,
      selectedDrawerItem: "Change Password",
      showCart: true,
      showBottomNav: true,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildProfileTitle(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(25, 18, 25, 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFD8B9A7),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFBBD9FF),
                              ),
                              child: const Icon(
                                Icons.lock,
                                size: 38,
                                color: Color(0xFF496B8F),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Keep your account secure by using a\nstrong password and enabling two-\nfactor authentication.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                color: Color(0xFF544943),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 27),
                      _profileLabel("Current Password"),
                      _passwordField(
                        controller: _currentPasswordController,
                        icon: Icons.key_outlined,
                        emptyMessage: "Please enter your current password",
                      ),
                      const SizedBox(height: 19),
                      _profileLabel("New Password"),
                      _passwordField(
                        controller: _passwordController,
                        icon: Icons.lock_outline,
                        emptyMessage: "Please enter your new password",
                      ),
                      const SizedBox(height: 19),
                      _profileLabel("Confirm New Password"),
                      _passwordField(
                        controller: _confirmPasswordController,
                        icon: Icons.check_circle_outline,
                        emptyMessage: "Please confirm your password",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please confirm your password";
                          }

                          if (value != _passwordController.text) {
                            return "Passwords do not match";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 34),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _updatePassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppResources.primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Change Password  ↻",
                            style: TextStyle(fontWeight: FontWeight.bold),
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

  Widget _buildProfileTitle() {
    return Container(
      height: 64,
      color: const Color(0xFFE2E2E2),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 23,
              color: Color(0xFF4B4B4B),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                "ChangePassword",
                style: TextStyle(
                  fontSize: 31,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB56F6F),
                  fontFamily: "serif",
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _profileLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 5, bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5F554F),
          ),
        ),
      ),
    );
  }
}
