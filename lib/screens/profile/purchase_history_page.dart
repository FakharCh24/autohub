import 'package:flutter/material.dart';

class PurchaseHistoryPage extends StatefulWidget {
  const PurchaseHistoryPage({super.key});

  @override
  State<PurchaseHistoryPage> createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  // Sample purchase history data
  final List<Map<String, dynamic>> _purchases = [
    {
      'carName': 'BMW M3',
      'year': '2022',
      'price': 'Rs 75,000,00',
      'purchaseDate': 'Jan 15, 2024',
      'seller': 'John Motors',
      'status': 'Completed',
      'paymentMethod': 'Bank Transfer',
      'transactionId': 'TXN123456789',
      'image': 'assets/images/bmw.jpg',
    },
    {
      'carName': 'Mercedes-Benz C-Class',
      'year': '2021',
      'price': 'Rs 55,000,00',
      'purchaseDate': 'Dec 10, 2023',
      'seller': 'Auto Dealership',
      'status': 'Completed',
      'paymentMethod': 'Credit Card',
      'transactionId': 'TXN987654321',
      'image': 'assets/images/merc.jpg',
    },
    {
      'carName': 'Ford Mustang',
      'year': '2020',
      'price': 'Rs 45,000,00',
      'purchaseDate': 'Nov 5, 2023',
      'seller': 'Classic Cars Inc',
      'status': 'Completed',
      'paymentMethod': 'Cash',
      'transactionId': 'TXN456789123',
      'image': 'assets/images/ford.jpg',
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
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          'Purchase History',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: _purchases.isEmpty
          ? _buildEmptyState()
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Summary Stats
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFB347), Color(0xFFFF8C00)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Total Purchases',
                          style: TextStyle(
                            color: Color(0xFF1A1A1A),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_purchases.length}',
                          style: const TextStyle(
                            color: Color(0xFF1A1A1A),
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Cars Purchased',
                          style: TextStyle(
                            color: const Color(0xFF1A1A1A).withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Purchase List
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Recent Purchases',
                          style: TextStyle(
                            color: Color(0xFFFFB347),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ..._purchases.map(
                          (purchase) => _buildPurchaseCard(purchase),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 80,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No purchases yet',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your purchase history will appear here',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseCard(Map<String, dynamic> purchase) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Car Image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Image.asset(
                  purchase['image'],
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 100,
                      height: 100,
                      color: const Color(0xFF1A1A1A),
                      child: const Icon(
                        Icons.car_rental,
                        size: 40,
                        color: Colors.white54,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),

              // Purchase Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        purchase['carName'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        purchase['year'],
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        purchase['price'],
                        style: const TextStyle(
                          color: Color(0xFFFFB347),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: Colors.white.withOpacity(0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            purchase['purchaseDate'],
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
              const SizedBox(width: 8),
            ],
          ),

          // Expandable Details
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
            ),
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                title: const Text(
                  'View Details',
                  style: TextStyle(
                    color: Color(0xFFFFB347),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                iconColor: const Color(0xFFFFB347),
                collapsedIconColor: const Color(0xFFFFB347),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow('Seller', purchase['seller']),
                        const SizedBox(height: 8),
                        _buildDetailRow('Status', purchase['status']),
                        const SizedBox(height: 8),
                        _buildDetailRow(
                          'Payment Method',
                          purchase['paymentMethod'],
                        ),
                        const SizedBox(height: 8),
                        _buildDetailRow(
                          'Transaction ID',
                          purchase['transactionId'],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  _viewReceipt(purchase);
                                },
                                icon: const Icon(Icons.receipt_long, size: 18),
                                label: const Text('Receipt'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFFFFB347),
                                  side: const BorderSide(
                                    color: Color(0xFFFFB347),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  _contactSupport(purchase);
                                },
                                icon: const Icon(Icons.support_agent, size: 18),
                                label: const Text('Support'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFFFFB347),
                                  side: const BorderSide(
                                    color: Color(0xFFFFB347),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _viewReceipt(Map<String, dynamic> purchase) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: const Text(
            'Purchase Receipt',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB347),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.receipt_long,
                      size: 40,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildReceiptRow('Car', purchase['carName']),
                _buildReceiptRow('Year', purchase['year']),
                _buildReceiptRow('Price', purchase['price']),
                _buildReceiptRow('Date', purchase['purchaseDate']),
                _buildReceiptRow('Seller', purchase['seller']),
                _buildReceiptRow('Payment', purchase['paymentMethod']),
                _buildReceiptRow('Transaction ID', purchase['transactionId']),
                const Divider(color: Colors.white24, height: 24),
                _buildReceiptRow(
                  'Status',
                  purchase['status'],
                  isHighlight: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB347),
                foregroundColor: const Color(0xFF1A1A1A),
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Receipt downloaded'),
                    backgroundColor: Color(0xFFFFB347),
                  ),
                );
              },
              icon: const Icon(Icons.download),
              label: const Text('Download'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReceiptRow(
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isHighlight ? const Color(0xFFFFB347) : Colors.white,
              fontSize: 14,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _contactSupport(Map<String, dynamic> purchase) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: const Text(
            'Contact Support',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Need help with your purchase of ${purchase['carName']}?',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.phone, color: Color(0xFFFFB347)),
                title: const Text(
                  'Call Support',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  '+1 800 123 4567',
                  style: TextStyle(color: Colors.white54),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Calling support...'),
                      backgroundColor: Color(0xFFFFB347),
                    ),
                  );
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.email, color: Color(0xFFFFB347)),
                title: const Text(
                  'Email Support',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  'support@autohub.com',
                  style: TextStyle(color: Colors.white54),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening email...'),
                      backgroundColor: Color(0xFFFFB347),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
