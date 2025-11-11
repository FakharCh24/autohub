import 'package:flutter/material.dart';

class SellCarStep1 extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const SellCarStep1({super.key, this.initialData});

  @override
  State<SellCarStep1> createState() => _SellCarStep1State();
}

class _SellCarStep1State extends State<SellCarStep1> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();

  String selectedCategory = 'Sedan';
  String selectedFuelType = 'Petrol';
  String selectedTransmission = 'Manual';
  String selectedCondition = 'Used - Good';
  String selectedColor = 'White';

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

  final List<String> colors = [
    'White',
    'Black',
    'Silver',
    'Grey',
    'Red',
    'Blue',
    'Green',
    'Yellow',
    'Orange',
    'Brown',
    'Gold',
    'Beige',
    'Purple',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _titleController.text = widget.initialData!['title'] ?? '';
      _brandController.text = widget.initialData!['brand'] ?? '';
      _modelController.text = widget.initialData!['model'] ?? '';
      _yearController.text = widget.initialData!['year']?.toString() ?? '';
      _mileageController.text =
          widget.initialData!['mileage']?.toString() ?? '';
      selectedCategory = widget.initialData!['category'] ?? 'Sedan';
      selectedFuelType = widget.initialData!['fuelType'] ?? 'Petrol';
      selectedTransmission = widget.initialData!['transmission'] ?? 'Manual';
      selectedCondition = widget.initialData!['condition'] ?? 'Used - Good';
      selectedColor = widget.initialData!['color'] ?? 'White';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _brandController.dispose();
    _modelController.dispose();
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
          'Step 1: Basic Information',
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
              // Progress Indicator
              _buildProgressIndicator(1, 3),

              const SizedBox(height: 24),

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
                    const Icon(
                      Icons.info_outline,
                      color: Color(0xFFFFB347),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Provide accurate details to attract serious buyers',
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
              ),

              const SizedBox(height: 20),

              // Brand and Model
              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      'Brand *',
                      _brandController,
                      'e.g., Honda',
                      icon: Icons.branding_watermark,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInputField(
                      'Model *',
                      _modelController,
                      'e.g., Civic',
                      icon: Icons.car_rental,
                    ),
                  ),
                ],
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

              // Condition and Color
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownField(
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
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdownField(
                      'Color *',
                      selectedColor,
                      colors,
                      Icons.palette,
                      (value) {
                        setState(() {
                          selectedColor = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Next Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _onNextPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB347),
                    foregroundColor: const Color(0xFF1A1A1A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Next: Upload Photos',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
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

  Widget _buildProgressIndicator(int currentStep, int totalSteps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step $currentStep of $totalSteps',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(totalSteps, (index) {
            final isActive = index < currentStep;
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: index < totalSteps - 1 ? 8 : 0),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFFFFB347)
                      : Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    String hint, {
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 14,
            ),
            prefixIcon: icon != null
                ? Icon(icon, color: Colors.white.withOpacity(0.5), size: 20)
                : null,
            filled: true,
            fillColor: const Color(0xFF2C2C2C),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFFFB347), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.redAccent, width: 2),
            ),
          ),
          validator:
              validator ??
              (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
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
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: Colors.white.withOpacity(0.5),
              size: 20,
            ),
            filled: true,
            fillColor: const Color(0xFF2C2C2C),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFFFB347), width: 2),
            ),
          ),
          dropdownColor: const Color(0xFF2C2C2C),
          style: const TextStyle(color: Colors.white, fontSize: 14),
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.white.withOpacity(0.7),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, overflow: TextOverflow.ellipsis, maxLines: 1),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _onNextPressed() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'title': _titleController.text.trim(),
        'brand': _brandController.text.trim(),
        'model': _modelController.text.trim(),
        'year': int.parse(_yearController.text.trim()),
        'mileage': int.parse(_mileageController.text.trim()),
        'category': selectedCategory,
        'fuelType': selectedFuelType,
        'transmission': selectedTransmission,
        'condition': selectedCondition,
        'color': selectedColor,
      };

      Navigator.pop(context, data);
    }
  }
}
