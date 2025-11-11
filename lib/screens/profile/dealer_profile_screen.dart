import 'package:flutter/material.dart';

class DealerProfileScreen extends StatefulWidget {
  final String dealerName;

  const DealerProfileScreen({Key? key, required this.dealerName})
    : super(key: key);

  @override
  State<DealerProfileScreen> createState() => _DealerProfileScreenState();
}

class _DealerProfileScreenState extends State<DealerProfileScreen> {
  bool _isFollowing = false;
  int _selectedTab = 0;

  // Sample listings
  final List<Map<String, dynamic>> _listings = [
    {
      'id': '1',
      'image': 'assets/images/bmw.jpg',
      'name': 'BMW 3 Series',
      'year': '2022',
      'price': '\$45,000',
      'mileage': '15,000 km',
      'condition': 'Excellent',
      'status': 'Available',
    },
    {
      'id': '2',
      'image': 'assets/images/merc.jpg',
      'name': 'Mercedes C-Class',
      'year': '2021',
      'price': '\$52,000',
      'mileage': '22,000 km',
      'condition': 'Like New',
      'status': 'Available',
    },
    {
      'id': '3',
      'image': 'assets/images/car1.jpg',
      'name': 'Audi A4',
      'year': '2023',
      'price': '\$48,000',
      'mileage': '8,000 km',
      'condition': 'Excellent',
      'status': 'Sold',
    },
    {
      'id': '4',
      'image': 'assets/images/car2.jpg',
      'name': 'Toyota Camry',
      'year': '2022',
      'price': '\$32,000',
      'mileage': '18,000 km',
      'condition': 'Good',
      'status': 'Available',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE50914),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Dealer Profile',
          style: TextStyle(color: Colors.white, fontFamily: 'roboto_bold'),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Profile Image
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: const AssetImage('assets/images/Profile.jpg'),
              ),
            ),

            const SizedBox(height: 16),

            // Name
            Center(
              child: Text(
                widget.dealerName,
                style: const TextStyle(fontSize: 22, fontFamily: 'roboto_bold',color: Colors.white),
              ),
            ),

            const SizedBox(height: 8),

            // Rating
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '4.8 (124 reviews)',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontFamily: 'roboto_regular',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isFollowing = !_isFollowing;
                        });
                      },
                      icon: Icon(
                        _isFollowing ? Icons.check : Icons.add,
                        color: Colors.white,
                      ),
                      label: Text(
                        _isFollowing ? 'Following' : 'Follow',
                        style: const TextStyle(
                          fontFamily: 'roboto_bold',
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFB347),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Opening chat...')),
                        );
                      },
                      icon: const Icon(Icons.message, color: Color(0xFFFFB347)),
                      label: const Text(
                        'Message',
                        style: TextStyle(
                          fontFamily: 'roboto_bold',
                          color: Color(0xFFFFB347),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: const BorderSide(color: Color(0xFFFFB347)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Stats Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildStatCard('Listings', '45'),
                  const SizedBox(width: 12),
                  _buildStatCard('Sold', '280'),
                  const SizedBox(width: 12),
                  _buildStatCard('Followers', '892'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tab Selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                ),
                child: Row(
                  children: [_buildTab('Listings', 0), _buildTab('Contact', 1)],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Tab Content
            _selectedTab == 0 ? _buildListingsTab() : _buildContactTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    bool isSelected = _selectedTab == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected
                    ? const Color(0xFFFFB347)
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'roboto_bold',
              fontSize: 14,
              color: isSelected
                  ? const Color(0xFFFFB347)
                  : Colors.white.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFFB347).withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontFamily: 'roboto_bold',
                color: Color(0xFFFFB347),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.7),
                fontFamily: 'roboto_regular',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListingsTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: _listings
            .map((listing) => _buildListingCard(listing))
            .toList(),
      ),
    );
  }

  Widget _buildListingCard(Map<String, dynamic> listing) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFB347).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              listing['image'],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${listing['year']} ${listing['name']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'roboto_bold',
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  listing['price'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'roboto_bold',
                    color: Color(0xFFFFB347),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${listing['mileage']} • ${listing['condition']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7),
                    fontFamily: 'roboto_regular',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildContactItem(Icons.phone, 'Phone', '+1 (555) 123-4567'),
          const SizedBox(height: 12),
          _buildContactItem(Icons.email, 'Email', 'dealer@autohub.com'),
          const SizedBox(height: 12),
          _buildContactItem(Icons.location_on, 'Address', '123 Auto St, NY'),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFB347).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFFB347)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.5),
                    fontFamily: 'roboto_regular',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'roboto_bold',
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
