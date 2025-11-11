import 'package:flutter/material.dart';

class PreviewListing extends StatelessWidget {
  final Map<String, dynamic> carData;

  const PreviewListing({super.key, required this.carData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2C2C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Preview Your Listing',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Gallery
            _buildImageGallery(),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Price
                  Text(
                    carData['title'] ?? 'Car Title',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text(
                        'PKR ',
                        style: TextStyle(
                          color: Color(0xFFFFB347),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _formatPrice(carData['price']),
                        style: const TextStyle(
                          color: Color(0xFFFFB347),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (carData['isNegotiable'] == true) ...[
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFB347).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: const Color(0xFFFFB347).withOpacity(0.5),
                            ),
                          ),
                          child: const Text(
                            'Negotiable',
                            style: TextStyle(
                              color: Color(0xFFFFB347),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Location
                  _buildInfoRow(
                    Icons.location_on,
                    'Location',
                    '${carData['city']}${carData['location']?.isNotEmpty == true ? ', ${carData['location']}' : ''}',
                  ),

                  const SizedBox(height: 24),

                  // Specifications Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2C),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Specifications',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildSpecGrid(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Description
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2C),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Description',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          carData['description'] ?? 'No description provided',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (carData['features']?.isNotEmpty == true) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2C2C),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Color(0xFFFFB347),
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Special Features',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            carData['features'],
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Edit and Submit Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.edit, size: 20),
                          label: const Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context, true),
                          icon: const Icon(Icons.check_circle, size: 20),
                          label: const Text(
                            'Publish Listing',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFB347),
                            foregroundColor: const Color(0xFF1A1A1A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGallery() {
    final images = carData['images'] as List<String>? ?? [];
    
    if (images.isEmpty) {
      return Container(
        height: 250,
        color: const Color(0xFF2C2C2C),
        child: Center(
          child: Icon(
            Icons.image,
            color: Colors.white.withOpacity(0.3),
            size: 64,
          ),
        ),
      );
    }

    return Container(
      height: 250,
      color: const Color(0xFF2C2C2C),
      child: Stack(
        children: [
          PageView.builder(
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Container(
                color: Colors.grey[800],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.directions_car,
                        color: Colors.white.withOpacity(0.5),
                        size: 64,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Image ${index + 1}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.photo_library, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    '${images.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFFFB347), size: 20),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildSpecItem(Icons.calendar_today, 'Year', carData['year']?.toString() ?? 'N/A')),
            const SizedBox(width: 12),
            Expanded(child: _buildSpecItem(Icons.speed, 'Mileage', '${_formatNumber(carData['mileage'])} km')),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildSpecItem(Icons.local_gas_station, 'Fuel', carData['fuelType'] ?? 'N/A')),
            const SizedBox(width: 12),
            Expanded(child: _buildSpecItem(Icons.settings, 'Transmission', carData['transmission'] ?? 'N/A')),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildSpecItem(Icons.category, 'Type', carData['category'] ?? 'N/A')),
            const SizedBox(width: 12),
            Expanded(child: _buildSpecItem(Icons.palette, 'Color', carData['color'] ?? 'N/A')),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildSpecItem(Icons.grade, 'Condition', carData['condition'] ?? 'N/A')),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSpecItem(
                Icons.engineering,
                'Engine',
                carData['engine']?.isNotEmpty == true ? '${carData['engine']} cc' : 'N/A',
              ),
            ),
          ],
        ),
        if (carData['isRegistered'] != null) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSpecItem(
                  Icons.verified,
                  'Status',
                  carData['isRegistered'] == true ? 'Registered' : 'Unregistered',
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSpecItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white.withOpacity(0.5), size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _formatPrice(dynamic price) {
    if (price == null) return '0';
    final priceInt = price is int ? price : int.tryParse(price.toString()) ?? 0;
    
    if (priceInt >= 10000000) {
      return '${(priceInt / 10000000).toStringAsFixed(2)} Crore';
    } else if (priceInt >= 100000) {
      return '${(priceInt / 100000).toStringAsFixed(2)} Lakh';
    } else {
      return priceInt.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
    }
  }

  String _formatNumber(dynamic number) {
    if (number == null) return '0';
    final numInt = number is int ? number : int.tryParse(number.toString()) ?? 0;
    return numInt.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
