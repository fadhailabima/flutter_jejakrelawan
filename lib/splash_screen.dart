import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding_screen.dart'; // file yang berisi kode onboarding sebelumnya

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    /// Delay selama 3 detik, lalu pindah ke halaman onboarding
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/onboarding_gif.gif',
          width: 250,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
