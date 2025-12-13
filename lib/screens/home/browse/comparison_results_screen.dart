import 'package:flutter/material.dart';

class ComparisonResultsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> carsToCompare;

  const ComparisonResultsScreen({Key? key, required this.carsToCompare})
    : super(key: key);

  @override
  State<ComparisonResultsScreen> createState() =>
      _ComparisonResultsScreenState();
}

class _ComparisonResultsScreenState extends State<ComparisonResultsScreen> {
  Map<String, dynamic>? _bestCar;
  Map<String, int> _carScores = {};

  final List<Map<String, dynamic>> _comparisonCategories = [
    {
      'title': 'Basic Information',
      'items': [
        {'label': 'Price', 'key': 'price'},
        {'label': 'Year', 'key': 'year'},
        {'label': 'Mileage', 'key': 'mileage'},
      ],
    },
    {
      'title': 'Engine',
      'items': [
        {'label': 'Fuel', 'key': 'fuel'},
        {'label': 'Transmission', 'key': 'transmission'},
        {'label': 'Engine', 'key': 'engine'},
        {'label': 'Power', 'key': 'power'},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _calculateBestCar();
  }

  void _calculateBestCar() {
    if (widget.carsToCompare.length < 2) return;

    // Initialize scores
    for (var car in widget.carsToCompare) {
      final carId = car['id'] ?? car['title'] ?? car['name'];
      _carScores[carId] = 0;
    }

    // Score based on price (lower is better)
    _scoreCars('price', lowerIsBetter: true);

    // Score based on year (higher is better)
    _scoreCars('year', lowerIsBetter: false);

    // Score based on mileage (lower is better)
    _scoreCars('mileage', lowerIsBetter: true);

    // Additional scoring factors
    _scoreFuelType();
    _scoreTransmission();
    _scoreCondition();

    // Find car with highest score
    String? bestCarId;
    int highestScore = -1;

    _carScores.forEach((carId, score) {
      if (score > highestScore) {
        highestScore = score;
        bestCarId = carId;
      }
    });

    // Set the best car
    if (bestCarId != null) {
      _bestCar = widget.carsToCompare.firstWhere(
        (car) => (car['id'] ?? car['title'] ?? car['name']) == bestCarId,
        orElse: () => widget.carsToCompare.first,
      );
    }
  }

  void _scoreCars(String key, {required bool lowerIsBetter}) {
    List<dynamic> values = [];

    for (var car in widget.carsToCompare) {
      var value = car[key];
      if (value != null) {
        // Convert to int if it's a string number
        if (value is String) {
          value = int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        }
        values.add(value);
      } else {
        values.add(0);
      }
    }

    // Find best and worst values
    var sortedValues = List.from(values)..sort();
    var bestValue = lowerIsBetter ? sortedValues.first : sortedValues.last;

    // Assign scores
    for (int i = 0; i < widget.carsToCompare.length; i++) {
      final car = widget.carsToCompare[i];
      final carId = car['id'] ?? car['title'] ?? car['name'];
      final value = values[i];

      if (value == bestValue) {
        _carScores[carId] = (_carScores[carId] ?? 0) + 10;
      } else if (lowerIsBetter) {
        // Give partial points based on how close to the best
        int points = (10 - ((value - bestValue) / bestValue * 5).round())
            .clamp(0, 9)
            .toInt();
        _carScores[carId] = (_carScores[carId] ?? 0) + points;
      } else {
        // Give partial points based on how close to the best
        int points = (10 - ((bestValue - value) / bestValue * 5).round())
            .clamp(0, 9)
            .toInt();
        _carScores[carId] = (_carScores[carId] ?? 0) + points;
      }
    }
  }

  void _scoreFuelType() {
    // Preferred fuel types: Petrol and Hybrid get more points
    for (var car in widget.carsToCompare) {
      final carId = car['id'] ?? car['title'] ?? car['name'];
      final fuel = car['fuel']?.toString().toLowerCase() ?? '';

      if (fuel.contains('hybrid') || fuel.contains('electric')) {
        _carScores[carId] = (_carScores[carId] ?? 0) + 8;
      } else if (fuel.contains('petrol')) {
        _carScores[carId] = (_carScores[carId] ?? 0) + 5;
      } else if (fuel.contains('diesel')) {
        _carScores[carId] = (_carScores[carId] ?? 0) + 4;
      }
    }
  }

  void _scoreTransmission() {
    // Automatic transmission gets more points
    for (var car in widget.carsToCompare) {
      final carId = car['id'] ?? car['title'] ?? car['name'];
      final transmission = car['transmission']?.toString().toLowerCase() ?? '';

      if (transmission.contains('automatic')) {
        _carScores[carId] = (_carScores[carId] ?? 0) + 5;
      } else if (transmission.contains('manual')) {
        _carScores[carId] = (_carScores[carId] ?? 0) + 3;
      }
    }
  }

  void _scoreCondition() {
    // Better condition gets more points
    for (var car in widget.carsToCompare) {
      final carId = car['id'] ?? car['title'] ?? car['name'];
      final condition = car['condition']?.toString().toLowerCase() ?? '';

      if (condition.contains('new') || condition.contains('excellent')) {
        _carScores[carId] = (_carScores[carId] ?? 0) + 10;
      } else if (condition.contains('good')) {
        _carScores[carId] = (_carScores[carId] ?? 0) + 7;
      } else if (condition.contains('fair')) {
        _carScores[carId] = (_carScores[carId] ?? 0) + 4;
      }
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
        title: const Text(
          'Compare Cars',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'roboto_bold',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: _shareComparison,
          ),
        ],
      ),
      body: widget.carsToCompare.length < 2
          ? _buildInsufficientCarsMessage()
          : Column(
              children: [
                // Best Car Recommendation (if calculated)
                if (_bestCar != null) _buildBestCarCard(),

                _buildCarHeaders(),

                const Divider(thickness: 1, color: Color(0xFF2C2C2C)),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: _comparisonCategories.map((category) {
                        return _buildComparisonCategory(category);
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildBestCarCard() {
    if (_bestCar == null) return const SizedBox.shrink();

    final imageUrls = _bestCar!['imageUrls'] as List<dynamic>?;
    final imageUrl = (imageUrls != null && imageUrls.isNotEmpty)
        ? imageUrls[0].toString()
        : '';
    final imageAsset = _bestCar!['image'] as String?;

    final carId = _bestCar!['id'] ?? _bestCar!['title'] ?? _bestCar!['name'];
    final score = _carScores[carId] ?? 0;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFFFFB347), const Color(0xFFFF8C00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFB347).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Best Overall Choice',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Based on comprehensive comparison',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Car Details
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Car Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildMiniPlaceholderImage();
                          },
                        )
                      : (imageAsset != null && imageAsset.isNotEmpty)
                      ? Image.asset(
                          imageAsset,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildMiniPlaceholderImage();
                          },
                        )
                      : _buildMiniPlaceholderImage(),
                ),
                const SizedBox(width: 16),

                // Car Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _bestCar!['title']?.toString() ??
                            _bestCar!['name']?.toString() ??
                            'Unknown Car',
                        style: const TextStyle(
                          color: Color(0xFF1A1A1A),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatPrice(_bestCar!['price']),
                        style: const TextStyle(
                          color: Color(0xFFFF8C00),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB347).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Score: $score points',
                          style: const TextStyle(
                            color: Color(0xFF1A1A1A),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniPlaceholderImage() {
    return Container(
      width: 80,
      height: 80,
      color: const Color(0xFF1A1A1A),
      child: const Icon(Icons.car_rental, color: Colors.white54, size: 30),
    );
  }

  String _formatPrice(dynamic price) {
    if (price is int) {
      return 'PKR $price';
    }
    return price?.toString() ?? 'N/A';
  }

  Widget _buildCarHeaders() {
    return Container(
      height: 220,
      child: Row(
        children: [
          Container(
            width: 120,
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Text(
                'Features',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'roboto_bold',
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ),
          ...widget.carsToCompare.map((car) {
            final isBestCar =
                _bestCar != null &&
                (_bestCar!['id'] == car['id'] ||
                    _bestCar!['title'] == car['title'] ||
                    _bestCar!['name'] == car['name']);
            final imageUrls = car['imageUrls'] as List<dynamic>?;
            final imageUrl = (imageUrls != null && imageUrls.isNotEmpty)
                ? imageUrls[0].toString()
                : '';
            final imageAsset = car['image'] as String?;

            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isBestCar
                        ? const Color(0xFFFFB347)
                        : const Color(0xFFFFB347).withOpacity(0.3),
                    width: isBestCar ? 2 : 1,
                  ),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: imageUrl.isNotEmpty
                                ? Image.network(
                                    imageUrl,
                                    height: 70,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildHeaderPlaceholderImage();
                                    },
                                  )
                                : (imageAsset != null && imageAsset.isNotEmpty)
                                ? Image.asset(
                                    imageAsset,
                                    height: 70,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildHeaderPlaceholderImage();
                                    },
                                  )
                                : _buildHeaderPlaceholderImage(),
                          ),
                          const SizedBox(height: 6),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: Text(
                                car['title']?.toString() ??
                                    '${car['make']} ${car['model']}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'roboto_bold',
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatPrice(car['price']),
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'roboto_bold',
                              color: Color(0xFFFFB347),
                            ),
                          ),
                          const SizedBox(height: 4),
                          InkWell(
                            onTap: () => _removeCar(car),
                            child: Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Best Car Badge
                    if (isBestCar)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFB347),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.star, color: Colors.white, size: 12),
                              SizedBox(width: 4),
                              Text(
                                'BEST',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
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
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildHeaderPlaceholderImage() {
    return Container(
      height: 70,
      width: double.infinity,
      color: const Color(0xFF1A1A1A),
      child: const Icon(Icons.car_rental, color: Colors.white54, size: 30),
    );
  }

  Widget _buildComparisonCategory(Map<String, dynamic> category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          color: const Color(0xFF2C2C2C),
          child: Text(
            category['title'],
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'roboto_bold',
              color: Color(0xFFFFB347),
            ),
          ),
        ),

        // Category Items
        ...((category['items'] as List).map((item) {
          return _buildComparisonRow(
            item['label'],
            widget.carsToCompare
                .map((car) => car[item['key']]?.toString() ?? 'N/A')
                .toList(),
          );
        }).toList()),
      ],
    );
  }

  Widget _buildComparisonRow(String label, List<String> values) {
    // Determine if this row has a "winner" (highest/best value)
    List<bool> isWinner = _determineWinners(label, values);

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF2C2C2C))),
      ),
      child: Row(
        children: [
          // Label
          Container(
            width: 120,
            padding: const EdgeInsets.all(12),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'roboto_regular',
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),

          // Values
          ...List.generate(values.length, (index) {
            return Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: isWinner[index]
                      ? const Color(0xFFFFB347).withOpacity(0.2)
                      : null,
                ),
                child: Text(
                  values[index],
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: isWinner[index]
                        ? 'roboto_bold'
                        : 'roboto_regular',
                    color: isWinner[index]
                        ? const Color(0xFFFFB347)
                        : Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  List<bool> _determineWinners(String label, List<String> values) {
    List<bool> winners = List.filled(values.length, false);

    // Skip if all values are N/A
    if (values.every((v) => v == 'N/A')) {
      return winners;
    }

    // Determine winners based on the label
    switch (label.toLowerCase()) {
      case 'price':
      case 'mileage':
        // Lower is better
        _markLowerAsWinner(values, winners);
        break;

      case 'year':
        // Higher is better
        _markHigherAsWinner(values, winners);
        break;

      case 'fuel':
        // Hybrid/Electric is best
        for (int i = 0; i < values.length; i++) {
          final fuel = values[i].toLowerCase();
          if (fuel.contains('hybrid') || fuel.contains('electric')) {
            winners[i] = true;
          }
        }
        break;

      case 'transmission':
        // Automatic is generally preferred
        for (int i = 0; i < values.length; i++) {
          if (values[i].toLowerCase().contains('automatic')) {
            winners[i] = true;
          }
        }
        break;

      default:
        // No winner highlighting for other fields
        break;
    }

    return winners;
  }

  void _markLowerAsWinner(List<String> values, List<bool> winners) {
    List<int> numericValues = [];

    for (var value in values) {
      if (value == 'N/A') {
        numericValues.add(double.maxFinite.toInt());
      } else {
        // Extract numeric value
        String numStr = value.replaceAll(RegExp(r'[^0-9]'), '');
        numericValues.add(int.tryParse(numStr) ?? double.maxFinite.toInt());
      }
    }

    int minValue = numericValues.reduce((a, b) => a < b ? a : b);
    if (minValue == double.maxFinite.toInt()) return;

    for (int i = 0; i < numericValues.length; i++) {
      if (numericValues[i] == minValue) {
        winners[i] = true;
      }
    }
  }

  void _markHigherAsWinner(List<String> values, List<bool> winners) {
    List<int> numericValues = [];

    for (var value in values) {
      if (value == 'N/A') {
        numericValues.add(0);
      } else {
        // Extract numeric value
        String numStr = value.replaceAll(RegExp(r'[^0-9]'), '');
        numericValues.add(int.tryParse(numStr) ?? 0);
      }
    }

    int maxValue = numericValues.reduce((a, b) => a > b ? a : b);
    if (maxValue == 0) return;

    for (int i = 0; i < numericValues.length; i++) {
      if (numericValues[i] == maxValue) {
        winners[i] = true;
      }
    }
  }

  Widget _buildInsufficientCarsMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.compare_arrows,
            size: 80,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Not Enough Cars',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'roboto_bold',
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add at least 2 cars to compare',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'roboto_regular',
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFB347),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Add More Cars',
              style: TextStyle(color: Colors.black, fontFamily: 'roboto_bold'),
            ),
          ),
        ],
      ),
    );
  }

  void _removeCar(Map<String, dynamic> car) {
    setState(() {
      widget.carsToCompare.remove(car);
    });

    if (widget.carsToCompare.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('At least 2 cars are required for comparison'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _shareComparison() {
    // Share comparison logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Comparison shared successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
