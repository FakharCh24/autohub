import 'package:flutter/material.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

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
          'Help Center',
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
          // Contact Support Card
          _buildContactCard(
            'Need Help?',
            'Contact our support team',
            Icons.support_agent,
          ),

          const SizedBox(height: 24),

          // FAQ Section
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(
              color: Color(0xFFFFB347),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // Buying Questions
          _buildFAQItem(
            'How do I buy a car?',
            'Browse listings, select a car, and contact the seller to arrange viewing and purchase.',
          ),

          _buildFAQItem(
            'Can I negotiate the price?',
            'Yes, you can discuss pricing directly with the seller.',
          ),

          _buildFAQItem(
            'How do I contact a seller?',
            'Tap on any car listing and use the contact button to message the seller.',
          ),

          const SizedBox(height: 16),

          // Selling Questions
          _buildFAQItem(
            'How do I sell my car?',
            'Tap the Sell button, fill in car details, upload photos, and submit your listing.',
          ),

          _buildFAQItem(
            'Is listing a car free?',
            'Yes, basic listings are completely free.',
          ),

          _buildFAQItem(
            'How long does my listing stay active?',
            'Listings remain active for 90 days and can be renewed anytime.',
          ),

          const SizedBox(height: 16),

          // Account Questions
          _buildFAQItem(
            'How do I reset my password?',
            'Go to Settings > Account > Change Password.',
          ),

          _buildFAQItem(
            'How do I edit my profile?',
            'Go to Profile > Edit Profile to update your information.',
          ),

          _buildFAQItem(
            'Is my data secure?',
            'Yes, we use encryption to protect all your personal information.',
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFB347), Color(0xFFFF8C42)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconColor: const Color(0xFFFFB347),
        collapsedIconColor: Colors.white,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
