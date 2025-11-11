import 'package:flutter/material.dart';

class CategoryBrowse extends StatelessWidget {
  const CategoryBrowse({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        'name': 'Sedan',
        'icon': Icons.directions_car,
        'count': 234,
        'color': Colors.blue,
      },
      {
        'name': 'SUV',
        'icon': Icons.airport_shuttle,
        'count': 189,
        'color': Colors.green,
      },
      {
        'name': 'Hatchback',
        'icon': Icons.directions_car_filled,
        'count': 145,
        'color': Colors.orange,
      },
      {
        'name': 'Coupe',
        'icon': Icons.sports_score,
        'count': 78,
        'color': Colors.red,
      },
      {
        'name': 'Convertible',
        'icon': Icons.beach_access,
        'count': 56,
        'color': Colors.purple,
      },
      {
        'name': 'Pickup Truck',
        'icon': Icons.local_shipping,
        'count': 123,
        'color': Colors.brown,
      },
      {
        'name': 'Van/Minivan',
        'icon': Icons.rv_hookup,
        'count': 91,
        'color': Colors.teal,
      },
      {
        'name': 'Sports Car',
        'icon': Icons.sports_motorsports,
        'count': 67,
        'color': Colors.pink,
      },
      {
        'name': 'Luxury',
        'icon': Icons.star,
        'count': 102,
        'color': Colors.amber,
      },
      {
        'name': 'Electric',
        'icon': Icons.electric_car,
        'count': 88,
        'color': Colors.lightGreen,
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
          'Browse by Category',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.0,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return _buildCategoryCard(context, categories[index]);
        },
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    Map<String, dynamic> category,
  ) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Browsing ${category['name']}'),
            backgroundColor: const Color(0xFFFFB347),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              category['color'].withOpacity(0.3),
              category['color'].withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: category['color'].withOpacity(0.5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: category['color'].withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(category['icon'], color: category['color'], size: 40),
            ),
            const SizedBox(height: 12),
            Text(
              category['name'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '${category['count']} cars',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
