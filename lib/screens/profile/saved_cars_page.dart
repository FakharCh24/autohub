import 'package:flutter/material.dart';

class SavedCarsPage extends StatefulWidget {
  const SavedCarsPage({super.key});

  @override
  State<SavedCarsPage> createState() => _SavedCarsPageState();
}

class _SavedCarsPageState extends State<SavedCarsPage> {
  // Sample saved cars data
  final List<Map<String, dynamic>> _savedCars = [
    {
      'name': 'BMW M3',
      'year': '2022',
      'price': '\$75,000',
      'mileage': '12,000 km',
      'fuel': 'Petrol',
      'transmission': 'Automatic',
      'location': 'New York',
      'savedDate': '2 days ago',
      'image': 'assets/images/bmw.jpg',
    },
    {
      'name': 'Mercedes-Benz C-Class',
      'year': '2021',
      'price': '\$55,000',
      'mileage': '25,000 km',
      'fuel': 'Diesel',
      'transmission': 'Automatic',
      'location': 'Los Angeles',
      'savedDate': '1 week ago',
      'image': 'assets/images/merc.jpg',
    },
    {
      'name': 'Ford Mustang',
      'year': '2020',
      'price': '\$45,000',
      'mileage': '35,000 km',
      'fuel': 'Petrol',
      'transmission': 'Manual',
      'location': 'Chicago',
      'savedDate': '2 weeks ago',
      'image': 'assets/images/ford.jpg',
    },
  ];

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
      body: _savedCars.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _savedCars.length,
              itemBuilder: (context, index) {
                return _buildCarCard(_savedCars[index], index);
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
                child: Image.asset(
                  car['image'],
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
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
                      _removeFavorite(index);
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
                bottom: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: Color(0xFFFFB347),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        car['savedDate'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
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
                            car['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            car['year'],
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
                        car['price'],
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
                    _buildSpecItem(Icons.speed, car['mileage']),
                    const SizedBox(width: 16),
                    _buildSpecItem(Icons.local_gas_station, car['fuel']),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildSpecItem(Icons.settings, car['transmission']),
                    const SizedBox(width: 16),
                    _buildSpecItem(Icons.location_on, car['location']),
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

  void _removeFavorite(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: const Text(
            'Remove from Saved',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Remove ${_savedCars[index]['name']} from saved cars?',
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
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
              onPressed: () {
                setState(() {
                  _savedCars.removeAt(index);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Removed from saved cars'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  void _viewCarDetails(Map<String, dynamic> car) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('View details for ${car['name']}'),
        backgroundColor: const Color(0xFFFFB347),
      ),
    );
  }

  void _contactSeller(Map<String, dynamic> car) {
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
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening messages...'),
                      backgroundColor: Color(0xFFFFB347),
                    ),
                  );
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
