import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../helper/firestore_helper.dart';

class ReviewsScreen extends StatefulWidget {
  final String carName;
  final String? carId;

  const ReviewsScreen({Key? key, required this.carName, this.carId})
    : super(key: key);

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  int _selectedRating = 0;
  final TextEditingController _reviewController = TextEditingController();
  String _selectedFilter = 'All';

  double _calculateAverageRating(List<Map<String, dynamic>> reviews) {
    if (reviews.isEmpty) return 0;
    return reviews.map((r) => r['rating'] as int).reduce((a, b) => a + b) /
        reviews.length;
  }

  Map<int, int> _calculateRatingDistribution(
    List<Map<String, dynamic>> reviews,
  ) {
    Map<int, int> distribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (var review in reviews) {
      distribution[review['rating'] as int] =
          (distribution[review['rating'] as int] ?? 0) + 1;
    }
    return distribution;
  }

  List<Map<String, dynamic>> _filterReviews(
    List<Map<String, dynamic>> reviews,
  ) {
    if (_selectedFilter == 'All') return reviews;
    int rating = int.parse(_selectedFilter.split(' ')[0]);
    return reviews.where((r) => r['rating'] == rating).toList();
  }

  @override
  Widget build(BuildContext context) {
    // If no carId, show error
    if (widget.carId == null) {
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
            'Reviews & Ratings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'roboto_bold',
            ),
          ),
          centerTitle: true,
        ),
        body: const Center(
          child: Text(
            'Car ID not available',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: FirestoreHelper.instance.getCarReviews(widget.carId!),
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: const Color(0xFF1A1A1A),
            appBar: _buildAppBar(),
            body: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFB347)),
              ),
            ),
          );
        }

        // Error state
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: const Color(0xFF1A1A1A),
            appBar: _buildAppBar(),
            body: Center(
              child: Text(
                'Error loading reviews: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        // Get reviews data
        final allReviews = snapshot.data ?? [];
        final filteredReviews = _filterReviews(allReviews);
        final averageRating = _calculateAverageRating(allReviews);
        final ratingDistribution = _calculateRatingDistribution(allReviews);

        return Scaffold(
          backgroundColor: const Color(0xFF1A1A1A),
          appBar: _buildAppBar(),
          body: Column(
            children: [
              // Car name
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Text(
                  widget.carName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'roboto_bold',
                    color: Colors.white,
                  ),
                ),
              ),

              // Rating Summary
              _buildRatingSummary(
                allReviews,
                averageRating,
                ratingDistribution,
              ),

              const Divider(thickness: 1, color: Color(0xFF2C2C2C)),

              // Filter Options
              _buildFilterOptions(),

              const Divider(thickness: 1, color: Color(0xFF2C2C2C)),

              // Reviews List
              Expanded(
                child: filteredReviews.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        itemCount: filteredReviews.length,
                        itemBuilder: (context, index) {
                          return _buildReviewCard(filteredReviews[index]);
                        },
                      ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _showWriteReviewDialog,
            backgroundColor: const Color(0xFFFFB347),
            icon: const Icon(Icons.edit, color: Colors.black),
            label: const Text(
              'Write Review',
              style: TextStyle(color: Colors.black, fontFamily: 'roboto_bold'),
            ),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF2C2C2C),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Reviews & Ratings',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'roboto_bold',
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildRatingSummary(
    List<Map<String, dynamic>> reviews,
    double averageRating,
    Map<int, int> ratingDistribution,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Average Rating
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(
                  averageRating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 48,
                    fontFamily: 'roboto_bold',
                    color: Color(0xFFFFB347),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return Icon(
                      index < averageRating.floor()
                          ? Icons.star
                          : (index < averageRating
                                ? Icons.star_half
                                : Icons.star_border),
                      color: const Color(0xFFFFB347),
                      size: 24,
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Text(
                  '${reviews.length} reviews',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                    fontFamily: 'roboto_regular',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 20),

          // Rating Distribution
          Expanded(
            flex: 3,
            child: Column(
              children: [5, 4, 3, 2, 1].map((rating) {
                int count = ratingDistribution[rating] ?? 0;
                double percentage = reviews.isEmpty
                    ? 0
                    : count / reviews.length;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        '$rating',
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'roboto_regular',
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.star,
                        color: Color(0xFFFFB347),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: percentage,
                          backgroundColor: const Color(0xFF2C2C2C),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFFFFB347),
                          ),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$count',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7),
                          fontFamily: 'roboto_regular',
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOptions() {
    List<String> filters = [
      'All',
      '5 Stars',
      '4 Stars',
      '3 Stars',
      '2 Stars',
      '1 Star',
    ];

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedFilter == filters[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(filters[index]),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filters[index];
                });
              },
              selectedColor: const Color(0xFFFFB347),
              backgroundColor: const Color(0xFF2C2C2C),
              labelStyle: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontFamily: 'roboto_regular',
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    // Format date from Timestamp
    String formattedDate = 'Recently';
    final createdAt = review['createdAt'];
    if (createdAt != null) {
      try {
        final dateTime = (createdAt as Timestamp).toDate();
        final now = DateTime.now();
        final difference = now.difference(dateTime);

        if (difference.inDays == 0) {
          formattedDate = 'Today';
        } else if (difference.inDays == 1) {
          formattedDate = 'Yesterday';
        } else if (difference.inDays < 7) {
          formattedDate = '${difference.inDays} days ago';
        } else if (difference.inDays < 30) {
          formattedDate = '${(difference.inDays / 7).floor()} weeks ago';
        } else {
          formattedDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
        }
      } catch (e) {
        formattedDate = 'Recently';
      }
    }

    // Get user info with defaults
    final userName = review['userName'] ?? 'Anonymous';
    final userImage = review['userImage'] ?? '';
    final reviewText = review['reviewText'] ?? 'No review text';
    final rating = review['rating'] ?? 0;
    final helpful = review['helpful'] ?? 0;
    final imageUrls = review['imageUrls'] as List<dynamic>? ?? [];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF2C2C2C))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFFFB347),
                backgroundImage:
                    userImage.isNotEmpty && userImage.startsWith('http')
                    ? NetworkImage(userImage)
                    : null,
                child: userImage.isEmpty || !userImage.startsWith('http')
                    ? Text(
                        userName[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'roboto_bold',
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.5),
                        fontFamily: 'roboto_regular',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Rating
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: const Color(0xFFFFB347),
                size: 20,
              );
            }),
          ),

          const SizedBox(height: 12),

          // Review Text
          Text(
            reviewText,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
              fontFamily: 'roboto_regular',
              height: 1.5,
            ),
          ),

          // Review Images
          if (imageUrls.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  final imageUrl = imageUrls[index] as String;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80,
                            height: 80,
                            color: const Color(0xFF2C2C2C),
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.white.withOpacity(0.3),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],

          const SizedBox(height: 12),

          // Helpful Button
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  final reviewId = review['id'];
                  if (reviewId != null) {
                    FirestoreHelper.instance.markReviewHelpful(reviewId);
                  }
                },
                icon: Icon(
                  Icons.thumb_up_outlined,
                  size: 18,
                  color: Colors.white.withOpacity(0.5),
                ),
                label: Text(
                  'Helpful ($helpful)',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontFamily: 'roboto_regular',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.rate_review_outlined,
            size: 80,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No reviews yet',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'roboto_bold',
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to review this car',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'roboto_regular',
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  void _showWriteReviewDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Color(0xFF2C2C2C),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Write a Review',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'roboto_bold',
                  color: Colors.white,
                ),
              ),
            ),

            const Divider(color: Color(0xFF1A1A1A)),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rating Selection
                    const Text(
                      'Your Rating',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'roboto_bold',
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          onPressed: () {
                            setState(() {
                              _selectedRating = index + 1;
                            });
                          },
                          icon: Icon(
                            index < _selectedRating
                                ? Icons.star
                                : Icons.star_border,
                            color: const Color(0xFFFFB347),
                            size: 40,
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 24),

                    // Review Text
                    const Text(
                      'Your Review',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'roboto_bold',
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _reviewController,
                      maxLines: 5,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Share your experience with this car...',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontFamily: 'roboto_regular',
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1A1A1A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFFFB347),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed:
                            _selectedRating > 0 &&
                                _reviewController.text.isNotEmpty
                            ? () async {
                                // Submit review to Firestore
                                final success = await FirestoreHelper.instance
                                    .addReview(
                                      carId: widget.carId!,
                                      rating: _selectedRating,
                                      reviewText: _reviewController.text.trim(),
                                    );

                                if (mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        success
                                            ? 'Review submitted successfully!'
                                            : 'Failed to submit review',
                                      ),
                                      backgroundColor: success
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  );

                                  // Reset form
                                  if (success) {
                                    setState(() {
                                      _selectedRating = 0;
                                      _reviewController.clear();
                                    });
                                  }
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFB347),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          disabledBackgroundColor: const Color(0xFF1A1A1A),
                        ),
                        child: const Text(
                          'Submit Review',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'roboto_bold',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }
}
