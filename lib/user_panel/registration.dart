import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:devart/admin/dashboard/admin_dashboard.dart';
import 'package:devart/resource/resource.dart';
import 'package:devart/user_panel/dashboard.dart';
import 'package:devart/user_panel/login.dart';
import 'package:devart/services/auth_service.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _agreeToTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate() || _isLoading) {
      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please agree to the Terms & Conditions."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = context.read<AuthService>();
      await authService.registerUser(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        password: _passwordController.text,
      );

      if (!mounted) return;

      final bool isAdmin = await authService.isCurrentUserAdmin();
      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) =>
              isAdmin ? const AdminDashboard() : const HomeScreen(),
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      final message = switch (e.code) {
        'email-already-in-use' => 'An account already exists for this email.',
        'weak-password' => 'Password is too weak (at least 6 characters).',
        'invalid-email' => 'Please enter a valid email address.',
        _ => e.message ?? 'Registration failed.',
      };
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  InputDecoration inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(width: 2, color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(width: 2, color: Colors.black),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(width: 2, color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(width: 2, color: Colors.red),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppResources.authBackgroundImage,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.white.withValues(alpha: 0.20)),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: MediaQuery.of(context).size.height * 0.21,
            child: Container(
              padding: const EdgeInsets.fromLTRB(30, 35, 30, 25),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.80),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(child: _buildRegistrationForm()),
            ),
          ),
          Positioned(
            top: 45,
            left: 15,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              icon: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white70,
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 25,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(AppResources.logo, width: 130, height: 130),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text(
            "Create Account",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 25),
          TextFormField(
            controller: _nameController,
            keyboardType: TextInputType.name,
            decoration: inputDecoration(
              hint: "Full Name",
              icon: Icons.person_outline,
            ),
            validator: (text) {
              if (text == null || text.trim().isEmpty) {
                return "Please enter your full name";
              }

              if (text.trim().length < 3) {
                return "Name must be at least 3 characters";
              }

              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: inputDecoration(
              hint: "Email",
              icon: Icons.email_outlined,
            ),
            validator: (text) {
              if (text == null || text.trim().isEmpty) {
                return "Email address cannot be empty";
              }

              final regex = RegExp(r'^[^@]+@[^.]+\..+$');

              if (!regex.hasMatch(text.trim())) {
                return "Please enter a valid email address";
              }

              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: inputDecoration(
              hint: "Phone Number",
              icon: Icons.phone_outlined,
            ),
            validator: (text) {
              if (text == null || text.trim().isEmpty) {
                return "Phone number cannot be empty";
              }

              final phoneRegex = RegExp(r'^[0-9]{10}$');

              if (!phoneRegex.hasMatch(text.trim())) {
                return "Please enter a valid 10-digit phone number";
              }

              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _passwordController,
            obscureText: false,
            decoration: inputDecoration(
              hint: "Password",
              icon: Icons.lock_outline,
            ),
            validator: (text) {
              if (text == null || text.isEmpty) {
                return "Please enter your password";
              }

              if (text.length < 6) {
                return "Password must be at least 6 characters";
              }

              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: false,
            decoration: inputDecoration(
              hint: "Confirm Password",
              icon: Icons.lock_outline,
            ),
            validator: (text) {
              if (text == null || text.isEmpty) {
                return "Please confirm your password";
              }

              if (text != _passwordController.text) {
                return "Passwords do not match";
              }

              return null;
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Checkbox(
                value: _agreeToTerms,
                activeColor: AppResources.primaryColor,
                onChanged: (value) {
                  setState(() {
                    _agreeToTerms = value ?? false;
                  });
                },
              ),
              const Text(
                "I agree to all the Terms & Conditions",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 220,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppResources.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: _isLoading ? null : _register,
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
            ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Already have an account?",
                style: TextStyle(fontSize: 18),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text(
                  " Sign In",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
