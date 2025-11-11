import 'package:flutter/material.dart';

class ReviewsScreen extends StatefulWidget {
  final String carName;

  const ReviewsScreen({Key? key, required this.carName}) : super(key: key);

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  int _selectedRating = 0;
  final TextEditingController _reviewController = TextEditingController();
  String _selectedFilter = 'All';

  // Sample reviews data
  final List<Map<String, dynamic>> _reviews = [
    {
      'userName': 'Fakhir Ashraf',
      'userImage': 'assets/images/Profile.jpg',
      'rating': 5,
      'date': 'Nov 5, 2025',
      'review':
          'Excellent car! The seller was very professional and the car was exactly as described. Highly recommended!',
      'helpful': 24,
      'images': [],
    },
    {
      'userName': 'Sarah Smith',
      'userImage': 'assets/images/Profile.jpg',
      'rating': 4,
      'date': 'Nov 3, 2025',
      'review':
          'Good condition overall. Minor scratches but nothing major. Fair price for the quality.',
      'helpful': 15,
      'images': ['assets/images/car1.jpg', 'assets/images/car2.jpg'],
    },
    {
      'userName': 'Mike Johnson',
      'userImage': 'assets/images/Profile.jpg',
      'rating': 5,
      'date': 'Oct 28, 2025',
      'review':
          'Amazing experience! The car runs perfectly and the documentation was complete. Would buy again!',
      'helpful': 32,
      'images': [],
    },
    {
      'userName': 'Emma Wilson',
      'userImage': 'assets/images/Profile.jpg',
      'rating': 3,
      'date': 'Oct 25, 2025',
      'review':
          'Decent car but had some issues with the AC. Seller fixed it before delivery though.',
      'helpful': 8,
      'images': [],
    },
  ];

  double get _averageRating {
    if (_reviews.isEmpty) return 0;
    return _reviews.map((r) => r['rating'] as int).reduce((a, b) => a + b) /
        _reviews.length;
  }

  Map<int, int> get _ratingDistribution {
    Map<int, int> distribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (var review in _reviews) {
      distribution[review['rating'] as int] =
          (distribution[review['rating'] as int] ?? 0) + 1;
    }
    return distribution;
  }

  List<Map<String, dynamic>> get _filteredReviews {
    if (_selectedFilter == 'All') return _reviews;
    int rating = int.parse(_selectedFilter.split(' ')[0]);
    return _reviews.where((r) => r['rating'] == rating).toList();
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
          'Reviews & Ratings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'roboto_bold',
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Car name
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
          _buildRatingSummary(),

          const Divider(thickness: 1, color: Color(0xFF2C2C2C)),

          // Filter Options
          _buildFilterOptions(),

          const Divider(thickness: 1, color: Color(0xFF2C2C2C)),

          // Reviews List
          Expanded(
            child: _filteredReviews.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: _filteredReviews.length,
                    itemBuilder: (context, index) {
                      return _buildReviewCard(_filteredReviews[index]);
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
  }

  Widget _buildRatingSummary() {
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
                  _averageRating.toStringAsFixed(1),
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
                      index < _averageRating.floor()
                          ? Icons.star
                          : (index < _averageRating
                                ? Icons.star_half
                                : Icons.star_border),
                      color: const Color(0xFFFFB347),
                      size: 24,
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_reviews.length} reviews',
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
                int count = _ratingDistribution[rating] ?? 0;
                double percentage = _reviews.isEmpty
                    ? 0
                    : count / _reviews.length;

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
                backgroundImage: AssetImage(review['userImage']),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['userName'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'roboto_bold',
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      review['date'],
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
                index < review['rating'] ? Icons.star : Icons.star_border,
                color: const Color(0xFFFFB347),
                size: 20,
              );
            }),
          ),

          const SizedBox(height: 12),

          // Review Text
          Text(
            review['review'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
              fontFamily: 'roboto_regular',
              height: 1.5,
            ),
          ),

          // Review Images
          if (review['images'].isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: review['images'].length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        review['images'][index],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
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
                onPressed: () {},
                icon: Icon(
                  Icons.thumb_up_outlined,
                  size: 18,
                  color: Colors.white.withOpacity(0.5),
                ),
                label: Text(
                  'Helpful (${review['helpful']})',
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
                            ? () {
                                // Submit review logic
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Review submitted successfully!',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
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
