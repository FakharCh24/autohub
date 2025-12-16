import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../helper/firestore_helper.dart';

class EditListingScreen extends StatefulWidget {
  final Map<String, dynamic> carData;

  const EditListingScreen({super.key, required this.carData});

  @override
  State<EditListingScreen> createState() => _EditListingScreenState();
}

class _EditListingScreenState extends State<EditListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirestoreHelper _firestoreHelper = FirestoreHelper.instance;

  // Controllers
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _yearController;
  late TextEditingController _mileageController;

  // Dropdowns
  late String selectedCategory;
  late String selectedFuelType;
  late String selectedTransmission;
  late String selectedCondition;

  bool _isLoading = false;

  final List<String> categories = [
    'Sedan',
    'SUV',
    'Hatchback',
    'Truck',
    'Sports Car',
    'Convertible',
    'Coupe',
    'Wagon',
    'Van',
    'Pickup',
  ];

  final List<String> fuelTypes = [
    'Petrol',
    'Diesel',
    'Hybrid',
    'Electric',
    'CNG',
    'LPG',
  ];

  final List<String> transmissions = [
    'Manual',
    'Automatic',
    'CVT',
    'Semi-Automatic',
  ];

  final List<String> conditions = [
    'Brand New',
    'Used - Excellent',
    'Used - Good',
    'Used - Fair',
    'Used - Needs Work',
  ];

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    _titleController = TextEditingController(
      text: widget.carData['title'] ?? '',
    );
    _priceController = TextEditingController(
      text: widget.carData['price']?.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.carData['description'] ?? '',
    );
    _yearController = TextEditingController(
      text: widget.carData['year']?.toString() ?? '',
    );
    _mileageController = TextEditingController(
      text: widget.carData['mileage']?.toString() ?? '',
    );

    selectedCategory = widget.carData['category'] ?? 'Sedan';
    selectedFuelType = widget.carData['fuel'] ?? 'Petrol';
    selectedTransmission = widget.carData['transmission'] ?? 'Manual';
    selectedCondition = widget.carData['condition'] ?? 'Used - Good';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _yearController.dispose();
    _mileageController.dispose();
    super.dispose();
  }

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
          'Edit Listing',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.edit, color: Color(0xFFFFB347), size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Update your listing details to keep it accurate',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Car Title
              _buildInputField(
                'Car Title *',
                _titleController,
                'e.g., Honda Civic VTi Oriel Prosmatec',
                icon: Icons.title,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Price
              _buildInputField(
                'Price (PKR) *',
                _priceController,
                'e.g., 3500000',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Price is required';
                  }
                  final price = int.tryParse(value);
                  if (price == null || price <= 0) {
                    return 'Enter a valid price';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Category
              _buildDropdownField(
                'Category *',
                selectedCategory,
                categories,
                Icons.category,
                (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              // Year and Mileage
              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      'Year *',
                      _yearController,
                      '2020',
                      icon: Icons.calendar_today,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        final year = int.tryParse(value);
                        if (year == null ||
                            year < 1900 ||
                            year > DateTime.now().year + 1) {
                          return 'Invalid year';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInputField(
                      'Mileage (km) *',
                      _mileageController,
                      '50000',
                      icon: Icons.speed,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        final mileage = int.tryParse(value);
                        if (mileage == null || mileage < 0) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Fuel Type and Transmission
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownField(
                      'Fuel Type *',
                      selectedFuelType,
                      fuelTypes,
                      Icons.local_gas_station,
                      (value) {
                        setState(() {
                          selectedFuelType = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdownField(
                      'Transmission *',
                      selectedTransmission,
                      transmissions,
                      Icons.settings,
                      (value) {
                        setState(() {
                          selectedTransmission = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Condition
              _buildDropdownField(
                'Condition *',
                selectedCondition,
                conditions,
                Icons.grade,
                (value) {
                  setState(() {
                    selectedCondition = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              // Description
              _buildInputField(
                'Description *',
                _descriptionController,
                'Describe the car\'s condition, features, service history, etc.',
                icon: Icons.description,
                maxLines: 6,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Description is required';
                  }
                  if (value.trim().length < 50) {
                    return 'Please provide a detailed description (min 50 characters)';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 40),

              // Update Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updateListing,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB347),
                    foregroundColor: const Color(0xFF1A1A1A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Color(0xFF1A1A1A),
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Update Listing',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    String hint, {
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            prefixIcon: icon != null
                ? Icon(icon, color: const Color(0xFFFFB347), size: 20)
                : null,
            filled: true,
            fillColor: const Color(0xFF2C2C2C),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFFFB347), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    String value,
    List<String> items,
    IconData icon,
    void Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2C),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            dropdownColor: const Color(0xFF2C2C2C),
            isExpanded: true,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: const Color(0xFFFFB347), size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            style: const TextStyle(color: Colors.white, fontSize: 14),
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.white.withOpacity(0.7),
            ),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item, overflow: TextOverflow.ellipsis, maxLines: 1),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Future<void> _updateListing() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final carId = widget.carData['id'];
      final oldPrice = widget.carData['price'];
      final newPrice = int.parse(_priceController.text.trim());

      // Build updates map for additional fields not in updateCar method
      Map<String, dynamic> updates = {
        'title': _titleController.text.trim(),
        'price': newPrice,
        'description': _descriptionController.text.trim(),
        'year': int.parse(_yearController.text.trim()),
        'mileage': int.parse(_mileageController.text.trim()),
        'category': selectedCategory,
        'fuel': selectedFuelType,
        'transmission': selectedTransmission,
        'condition': selectedCondition,
      };

      // Update in Firestore
      await _firestore.collection('cars').doc(carId).update(updates);

      // If price changed, trigger price monitoring for alerts
      if (oldPrice != newPrice) {
        print('Price changed from $oldPrice to $newPrice for car $carId');
        await _firestoreHelper.updateCar(carId: carId, price: newPrice);
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Listing updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating listing: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
}
