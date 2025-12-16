import 'package:autohub/screens/chat/chat_conversation_page.dart';
import 'package:autohub/screens/home/browse/compare_cars.dart';
import 'package:autohub/screens/sell/price_alert_setup.dart';
import 'package:autohub/screens/reviews/reviews_screen.dart';
import 'package:autohub/screens/profile/dealer_profile_screen.dart';
import 'package:autohub/helper/chat_service.dart';
import 'package:autohub/helper/firestore_helper.dart';
import 'package:flutter/material.dart';

class CarDetailPage extends StatefulWidget {
  final String carName;
  final String price;
  final String location;
  final String image;
  final String specs;
  final String? carId;
  final String? sellerId;
  final String? sellerName;

  const CarDetailPage({
    super.key,
    required this.carName,
    required this.price,
    required this.location,
    required this.image,
    required this.specs,
    this.carId,
    this.sellerId,
    this.sellerName,
  });

  @override
  State<CarDetailPage> createState() => _CarDetailPageState();
}

class _CarDetailPageState extends State<CarDetailPage> {
  bool isFavorite = false;
  final ChatService _chatService = ChatService.instance;
  final FirestoreHelper _firestoreHelper = FirestoreHelper.instance;
  Map<String, dynamic>? carData;
  Map<String, dynamic>? sellerData;
  Map<String, dynamic>? sellerStats;
  bool isLoading = true;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadCarData();
  }

  Future<void> _loadCarData() async {
    try {
      print('Loading car data for carId: ${widget.carId}');

      if (widget.carId != null) {
        final car = await _firestoreHelper.getCarById(widget.carId!);
        print('Car data loaded: ${car != null}');

        if (car != null) {
          carData = car;

          // Increment view count
          await _firestoreHelper.incrementViews(widget.carId!);

          // Track as recently viewed
          await _firestoreHelper.trackViewedCar(widget.carId!);

          // Load seller data
          final sellerId = car['userId'];
          print('Seller ID: $sellerId');

          if (sellerId != null) {
            final seller = await _firestoreHelper.getUserProfile(sellerId);
            final stats = await _firestoreHelper.getUserStats(sellerId);
            print('Seller data loaded: ${seller != null}');

            if (seller != null) {
              sellerData = seller;
            }
            sellerStats = stats;
          }

          // Check if car is in favorites
          final isFav = await _firestoreHelper.isCarFavorite(widget.carId!);

          if (mounted) {
            setState(() {
              isFavorite = isFav;
              isLoading = false;
            });
          }
        } else {
          print('Car not found for ID: ${widget.carId}');
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
        }
      } else {
        print('No carId provided');
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error loading car data: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
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
            'Loading...',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFFFFB347)),
              SizedBox(height: 16),
              Text(
                'Loading car details...',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      );
    }

    // Check if data failed to load
    if (widget.carId != null && carData == null) {
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
            'Car Details',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Car not found',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Car ID: ${widget.carId}',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB347),
                ),
                child: const Text(
                  'Go Back',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Use real data if available, fallback to widget props
    final List<String> imageUrls = carData?['imageUrls'] != null
        ? List<String>.from(carData!['imageUrls'])
        : [widget.image];

    // Debug: Print image URLs
    print('CarDetailPage - Image URLs count: ${imageUrls.length}');
    print('CarDetailPage - Image URLs: $imageUrls');

    final displayTitle = carData?['title'] ?? widget.carName;
    final displayPrice = carData != null
        ? 'Rs ${carData!['price']}'
        : widget.price;
    final displayLocation = carData?['location'] ?? widget.location;
    final displayDescription =
        carData?['description'] ??
        'This well-maintained car is in excellent condition. Perfect for daily commute and long drives. All service records available. Single owner, no accidents. Recently serviced with new tires.';

    // Extract specifications
    final transmission = carData?['transmission'] ?? 'Automatic';
    final fuel = carData?['fuel'] ?? 'Petrol';
    final year = carData?['year']?.toString() ?? '2025';
    final mileage = carData?['mileage']?.toString() ?? 'N/A';
    final condition = carData?['condition'] ?? 'Excellent';
    final category = carData?['category'] ?? 'Sedan';

    // Seller information
    final sellerId = carData?['userId'] ?? widget.sellerId;
    final sellerName = sellerData?['name'] ?? widget.sellerName ?? 'Seller';

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: const Color(0xFF1A1A1A),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? const Color(0xFFFFB347) : Colors.white,
                  ),
                ),
                onPressed: () async {
                  if (widget.carId != null) {
                    if (isFavorite) {
                      await _firestoreHelper.removeFromFavorites(widget.carId!);
                    } else {
                      await _firestoreHelper.addToFavorites(widget.carId!);
                    }
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  }
                },
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share, color: Colors.white),
                ),
                onPressed: () {},
              ),
              PopupMenuButton<String>(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.more_vert, color: Colors.white),
                ),
                color: const Color(0xFF2C2C2C),
                onSelected: (value) {
                  if (value == 'compare') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CompareCars(),
                      ),
                    );
                  } else if (value == 'alert') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PriceAlertSetup(
                          carName: widget.carName,
                          carId: widget.carId,
                          currentPrice: double.tryParse(
                            widget.price.replaceAll(RegExp(r'[^0-9.]'), ''),
                          ),
                          carImage: widget.image,
                        ),
                      ),
                    );
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'compare',
                    child: Row(
                      children: [
                        Icon(Icons.compare_arrows, color: Color(0xFFFFB347)),
                        SizedBox(width: 12),
                        Text(
                          'Compare with Others',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'alert',
                    child: Row(
                      children: [
                        Icon(
                          Icons.notifications_active,
                          color: Color(0xFFFFB347),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Set Price Alert',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Image Carousel using PageView
                  GestureDetector(
                    onTap: () {
                      // Open full-screen image viewer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImageViewer(
                            imageUrls: imageUrls,
                            initialIndex: _currentImageIndex,
                          ),
                        ),
                      );
                    },
                    child: PageView.builder(
                      itemCount: imageUrls.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentImageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final imageUrl = imageUrls[index];
                        return imageUrl.startsWith('http')
                            ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey.withOpacity(0.3),
                                    child: const Icon(
                                      Icons.car_rental,
                                      color: Colors.white54,
                                      size: 80,
                                    ),
                                  );
                                },
                              )
                            : Image.asset(
                                imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey.withOpacity(0.3),
                                    child: const Icon(
                                      Icons.car_rental,
                                      color: Colors.white54,
                                      size: 80,
                                    ),
                                  );
                                },
                              );
                      },
                    ),
                  ),
                  // Image counter indicator (moved to top right)
                  if (imageUrls.length > 1)
                    IgnorePointer(
                      child: Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.image,
                                color: Colors.white,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${_currentImageIndex + 1}/${imageUrls.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  // Dot indicators (at the absolute bottom of the image)
                  if (imageUrls.length > 1)
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: IgnorePointer(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: imageUrls.asMap().entries.map((entry) {
                            return Container(
                              width: 6.0,
                              height: 6.0,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 3.0,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentImageIndex == entry.key
                                    ? const Color(0xFFFFB347)
                                    : Colors.white.withOpacity(0.6),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Car Name and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          displayTitle,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFFFFB347),
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        displayLocation,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFB347), Color(0xFFFF8C42)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFB347).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          displayPrice,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Price',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Specifications
                  const Text(
                    'Specifications',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2C),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFFFB347).withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildSpecRow(
                          Icons.settings,
                          'Transmission',
                          transmission,
                        ),
                        const Divider(color: Colors.white24),
                        _buildSpecRow(
                          Icons.local_gas_station,
                          'Fuel Type',
                          fuel,
                        ),
                        const Divider(color: Colors.white24),
                        _buildSpecRow(Icons.speed, 'Mileage', '$mileage km'),
                        const Divider(color: Colors.white24),
                        _buildSpecRow(Icons.calendar_today, 'Year', year),
                        const Divider(color: Colors.white24),
                        _buildSpecRow(Icons.category, 'Category', category),
                        const Divider(color: Colors.white24),
                        _buildSpecRow(
                          Icons.check_circle,
                          'Condition',
                          condition,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Features
                  const Text(
                    'Features',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildFeatureChip('Air Conditioning'),
                      _buildFeatureChip('Sunroof'),
                      _buildFeatureChip('Leather Seats'),
                      _buildFeatureChip('Navigation'),
                      _buildFeatureChip('Bluetooth'),
                      _buildFeatureChip('Backup Camera'),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2C),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFFFB347).withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      displayDescription,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Customer Reviews Section
                  if (widget.carId != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Customer Reviews',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to Reviews Screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReviewsScreen(
                                  carName: widget.carName,
                                  carId: widget.carId,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'See All',
                            style: TextStyle(
                              color: Color(0xFFFFB347),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Real Reviews or Add Review Button
                    StreamBuilder<List<Map<String, dynamic>>>(
                      stream: _firestoreHelper.getCarReviews(widget.carId!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFFFB347),
                            ),
                          );
                        }

                        final reviews = snapshot.data ?? [];

                        if (reviews.isEmpty) {
                          // Show "Add Review" button when no reviews
                          return Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2C2C2C),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFFFB347).withOpacity(0.3),
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.rate_review_outlined,
                                  size: 48,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No reviews yet',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Be the first to review this car',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ReviewsScreen(
                                          carName: widget.carName,
                                          carId: widget.carId,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                  label: const Text('Write a Review'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFFB347),
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        // Show first review
                        final firstReview = reviews.first;
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2C2C2C),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFFFB347).withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: const Color(0xFFFFB347),
                                    child: Text(
                                      (firstReview['userName'] ?? 'U')[0]
                                          .toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          firstReview['userName'] ??
                                              'Anonymous',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: List.generate(5, (index) {
                                            return Icon(
                                              index <
                                                      (firstReview['rating'] ??
                                                          0)
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: const Color(0xFFFFB347),
                                              size: 16,
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                firstReview['reviewText'] ?? '',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Seller Info
                  const Text(
                    'Seller Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      // Navigate to Dealer Profile Screen with seller ID
                      if (sellerId != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DealerProfileScreen(
                              dealerName: sellerName,
                              dealerId: sellerId,
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2C2C),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFFB347).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFB347).withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Color(0xFFFFB347),
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      sellerName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white.withOpacity(0.5),
                                      size: 14,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Color(0xFFFFB347),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      sellerStats != null &&
                                              sellerStats!['totalReviews'] > 0
                                          ? '${(sellerStats!['averageRating'] as double).toStringAsFixed(1)} (${sellerStats!['totalReviews']} reviews)'
                                          : 'No reviews yet',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.phone,
                              color: Color(0xFFFFB347),
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Buttons
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2C),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  // Use sellerId from carData if available
                  final actualSellerId = sellerId ?? widget.sellerId;
                  final actualCarId = widget.carId;

                  if (actualSellerId == null || actualCarId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Unable to contact seller'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  // Show loading
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFFB347),
                      ),
                    ),
                  );

                  try {
                    final currentUserId = _chatService.currentUserId;
                    if (currentUserId == null) {
                      if (mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please sign in to chat with seller'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                      return;
                    }

                    // Create or get existing chat room
                    final chatId = await _chatService.createOrGetChatRoom(
                      sellerId: actualSellerId,
                      buyerId: currentUserId,
                      carId: actualCarId,
                      carTitle: displayTitle,
                    );

                    if (chatId == null) {
                      throw Exception('Failed to create chat room');
                    }

                    if (mounted) {
                      Navigator.pop(context); // Close loading dialog

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatConversationPage(
                            chatId: chatId,
                            otherUserId: actualSellerId,
                            otherUserName: sellerName,
                            carTitle: displayTitle,
                          ),
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      Navigator.pop(context); // Close loading dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.message),
                label: const Text('Message'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFFB347),
                  side: const BorderSide(color: Color(0xFFFFB347)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.phone),
                label: const Text('Call Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB347),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  shadowColor: const Color(0xFFFFB347).withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFB347).withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFFFFB347), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String feature) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFB347).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Color(0xFFFFB347), size: 16),
          const SizedBox(width: 6),
          Text(
            feature,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// Full Screen Image Viewer Widget
class FullScreenImageViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
  });

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full screen image viewer with PageView
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final imageUrl = widget.imageUrls[index];
              return Center(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: imageUrl.startsWith('http')
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.broken_image,
                              color: Colors.white54,
                              size: 100,
                            );
                          },
                        )
                      : Image.asset(
                          imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.broken_image,
                              color: Colors.white54,
                              size: 100,
                            );
                          },
                        ),
                ),
              );
            },
          ),

          // Top bar with close button and counter
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Close button
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),

                  // Image counter
                  if (widget.imageUrls.length > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_currentIndex + 1} / ${widget.imageUrls.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                  // Share button
                  IconButton(
                    onPressed: () {
                      // TODO: Add share functionality
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.share,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom navigation dots
          if (widget.imageUrls.length > 1)
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.imageUrls.asMap().entries.map((entry) {
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == entry.key
                          ? const Color(0xFFFFB347)
                          : Colors.white.withOpacity(0.5),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
