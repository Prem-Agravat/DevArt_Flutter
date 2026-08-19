import 'package:flutter/material.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              "lib/assets/images/devart-logo.png",
              fit: BoxFit.cover,
            ),
          ),

          // White overlay
          Positioned.fill(
            child: Container(color: Colors.white.withOpacity(0.55)),
          ),

          // Login card
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: MediaQuery.of(context).size.height * 0.36,
            child: Container(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    "Create Account",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 50),

                  // Email
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon: const Icon(Icons.person_outline),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Password
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: const Icon(Icons.visibility),
                      contentPadding: const EdgeInsets.symmetric(vertical: 18),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Checkbox(value: false, onChanged: (value) {}),
                      const Text("Remember me", style: TextStyle(fontSize: 18)),
                      const Spacer(),
                      const Text(
                        "Forgot Password?",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  const Text("Admin Panel", style: TextStyle(fontSize: 18)),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: 220,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA06D42),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Sign In",
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      children: [
                        TextSpan(text: "Don't have an account? "),
                        TextSpan(
                          text: "Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Logo
          Positioned(
            top: 90,
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
