import 'package:autohub/screens/onboarding/splash.dart';
import 'package:autohub/screens/home/homeScreen.dart';
import 'package:autohub/helper/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: AuthWrapper());
  }
}

// Widget to handle authentication state
class AuthWrapper extends StatelessWidget {
  final AuthService _authService = AuthService();

  AuthWrapper({super.key});

  Future<bool> _checkLoginStatus() async {
    var sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getBool("Login") ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        // If checking authentication state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFFFB347)),
            ),
          );
        }

        // Check if user is logged in with Firebase
        if (snapshot.hasData && snapshot.data != null) {
          return FutureBuilder<bool>(
            future: _checkLoginStatus(),
            builder: (context, prefs) {
              if (prefs.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  backgroundColor: Colors.black,
                  body: Center(
                    child: CircularProgressIndicator(color: Color(0xFFFFB347)),
                  ),
                );
              }
              // If logged in, go to home screen
              if (prefs.data == true) {
                return const HomeScreen();
              }
              // Otherwise show splash/onboarding
              return Splash();
            },
          );
        }

        // User not logged in, show splash/onboarding
        return Splash();
      },
    );
  }
}
