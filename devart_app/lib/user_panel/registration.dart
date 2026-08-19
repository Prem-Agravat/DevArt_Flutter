import 'package:flutter/material.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  InputDecoration inputDecoration({
    required String hint,
    required IconData icon,
    IconData? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(width: 2),
      ),
    );
  }

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

          // Registration card
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: MediaQuery.of(context).size.height * 0.22,
            child: Container(
              padding: const EdgeInsets.fromLTRB(30, 35, 30, 25),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    TextField(
                      decoration: inputDecoration(
                        hint: "Full Name",
                        icon: Icons.person_outline,
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      decoration: inputDecoration(
                        hint: "Email",
                        icon: Icons.email_outlined,
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      decoration: inputDecoration(
                        hint: "Phone Number",
                        icon: Icons.phone_outlined,
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      obscureText: true,
                      decoration: inputDecoration(
                        hint: "Password",
                        icon: Icons.lock_outline,
                        suffixIcon: Icons.visibility,
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      obscureText: true,
                      decoration: inputDecoration(
                        hint: "Confirm Password",
                        icon: Icons.lock_outline,
                        suffixIcon: Icons.visibility,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Checkbox(value: false, onChanged: (value) {}),
                        Expanded(
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () {},
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
                        GestureDetector(
                          onTap: () {
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
              ),
            ),
          ),

          // Back button
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
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 28,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),

          // Logo
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
}
