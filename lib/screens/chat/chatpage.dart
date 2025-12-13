import 'package:autohub/screens/chat/blocked_users_page.dart';
import 'package:autohub/screens/chat/chat_conversation_page.dart';
import 'package:autohub/helper/chat_service.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatService _chatService = ChatService.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        appBar: AppBar(
          backgroundColor: const Color(0xFF2C2C2C),
          elevation: 0,
          title: const Text(
            'Messages',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                _showSearchDialog();
              },
              icon: const Icon(Icons.search, color: Colors.white),
              tooltip: 'Search Messages',
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BlockedUsersPage(),
                  ),
                );
              },
              icon: const Icon(Icons.block, color: Colors.white),
              tooltip: 'Blocked Users',
            ),
          ],
        ),
        body: _buildConversationList(),
      ),
    );
  }

  Widget _buildConversationList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _chatService.getUserChats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFFFB347)),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading chats: ${snapshot.error}',
              style: const TextStyle(color: Colors.white),
            ),
          );
        }

        final chats = snapshot.data ?? [];

        if (chats.isEmpty) {
          return _buildEmptyState();
        }

        final currentUserId = _chatService.currentUserId ?? '';
        final newMessagesCount = chats.where((chat) {
          final unreadCount = chat['unreadCount'];
          if (unreadCount is Map) {
            return (unreadCount[currentUserId] ?? 0) > 0;
          }
          return false;
        }).length;

        return Column(
          children: [
            // Active Deals Header
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Active Conversations',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (newMessagesCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB347),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$newMessagesCount New',
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

            // Conversations List
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  return _buildConversationTile(chats[index]);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No conversations yet',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start chatting with sellers!',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationTile(Map<String, dynamic> chat) {
    final otherUserName = chat['otherUserName'] ?? 'Unknown';
    final otherUserId = chat['otherUserId'] ?? '';
    final lastMessage = chat['lastMessage'] ?? '';

    // Convert timestamp from int to DateTime
    DateTime? timestamp;
    final lastMessageTime = chat['lastMessageTime'];
    if (lastMessageTime != null) {
      if (lastMessageTime is int) {
        timestamp = DateTime.fromMillisecondsSinceEpoch(lastMessageTime);
      } else if (lastMessageTime is DateTime) {
        timestamp = lastMessageTime;
      }
    }

    final currentUserId = _chatService.currentUserId ?? '';
    final unreadCountMap = chat['unreadCount'];
    final unreadCount = (unreadCountMap is Map)
        ? (unreadCountMap[currentUserId] ?? 0) as int
        : 0;
    final carTitle = chat['carTitle'] ?? 'Car';
    final chatId = chat['chatId'] ?? '';

    // Format timestamp
    String timeText = '';
    if (timestamp != null) {
      final now = DateTime.now();
      final difference = now.difference(timestamp);

      if (difference.inDays == 0) {
        timeText =
            '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
      } else if (difference.inDays == 1) {
        timeText = 'Yesterday';
      } else if (difference.inDays < 7) {
        timeText = '${difference.inDays}d ago';
      } else {
        timeText = '${timestamp.day}/${timestamp.month}';
      }
    }

    // Get first letter for avatar
    final avatar = otherUserName.isNotEmpty
        ? otherUserName[0].toUpperCase()
        : '?';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ListTile(
        leading: StreamBuilder<bool>(
          stream: _chatService.getUserOnlineStatus(otherUserId),
          builder: (context, onlineSnapshot) {
            final isOnline = onlineSnapshot.data ?? false;
            return Stack(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFFFB347),
                  child: Text(
                    avatar,
                    style: const TextStyle(
                      color: Color(0xFF1A1A1A),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF2C2C2C),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                otherUserName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              timeText,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Re: $carTitle',
              style: const TextStyle(
                color: Color(0xFFFFB347),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Expanded(
                  child: Text(
                    lastMessage,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (unreadCount > 0)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFB347),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$unreadCount',
                      style: const TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        onTap: () async {
          // Mark messages as read when opening chat
          await _chatService.markMessagesAsRead(chatId);

          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatConversationPage(
                  chatId: chatId,
                  otherUserId: otherUserId,
                  otherUserName: otherUserName,
                  carTitle: carTitle,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: const Text(
            'Search Messages',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search conversations...',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              filled: true,
              fillColor: const Color(0xFF1A1A1A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
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
                backgroundColor: const Color(0xFFFFB347),
                foregroundColor: const Color(0xFF1A1A1A),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }
}
