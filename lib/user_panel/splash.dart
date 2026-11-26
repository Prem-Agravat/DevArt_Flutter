import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:devart/admin/dashboard/admin_dashboard.dart';
import 'package:devart/resource/resource.dart';
import 'package:devart/services/auth_service.dart';
import 'package:devart/user_panel/dashboard.dart';
import 'package:devart/user_panel/login.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppResources.logo,
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 20),
                Text(
                  "Welcome to Devart",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppResources.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final auth = context.read<AuthService>();
                    final Widget nextScreen = auth.isLoggedIn
                        ? (auth.isAdmin
                            ? const AdminDashboard()
                            : const HomeScreen())
                        : const LoginScreen();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => nextScreen),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppResources.textPrimaryColor,
                  ),
                  child: Text(
                    "Get Started",
                    style: TextStyle(fontSize: 18, color: AppResources.textPrimaryColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
