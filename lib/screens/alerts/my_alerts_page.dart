import 'package:flutter/material.dart';
import '../../models/price_alert.dart';
import '../../services/price_alert_service.dart';

class MyAlertsPage extends StatefulWidget {
  const MyAlertsPage({super.key});

  @override
  State<MyAlertsPage> createState() => _MyAlertsPageState();
}

class _MyAlertsPageState extends State<MyAlertsPage> {
  final PriceAlertService _alertService = PriceAlertService.instance;
  bool showActiveOnly = false;

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
          'My Price Alerts',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              showActiveOnly ? Icons.filter_alt : Icons.filter_alt_outlined,
              color: const Color(0xFFFFB347),
            ),
            onPressed: () {
              setState(() {
                showActiveOnly = !showActiveOnly;
              });
            },
            tooltip: showActiveOnly ? 'Show All' : 'Show Active Only',
          ),
        ],
      ),
      body: StreamBuilder<List<PriceAlert>>(
        stream: _alertService.watchUserAlerts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFB347)),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading alerts',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          List<PriceAlert> alerts = snapshot.data ?? [];

          // Filter if needed
          if (showActiveOnly) {
            alerts = alerts.where((alert) => alert.isActive).toList();
          }

          if (alerts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    color: Colors.white.withOpacity(0.3),
                    size: 80,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    showActiveOnly ? 'No Active Alerts' : 'No Price Alerts',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Set price alerts to get notified\nwhen car prices change',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: alerts.length,
            itemBuilder: (context, index) {
              final alert = alerts[index];
              return _buildAlertCard(alert);
            },
          );
        },
      ),
    );
  }

  Widget _buildAlertCard(PriceAlert alert) {
    final priceFormatter = (double price) {
      if (price >= 1000000) {
        return '${(price / 1000000).toStringAsFixed(1)}M';
      } else if (price >= 1000) {
        return '${(price / 1000).toStringAsFixed(0)}K';
      }
      return price.toStringAsFixed(0);
    };

    return Card(
      color: const Color(0xFF2C2C2C),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: alert.isActive
              ? const Color(0xFFFFB347).withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with car name and toggle
            Row(
              children: [
                // Car icon/image
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(8),
                    image: alert.carImage != null
                        ? DecorationImage(
                            image: NetworkImage(alert.carImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: alert.carImage == null
                      ? const Icon(
                          Icons.directions_car,
                          color: Color(0xFFFFB347),
                          size: 24,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                // Car name and status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert.carName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: alert.isActive
                                  ? Colors.green
                                  : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            alert.isActive ? 'Active' : 'Inactive',
                            style: TextStyle(
                              color: alert.isActive
                                  ? Colors.green
                                  : Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Toggle switch
                Switch(
                  value: alert.isActive,
                  onChanged: (value) async {
                    final success = await _alertService.toggleAlertStatus(
                      alert.alertId,
                      value,
                    );
                    if (!success && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to update alert'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  activeColor: const Color(0xFFFFB347),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Alert details
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    alert.alertType == 'Below'
                        ? Icons.trending_down
                        : Icons.trending_up,
                    color: alert.alertType == 'Below'
                        ? Colors.green
                        : Colors.orange,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notify when price ${alert.alertType.toLowerCase()}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'PKR ${priceFormatter(alert.targetPrice)}',
                          style: const TextStyle(
                            color: Color(0xFFFFB347),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (alert.currentPrice != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Current',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          'PKR ${priceFormatter(alert.currentPrice!)}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Notification preferences
            Row(
              children: [
                if (alert.notifyByPush)
                  _buildNotificationBadge(Icons.notifications, 'Push'),
                if (alert.notifyByPush && alert.notifyByEmail)
                  const SizedBox(width: 8),
                if (alert.notifyByEmail)
                  _buildNotificationBadge(Icons.email, 'Email'),
                const Spacer(),
                Text(
                  _formatDate(alert.createdAt),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Navigate to car details if possible
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Opening car details...'),
                          backgroundColor: Color(0xFFFFB347),
                        ),
                      );
                    },
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('View Car'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFFFB347),
                      side: const BorderSide(color: Color(0xFFFFB347)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showDeleteConfirmation(alert),
                    icon: const Icon(Icons.delete, size: 16),
                    label: const Text('Delete'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
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
    );
  }

  Widget _buildNotificationBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFB347).withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFFFB347).withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFFFB347), size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFFFB347),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? "week" : "weeks"} ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showDeleteConfirmation(PriceAlert alert) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.orange, size: 28),
              SizedBox(width: 12),
              Text(
                'Delete Alert?',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete this price alert for ${alert.carName}?',
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                Navigator.pop(context);
                final success = await _alertService.deleteAlert(alert.alertId);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? 'Alert deleted successfully'
                            : 'Failed to delete alert',
                      ),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
