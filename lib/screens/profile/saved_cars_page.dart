import 'package:flutter/material.dart';
import 'package:autohub/screens/home/car_detail_page.dart';
import 'package:autohub/helper/firestore_helper.dart';
import 'package:autohub/helper/chat_service.dart';
import 'package:autohub/screens/chat/chat_conversation_page.dart';
import 'package:intl/intl.dart';

class SavedCarsPage extends StatefulWidget {
  const SavedCarsPage({super.key});

  @override
  State<SavedCarsPage> createState() => _SavedCarsPageState();
}

class _SavedCarsPageState extends State<SavedCarsPage> {
  final FirestoreHelper _firestoreHelper = FirestoreHelper.instance;

  String _formatPrice(dynamic price) {
    final num priceNum = price is num ? price : 0;
    return NumberFormat('#,##,###').format(priceNum);
  }

  String _formatMileage(dynamic mileage) {
    final num mileageNum = mileage is num ? mileage : 0;
    return '${NumberFormat('#,###').format(mileageNum)} km';
  }

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
          'Saved Cars',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firestoreHelper.getFavoriteCars(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFB347)),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading favorites: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          final savedCars = snapshot.data ?? [];

          if (savedCars.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: savedCars.length,
            itemBuilder: (context, index) {
              return _buildCarCard(savedCars[index], index);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No saved cars yet',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start saving cars you like!',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarCard(Map<String, dynamic> car, int index) {
    final carId = car['id'] ?? '';
    final List<String> imageUrls = List<String>.from(car['imageUrls'] ?? []);
    final displayImage = imageUrls.isNotEmpty ? imageUrls[0] : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          // Car Image with Favorite Button
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: displayImage.isNotEmpty
                    ? Image.network(
                        displayImage,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: double.infinity,
                            height: 200,
                            color: const Color(0xFF1A1A1A),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFFFB347),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: 200,
                            color: const Color(0xFF1A1A1A),
                            child: const Icon(
                              Icons.car_rental,
                              size: 60,
                              color: Colors.white54,
                            ),
                          );
                        },
                      )
                    : Container(
                        width: double.infinity,
                        height: 200,
                        color: const Color(0xFF1A1A1A),
                        child: const Icon(
                          Icons.car_rental,
                          size: 60,
                          color: Colors.white54,
                        ),
                      ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A).withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      _removeFavorite(carId, car['title'] ?? 'this car');
                    },
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.image, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${imageUrls.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Car Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Price Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            car['title'] ?? 'Unknown',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            car['year']?.toString() ?? 'N/A',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB347),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Rs ${_formatPrice(car['price'] ?? 0)}',
                        style: const TextStyle(
                          color: Color(0xFF1A1A1A),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Specifications
                Row(
                  children: [
                    _buildSpecItem(
                      Icons.speed,
                      _formatMileage(car['mileage'] ?? 0),
                    ),
                    const SizedBox(width: 16),
                    _buildSpecItem(
                      Icons.local_gas_station,
                      car['fuel'] ?? 'N/A',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildSpecItem(
                      Icons.settings,
                      car['transmission'] ?? 'N/A',
                    ),
                    const SizedBox(width: 16),
                    _buildSpecItem(
                      Icons.location_on,
                      car['location'] ?? 'Pakistan',
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _viewCarDetails(car);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFFFB347),
                          side: const BorderSide(color: Color(0xFFFFB347)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('View Details'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _contactSeller(car);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFB347),
                          foregroundColor: const Color(0xFF1A1A1A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Contact'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFFFB347), size: 16),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
        ),
      ],
    );
  }

  Future<void> _removeFavorite(String carId, String carName) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: const Text(
            'Remove from Saved',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Remove $carName from saved cars?',
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
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
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await _firestoreHelper.removeFromFavorites(carId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Removed from saved cars'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error removing car: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _viewCarDetails(Map<String, dynamic> car) {
    final List<String> imageUrls = List<String>.from(car['imageUrls'] ?? []);
    final displayImage = imageUrls.isNotEmpty ? imageUrls[0] : '';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CarDetailPage(
          carName: car['title'] ?? 'Unknown',
          price: 'Rs ${_formatPrice(car['price'] ?? 0)}',
          location: car['location'] ?? 'Pakistan',
          image: displayImage,
          specs:
              '${_formatMileage(car['mileage'] ?? 0)} • ${car['fuel']} • ${car['transmission']}',
          carId: car['id'],
          sellerId: car['userId'],
        ),
      ),
    );
  }

  Future<void> _contactSeller(Map<String, dynamic> car) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: const Text(
            'Contact Seller',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contact seller about ${car['name']}',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.phone, color: Color(0xFFFFB347)),
                title: const Text(
                  'Call',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Calling seller...'),
                      backgroundColor: Color(0xFFFFB347),
                    ),
                  );
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.message, color: Color(0xFFFFB347)),
                title: const Text(
                  'Message',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  Navigator.pop(context);

                  final sellerId = car['userId'];
                  final carId = car['id'];

                  if (sellerId == null || carId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Unable to contact seller'),
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
                    final chatService = ChatService.instance;
                    final currentUserId = chatService.currentUserId;

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

                    final chatId = await chatService.createOrGetChatRoom(
                      sellerId: sellerId,
                      buyerId: currentUserId,
                      carId: carId,
                      carTitle: car['title'] ?? 'Car',
                    );

                    if (chatId == null) {
                      throw Exception('Failed to create chat');
                    }

                    final sellerDoc = await _firestoreHelper.getUserProfile(
                      sellerId,
                    );
                    final sellerName = sellerDoc?['name'] ?? 'Seller';

                    if (mounted) {
                      Navigator.pop(context); // Close loading

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatConversationPage(
                            chatId: chatId,
                            otherUserId: sellerId,
                            otherUserName: sellerName,
                            carTitle: car['title'] ?? 'Car',
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
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.email, color: Color(0xFFFFB347)),
                title: const Text(
                  'Email',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening email...'),
                      backgroundColor: Color(0xFFFFB347),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
