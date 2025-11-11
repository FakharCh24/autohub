import 'package:flutter/material.dart';

class SellCarStep3 extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const SellCarStep3({super.key, this.initialData});

  @override
  State<SellCarStep3> createState() => _SellCarStep3State();
}

class _SellCarStep3State extends State<SellCarStep3> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _engineController = TextEditingController();
  final TextEditingController _featuresController = TextEditingController();

  String selectedCity = 'Lahore';
  bool isNegotiable = true;
  bool isRegistered = true;

  final List<String> cities = [
    'Lahore',
    'Karachi',
    'Islamabad',
    'Rawalpindi',
    'Faisalabad',
    'Multan',
    'Peshawar',
    'Quetta',
    'Sialkot',
    'Gujranwala',
    'Hyderabad',
    'Bahawalpur',
    'Sargodha',
    'Sukkur',
    'Larkana',
    'Abbottabad',
    'Mardan',
    'Mingora',
    'Rahim Yar Khan',
    'Sahiwal',
    'Okara',
    'Wah Cantonment',
    'Dera Ghazi Khan',
    'Mirpur Khas',
    'Nawabshah',
    'Kohat',
    'Jhang',
    'Gujrat',
    'Sheikhupura',
    'Kasur',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _priceController.text = widget.initialData!['price']?.toString() ?? '';
      _descriptionController.text = widget.initialData!['description'] ?? '';
      _locationController.text = widget.initialData!['location'] ?? '';
      _engineController.text = widget.initialData!['engine'] ?? '';
      _featuresController.text = widget.initialData!['features'] ?? '';
      selectedCity = widget.initialData!['city'] ?? 'Lahore';
      isNegotiable = widget.initialData!['isNegotiable'] ?? true;
      isRegistered = widget.initialData!['isRegistered'] ?? true;
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _engineController.dispose();
    _featuresController.dispose();
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
          'Step 3: Price & Details',
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
              _buildProgressIndicator(3, 3),

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
                      Icons.attach_money,
                      color: Color(0xFFFFB347),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Set a competitive price to attract buyers faster',
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

              // Price Section
              const Text(
                'Pricing',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              _buildInputField(
                'Asking Price (PKR) *',
                _priceController,
                'e.g., 2500000',
                icon: Icons.payments,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Price is required';
                  }
                  final price = int.tryParse(value);
                  if (price == null || price <= 0) {
                    return 'Enter a valid price';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Negotiable Toggle
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.handshake,
                          color: Colors.white.withOpacity(0.7),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Price Negotiable',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: isNegotiable,
                      onChanged: (value) {
                        setState(() {
                          isNegotiable = value;
                        });
                      },
                      activeColor: const Color(0xFFFFB347),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Location Section
              const Text(
                'Location',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              _buildDropdownField(
                'City *',
                selectedCity,
                cities,
                Icons.location_city,
                (value) {
                  setState(() {
                    selectedCity = value!;
                  });
                },
              ),

              const SizedBox(height: 16),

              _buildInputField(
                'Specific Location (Optional)',
                _locationController,
                'e.g., DHA Phase 5, Johar Town',
                icon: Icons.location_on,
              ),

              const SizedBox(height: 32),

              // Description Section
              const Text(
                'Car Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              _buildInputField(
                'Engine Capacity (CC)',
                _engineController,
                'e.g., 1800',
                icon: Icons.speed,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 16),

              // Registered Toggle
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.verified,
                          color: Colors.white.withOpacity(0.7),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Car is Registered',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: isRegistered,
                      onChanged: (value) {
                        setState(() {
                          isRegistered = value;
                        });
                      },
                      activeColor: const Color(0xFFFFB347),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _buildInputField(
                'Features & Description *',
                _descriptionController,
                'Describe the car\'s condition, features, service history, modifications, etc.',
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

              const SizedBox(height: 16),

              _buildInputField(
                'Special Features (Optional)',
                _featuresController,
                'e.g., Sunroof, Leather Seats, Navigation System, Parking Sensors',
                icon: Icons.star,
                maxLines: 3,
              ),

              const SizedBox(height: 40),

              // Navigation Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Back',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _onNextPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFB347),
                        foregroundColor: const Color(0xFF1A1A1A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Preview Listing',
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
                ],
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
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
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
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 16 : 16,
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
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: value,
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
          style: const TextStyle(color: Colors.white, fontSize: 15),
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.white.withOpacity(0.7),
          ),
          isExpanded: true,
          menuMaxHeight: 300,
          items: items.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _onNextPressed() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'price': int.parse(_priceController.text.trim()),
        'description': _descriptionController.text.trim(),
        'location': _locationController.text.trim(),
        'city': selectedCity,
        'engine': _engineController.text.trim(),
        'features': _featuresController.text.trim(),
        'isNegotiable': isNegotiable,
        'isRegistered': isRegistered,
      };

      Navigator.pop(context, data);
    }
  }
}
