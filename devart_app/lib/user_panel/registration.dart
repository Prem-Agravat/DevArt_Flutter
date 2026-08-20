import 'package:flutter/material.dart';
import 'package:devart/user_panel/login.dart';

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

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please agree to the Terms & Conditions")),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "lib/assets/images/devart-logo.png",
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(color: Colors.white.withOpacity(0.55)),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: MediaQuery.of(context).size.height * 0.21,
            child: Container(
              padding: const EdgeInsets.fromLTRB(30, 35, 30, 25),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.80),
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
                Navigator.pop(context);
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
              child: Image.asset(
                "lib/assets/images/devart-logo.png",
                width: 130,
                height: 130,
              ),
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
            obscureText: _obscurePassword,
            decoration: inputDecoration(
              hint: "Password",
              icon: Icons.lock_outline,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
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
            obscureText: _obscureConfirmPassword,
            decoration: inputDecoration(
              hint: "Confirm Password",
              icon: Icons.lock_outline,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
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
                onChanged: (value) {
                  setState(() {
                    _agreeToTerms = value ?? false;
                  });
                },
              ),
              Expanded(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                    children: [
                      TextSpan(text: "I agree to all the "),
                      TextSpan(
                        text: "Terms & Conditions",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: 220,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA06D42),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: _register,
              child: const Text(
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
                  Navigator.pop(context);
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
