import 'package:flutter/material.dart';
import 'package:autohub/helper/firestore_helper.dart';

class CarSelectionDialog extends StatefulWidget {
  final List<Map<String, dynamic>> alreadySelected;

  const CarSelectionDialog({super.key, this.alreadySelected = const []});

  @override
  State<CarSelectionDialog> createState() => _CarSelectionDialogState();
}

class _CarSelectionDialogState extends State<CarSelectionDialog> {
  final FirestoreHelper _firestoreHelper = FirestoreHelper.instance;
  List<Map<String, dynamic>> _selectedCars = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedCars = List.from(widget.alreadySelected);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFFB347).withOpacity(0.3)),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF2C2C2C),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.compare_arrows, color: Color(0xFFFFB347)),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Select Cars to Compare',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search cars...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFFFFB347),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF2C2C2C),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Selected Count
            if (_selectedCars.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB347).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFFFB347).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xFFFFB347),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_selectedCars.length} car(s) selected',
                      style: const TextStyle(
                        color: Color(0xFFFFB347),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Car List
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _firestoreHelper.getAllCars(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFFB347),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 60,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading cars',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final cars = snapshot.data ?? [];

                  // Filter cars based on search query
                  final filteredCars = cars.where((car) {
                    if (_searchQuery.isEmpty) return true;
                    final title = (car['title'] ?? '').toString().toLowerCase();
                    final category = (car['category'] ?? '')
                        .toString()
                        .toLowerCase();
                    return title.contains(_searchQuery) ||
                        category.contains(_searchQuery);
                  }).toList();

                  if (filteredCars.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 60,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isEmpty
                                ? 'No cars available'
                                : 'No cars found',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredCars.length,
                    itemBuilder: (context, index) {
                      final car = filteredCars[index];
                      final isSelected = _selectedCars.any(
                        (selectedCar) => selectedCar['id'] == car['id'],
                      );

                      return _buildCarItem(car, isSelected);
                    },
                  );
                },
              ),
            ),

            // Action Buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
                border: Border(
                  top: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _selectedCars.clear();
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFFFB347),
                        side: const BorderSide(color: Color(0xFFFFB347)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Clear All'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _selectedCars.isEmpty
                          ? null
                          : () {
                              Navigator.pop(context, _selectedCars);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFB347),
                        foregroundColor: const Color(0xFF1A1A1A),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        disabledBackgroundColor: Colors.grey,
                      ),
                      child: Text(
                        _selectedCars.isEmpty
                            ? 'Select Cars'
                            : 'Add ${_selectedCars.length} Car(s)',
                        style: const TextStyle(fontWeight: FontWeight.bold),
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

  Widget _buildCarItem(Map<String, dynamic> car, bool isSelected) {
    final imageUrls = car['imageUrls'] as List<dynamic>?;
    final imageUrl = (imageUrls != null && imageUrls.isNotEmpty)
        ? imageUrls[0].toString()
        : '';

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedCars.removeWhere((c) => c['id'] == car['id']);
          } else {
            _selectedCars.add(car);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFFB347)
                : Colors.white.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Car Image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholderImage();
                      },
                    )
                  : _buildPlaceholderImage(),
            ),

            // Car Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      car['title'] ?? 'Unknown',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'PKR ${car['price']?.toString() ?? 'N/A'}',
                      style: const TextStyle(
                        color: Color(0xFFFFB347),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: Colors.white.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${car['year'] ?? 'N/A'}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.speed,
                          size: 12,
                          color: Colors.white.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${car['mileage'] ?? 'N/A'} km',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Checkbox
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isSelected
                    ? const Color(0xFFFFB347)
                    : Colors.white.withOpacity(0.3),
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 100,
      height: 100,
      color: const Color(0xFF1A1A1A),
      child: const Icon(Icons.car_rental, color: Colors.white54, size: 40),
    );
  }
}
