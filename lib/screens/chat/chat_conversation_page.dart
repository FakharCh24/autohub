import 'package:flutter/material.dart';
import 'package:autohub/screens/chat/chat_media_gallery.dart';
import 'package:autohub/screens/chat/chat_settings.dart';

class ChatConversationPage extends StatefulWidget {
  final String conversationName;
  final String avatar;
  final String carTitle;
  final bool isOnline;

  const ChatConversationPage({
    super.key,
    required this.conversationName,
    required this.avatar,
    required this.carTitle,
    required this.isOnline,
  });

  @override
  State<ChatConversationPage> createState() => _ChatConversationPageState();
}

class _ChatConversationPageState extends State<ChatConversationPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2C2C),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFFFB347),
              child: Text(
                widget.avatar,
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
                    widget.conversationName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    widget.isOnline ? 'Online' : 'Offline',
                    style: TextStyle(
                      color: widget.isOnline
                          ? Colors.green.withOpacity(0.8)
                          : Colors.grey.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatMediaGallery(
                    conversationName: widget.conversationName,
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
                      conversationName: widget.conversationName,
                    ),
                  ),
                );
              } else if (value == 'media') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatMediaGallery(
                      conversationName: widget.conversationName,
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
      body: Column(
        children: [
          // Car Title Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2C),
              border: Border(
                bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.directions_car,
                  color: Color(0xFFFFB347),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Re: ${widget.carTitle}',
                  style: const TextStyle(
                    color: Color(0xFFFFB347),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
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
                  'Hi! Is the ${widget.carTitle} still available?',
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
                  onPressed: () {
                    // TODO: Implement file attachment
                  },
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
                        // TODO: Send message
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
      ),
    );
  }

  Widget _buildMessage(String message, bool isMe, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
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
}
