import 'package:autohub/screens/chat/chatpage.dart';
import 'package:autohub/screens/home/searchpage.dart';
import 'package:autohub/screens/home/startpage.dart';
import 'package:autohub/screens/profile/profilepage.dart';
import 'package:autohub/screens/sell/sellpage.dart';
import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    StartPage(),
    SearchPage(),
    SellPage(),
    ChatPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xFF1A1A1A),
          currentIndex: _currentIndex,
          selectedItemColor: const Color(0xFFFFB347),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: false,
          elevation: 0,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_car_filled),
              label: 'Sell',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Chat'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
