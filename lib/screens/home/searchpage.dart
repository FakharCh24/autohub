import 'package:autohub/screens/home/browse/compare_cars.dart';
import 'package:autohub/screens/home/car_detail_page.dart';
import 'package:autohub/screens/home/filter/advanced_filter_screen.dart';
import 'package:autohub/screens/home/search_result_page.dart';
import 'package:autohub/helper/firestore_helper.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FirestoreHelper _firestoreHelper = FirestoreHelper.instance;
  String selectedCategory = 'All';
  RangeValues priceRange = const RangeValues(0, 10000000);
  String selectedFuel = 'All';
  String selectedTransmission = 'All';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        appBar: AppBar(
          backgroundColor: const Color(0xFF2C2C2C),
          elevation: 0,
          title: const Text(
            'Search Cars',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdvancedFilterScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.tune, color: Color(0xFFFFB347)),
              tooltip: 'Advanced Filters',
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CompareCars()),
                );
              },
              icon: const Icon(Icons.compare_arrows, color: Color(0xFFFFB347)),
              tooltip: 'Compare Cars',
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search cars, brands, models...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    prefixIcon: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      onPressed: () {
                        if (_searchController.text.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchResultPage(
                                searchQuery: _searchController.text,
                                category: selectedCategory,
                                priceRange: priceRange,
                                fuelType: selectedFuel,
                                transmission: selectedTransmission,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                            icon: Icon(
                              Icons.clear,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchResultPage(
                            searchQuery: value,
                            category: selectedCategory,
                            priceRange: priceRange,
                            fuelType: selectedFuel,
                            transmission: selectedTransmission,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),

            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryChip('All'),
                  _buildCategoryChip('SUV'),
                  _buildCategoryChip('Sedan'),
                  _buildCategoryChip('Hatchback'),
                  _buildCategoryChip('Truck'),
                  _buildCategoryChip('Sports'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Search Button
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: ElevatedButton.icon(
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => SearchResultPage(
            //             searchQuery: _searchController.text,
            //             category: selectedCategory,
            //             priceRange: priceRange,
            //             fuelType: selectedFuel,
            //             transmission: selectedTransmission,
            //           ),
            //         ),
            //       );
            //     },
            //     icon: const Icon(Icons.search, color: Colors.white),
            //     label: const Text(
            //       'Search with Filters',
            //       style: TextStyle(
            //         color: Colors.white,
            //         fontWeight: FontWeight.bold,
            //         fontSize: 16,
            //       ),
            //     ),
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: const Color(0xFFFFB347),
            //       padding: const EdgeInsets.symmetric(vertical: 16),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //       elevation: 4,
            //       shadowColor: const Color(0xFFFFB347).withOpacity(0.5),
            //     ),
            //   ),
            // ),

            // const SizedBox(height: 20),

            // Search Results - Show all cars from Firestore
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
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final cars = snapshot.data ?? [];

                  if (cars.isEmpty) {
                    return const Center(
                      child: Text(
                        'No cars available',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: cars.length,
                    itemBuilder: (context, index) {
                      return _buildSearchResultCard(cars[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    bool isSelected = selectedCategory == category;
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: FilterChip(
        label: Text(
          category,
          style: TextStyle(
            color: isSelected ? const Color(0xFF1A1A1A) : Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        selected: isSelected,
        selectedColor: const Color(0xFFFFB347),
        backgroundColor: const Color(0xFF2C2C2C),
        side: BorderSide(
          color: isSelected
              ? const Color(0xFFFFB347)
              : Colors.white.withOpacity(0.3),
        ),
        onSelected: (selected) {
          setState(() {
            selectedCategory = category;
          });
        },
      ),
    );
  }

  Widget _buildSearchResultCard(Map<String, dynamic> carData) {
    // Extract data from Firestore document
    final imageUrl = (carData['imageUrls'] as List?)?.isNotEmpty == true
        ? carData['imageUrls'][0]
        : 'assets/images/car1.jpg';

    var car = {
      'id': carData['id'],
      'name': carData['title'] ?? 'Unknown Car',
      'price': 'Rs ${carData['price'] ?? 0}',
      'location': carData['location'] ?? 'Unknown',
      'year': '${carData['year'] ?? 'N/A'}',
      'fuel': carData['fuel'] ?? 'N/A',
      'mileage': '${carData['mileage'] ?? 0} km',
      'image': imageUrl,
    };

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CarDetailPage(
              carName: car['name'],
              price: car['price'],
              location: car['location'],
              image: car['image'],
              specs: '${car['fuel']} • ${car['year']} • ${car['mileage']}',
              carId: carData['id'],
              sellerId: carData['userId'],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
              child: car['image'].startsWith('http')
                  ? Image.network(
                      car['image'],
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 120,
                          height: 120,
                          color: Colors.grey.withOpacity(0.3),
                          child: const Icon(
                            Icons.car_rental,
                            color: Colors.white54,
                          ),
                        );
                      },
                    )
                  : Image.asset(
                      car['image'],
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 120,
                          height: 120,
                          color: Colors.grey.withOpacity(0.3),
                          child: const Icon(
                            Icons.car_rental,
                            color: Colors.white54,
                          ),
                        );
                      },
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      car['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      car['price'],
                      style: const TextStyle(
                        color: Color(0xFFFFB347),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          car['year'],
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.local_gas_station,
                          size: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          car['fuel'],
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          car['location'],
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () async {
                  final carId = carData['id'];
                  if (carId != null) {
                    // Check if already favorite
                    final isFav = await _firestoreHelper.isCarFavorite(carId);
                    if (isFav) {
                      await _firestoreHelper.removeFromFavorites(carId);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Removed from favorites'),
                            backgroundColor: Colors.orange,
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    } else {
                      await _firestoreHelper.addToFavorites(carId);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Added to favorites'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    }
                  }
                },
                icon: const Icon(
                  Icons.favorite_border,
                  color: Color(0xFFFFB347),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
