import 'package:flutter/material.dart';
import 'package:autohub/screens/home/browse/comparison_results_screen.dart';

class CompareCars extends StatefulWidget {
  const CompareCars({super.key});

  @override
  State<CompareCars> createState() => _CompareCarsState();
}

class _CompareCarsState extends State<CompareCars> {
  final List<Map<String, dynamic>> cars = [
    {
      'name': 'BMW M3 2022',
      'price': 'PKR 17,500,000',
      'year': '2022',
      'mileage': '12,000 km',
      'fuel': 'Petrol',
      'transmission': 'Automatic',
      'engine': '3.0L',
      'power': '503 hp',
      'image': 'assets/images/bmw.jpg',
    },
    {
      'name': 'Mercedes C-Class 2021',
      'price': 'PKR 12,000,000',
      'year': '2021',
      'mileage': '25,000 km',
      'fuel': 'Diesel',
      'transmission': 'Automatic',
      'engine': '2.0L',
      'power': '255 hp',
      'image': 'assets/images/merc.jpg',
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
          'Compare Cars',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _addCarToCompare,
            icon: const Icon(Icons.add, color: Color(0xFFFFB347)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Car Images
            Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: cars
                    .map(
                      (car) => Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(car['image'], fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),

            // Comparison Table
            _buildComparisonRow(
              'Name',
              cars.map((c) => c['name'] as String).toList(),
            ),
            _buildComparisonRow(
              'Price',
              cars.map((c) => c['price'] as String).toList(),
              isHighlight: true,
            ),
            _buildComparisonRow(
              'Year',
              cars.map((c) => c['year'] as String).toList(),
            ),
            _buildComparisonRow(
              'Mileage',
              cars.map((c) => c['mileage'] as String).toList(),
            ),
            _buildComparisonRow(
              'Fuel Type',
              cars.map((c) => c['fuel'] as String).toList(),
            ),
            _buildComparisonRow(
              'Transmission',
              cars.map((c) => c['transmission'] as String).toList(),
            ),
            _buildComparisonRow(
              'Engine',
              cars.map((c) => c['engine'] as String).toList(),
            ),
            _buildComparisonRow(
              'Power',
              cars.map((c) => c['power'] as String).toList(),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.share),
                      label: const Text('Share'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFFFB347),
                        side: const BorderSide(color: Color(0xFFFFB347)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ComparisonResultsScreen(carsToCompare: cars),
                          ),
                        );
                      },
                      icon: const Icon(Icons.compare),
                      label: const Text('Compare'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFB347),
                        foregroundColor: const Color(0xFF1A1A1A),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
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

  Widget _buildComparisonRow(
    String label,
    List<String> values, {
    bool isHighlight = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: isHighlight
                    ? const Color(0xFFFFB347)
                    : Colors.white.withOpacity(0.7),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...values.map(
            (value) => Expanded(
              flex: 3,
              child: Text(
                value,
                style: TextStyle(
                  color: isHighlight ? const Color(0xFFFFB347) : Colors.white,
                  fontSize: 14,
                  fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addCarToCompare() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Select a car to add to comparison'),
        backgroundColor: Color(0xFFFFB347),
      ),
    );
  }

  //   void _clearComparison() {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           backgroundColor: const Color(0xFF2C2C2C),
  //           title: const Text(
  //             'Clear Comparison',
  //             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  //           ),
  //           content: const Text(
  //             'Are you sure you want to clear all cars from comparison?',
  //             style: TextStyle(color: Colors.white),
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: const Text(
  //                 'Cancel',
  //                 style: TextStyle(color: Colors.white),
  //               ),
  //             ),
  //             ElevatedButton(
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: const Color(0xFFFFB347),
  //                 foregroundColor: const Color(0xFF1A1A1A),
  //               ),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 Navigator.pop(context);
  //               },
  //               child: const Text('Clear'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }
}
