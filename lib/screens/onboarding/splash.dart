import 'dart:async';
import 'package:autohub/screens/auth/login.dart';
import 'package:autohub/screens/home/navbar.dart';
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
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // First check if it's the first launch
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      // Mark that the app has been launched
      await prefs.setBool('isFirstLaunch', false);

      // Navigate to onboarding
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Onboarding1()),
      );
      return;
    }

    // If not first launch, check login status
    bool isLoggedIn = prefs.getBool("Login") ?? false;

    if (isLoggedIn) {
      // User is logged in, go to home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Navbar()),
      );
    } else {
      // User not logged in, go to login
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
