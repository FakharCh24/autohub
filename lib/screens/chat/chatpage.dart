import 'package:autohub/screens/chat/blocked_users_page.dart';
import 'package:autohub/screens/chat/chat_media_gallery.dart';
import 'package:autohub/screens/chat/chat_settings.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> conversations = [
    {
      'name': 'Ahmed Ali',
      'lastMessage': 'Is the BMW still available?',
      'time': '2:30 PM',
      'unread': 2,
      'avatar': 'A',
      'carTitle': 'BMW X5 2023',
      'isOnline': true,
    },
    {
      'name': 'Sarah Khan',
      'lastMessage': 'Can we negotiate the price?',
      'time': '1:15 PM',
      'unread': 0,
      'avatar': 'S',
      'carTitle': 'Honda Civic',
      'isOnline': false,
    },
    {
      'name': 'Usman Sheikh',
      'lastMessage': 'Thanks for the info!',
      'time': '11:45 AM',
      'unread': 0,
      'avatar': 'U',
      'carTitle': 'Toyota Corolla',
      'isOnline': true,
    },
    {
      'name': 'Fatima Malik',
      'lastMessage': 'When can I see the car?',
      'time': 'Yesterday',
      'unread': 1,
      'avatar': 'F',
      'carTitle': 'Mercedes C-Class',
      'isOnline': false,
    },
  ];

  String? selectedConversation;

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
        body: selectedConversation == null
            ? _buildConversationList()
            : _buildChatInterface(),
      ),
    );
  }

  Widget _buildConversationList() {
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB347),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${conversations.where((c) => c['unread'] > 0).length} New',
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
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              return _buildConversationTile(conversations[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildConversationTile(Map<String, dynamic> conversation) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFFFB347),
              child: Text(
                conversation['avatar'],
                style: const TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (conversation['isOnline'])
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
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                conversation['name'],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Text(
              conversation['time'],
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
              'Re: ${conversation['carTitle']}',
              style: const TextStyle(
                color: Color(0xFFFFB347),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Expanded(
                  child: Text(
                    conversation['lastMessage'],
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (conversation['unread'] > 0)
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
                      '${conversation['unread']}',
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
        onTap: () {
          setState(() {
            selectedConversation = conversation['name'];
          });
        },
      ),
    );
  }

  Widget _buildChatInterface() {
    return Column(
      children: [
        // Chat Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2C),
            border: Border(
              bottom: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    selectedConversation = null;
                  });
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              CircleAvatar(
                backgroundColor: const Color(0xFFFFB347),
                child: Text(
                  selectedConversation![0],
                  style: const TextStyle(
                    color: Color(0xFF1A1A1A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedConversation!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Online',
                      style: TextStyle(
                        color: Colors.green.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatMediaGallery(
                        conversationName: selectedConversation!,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.photo_library, color: Color(0xFFFFB347)),
                tooltip: 'Media Gallery',
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                color: const Color(0xFF2C2C2C),
                onSelected: (value) {
                  if (value == 'settings') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatSettings(
                          conversationName: selectedConversation!,
                        ),
                      ),
                    );
                  } else if (value == 'media') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatMediaGallery(
                          conversationName: selectedConversation!,
                        ),
                      ),
                    );
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'settings',
                    child: Row(
                      children: [
                        Icon(Icons.settings, color: Color(0xFFFFB347)),
                        SizedBox(width: 12),
                        Text(
                          'Chat Settings',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'media',
                    child: Row(
                      children: [
                        Icon(Icons.photo_library, color: Color(0xFFFFB347)),
                        SizedBox(width: 12),
                        Text(
                          'Media Gallery',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Messages Area
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildMessage(
                'Hi! Is the BMW X5 still available?',
                false,
                '2:15 PM',
              ),
              _buildMessage(
                'Yes, it is! Would you like to schedule a viewing?',
                true,
                '2:16 PM',
              ),
              _buildMessage(
                'That would be great! What times work for you?',
                false,
                '2:18 PM',
              ),
              _buildMessage(
                'I\'m free this weekend. Saturday or Sunday work?',
                true,
                '2:20 PM',
              ),
              _buildMessage(
                'Saturday afternoon works perfectly!',
                false,
                '2:30 PM',
              ),
            ],
          ),
        ),

        // Message Input
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2C),
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.attach_file, color: Colors.white),
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    filled: true,
                    fillColor: const Color(0xFF1A1A1A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFFB347),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      // Send message logic here
                      _messageController.clear();
                    }
                  },
                  icon: const Icon(Icons.send, color: Color(0xFF1A1A1A)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessage(String message, bool isMe, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMe) const SizedBox(width: 40),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFFFFB347) : const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      color: isMe ? const Color(0xFF1A1A1A) : Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      color: isMe
                          ? const Color(0xFF1A1A1A).withOpacity(0.7)
                          : Colors.white.withOpacity(0.5),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) const SizedBox(width: 40),
        ],
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
