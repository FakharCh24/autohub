import 'package:flutter/material.dart';
import '../../helper/db_helper.dart';
import 'dart:convert';

class MyListingsPage extends StatefulWidget {
  const MyListingsPage({super.key});

  @override
  State<MyListingsPage> createState() => _MyListingsPageState();
}

class _MyListingsPageState extends State<MyListingsPage> {
  List<Map<String, dynamic>> _cars = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  Future<void> _loadCars() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final cars = await DbHelper.getInstance.getCars();
      setState(() {
        _cars = cars;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        _showErrorSnackBar('Error loading cars: $e');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  List<String> _parseImages(String? imagesJson) {
    if (imagesJson == null || imagesJson.isEmpty) return [];
    try {
      final decoded = jsonDecode(imagesJson);
      if (decoded is List) return decoded.cast<String>();
    } catch (_) {}
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2C2C),
        elevation: 0,
        title: const Text(
          'My Listings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadCars,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFB347)),
            )
          : _cars.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              color: const Color(0xFFFFB347),
              backgroundColor: const Color(0xFF2C2C2C),
              onRefresh: _loadCars,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _cars.length,
                itemBuilder: (context, index) {
                  return _buildCarCard(_cars[index]);
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.car_rental,
            size: 80,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No cars listed yet',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start by adding your first car!',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarCard(Map<String, dynamic> car) {
    final images = _parseImages(car[DbHelper.COLUMN_IMAGES]);
    final hasImages = images.isNotEmpty;

    return Card(
      color: const Color(0xFF2C2C2C),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: hasImages
                ? ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: Image.asset(
                      images[0],
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildImagePlaceholder();
                      },
                    ),
                  )
                : _buildImagePlaceholder(),
          ),

          // Car details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        car[DbHelper.COLUMN_TITLE] ?? 'Untitled',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB347),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'PKR ${_formatPrice(car[DbHelper.COLUMN_PRICE])}',
                        style: const TextStyle(
                          color: Color(0xFF1A1A1A),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Category badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    car[DbHelper.COLUMN_CATEGORY] ?? '',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Specs row
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    _buildSpecItem(
                      Icons.calendar_today,
                      '${car[DbHelper.COLUMN_YEAR]}',
                    ),
                    _buildSpecItem(
                      Icons.speed,
                      '${_formatNumber(car[DbHelper.COLUMN_MILEAGE])} km',
                    ),
                    _buildSpecItem(
                      Icons.local_gas_station,
                      car[DbHelper.COLUMN_FUEL] ?? '',
                    ),
                    _buildSpecItem(
                      Icons.settings,
                      car[DbHelper.COLUMN_TRANSMISSION] ?? '',
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Condition
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.white.withOpacity(0.7),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      car[DbHelper.COLUMN_CONDITION] ?? '',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Description
                Text(
                  car[DbHelper.COLUMN_DESC] ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 16),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showCarDetails(car);
                        },
                        icon: const Icon(Icons.visibility),
                        label: const Text('View Details'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFFFB347),
                          side: const BorderSide(color: Color(0xFFFFB347)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _confirmDelete(car[DbHelper.COLUMN_ID]);
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text('Delete'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
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

  Widget _buildImagePlaceholder() {
    return Center(
      child: Icon(
        Icons.directions_car,
        size: 64,
        color: Colors.white.withOpacity(0.3),
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFFFFB347), size: 16),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
        ),
      ],
    );
  }

  String _formatPrice(dynamic price) {
    if (price == null) return '0';
    final priceInt = price is int ? price : int.tryParse(price.toString()) ?? 0;
    return priceInt.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  String _formatNumber(dynamic number) {
    if (number == null) return '0';
    final numInt = number is int
        ? number
        : int.tryParse(number.toString()) ?? 0;
    return numInt.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  void _showCarDetails(Map<String, dynamic> car) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2C2C2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                car[DbHelper.COLUMN_TITLE] ?? 'Untitled',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                'Price',
                'PKR ${_formatPrice(car[DbHelper.COLUMN_PRICE])}',
              ),
              _buildDetailRow('Category', car[DbHelper.COLUMN_CATEGORY]),
              _buildDetailRow('Year', '${car[DbHelper.COLUMN_YEAR]}'),
              _buildDetailRow(
                'Mileage',
                '${_formatNumber(car[DbHelper.COLUMN_MILEAGE])} km',
              ),
              _buildDetailRow('Fuel Type', car[DbHelper.COLUMN_FUEL]),
              _buildDetailRow(
                'Transmission',
                car[DbHelper.COLUMN_TRANSMISSION],
              ),
              _buildDetailRow('Condition', car[DbHelper.COLUMN_CONDITION]),
              const SizedBox(height: 16),
              const Text(
                'Description',
                style: TextStyle(
                  color: Color(0xFFFFB347),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                car[DbHelper.COLUMN_DESC] ?? 'No description',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(int? carId) {
    if (carId == null) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Delete Listing',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to delete this car listing?',
            style: TextStyle(color: Colors.white.withOpacity(0.8)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteCar(carId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteCar(int carId) async {
    try {
      final db = await DbHelper.getInstance.getDB();
      await db.delete(
        DbHelper.TABLE_CAR,
        where: '${DbHelper.COLUMN_ID} = ?',
        whereArgs: [carId],
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Car deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _loadCars();
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Failed to delete car: $e');
      }
    }
  }
}
