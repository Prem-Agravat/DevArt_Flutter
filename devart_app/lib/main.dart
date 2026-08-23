import 'package:devart/user_panel/splash.dart';
import 'package:flutter/material.dart';
//import 'package:devart/user_panel/splash.dart';

void main() {
  runApp(const DevArtApp());
}

class DevArtApp extends StatelessWidget {
  const DevArtApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DevArt',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(),
    );
  }
}
