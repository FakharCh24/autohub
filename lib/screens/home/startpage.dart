import 'package:autohub/screens/home/browse/category_browse.dart';
import 'package:autohub/screens/home/browse/recommended_cars.dart';
import 'package:autohub/screens/home/browse/filtered_cars_page.dart';
import 'package:autohub/screens/home/car_detail_page.dart';
import 'package:autohub/screens/home/filter/advanced_filter_screen.dart';
import 'package:autohub/screens/notifications/notifications_center.dart';
import 'package:autohub/helper/firestore_helper.dart';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final FirestoreHelper _firestoreHelper = FirestoreHelper.instance;

  // Track selected state of quick filters
  bool isNewListingsSelected = true;
  bool isPriceDropSelected = true;
  bool isTopRatedSelected = false;
  bool isElectricSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: const Text(
          'AutoHub',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 26,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsCenter(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // 🔍 Search Bar
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color(0xFFFFB347).withOpacity(0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFB347).withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Search for your dream car...',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: const Color(0xFFFFB347).withOpacity(0.8),
                      size: 24,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdvancedFilterScreen(),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB347).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.tune,
                          color: Color(0xFFFFB347),
                          size: 20,
                        ),
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ⚡ Quick Filters
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Quick Filters',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RecommendedCars(),
                        ),
                      );
                    },
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFFB347),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip(
                      Icons.fiber_new,
                      "New Listings",
                      isNewListingsSelected,
                      () {
                        setState(() {
                          isNewListingsSelected = !isNewListingsSelected;
                        });
                      },
                    ),
                    const SizedBox(width: 12),
                    _buildFilterChip(
                      Icons.trending_down,
                      "Price Drop",
                      isPriceDropSelected,
                      () {
                        setState(() {
                          isPriceDropSelected = !isPriceDropSelected;
                        });
                      },
                    ),
                    const SizedBox(width: 12),
                    _buildFilterChip(
                      Icons.star_outline,
                      "Top Rated",
                      isTopRatedSelected,
                      () {
                        setState(() {
                          isTopRatedSelected = !isTopRatedSelected;
                        });
                      },
                    ),
                    const SizedBox(width: 12),
                    _buildFilterChip(
                      Icons.electric_car,
                      "Electric",
                      isElectricSelected,
                      () {
                        setState(() {
                          isElectricSelected = !isElectricSelected;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // 🚗 Browse Categories
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Browse Categories",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CategoryBrowse(),
                        ),
                      );
                    },
                    child: const Text(
                      "View All",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFFB347),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Category Grid
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
                children: [
                  _buildCategoryCard(
                    context,
                    Icons.directions_car,
                    "SUV",
                    false,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const FilteredCarsPage(category: 'SUV'),
                        ),
                      );
                    },
                  ),
                  _buildCategoryCard(
                    context,
                    Icons.car_rental,
                    "Sedan",
                    false,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const FilteredCarsPage(category: 'Sedan'),
                        ),
                      );
                    },
                  ),
                  _buildCategoryCard(
                    context,
                    Icons.airport_shuttle,
                    "Hatchback",
                    false,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const FilteredCarsPage(category: 'Hatchback'),
                        ),
                      );
                    },
                  ),
                  _buildCategoryCard(
                    context,
                    Icons.local_shipping,
                    "Truck",
                    false,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const FilteredCarsPage(category: 'Truck'),
                        ),
                      );
                    },
                  ),
                ],
              ),

              // const SizedBox(height: 10),

              // 🚘 Featured Cars
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Featured Cars',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Archivo_Condensed',
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Display cars from Firestore
                    StreamBuilder<List<Map<String, dynamic>>>(
                      stream: _firestoreHelper.getAllCars(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(
                                color: Color(0xFFFFB347),
                              ),
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                'Error loading cars: ${snapshot.error}',
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          );
                        }

                        final cars = snapshot.data ?? [];

                        if (cars.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                'No cars available',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: cars.map((car) {
                            final imageUrl =
                                (car['imageUrls'] as List?)?.isNotEmpty == true
                                ? car['imageUrls'][0]
                                : 'assets/images/car1.jpg';
                            final title = car['title'] ?? 'Unknown Car';
                            final price = 'Rs ${car['price'] ?? 0}';
                            final location = car['location'] ?? 'Unknown';
                            final transmission = car['transmission'] ?? 'N/A';
                            final fuel = car['fuel'] ?? 'N/A';
                            final year = car['year'] ?? 'N/A';
                            final specs = '$transmission • $fuel • $year';
                            final sellerId = car['userId'];
                            final carId = car['id'];

                            return FutureBuilder<bool>(
                              future: _firestoreHelper.isCarFavorite(carId),
                              builder: (context, favoriteSnapshot) {
                                final isFavorite =
                                    favoriteSnapshot.data ?? false;
                                return carCard(
                                  context,
                                  imageUrl,
                                  title,
                                  price,
                                  location,
                                  isFavorite,
                                  specs,
                                  carId: carId,
                                  sellerId: sellerId,
                                );
                              },
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Helper: Filter Chip
  Widget _buildFilterChip(
    IconData icon,
    String label,
    bool selected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  colors: [Color(0xFFFFB347), Color(0xFFFF8C42)],
                )
              : null,
          color: selected ? null : const Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? const Color(0xFFFFB347)
                : const Color(0xFFFFB347).withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFFB347).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: selected ? Colors.white : const Color(0xFFFFB347),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xFFFFB347),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Helper: Category Card
  Widget _buildCategoryCard(
    BuildContext context,
    IconData icon,
    String title,
    bool selected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFB347) : const Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: selected
                ? const Color(0xFFFFB347)
                : const Color(0xFFFFB347).withOpacity(0.3),
            width: selected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? const Color(0xFFFFB347).withOpacity(0.4)
                  : Colors.black.withOpacity(0.2),
              blurRadius: selected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withOpacity(0.2)
                    : const Color(0xFFFFB347).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: selected ? Colors.white : const Color(0xFFFFB347),
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: selected ? Colors.white : Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Helper: Car Card
  Widget carCard(
    BuildContext context,
    String image,
    String title,
    String price,
    String location,
    bool favorite,
    String specs, {
    String? carId,
    String? sellerId,
  }) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setCardState) {
        bool isFavorite = favorite;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CarDetailPage(
                  carName: title,
                  price: price,
                  location: location,
                  image: image,
                  specs: specs,
                  carId: carId,
                  sellerId: sellerId,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2C),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFFFB347).withOpacity(0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: image.startsWith('http')
                          ? Image.network(
                              image,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      height: 180,
                                      width: double.infinity,
                                      color: Colors.grey.withOpacity(0.3),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          value:
                                              loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                              : null,
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                Color
                                              >(Color(0xFFFFB347)),
                                        ),
                                      ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                print('Error loading image: $error');
                                return Container(
                                  height: 180,
                                  width: double.infinity,
                                  color: Colors.grey.withOpacity(0.3),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.broken_image,
                                        color: Colors.white54,
                                        size: 50,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Failed to load image',
                                        style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Image.asset(
                              image,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 180,
                                  width: double.infinity,
                                  color: Colors.grey.withOpacity(0.3),
                                  child: const Icon(
                                    Icons.car_rental,
                                    color: Colors.white54,
                                    size: 50,
                                  ),
                                );
                              },
                            ),
                    ),
                    // Gradient overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite
                                ? const Color(0xFFFFB347)
                                : Colors.white,
                            size: 20,
                          ),
                          onPressed: () async {
                            if (carId != null) {
                              if (isFavorite) {
                                await _firestoreHelper.removeFromFavorites(
                                  carId,
                                );
                              } else {
                                await _firestoreHelper.addToFavorites(carId);
                              }
                              // Update the local state to reflect the change immediately
                              setCardState(() {
                                isFavorite = !isFavorite;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.speed,
                            color: Colors.white.withOpacity(0.6),
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            specs,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                price,
                                style: const TextStyle(
                                  color: Color(0xFFFFB347),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.white.withOpacity(0.5),
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    location,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFB347), Color(0xFFFF8C42)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFFFB347,
                                  ).withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
