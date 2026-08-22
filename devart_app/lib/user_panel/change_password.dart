import 'package:flutter/material.dart';
import 'package:devart/user_panel/login.dart';
import 'package:devart/common/app_shell.dart';

class ChangePasswordScreen extends StatefulWidget {
  final bool fromProfile;

  const ChangePasswordScreen({super.key, this.fromProfile = false});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _currentPasswordController = TextEditingController();

  final _passwordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updatePassword() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _showSuccessDialog();
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
                  color: Colors.black.withOpacity(0.18),
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
                Text(
                  widget.fromProfile ? "Password Updated!" : "Password Updated",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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

                      if (widget.fromProfile) {
                        Navigator.pop(context, true);
                      } else {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA06D42),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      widget.fromProfile
                          ? "Return to Profile"
                          : "Return to Login",
                      style: const TextStyle(fontSize: 18),
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
    required Widget suffixIcon,
    String? hint,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF8B7B72)),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD8C2B5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFA06D42), width: 2),
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
    required bool obscure,
    required IconData icon,
    required VoidCallback onToggle,
    required String emptyMessage,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: _inputDecoration(
        icon: icon,
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(
            obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: const Color(0xFF8B7B72),
          ),
        ),
        hint: "••••••••",
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
    if (widget.fromProfile) {
      return _buildProfileVersion();
    }

    return _buildAuthenticationVersion();
  }

  Widget _buildProfileVersion() {
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
                        obscure: _obscureCurrentPassword,
                        icon: Icons.key_outlined,
                        emptyMessage: "Please enter your current password",
                        onToggle: () {
                          setState(() {
                            _obscureCurrentPassword = !_obscureCurrentPassword;
                          });
                        },
                      ),
                      const SizedBox(height: 19),
                      _profileLabel("New Password"),
                      _passwordField(
                        controller: _passwordController,
                        obscure: _obscurePassword,
                        icon: Icons.lock_outline,
                        emptyMessage: "Please enter your new password",
                        onToggle: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      const SizedBox(height: 19),
                      _profileLabel("Confirm New Password"),
                      _passwordField(
                        controller: _confirmPasswordController,
                        obscure: _obscureConfirmPassword,
                        icon: Icons.check_circle_outline,
                        emptyMessage: "Please confirm your password",
                        onToggle: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
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
                            backgroundColor: const Color(0xFF874D27),
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
      color: const Color(0xFFF5E9E5),
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

  Widget _buildAuthenticationVersion() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "lib/assets/images/devart_bgimage_auth.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.white.withOpacity(0.20)),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: MediaQuery.of(context).size.height * 0.34,
            child: Container(
              padding: const EdgeInsets.fromLTRB(30, 25, 30, 25),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.82),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text(
                          "Change Password",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFA06D42),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Please enter your new password\nbelow.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "New Password",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _passwordField(
                          controller: _passwordController,
                          obscure: _obscurePassword,
                          icon: Icons.lock_outline,
                          emptyMessage: "Please enter a new password",
                          onToggle: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        const SizedBox(height: 22),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Confirm Password",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _passwordField(
                          controller: _confirmPasswordController,
                          obscure: _obscureConfirmPassword,
                          icon: Icons.lock_outline,
                          emptyMessage: "Please confirm your password",
                          onToggle: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
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
                        const SizedBox(height: 25),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _updatePassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFA06D42),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              "Update Password  ↻",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 45,
            left: 15,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white70,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 25,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                "lib/assets/images/devart-logo.png",
                width: 180,
                height: 180,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
