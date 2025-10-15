import 'package:autohub/screens/auth/login.dart';
import 'package:autohub/screens/onboarding/onboarding2.dart';
import 'package:flutter/material.dart';

class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/Cover.png", fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.transparent, Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Container(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    RichText(
                      // textAlign: TextAlign.start,
                      text: TextSpan(
                        text: 'Find Your ',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontFamily: "Hegarty",
                          shadows: [
                            Shadow(
                              blurRadius: 20.0,
                              color: Colors.white.withOpacity(0.5),
                              offset: const Offset(0, 0),
                            ),
                            Shadow(
                              blurRadius: 40.0,
                              color: Colors.white.withOpacity(0.3),
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        children: [
                          TextSpan(
                            text: 'Dream Car',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w300,
                              color: const Color(0xFFFFB347),
                              fontFamily: "Hegarty",
                              shadows: [
                                Shadow(
                                  blurRadius: 20.0,
                                  color: Colors.black.withOpacity(0.6),
                                  offset: const Offset(0, 0),
                                ),
                                Shadow(
                                  blurRadius: 40.0,
                                  color: const Color(
                                    0xFFFFB347,
                                  ).withOpacity(0.4),
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Text(
                        'Discover thousands of new and used cars from trusted sellers. Your next ride is just a tap away.',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.9),
                          fontFamily: 'roboto_regular',
                          shadows: [
                            Shadow(
                              blurRadius: 15.0,
                              color: Colors.white.withOpacity(0.3),
                              offset: const Offset(0, 0),
                            ),
                            Shadow(
                              blurRadius: 30.0,
                              color: Colors.white.withOpacity(0.2),
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFB347),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Onboarding2(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Next',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Skip',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white.withOpacity(0.7),
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white.withOpacity(
                                    0.7,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
