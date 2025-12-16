import 'package:flutter/material.dart';

class AdvancedFilterScreen extends StatefulWidget {
  const AdvancedFilterScreen({super.key});

  @override
  State<AdvancedFilterScreen> createState() => _AdvancedFilterScreenState();
}

class _AdvancedFilterScreenState extends State<AdvancedFilterScreen> {
  RangeValues _priceRange = const RangeValues(0, 20000000);
  RangeValues _yearRange = const RangeValues(2000, 2024);
  RangeValues _mileageRange = const RangeValues(0, 200000);

  List<String> selectedBrands = [];
  List<String> selectedCategories = [];
  List<String> selectedFuelTypes = [];
  List<String> selectedTransmissions = [];
  List<String> selectedColors = [];

  bool registeredOnly = false;
  bool negotiableOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2C2C),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: Colors.white),
        ),
        title: const Text(
          'Advanced Filters',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child: const Text(
              'Reset',
              style: TextStyle(color: Color(0xFFFFB347)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Price Range (PKR)'),
                  _buildRangeSlider(
                    _priceRange,
                    0,
                    20000000,
                    (values) => setState(() => _priceRange = values),
                  ),
                  _buildRangeLabels(
                    '${_priceRange.start.toInt()}',
                    '${_priceRange.end.toInt()}',
                  ),

                  const SizedBox(height: 24),

                  // Year Range
                  _buildSectionHeader('Year'),
                  _buildRangeSlider(
                    _yearRange,
                    2000,
                    2024,
                    (values) => setState(() => _yearRange = values),
                  ),
                  _buildRangeLabels(
                    '${_yearRange.start.toInt()}',
                    '${_yearRange.end.toInt()}',
                  ),

                  const SizedBox(height: 24),

                  // Mileage Range
                  _buildSectionHeader('Mileage (km)'),
                  _buildRangeSlider(
                    _mileageRange,
                    0,
                    200000,
                    (values) => setState(() => _mileageRange = values),
                  ),
                  _buildRangeLabels(
                    '${_mileageRange.start.toInt()}',
                    '${_mileageRange.end.toInt()}',
                  ),

                  const SizedBox(height: 24),

                  // Categories
                  _buildSectionHeader('Category'),
                  Wrap(
                    spacing: 8,
                    children: ['Sedan', 'SUV', 'Hatchback', 'Coupe', 'Pickup']
                        .map((category) {
                          return FilterChip(
                            label: Text(category),
                            selected: selectedCategories.contains(category),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedCategories.add(category);
                                } else {
                                  selectedCategories.remove(category);
                                }
                              });
                            },
                            backgroundColor: const Color(0xFF2C2C2C),
                            selectedColor: const Color(0xFFFFB347),
                            labelStyle: TextStyle(
                              color: selectedCategories.contains(category)
                                  ? const Color(0xFF1A1A1A)
                                  : Colors.white,
                            ),
                          );
                        })
                        .toList(),
                  ),

                  const SizedBox(height: 24),

                  // Fuel Types
                  _buildSectionHeader('Fuel Type'),
                  Wrap(
                    spacing: 8,
                    children: ['Petrol', 'Diesel', 'Electric', 'Hybrid'].map((
                      fuel,
                    ) {
                      return FilterChip(
                        label: Text(fuel),
                        selected: selectedFuelTypes.contains(fuel),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedFuelTypes.add(fuel);
                            } else {
                              selectedFuelTypes.remove(fuel);
                            }
                          });
                        },
                        backgroundColor: const Color(0xFF2C2C2C),
                        selectedColor: const Color(0xFFFFB347),
                        labelStyle: TextStyle(
                          color: selectedFuelTypes.contains(fuel)
                              ? const Color(0xFF1A1A1A)
                              : Colors.white,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Transmission
                  _buildSectionHeader('Transmission'),
                  Wrap(
                    spacing: 8,
                    children: ['Automatic', 'Manual', 'CVT'].map((trans) {
                      return FilterChip(
                        label: Text(trans),
                        selected: selectedTransmissions.contains(trans),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedTransmissions.add(trans);
                            } else {
                              selectedTransmissions.remove(trans);
                            }
                          });
                        },
                        backgroundColor: const Color(0xFF2C2C2C),
                        selectedColor: const Color(0xFFFFB347),
                        labelStyle: TextStyle(
                          color: selectedTransmissions.contains(trans)
                              ? const Color(0xFF1A1A1A)
                              : Colors.white,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Additional Filters
                  _buildSectionHeader('Additional Filters'),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2C),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        SwitchListTile(
                          value: registeredOnly,
                          onChanged: (value) =>
                              setState(() => registeredOnly = value),
                          title: const Text(
                            'Registered Only',
                            style: TextStyle(color: Colors.white),
                          ),
                          activeColor: const Color(0xFFFFB347),
                        ),
                        Divider(
                          height: 1,
                          color: Colors.white.withOpacity(0.1),
                        ),
                        SwitchListTile(
                          value: negotiableOnly,
                          onChanged: (value) =>
                              setState(() => negotiableOnly = value),
                          title: const Text(
                            'Negotiable Only',
                            style: TextStyle(color: Colors.white),
                          ),
                          activeColor: const Color(0xFFFFB347),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Apply Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2C),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFFFB347),
                      side: const BorderSide(color: Color(0xFFFFB347)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Save Search'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB347),
                      foregroundColor: const Color(0xFF1A1A1A),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFFFB347),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRangeSlider(
    RangeValues values,
    double min,
    double max,
    Function(RangeValues) onChanged,
  ) {
    return RangeSlider(
      values: values,
      min: min,
      max: max,
      activeColor: const Color(0xFFFFB347),
      inactiveColor: Colors.white24,
      onChanged: onChanged,
    );
  }

  Widget _buildRangeLabels(String min, String max) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            min,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          Text(
            max,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _priceRange = const RangeValues(0, 20000000);
      _yearRange = const RangeValues(2000, 2024);
      _mileageRange = const RangeValues(0, 200000);
      selectedBrands.clear();
      selectedCategories.clear();
      selectedFuelTypes.clear();
      selectedTransmissions.clear();
      selectedColors.clear();
      registeredOnly = false;
      negotiableOnly = false;
    });
  }

  void _applyFilters() {
    // Create a map with all filter data
    final filterData = {
      'priceRange': _priceRange,
      'yearRange': _yearRange,
      'mileageRange': _mileageRange,
      'categories': selectedCategories,
      'fuelTypes': selectedFuelTypes,
      'transmissions': selectedTransmissions,
      'colors': selectedColors,
      'registeredOnly': registeredOnly,
      'negotiableOnly': negotiableOnly,
    };

    // Return filter data to the previous screen
    Navigator.pop(context, filterData);
  }
}
