import 'dart:async';
import 'package:autohub/screens/auth/login.dart';
import 'package:autohub/screens/onboarding/onboarding1.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    // Get shared preferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if this is the first launch
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    // Wait for 2 seconds (splash screen duration)
    await Future.delayed(Duration(seconds: 2));

    if (!mounted) return;

    if (isFirstLaunch) {
      // Mark that the app has been launched
      await prefs.setBool('isFirstLaunch', false);

      // Navigate to onboarding
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Onboarding1()),
      );
    } else {
      // Navigate directly to login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF2C2C2C),
        child: Center(
          child: Text(
            'AUTOHUB',
            style: TextStyle(
              fontSize: 50,
              color: Color(0xFFFFB347),
              fontWeight: FontWeight.bold,
              fontFamily: "Hegarty",
            ),
          ),
        ),
      ),
    );
  }
}
