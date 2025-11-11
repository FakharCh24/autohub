import 'package:autohub/screens/auth/Login.dart';
import 'package:autohub/screens/home/browse/recently_viewed.dart';
import 'package:autohub/screens/notifications/notifications_center.dart';
import 'package:autohub/screens/sell/my_listings_page.dart';
import 'package:autohub/screens/settings/about_autohub_page.dart';
import 'package:autohub/screens/settings/help_center_page.dart';
import 'package:autohub/screens/settings/language_selection_page.dart';
import 'package:autohub/screens/settings/privacy_security_page.dart';
import 'package:autohub/screens/settings/send_feedback_page.dart';
import 'package:autohub/screens/settings/terms_conditions_page.dart';
import 'package:flutter/material.dart';
import 'edit_profile_page.dart';
import 'saved_cars_page.dart';
import 'purchase_history_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isDarkMode = true;
  bool notificationsEnabled = true;
  bool locationEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsCenter(),
                ),
              );
            },
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              _showSettingsDialog();
            },
            icon: const Icon(Icons.settings, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color(0xFF2C2C2C),
                        backgroundImage: const AssetImage(
                          'assets/images/Profile.jpg',
                        ),
                        onBackgroundImageError: (exception, stackTrace) {},
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFB347),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Color(0xFF1A1A1A),
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Fakhir Ashraf',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'fch9629652@gmail.com',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB347).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFFB347)),
                    ),
                    child: const Text(
                      'Verified Seller',
                      style: TextStyle(
                        color: Color(0xFFFFB347),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Stats Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Cars Listed',
                      '12',
                      Icons.car_rental,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard('Cars Sold', '8', Icons.check_circle),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard('Reviews', '4.8', Icons.star)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Menu Options
            _buildMenuSection('Account', [
              _buildMenuItem(Icons.person_outline, 'Edit Profile', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfilePage(),
                  ),
                );
              }),
              _buildMenuItem(Icons.car_rental, 'My Listings', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyListingsPage(),
                  ),
                );
              }),
              _buildMenuItem(Icons.favorite_outline, 'Saved Cars', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SavedCarsPage(),
                  ),
                );
              }),
              _buildMenuItem(Icons.history, 'Purchase History', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PurchaseHistoryPage(),
                  ),
                );
              }),
              _buildMenuItem(Icons.visibility_outlined, 'Recently Viewed', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RecentlyViewed(),
                  ),
                );
              }),
            ]),

            _buildMenuSection('Settings', [
              _buildMenuItem(
                Icons.notifications_none_outlined,
                'Notifications',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsCenter(),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                Icons.location_on_outlined,
                'Location Services',
                () {},
                trailing: Switch(
                  value: locationEnabled,
                  onChanged: (value) {
                    setState(() {
                      locationEnabled = value;
                    });
                  },
                  activeColor: const Color(0xFFFFB347),
                ),
              ),
              _buildMenuItem(Icons.security, 'Privacy & Security', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacySecurityPage(),
                  ),
                );
              }),
              _buildMenuItem(Icons.language, 'Language', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LanguageSelectionPage(),
                  ),
                );
              }),
            ]),

            _buildMenuSection('Support', [
              _buildMenuItem(Icons.help_outline, 'Help Center', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HelpCenterPage(),
                  ),
                );
              }),
              _buildMenuItem(Icons.feedback_outlined, 'Send Feedback', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SendFeedbackPage(),
                  ),
                );
              }),
              _buildMenuItem(Icons.info_outline, 'About AutoHub', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutAutoHubPage(),
                  ),
                );
              }),
              _buildMenuItem(
                Icons.description_outlined,
                'Terms & Conditions',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TermsConditionsPage(),
                    ),
                  );
                },
              ),
            ]),

            const SizedBox(height: 24),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    _showLogoutDialog();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFFFB347), size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFFFFB347),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2C),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Column(children: items),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white.withOpacity(0.8)),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      trailing:
          trailing ??
          Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.5)),
      onTap: onTap,
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: const Text(
            'Quick Settings',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.dark_mode, color: Colors.white),
                title: const Text(
                  'Dark Mode',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      isDarkMode = value;
                    });
                    Navigator.pop(context);
                  },
                  activeColor: const Color(0xFFFFB347),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.notifications, color: Colors.white),
                title: const Text(
                  'Notifications',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Switch(
                  value: notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      notificationsEnabled = value;
                    });
                    Navigator.pop(context);
                  },
                  activeColor: const Color(0xFFFFB347),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Close',
                style: TextStyle(color: Color(0xFFFFB347)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: const Text(
            'Logout',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
