import 'package:flutter/material.dart';
import 'notification_details.dart';
import 'notification_settings.dart';
import '../../helper/firestore_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsCenter extends StatefulWidget {
  const NotificationsCenter({super.key});

  @override
  State<NotificationsCenter> createState() => _NotificationsCenterState();
}

class _NotificationsCenterState extends State<NotificationsCenter> {
  String selectedTab = 'All';

  List<Map<String, dynamic>> _filterNotifications(
    List<Map<String, dynamic>> notifications,
  ) {
    if (selectedTab == 'All') return notifications;
    if (selectedTab == 'Unread') {
      return notifications.where((n) => n['isRead'] == false).toList();
    }
    return notifications
        .where((n) => n['type'] == selectedTab.toLowerCase())
        .toList();
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'message':
        return Icons.message;
      case 'alert':
        return Icons.local_offer;
      case 'system':
        return Icons.check_circle;
      case 'appointment':
        return Icons.calendar_today;
      case 'social':
        return Icons.person_add;
      default:
        return Icons.notifications;
    }
  }

  Color _getColorForType(String type) {
    switch (type.toLowerCase()) {
      case 'message':
        return Colors.blue;
      case 'alert':
        return Colors.orange;
      case 'system':
        return Colors.green;
      case 'appointment':
        return Colors.purple;
      case 'social':
        return Colors.teal;
      default:
        return const Color(0xFFFFB347);
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
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationSettings(),
                ),
              );
            },
            icon: const Icon(Icons.settings, color: Colors.white),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            color: const Color(0xFF2C2C2C),
            onSelected: (value) {
              // Removed mark_all and clear_all - not needed with real-time data
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'refresh',
                child: Text('Refresh', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: FirestoreHelper.instance.getUserNotifications(),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFB347)),
              ),
            );
          }

          // Error state
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading notifications: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          final allNotifications = snapshot.data ?? [];
          final filteredNotifications = _filterNotifications(allNotifications);
          final unreadCount = allNotifications
              .where((n) => n['isRead'] == false)
              .length;

          return Column(
            children: [
              // Tabs
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C),
                  border: Border(
                    bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
                  ),
                ),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildTab('All'),
                    _buildTab('Unread'),
                    _buildTab('Message'),
                    _buildTab('Alert'),
                    _buildTab('System'),
                  ],
                ),
              ),

              // Notifications Count
              if (filteredNotifications.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$unreadCount Unread',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          // Mark all as read
                          for (var notification in allNotifications) {
                            if (notification['isRead'] == false) {
                              await FirestoreHelper.instance
                                  .markNotificationAsRead(notification['id']);
                            }
                          }
                        },
                        child: const Text(
                          'Mark all as read',
                          style: TextStyle(color: Color(0xFFFFB347)),
                        ),
                      ),
                    ],
                  ),
                ),

              // Notifications List
              Expanded(
                child: filteredNotifications.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredNotifications.length,
                        itemBuilder: (context, index) {
                          final notification = filteredNotifications[index];
                          // Add icon and color dynamically
                          notification['icon'] = _getIconForType(
                            notification['type'] ?? '',
                          );
                          notification['color'] = _getColorForType(
                            notification['type'] ?? '',
                          );

                          // Format timestamp
                          final createdAt =
                              notification['createdAt'] as Timestamp?;
                          if (createdAt != null) {
                            final DateTime dateTime = createdAt.toDate();
                            final Duration difference = DateTime.now()
                                .difference(dateTime);

                            if (difference.inMinutes < 60) {
                              notification['time'] =
                                  '${difference.inMinutes} min ago';
                            } else if (difference.inHours < 24) {
                              notification['time'] =
                                  '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
                            } else if (difference.inDays < 7) {
                              notification['time'] =
                                  '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
                            } else {
                              notification['time'] =
                                  '${dateTime.day}/${dateTime.month}/${dateTime.year}';
                            }
                          }

                          return _buildNotificationCard(notification);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTab(String title) {
    final isSelected = selectedTab == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = title;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFB347) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFB347) : Colors.white54,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? const Color(0xFF1A1A1A) : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    return Dismissible(
      key: Key(notification['id'].toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        // Note: In a real app, you'd delete from Firestore here
        // For now, just show a message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification deleted'),
            backgroundColor: Colors.red,
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  NotificationDetails(notification: notification),
            ),
          );
          setState(() {
            notification['isRead'] = true;
          });
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notification['isRead']
                ? const Color(0xFF2C2C2C)
                : const Color(0xFF2C2C2C).withOpacity(0.7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: notification['isRead']
                  ? Colors.white.withOpacity(0.1)
                  : const Color(0xFFFFB347).withOpacity(0.3),
              width: notification['isRead'] ? 1 : 2,
            ),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: notification['color'].withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  notification['icon'],
                  color: notification['color'],
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification['title'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: notification['isRead']
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                        ),
                        if (!notification['isRead'])
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFB347),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification['message'],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notification['time'],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                      ),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
