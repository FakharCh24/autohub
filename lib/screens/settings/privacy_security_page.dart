import 'package:flutter/material.dart';

class PrivacySecurityPage extends StatefulWidget {
  const PrivacySecurityPage({super.key});

  @override
  State<PrivacySecurityPage> createState() => _PrivacySecurityPageState();
}

class _PrivacySecurityPageState extends State<PrivacySecurityPage> {
  bool twoFactorAuth = false;
  bool biometricAuth = true;
  bool showEmail = false;
  bool showPhone = false;
  bool showLocation = true;
  bool dataCollection = true;
  bool personalizedAds = false;
  bool activityTracking = true;
  bool shareDataWithPartners = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2C2C),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          'Privacy & Security',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Security Section
            _buildSectionHeader('Security', Icons.security),
            _buildSecurityOption(
              'Two-Factor Authentication',
              'Add an extra layer of security',
              twoFactorAuth,
              (value) {
                setState(() {
                  twoFactorAuth = value;
                });
                if (value) {
                  _showTwoFactorDialog();
                }
              },
            ),
            _buildSecurityOption(
              'Biometric Authentication',
              'Use fingerprint or face ID',
              biometricAuth,
              (value) {
                setState(() {
                  biometricAuth = value;
                });
              },
            ),
            _buildActionItem(
              'Change Password',
              'Update your password regularly',
              Icons.lock_outline,
              () => _showChangePasswordDialog(),
            ),
            _buildActionItem(
              'Active Sessions',
              'View and manage logged-in devices',
              Icons.devices,
              () => _showActiveSessionsDialog(),
            ),

            const SizedBox(height: 24),

            // Privacy Section
            _buildSectionHeader('Privacy', Icons.privacy_tip),
            _buildSecurityOption(
              'Show Email on Profile',
              'Allow others to see your email',
              showEmail,
              (value) {
                setState(() {
                  showEmail = value;
                });
              },
            ),
            _buildSecurityOption(
              'Show Phone Number',
              'Display phone on public profile',
              showPhone,
              (value) {
                setState(() {
                  showPhone = value;
                });
              },
            ),
            _buildSecurityOption(
              'Share Location',
              'Share your location for better results',
              showLocation,
              (value) {
                setState(() {
                  showLocation = value;
                });
              },
            ),
            _buildActionItem(
              'Blocked Users',
              'Manage blocked users list',
              Icons.block,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No blocked users'),
                    backgroundColor: Color(0xFFFFB347),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Data & Personalization
            _buildSectionHeader('Data & Personalization', Icons.analytics),
            _buildSecurityOption(
              'Data Collection',
              'Allow app to collect usage data',
              dataCollection,
              (value) {
                setState(() {
                  dataCollection = value;
                });
              },
            ),
            _buildSecurityOption(
              'Personalized Ads',
              'Show ads based on your interests',
              personalizedAds,
              (value) {
                setState(() {
                  personalizedAds = value;
                });
              },
            ),
            _buildSecurityOption(
              'Activity Tracking',
              'Track app usage and preferences',
              activityTracking,
              (value) {
                setState(() {
                  activityTracking = value;
                });
              },
            ),
            _buildSecurityOption(
              'Share Data with Partners',
              'Share data with trusted partners',
              shareDataWithPartners,
              (value) {
                setState(() {
                  shareDataWithPartners = value;
                });
              },
            ),

            const SizedBox(height: 24),

            // Account Management
            _buildSectionHeader('Account Management', Icons.manage_accounts),
            _buildActionItem(
              'Download My Data',
              'Get a copy of your data',
              Icons.download,
              () => _showDownloadDataDialog(),
            ),
            _buildActionItem(
              'Delete Account',
              'Permanently delete your account',
              Icons.delete_forever,
              () => _showDeleteAccountDialog(),
              isDestructive: true,
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFFB347), size: 24),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFFFB347),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityOption(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFFFFB347),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildActionItem(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDestructive
              ? Colors.red.withOpacity(0.3)
              : Colors.white.withOpacity(0.2),
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? Colors.red : Colors.white.withOpacity(0.8),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? Colors.red : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isDestructive
                ? Colors.red.withOpacity(0.7)
                : Colors.white.withOpacity(0.6),
            fontSize: 13,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: isDestructive
              ? Colors.red.withOpacity(0.7)
              : Colors.white.withOpacity(0.5),
        ),
        onTap: onTap,
      ),
    );
  }

  void _showTwoFactorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: const Text(
            'Enable Two-Factor Authentication',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Two-factor authentication adds an extra layer of security. You\'ll need to enter a code from your phone in addition to your password.',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  twoFactorAuth = false;
                });
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB347),
                foregroundColor: const Color(0xFF1A1A1A),
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Two-factor authentication enabled'),
                    backgroundColor: Color(0xFFFFB347),
                  ),
                );
              },
              child: const Text('Enable'),
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: const Text(
            'Change Password',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFFB347)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'New Password',
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFFB347)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFFB347)),
                  ),
                ),
              ),
            ],
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
                backgroundColor: const Color(0xFFFFB347),
                foregroundColor: const Color(0xFF1A1A1A),
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password changed successfully'),
                    backgroundColor: Color(0xFFFFB347),
                  ),
                );
              },
              child: const Text('Change'),
            ),
          ],
        );
      },
    );
  }

  void _showActiveSessionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: const Text(
            'Active Sessions',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSessionItem('Current Device', 'Windows • Chrome', true),
              const SizedBox(height: 8),
              _buildSessionItem('iPhone 13', 'iOS • Safari', false),
              const SizedBox(height: 8),
              _buildSessionItem('MacBook Pro', 'macOS • Chrome', false),
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

  Widget _buildSessionItem(String device, String info, bool isCurrent) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCurrent
              ? const Color(0xFFFFB347)
              : Colors.white.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.devices,
            color: isCurrent ? const Color(0xFFFFB347) : Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  info,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (isCurrent)
            const Text(
              'Current',
              style: TextStyle(
                color: Color(0xFFFFB347),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  void _showDownloadDataDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: const Text(
            'Download Your Data',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'We\'ll prepare a copy of your data and send it to your email within 48 hours.',
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
                backgroundColor: const Color(0xFFFFB347),
                foregroundColor: const Color(0xFF1A1A1A),
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Data download request submitted'),
                    backgroundColor: Color(0xFFFFB347),
                  ),
                );
              },
              child: const Text('Request'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: const Text(
            'Delete Account',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'This action cannot be undone. All your data will be permanently deleted.',
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
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account deletion is being processed'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
