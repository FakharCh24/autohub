import 'dart:convert';
import 'package:autohub/helper/db_helper.dart';
import 'package:autohub/screens/home/car_detail_page.dart';
import 'package:flutter/material.dart';

class SearchResultPage extends StatefulWidget {
  final String searchQuery;
  final String? category;
  final RangeValues? priceRange;
  final String? fuelType;
  final String? transmission;
  final int? minYear;
  final int? maxYear;
  final int? maxMileage;

  const SearchResultPage({
    super.key,
    required this.searchQuery,
    this.category,
    this.priceRange,
    this.fuelType,
    this.transmission,
    this.minYear,
    this.maxYear,
    this.maxMileage,
  });

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = true;
  String sortBy = 'newest'; // newest, price_low, price_high, mileage

  @override
  void initState() {
    super.initState();
    _loadSearchResults();
  }

  Future<void> _loadSearchResults() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Get all cars from database
      List<Map<String, dynamic>> allCars = await DbHelper.getInstance.getCars();
      List<Map<String, dynamic>> filtered = allCars.where((car) {
        if (widget.searchQuery.isNotEmpty) {
          String query = widget.searchQuery.toLowerCase();
          String title = (car[DbHelper.COLUMN_TITLE] ?? '')
              .toString()
              .toLowerCase();
          String category = (car[DbHelper.COLUMN_CATEGORY] ?? '')
              .toString()
              .toLowerCase();

          if (!title.contains(query) && !category.contains(query)) {
            return false;
          }
        }
        if (widget.category != null && widget.category != 'All') {
          if (car[DbHelper.COLUMN_CATEGORY] != widget.category) {
            return false;
          }
        }
        if (widget.priceRange != null) {
          int price = car[DbHelper.COLUMN_PRICE] ?? 0;
          if (price < widget.priceRange!.start ||
              price > widget.priceRange!.end) {
            return false;
          }
        }
        if (widget.fuelType != null && widget.fuelType != 'All') {
          if (car[DbHelper.COLUMN_FUEL] != widget.fuelType) {
            return false;
          }
        }
        if (widget.transmission != null && widget.transmission != 'All') {
          if (car[DbHelper.COLUMN_TRANSMISSION] != widget.transmission) {
            return false;
          }
        }
        if (widget.minYear != null) {
          int year = car[DbHelper.COLUMN_YEAR] ?? 0;
          if (year < widget.minYear!) {
            return false;
          }
        }

        if (widget.maxYear != null) {
          int year = car[DbHelper.COLUMN_YEAR] ?? 0;
          if (year > widget.maxYear!) {
            return false;
          }
        }
        if (widget.maxMileage != null) {
          int mileage = car[DbHelper.COLUMN_MILEAGE] ?? 0;
          if (mileage > widget.maxMileage!) {
            return false;
          }
        }

        return true;
      }).toList();

      _sortResults(filtered);

      setState(() {
        searchResults = filtered;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading search results: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _sortResults(List<Map<String, dynamic>> results) {
    switch (sortBy) {
      case 'price_low':
        results.sort(
          (a, b) => (a[DbHelper.COLUMN_PRICE] ?? 0).compareTo(
            b[DbHelper.COLUMN_PRICE] ?? 0,
          ),
        );
        break;
      case 'price_high':
        results.sort(
          (a, b) => (b[DbHelper.COLUMN_PRICE] ?? 0).compareTo(
            a[DbHelper.COLUMN_PRICE] ?? 0,
          ),
        );
        break;
      case 'mileage':
        results.sort(
          (a, b) => (a[DbHelper.COLUMN_MILEAGE] ?? 0).compareTo(
            b[DbHelper.COLUMN_MILEAGE] ?? 0,
          ),
        );
        break;
      case 'newest':
      default:
        results.sort(
          (a, b) => (b[DbHelper.COLUMN_YEAR] ?? 0).compareTo(
            a[DbHelper.COLUMN_YEAR] ?? 0,
          ),
        );
        break;
    }
  }

  List<String> _parseImages(String? imagesJson) {
    if (imagesJson == null || imagesJson.isEmpty) {
      return [];
    }
    try {
      final decoded = jsonDecode(imagesJson);
      if (decoded is List) {
        return decoded.cast<String>();
      }
    } catch (e) {
      print('Error parsing images: $e');
    }
    return [];
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Search Results',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            if (widget.searchQuery.isNotEmpty)
              Text(
                '"${widget.searchQuery}"',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Row(
              children: [
                Icon(Icons.sort, color: Colors.white.withOpacity(0.9)),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white.withOpacity(0.9),
                ),
              ],
            ),
            color: const Color(0xFF2C2C2C),
            onSelected: (value) {
              setState(() {
                sortBy = value;
                _sortResults(searchResults);
              });
            },
            itemBuilder: (BuildContext context) => [
              _buildSortMenuItem('Newest First', 'newest'),
              _buildSortMenuItem('Price: Low to High', 'price_low'),
              _buildSortMenuItem('Price: High to Low', 'price_high'),
              _buildSortMenuItem('Lowest Mileage', 'mileage'),
            ],
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFB347)),
            )
          : searchResults.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                // Results count and filters summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2C),
                    border: Border(
                      bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${searchResults.length} ',
                            style: const TextStyle(
                              color: Color(0xFFFFB347),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            searchResults.length == 1
                                ? 'car found'
                                : 'cars found',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      if (_hasActiveFilters())
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFB347).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFFFB347)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.filter_list,
                                color: Color(0xFFFFB347),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Filtered',
                                style: const TextStyle(
                                  color: Color(0xFFFFB347),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                // Results list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      return _buildCarCard(searchResults[index]);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  bool _hasActiveFilters() {
    return (widget.category != null && widget.category != 'All') ||
        widget.priceRange != null ||
        (widget.fuelType != null && widget.fuelType != 'All') ||
        (widget.transmission != null && widget.transmission != 'All') ||
        widget.minYear != null ||
        widget.maxYear != null ||
        widget.maxMileage != null;
  }

  PopupMenuItem<String> _buildSortMenuItem(String label, String value) {
    bool isSelected = sortBy == value;
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(
            isSelected
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: isSelected ? const Color(0xFFFFB347) : Colors.white54,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFFFFB347) : Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFFFB347).withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.search_off,
                size: 80,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Cars Found',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'We couldn\'t find any cars matching your criteria.\nTry adjusting your filters or search terms.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Different Search'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB347),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
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

  Widget _buildCarCard(Map<String, dynamic> car) {
    List<String> images = _parseImages(car[DbHelper.COLUMN_IMAGES]);
    String displayImage = images.isNotEmpty ? images[0] : '';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CarDetailPage(
              carName: car[DbHelper.COLUMN_TITLE] ?? 'Unknown',
              price: 'Rs ${_formatPrice(car[DbHelper.COLUMN_PRICE] ?? 0)}',
              location: 'Pakistan',
              image: displayImage.isNotEmpty
                  ? displayImage
                  : 'assets/images/car1.jpg',
              specs:
                  '${car[DbHelper.COLUMN_FUEL]} • ${car[DbHelper.COLUMN_YEAR]} • ${_formatMileage(car[DbHelper.COLUMN_MILEAGE] ?? 0)}',
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: displayImage.isNotEmpty
                      ? Image.network(
                          displayImage,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholderImage();
                          },
                        )
                      : _buildPlaceholderImage(),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB347),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      car[DbHelper.COLUMN_CONDITION] ?? 'Used',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.image, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '${images.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Car Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          car[DbHelper.COLUMN_TITLE] ?? 'Unknown',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Color(0xFFFFB347),
                        ),
                        onPressed: () {
                          // Add to favorites functionality
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rs ${_formatPrice(car[DbHelper.COLUMN_PRICE] ?? 0)}',
                    style: const TextStyle(
                      color: Color(0xFFFFB347),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Specs Row
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      _buildSpecChip(
                        Icons.calendar_today,
                        car[DbHelper.COLUMN_YEAR]?.toString() ?? 'N/A',
                      ),
                      _buildSpecChip(
                        Icons.speed,
                        _formatMileage(car[DbHelper.COLUMN_MILEAGE] ?? 0),
                      ),
                      _buildSpecChip(
                        Icons.local_gas_station,
                        car[DbHelper.COLUMN_FUEL] ?? 'N/A',
                      ),
                      _buildSpecChip(
                        Icons.settings,
                        car[DbHelper.COLUMN_TRANSMISSION] ?? 'N/A',
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Category Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB347).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFFFB347).withOpacity(0.5),
                      ),
                    ),
                    child: Text(
                      car[DbHelper.COLUMN_CATEGORY] ?? 'Car',
                      style: const TextStyle(
                        color: Color(0xFFFFB347),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
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

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF2C2C2C), const Color(0xFF1A1A1A)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_car,
            size: 60,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 8),
          Text(
            'No Image',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.white.withOpacity(0.7)),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
        ),
      ],
    );
  }

  String _formatPrice(int price) {
    if (price >= 10000000) {
      return '${(price / 10000000).toStringAsFixed(2)} Cr';
    } else if (price >= 100000) {
      return '${(price / 100000).toStringAsFixed(2)} Lac';
    } else {
      return price.toString();
    }
  }

  String _formatMileage(int mileage) {
    if (mileage >= 1000) {
      return '${(mileage / 1000).toStringAsFixed(0)}k km';
    }
    return '$mileage km';
  }
}
