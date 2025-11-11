import 'package:flutter/material.dart';
class RecommendedCars extends StatelessWidget {
  const RecommendedCars({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> recommendations = [
      {
        'name': 'BMW X5 2023',
        'price': 'PKR 15,500,000',
        'matchScore': 95,
        'reason': 'Matches your search history',
        'image': 'assets/images/bmw.jpg',
        'mileage': '12,000 km',
        'fuel': 'Petrol',
      },
      {
        'name': 'Mercedes C-Class 2021',
        'price': 'PKR 12,000,000',
        'matchScore': 88,
        'reason': 'Similar to your saved cars',
        'image': 'assets/images/merc.jpg',
        'mileage': '25,000 km',
        'fuel': 'Diesel',
      },
      {
        'name': 'Ford Mustang 2020',
        'price': 'PKR 10,500,000',
        'matchScore': 82,
        'reason': 'Popular in your area',
        'image': 'assets/images/ford.jpg',
        'mileage': '35,000 km',
        'fuel': 'Petrol',
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
          'Recommended For You',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: recommendations.length,
        itemBuilder: (context, index) {
          return _buildRecommendationCard(context, recommendations[index]);
        },
      ),
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context,
    Map<String, dynamic> car,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.asset(
                  car['image'],
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${car['matchScore']}% Match',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.lightbulb,
                      color: Color(0xFFFFB347),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      car['reason'],
                      style: const TextStyle(
                        color: Color(0xFFFFB347),
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  car['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  car['price'],
                  style: const TextStyle(
                    color: Color(0xFFFFB347),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildSpec(Icons.speed, car['mileage']),
                    const SizedBox(width: 16),
                    _buildSpec(Icons.local_gas_station, car['fuel']),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.favorite_border, size: 18),
                        label: const Text('Save'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFFFB347),
                          side: const BorderSide(color: Color(0xFFFFB347)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFB347),
                          foregroundColor: const Color(0xFF1A1A1A),
                        ),
                        child: const Text('View Details'),
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

  Widget _buildSpec(IconData icon, String text) {
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
}
