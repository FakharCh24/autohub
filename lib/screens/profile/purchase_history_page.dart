import 'package:flutter/material.dart';
import 'package:autohub/helper/firestore_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseHistoryPage extends StatefulWidget {
  const PurchaseHistoryPage({super.key});

  @override
  State<PurchaseHistoryPage> createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  final FirestoreHelper _firestoreHelper = FirestoreHelper.instance;

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
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firestoreHelper.getPurchaseHistory(),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFB347)),
            );
          }

          // Error state
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          }

          final purchases = snapshot.data ?? [];

          // Empty state
          if (purchases.isEmpty) {
            return _buildEmptyState();
          }

          return SingleChildScrollView(
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
                        '${purchases.length}',
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
                      ...purchases.map(
                        (purchase) => _buildPurchaseCard(purchase),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
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
    // Extract car data and format display
    final carData = purchase['carData'] as Map<String, dynamic>?;
    final sellerData = purchase['sellerData'] as Map<String, dynamic>?;

    final carName = carData?['title'] ?? 'Unknown Car';
    final year = carData?['year']?.toString() ?? 'N/A';
    final price = 'Rs ${purchase['price'] ?? 0}';
    final seller = sellerData?['name'] ?? 'Unknown Seller';
    final status = purchase['status'] ?? 'Completed';
    final paymentMethod = purchase['paymentMethod'] ?? 'N/A';
    final transactionId = purchase['id'] ?? 'N/A';

    // Format purchase date
    String purchaseDate = 'N/A';
    if (purchase['purchaseDate'] != null) {
      try {
        final timestamp = purchase['purchaseDate'];
        if (timestamp is Timestamp) {
          final date = timestamp.toDate();
          purchaseDate = '${date.day}/${date.month}/${date.year}';
        }
      } catch (e) {
        print('Error formatting date: $e');
      }
    }

    // Get car image
    final imageUrl = carData?['imageUrls']?.isNotEmpty == true
        ? carData!['imageUrls'][0]
        : null;

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
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
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
                      )
                    : Container(
                        width: 100,
                        height: 100,
                        color: const Color(0xFF1A1A1A),
                        child: const Icon(
                          Icons.car_rental,
                          size: 40,
                          color: Colors.white54,
                        ),
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
                        carName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        year,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        price,
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
                            purchaseDate,
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
                        _buildDetailRow('Seller', seller),
                        const SizedBox(height: 8),
                        _buildDetailRow('Status', status),
                        const SizedBox(height: 8),
                        _buildDetailRow('Payment Method', paymentMethod),
                        const SizedBox(height: 8),
                        _buildDetailRow('Transaction ID', transactionId),
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
