import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFB347), Color(0xFFFF8C42)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Terms & Conditions',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Last updated: January 15, 2025',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Terms Sections
          _buildSection(
            '1. Acceptance of Terms',
            'By using AutoHub, you agree to these terms and conditions. If you do not agree, please do not use our service.',
          ),

          _buildSection(
            '2. User Accounts',
            'You must provide accurate information when creating an account. You are responsible for keeping your password secure.',
          ),

          _buildSection(
            '3. Buying and Selling',
            'Users can buy and sell vehicles through our platform. All transactions are between buyers and sellers directly.',
          ),

          _buildSection(
            '4. Listing Guidelines',
            'Listings must be accurate and truthful. Users must own or have permission to sell the vehicle they list.',
          ),

          _buildSection(
            '5. Prohibited Activities',
            'Users may not:\n'
                '• Post false information\n'
                '• Engage in fraudulent activities\n'
                '• Harass other users\n'
                '• Violate any laws',
          ),

          _buildSection(
            '6. Privacy',
            'We protect your personal information. See our Privacy Policy for details on how we collect and use your data.',
          ),

          _buildSection(
            '7. Disclaimer',
            'AutoHub is provided "as is". We do not guarantee the accuracy of listings or the quality of vehicles.',
          ),

          _buildSection(
            '8. Limitation of Liability',
            'AutoHub is not responsible for disputes between buyers and sellers, or for any damages arising from use of our service.',
          ),

          _buildSection(
            '9. Changes to Terms',
            'We may update these terms at any time. Continued use of AutoHub means you accept the updated terms.',
          ),

          _buildSection(
            '10. Contact Us',
            'If you have questions about these terms, contact us at:\n'
                'support@autohub.com',
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFFFB347),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
