import 'package:flutter/material.dart';

class RecentlyViewed extends StatelessWidget {
  const RecentlyViewed({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> recentCars = [
      {
        'name': 'BMW M3 2022',
        'price': 'PKR 17,500,000',
        'viewedAt': '2 hours ago',
        'image': 'assets/images/bmw.jpg',
      },
      {
        'name': 'Mercedes C-Class',
        'price': 'PKR 12,000,000',
        'viewedAt': '5 hours ago',
        'image': 'assets/images/merc.jpg',
      },
      {
        'name': 'Ford Mustang',
        'price': 'PKR 10,500,000',
        'viewedAt': '1 day ago',
        'image': 'assets/images/ford.jpg',
      },
    ];

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
            onPressed: () {},
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: recentCars.length,
        itemBuilder: (context, index) {
          return _buildCarCard(context, recentCars[index]);
        },
      ),
    );
  }

  Widget _buildCarCard(BuildContext context, Map<String, dynamic> car) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(12),
            ),
            child: Image.asset(
              car['image'],
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    car['price'],
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
                        car['viewedAt'],
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
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.close, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
