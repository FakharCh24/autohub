import 'package:flutter/material.dart';

class BrandBrowse extends StatelessWidget {
  const BrandBrowse({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> brands = [
      {'name': 'BMW', 'count': 87, 'logo': 'assets/images/bmw.jpg'},
      {'name': 'Mercedes-Benz', 'count': 95, 'logo': 'assets/images/merc.jpg'},
      {'name': 'Ford', 'count': 124, 'logo': 'assets/images/ford.jpg'},
      {'name': 'Toyota', 'count': 156, 'logo': 'assets/images/car1.jpg'},
      {'name': 'Honda', 'count': 132, 'logo': 'assets/images/car2.jpg'},
      {'name': 'Nissan', 'count': 98, 'logo': 'assets/images/car3.jpg'},
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
          'Browse by Brand',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: brands.length,
        itemBuilder: (context, index) {
          return _buildBrandCard(context, brands[index]);
        },
      ),
    );
  }

  Widget _buildBrandCard(BuildContext context, Map<String, dynamic> brand) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              brand['logo'],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.directions_car, color: Colors.grey);
              },
            ),
          ),
        ),
        title: Text(
          brand['name'],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${brand['count']} cars available',
          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFFFFB347)),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Browsing ${brand['name']}'),
              backgroundColor: const Color(0xFFFFB347),
            ),
          );
        },
      ),
    );
  }
}
