import 'package:autohub/screens/chat/chat_conversation_page.dart';
import 'package:flutter/material.dart';
import 'package:autohub/screens/home/car_detail_page.dart';
import 'package:autohub/helper/chat_service.dart';
import 'package:autohub/helper/firestore_helper.dart';

class DealerProfileScreen extends StatefulWidget {
  final String dealerName;
  final String? dealerId;

  const DealerProfileScreen({Key? key, required this.dealerName, this.dealerId})
    : super(key: key);

  @override
  State<DealerProfileScreen> createState() => _DealerProfileScreenState();
}

class _DealerProfileScreenState extends State<DealerProfileScreen> {
  bool _isFollowing = false;
  int _selectedTab = 0;
  final ChatService _chatService = ChatService.instance;
  final FirestoreHelper _firestoreHelper = FirestoreHelper.instance;
  Map<String, dynamic>? dealerData;
  Map<String, dynamic>? dealerStats;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDealerData();
  }

  Future<void> _loadDealerData() async {
    if (widget.dealerId != null) {
      final data = await _firestoreHelper.getUserProfile(widget.dealerId!);
      final stats = await _firestoreHelper.getUserStats(widget.dealerId!);
      setState(() {
        dealerData = data;
        dealerStats = stats;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFFFFB347)),
        ),
      );
    }

    final displayName = dealerData?['name'] ?? widget.dealerName;

    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
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
                backgroundColor: const Color(0xFFFFB347).withOpacity(0.2),
                backgroundImage:
                    dealerData?['photoUrl'] != null &&
                        dealerData!['photoUrl'].toString().isNotEmpty
                    ? NetworkImage(dealerData!['photoUrl'])
                    : const AssetImage('assets/images/Profile.jpg')
                          as ImageProvider,
                onBackgroundImageError: (exception, stackTrace) {
                  // Fallback to default icon if image fails to load
                },
                child:
                    dealerData?['photoUrl'] == null ||
                        dealerData!['photoUrl'].toString().isEmpty
                    ? const Icon(
                        Icons.person,
                        color: Color(0xFFFFB347),
                        size: 50,
                      )
                    : null,
              ),
            ),

            const SizedBox(height: 16),

            // Name
            Center(
              child: Text(
                displayName,
                style: const TextStyle(
                  fontSize: 22,
                  fontFamily: 'roboto_bold',
                  color: Colors.white,
                ),
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
                    dealerStats != null && dealerStats!['totalReviews'] > 0
                        ? '${(dealerStats!['averageRating'] as double).toStringAsFixed(1)} (${dealerStats!['totalReviews']} reviews)'
                        : 'No reviews yet',
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
                      onPressed: () async {
                        if (widget.dealerId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Unable to contact dealer'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        // Show loading
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFFFB347),
                            ),
                          ),
                        );

                        try {
                          final currentUserId = _chatService.currentUserId;
                          if (currentUserId == null) {
                            if (mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please sign in to chat'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                            return;
                          }

                          // For dealer inquiry, we use a generic carId
                          final chatId = await _chatService.createOrGetChatRoom(
                            sellerId: widget.dealerId!,
                            buyerId: currentUserId,
                            carId: 'dealer_inquiry',
                            carTitle: 'General Inquiry',
                          );

                          if (chatId == null) {
                            throw Exception('Failed to create chat');
                          }

                          if (mounted) {
                            Navigator.pop(context); // Close loading

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatConversationPage(
                                  chatId: chatId,
                                  otherUserId: widget.dealerId!,
                                  otherUserName: widget.dealerName,
                                  carTitle: 'General Inquiry',
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
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
                  _buildStatCard(
                    'Listings',
                    '${dealerStats?['carsListed'] ?? 0}',
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard('Sold', '${dealerStats?['carsSold'] ?? 0}'),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    'Rating',
                    dealerStats?['averageRating'] != null
                        ? (dealerStats!['averageRating'] as double)
                              .toStringAsFixed(1)
                        : '0.0',
                  ),
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
    if (widget.dealerId == null) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(
          'Dealer information not available',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _firestoreHelper.getUserListings(widget.dealerId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(color: Color(0xFFFFB347)),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        final listings = snapshot.data ?? [];

        if (listings.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'No listings available',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: listings
                .map((listing) => _buildListingCard(listing))
                .toList(),
          ),
        );
      },
    );
  }

  Widget _buildListingCard(Map<String, dynamic> listing) {
    // Extract data from Firestore
    final imageUrl = (listing['imageUrls'] as List?)?.isNotEmpty == true
        ? listing['imageUrls'][0]
        : 'assets/images/car1.jpg';
    final title = listing['title'] ?? 'Unknown Car';
    final year = listing['year'] ?? 'N/A';
    final price = 'Rs ${listing['price'] ?? 0}';
    final mileage = '${listing['mileage'] ?? 0} km';
    final condition = listing['condition'] ?? 'N/A';
    final location = listing['location'] ?? 'Unknown';
    final transmission = listing['transmission'] ?? 'N/A';
    final fuel = listing['fuel'] ?? 'N/A';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CarDetailPage(
              carName: '$year $title',
              price: price,
              location: location,
              image: imageUrl,
              specs: '$mileage • $transmission • $fuel',
              carId: listing['id'],
              sellerId: widget.dealerId,
            ),
          ),
        );
      },
      child: Container(
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
              child: imageUrl.startsWith('http')
                  ? Image.network(
                      imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey.withOpacity(0.3),
                          child: const Icon(
                            Icons.car_rental,
                            color: Colors.white54,
                          ),
                        );
                      },
                    )
                  : Image.asset(
                      imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey.withOpacity(0.3),
                          child: const Icon(
                            Icons.car_rental,
                            color: Colors.white54,
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$year $title',
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'roboto_bold',
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'roboto_bold',
                      color: Color(0xFFFFB347),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$mileage • $condition',
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
      ),
    );
  }

  Widget _buildContactTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildContactItem(
            Icons.phone,
            'Phone',
            dealerData?['phone'] ?? 'Not provided',
          ),
          const SizedBox(height: 12),
          _buildContactItem(
            Icons.email,
            'Email',
            dealerData?['email'] ?? 'Not provided',
          ),
          const SizedBox(height: 12),
          _buildContactItem(
            Icons.location_on,
            'Address',
            dealerData?['address'] ?? 'Not provided',
          ),
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
