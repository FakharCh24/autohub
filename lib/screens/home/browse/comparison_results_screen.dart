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
  // Simplified comparison categories
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
                // Car Headers
                _buildCarHeaders(),

                const Divider(thickness: 1, color: Color(0xFF2C2C2C)),

                // Comparison Table
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

  Widget _buildCarHeaders() {
    return Container(
      height: 220,
      child: Row(
        children: [
          // Empty cell for labels
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

          // Car cards
          ...widget.carsToCompare.map((car) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFFFB347).withOpacity(0.3),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          car['image'] ?? 'assets/images/car1.jpg',
                          height: 70,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
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
                        car['price'],
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
              ),
            );
          }).toList(),
        ],
      ),
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
    // No winner highlighting - keep it simple
    return List.filled(values.length, false);
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
