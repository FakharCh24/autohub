import 'package:flutter/material.dart';
import 'package:autohub/screens/home/browse/comparison_results_screen.dart';
import 'package:autohub/screens/home/browse/car_selection_dialog.dart';

class CompareCars extends StatefulWidget {
  const CompareCars({super.key});

  @override
  State<CompareCars> createState() => _CompareCarsState();
}

class _CompareCarsState extends State<CompareCars> {
  List<Map<String, dynamic>> cars = [];

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
      body: cars.isEmpty
          ? _buildEmptyState()
          : SingleChildScrollView(
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
                              child: Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: _buildCarImage(car),
                                    ),
                                  ),
                                  // Remove button
                                  Positioned(
                                    top: 8,
                                    right: 12,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          cars.remove(car);
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),

                  // Comparison Table
                  _buildComparisonRow(
                    'Name',
                    cars
                        .map(
                          (c) =>
                              c['title']?.toString() ??
                              c['name']?.toString() ??
                              'N/A',
                        )
                        .toList(),
                  ),
                  _buildComparisonRow(
                    'Price',
                    cars.map((c) {
                      final price = c['price'];
                      if (price is int) {
                        return 'PKR $price';
                      }
                      return price?.toString() ?? 'N/A';
                    }).toList(),
                    isHighlight: true,
                  ),
                  _buildComparisonRow(
                    'Year',
                    cars.map((c) => c['year']?.toString() ?? 'N/A').toList(),
                  ),
                  _buildComparisonRow(
                    'Mileage',
                    cars.map((c) {
                      final mileage = c['mileage'];
                      if (mileage is int) {
                        return '$mileage km';
                      }
                      return mileage?.toString() ?? 'N/A';
                    }).toList(),
                  ),
                  _buildComparisonRow(
                    'Fuel Type',
                    cars.map((c) => c['fuel']?.toString() ?? 'N/A').toList(),
                  ),
                  _buildComparisonRow(
                    'Transmission',
                    cars
                        .map((c) => c['transmission']?.toString() ?? 'N/A')
                        .toList(),
                  ),
                  _buildComparisonRow(
                    'Condition',
                    cars
                        .map((c) => c['condition']?.toString() ?? 'N/A')
                        .toList(),
                  ),
                  _buildComparisonRow(
                    'Category',
                    cars
                        .map((c) => c['category']?.toString() ?? 'N/A')
                        .toList(),
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                cars.clear();
                              });
                            },
                            icon: const Icon(Icons.clear),
                            label: const Text('Clear All'),
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
                            onPressed: cars.length < 2
                                ? null
                                : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ComparisonResultsScreen(
                                              carsToCompare: cars,
                                            ),
                                      ),
                                    );
                                  },
                            icon: const Icon(Icons.compare),
                            label: const Text('Compare'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFB347),
                              foregroundColor: const Color(0xFF1A1A1A),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              disabledBackgroundColor: Colors.grey,
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

  void _addCarToCompare() async {
    final selectedCars = await showDialog<List<Map<String, dynamic>>>(
      context: context,
      builder: (context) => CarSelectionDialog(alreadySelected: cars),
    );

    if (selectedCars != null && selectedCars.isNotEmpty) {
      setState(() {
        cars = selectedCars;
      });
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.compare_arrows,
              size: 100,
              color: Colors.white.withOpacity(0.2),
            ),
            const SizedBox(height: 24),
            Text(
              'No Cars Selected',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Tap the + button to select cars to compare',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _addCarToCompare,
              icon: const Icon(Icons.add),
              label: const Text('Select Cars'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB347),
                foregroundColor: const Color(0xFF1A1A1A),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarImage(Map<String, dynamic> car) {
    // Check if it's a new car with imageUrls or old format with image
    final imageUrls = car['imageUrls'] as List<dynamic>?;
    final imageUrl = (imageUrls != null && imageUrls.isNotEmpty)
        ? imageUrls[0].toString()
        : null;

    final imageAsset = car['image'] as String?;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderImage();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildPlaceholderImage();
        },
      );
    } else if (imageAsset != null && imageAsset.isNotEmpty) {
      return Image.asset(
        imageAsset,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderImage();
        },
      );
    } else {
      return _buildPlaceholderImage();
    }
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: const Color(0xFF1A1A1A),
      child: const Center(
        child: Icon(Icons.car_rental, color: Colors.white54, size: 60),
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
