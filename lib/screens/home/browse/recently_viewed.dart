import 'package:flutter/material.dart';
import 'package:autohub/helper/firestore_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../car_detail_page.dart';

class RecentlyViewed extends StatelessWidget {
  const RecentlyViewed({super.key});

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
          'Recently Viewed',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              // Clear recently viewed history
              await FirestoreHelper.instance.clearRecentlyViewed();
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: FirestoreHelper.instance.getRecentlyViewedCars(),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFB347)),
            );
          }

          // Error state
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          }

          final recentCars = snapshot.data ?? [];

          // Empty state
          if (recentCars.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No recently viewed cars',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Cars you view will appear here',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: recentCars.length,
            itemBuilder: (context, index) {
              return _buildCarCard(context, recentCars[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildCarCard(BuildContext context, Map<String, dynamic> car) {
    // Format viewed time
    String viewedAt = 'Recently';
    if (car['viewedAt'] != null) {
      try {
        final timestamp = car['viewedAt'];
        if (timestamp is Timestamp) {
          final date = timestamp.toDate();
          final now = DateTime.now();
          final difference = now.difference(date);

          if (difference.inMinutes < 60) {
            viewedAt = '${difference.inMinutes} minutes ago';
          } else if (difference.inHours < 24) {
            viewedAt = '${difference.inHours} hours ago';
          } else if (difference.inDays < 7) {
            viewedAt = '${difference.inDays} days ago';
          } else {
            viewedAt = '${date.day}/${date.month}/${date.year}';
          }
        }
      } catch (e) {
        print('Error formatting date: $e');
      }
    }

    final imageUrl = car['imageUrls']?.isNotEmpty == true
        ? car['imageUrls'][0]
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CarDetailPage(
                carName: car['title'] ?? 'Unknown',
                price: 'Rs ${car['price'] ?? 0}',
                location: car['location'] ?? 'Unknown',
                image: imageUrl ?? '',
                specs: '${car['year']} • ${car['mileage']} km • ${car['fuel']}',
                carId: car['id'],
                sellerId: car['userId'],
              ),
            ),
          );
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 100,
                          height: 100,
                          color: const Color(0xFF1A1A1A),
                          child: const Icon(
                            Icons.car_rental,
                            size: 40,
                            color: Colors.white54,
                          ),
                        );
                      },
                    )
                  : Container(
                      width: 100,
                      height: 100,
                      color: const Color(0xFF1A1A1A),
                      child: const Icon(
                        Icons.car_rental,
                        size: 40,
                        color: Colors.white54,
                      ),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      car['title'] ?? 'Unknown Car',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rs ${car['price'] ?? 0}',
                      style: const TextStyle(
                        color: Color(0xFFFFB347),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.white54,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          viewedAt,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
