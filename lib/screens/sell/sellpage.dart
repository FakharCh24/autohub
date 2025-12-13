import 'package:autohub/screens/sell/create_listing/listing_success_screen.dart';
import 'package:autohub/screens/sell/create_listing/preview_listing.dart';
import 'package:autohub/screens/sell/create_listing/sell_car_step1.dart';
import 'package:autohub/screens/sell/create_listing/sell_car_step2.dart';
import 'package:autohub/screens/sell/create_listing/sell_car_step3.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../../helper/firestore_helper.dart';
import '../../helper/storage_helper.dart';
import 'my_listings_page.dart';

class SellPage extends StatefulWidget {
  const SellPage({super.key});

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  Map<String, dynamic> carData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2C2C),
        elevation: 0,
        title: const Text(
          'Sell Your Car',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt, color: Colors.white),
            tooltip: 'My Listings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyListingsPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFFB347),
                    const Color(0xFFFFB347).withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFB347).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.sell, color: Color(0xFF1A1A1A), size: 56),
                  const SizedBox(height: 16),
                  const Text(
                    'List Your Car in Minutes',
                    style: TextStyle(
                      color: Color(0xFF1A1A1A),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Reach thousands of buyers across Pakistan',
                    style: TextStyle(
                      color: const Color(0xFF1A1A1A).withOpacity(0.8),
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // How It Works Section
            const Text(
              'How It Works',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            _buildStepCard(
              1,
              'Enter Car Details',
              'Basic information about your vehicle',
              Icons.directions_car,
            ),

            const SizedBox(height: 12),

            _buildStepCard(
              2,
              'Upload Photos',
              'Add high-quality images of your car',
              Icons.photo_camera,
            ),

            const SizedBox(height: 12),

            _buildStepCard(
              3,
              'Set Price & Location',
              'Add pricing and your location details',
              Icons.attach_money,
            ),

            const SizedBox(height: 12),

            _buildStepCard(
              4,
              'Review & Publish',
              'Preview and publish your listing',
              Icons.check_circle,
            ),

            const SizedBox(height: 32),

            // Benefits Section
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
                    'Why Sell on AutoHub?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildBenefitItem(
                    Icons.people,
                    'Large Buyer Network',
                    'Connect with serious buyers instantly',
                  ),
                  const SizedBox(height: 12),
                  _buildBenefitItem(
                    Icons.security,
                    'Safe & Secure',
                    'Your information is protected',
                  ),
                  const SizedBox(height: 12),
                  _buildBenefitItem(
                    Icons.speed,
                    'Quick Listings',
                    'List your car in under 5 minutes',
                  ),
                  const SizedBox(height: 12),
                  _buildBenefitItem(
                    Icons.money_off,
                    'No Hidden Charges',
                    'Free to list, pay only when sold',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Start Listing Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _startListingProcess,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB347),
                  foregroundColor: const Color(0xFF1A1A1A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle, size: 24),
                    SizedBox(width: 12),
                    Text(
                      'Start Listing Now',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Quick Access to My Listings
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyListingsPage(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.list_alt, size: 24),
                    SizedBox(width: 12),
                    Text(
                      'View My Listings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Terms Text
            Text(
              'By listing your car, you agree to our Terms of Service and Privacy Policy',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard(
    int step,
    String title,
    String description,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFFB347).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFFFB347)),
            ),
            child: Center(
              child: Text(
                '$step',
                style: const TextStyle(
                  color: Color(0xFFFFB347),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Icon(icon, color: const Color(0xFFFFB347).withOpacity(0.7), size: 28),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String title, String description) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFFFB347), size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _startListingProcess() async {
    try {
      print('Starting listing process...');

      // Step 1: Basic Info
      if (!mounted) {
        print('Widget not mounted!');
        return;
      }

      final step1Data = await Navigator.of(context, rootNavigator: false)
          .push<Map<String, dynamic>>(
            MaterialPageRoute<Map<String, dynamic>>(
              builder: (ctx) {
                return SellCarStep1(initialData: carData);
              },
            ),
          );

      print('Step 1 completed with data: $step1Data');

      if (step1Data == null) return;

      setState(() {
        carData.addAll(step1Data);
      });

      // Step 2: Photos
      final step2Data = await Navigator.of(context).push<Map<String, dynamic>>(
        MaterialPageRoute<Map<String, dynamic>>(
          builder: (context) {
            return SellCarStep2(initialData: carData);
          },
        ),
      );

      if (step2Data == null) return;

      setState(() {
        carData.addAll(step2Data);
      });

      // Step 3: Price & Details
      final step3Data = await Navigator.of(context).push<Map<String, dynamic>>(
        MaterialPageRoute<Map<String, dynamic>>(
          builder: (context) {
            return SellCarStep3(initialData: carData);
          },
        ),
      );

      if (step3Data == null) return;

      setState(() {
        carData.addAll(step3Data);
      });

      // Preview & Confirm
      final confirmed = await Navigator.of(context).push<bool>(
        MaterialPageRoute<bool>(
          builder: (context) {
            return PreviewListing(carData: carData);
          },
        ),
      );

      if (confirmed == true) {
        await _saveCar();
      }
    } catch (e) {
      print('Error in listing process: $e');
      if (mounted) {
        _showErrorDialog(
          'An error occurred while starting the listing process. Please try again.',
        );
      }
    }
  }

  Future<void> _saveCar() async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFB347)),
          ),
        ),
      );

      // Upload images to Firebase Storage
      List<String> imageUrls = [];
      final imagePaths = (carData['images'] as List<String>?) ?? [];

      for (String imagePath in imagePaths) {
        final imageFile = File(imagePath);
        final url = await StorageHelper.instance.uploadCarImage(imageFile);
        if (url != null) {
          imageUrls.add(url);
        }
      }

      // Save to Firestore
      final carId = await FirestoreHelper.instance.addCar(
        title: carData['title'] ?? '',
        price: carData['price'] ?? 0,
        description: carData['description'] ?? '',
        year: carData['year'] ?? 2020,
        mileage: carData['mileage'] ?? 0,
        category: carData['category'] ?? 'Sedan',
        fuel: carData['fuelType'] ?? 'Petrol',
        transmission: carData['transmission'] ?? 'Manual',
        condition: carData['condition'] ?? 'Used',
        location: carData['city'] ?? 'Lahore',
        imageUrls: imageUrls,
      );

      // Close loading
      if (mounted) {
        Navigator.of(context).pop();
      }

      if (carId != null) {
        // Navigate to success screen
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ListingSuccessScreen(carData: carData),
            ),
          );
        }

        // Clear data
        if (mounted) {
          setState(() {
            carData = {};
          });
        }
      } else {
        if (mounted) {
          _showErrorDialog('Failed to save car. Please try again.');
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close loading
        _showErrorDialog('An error occurred: $e');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.redAccent,
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                'Error',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB347),
                  foregroundColor: const Color(0xFF1A1A1A),
                ),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }
}
