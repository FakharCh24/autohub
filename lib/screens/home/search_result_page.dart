import 'package:autohub/helper/firestore_helper.dart';
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
  final FirestoreHelper _firestoreHelper = FirestoreHelper.instance;
  List<Map<String, dynamic>> searchResults = [];
  Set<String> favoritedCarIds = {};
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
      // Get cars from Firestore with filters
      List<Map<String, dynamic>> filtered = await _firestoreHelper.searchCars(
        query: widget.searchQuery,
        category: widget.category,
        minPrice: widget.priceRange?.start.toInt(),
        maxPrice: widget.priceRange?.end.toInt(),
        fuel: widget.fuelType,
        transmission: widget.transmission,
      );

      // Apply additional filters
      if (widget.minYear != null) {
        filtered = filtered.where((car) {
          int year = car['year'] ?? 0;
          return year >= widget.minYear!;
        }).toList();
      }

      if (widget.maxYear != null) {
        filtered = filtered.where((car) {
          int year = car['year'] ?? 0;
          return year <= widget.maxYear!;
        }).toList();
      }

      if (widget.maxMileage != null) {
        filtered = filtered.where((car) {
          int mileage = car['mileage'] ?? 0;
          return mileage <= widget.maxMileage!;
        }).toList();
      }

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
        results.sort((a, b) => (a['price'] ?? 0).compareTo(b['price'] ?? 0));
        break;
      case 'price_high':
        results.sort((a, b) => (b['price'] ?? 0).compareTo(a['price'] ?? 0));
        break;
      case 'mileage':
        results.sort(
          (a, b) => (a['mileage'] ?? 0).compareTo(b['mileage'] ?? 0),
        );
        break;
      case 'newest':
      default:
        results.sort((a, b) => (b['year'] ?? 0).compareTo(a['year'] ?? 0));
        break;
    }
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
    List<String> images = List<String>.from(car['imageUrls'] ?? []);
    String displayImage = images.isNotEmpty ? images[0] : '';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CarDetailPage(
              carName: car['title'] ?? 'Unknown',
              price: 'Rs ${_formatPrice(car['price'] ?? 0)}',
              location: car['location'] ?? 'Pakistan',
              image: displayImage.isNotEmpty
                  ? displayImage
                  : 'assets/images/car1.jpg',
              specs:
                  '${car['fuel']} • ${car['year']} • ${_formatMileage(car['mileage'] ?? 0)}',
              carId: car['id'],
              sellerId: car['userId'],
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
                      car['condition'] ?? 'Used',
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
                          car['title'] ?? 'Unknown',
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
                        icon: Icon(
                          favoritedCarIds.contains(car['id'])
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: const Color(0xFFFFB347),
                        ),
                        onPressed: () async {
                          final carId = car['id'] ?? '';
                          if (carId.isEmpty) return;

                          setState(() {
                            if (favoritedCarIds.contains(carId)) {
                              favoritedCarIds.remove(carId);
                            } else {
                              favoritedCarIds.add(carId);
                            }
                          });

                          try {
                            if (favoritedCarIds.contains(carId)) {
                              await _firestoreHelper.addToFavorites(carId);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Added to favorites'),
                                    backgroundColor: Color(0xFFFFB347),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              }
                            } else {
                              await _firestoreHelper.removeFromFavorites(carId);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Removed from favorites'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              }
                            }
                          } catch (e) {
                            // Revert on error
                            setState(() {
                              if (favoritedCarIds.contains(carId)) {
                                favoritedCarIds.remove(carId);
                              } else {
                                favoritedCarIds.add(carId);
                              }
                            });
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rs ${_formatPrice(car['price'] ?? 0)}',
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
                        car['year']?.toString() ?? 'N/A',
                      ),
                      _buildSpecChip(
                        Icons.speed,
                        _formatMileage(car['mileage'] ?? 0),
                      ),
                      _buildSpecChip(
                        Icons.local_gas_station,
                        car['fuel'] ?? 'N/A',
                      ),
                      _buildSpecChip(
                        Icons.settings,
                        car['transmission'] ?? 'N/A',
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
                      car['category'] ?? 'Car',
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
