import 'package:flutter/material.dart';
import 'package:autohub/screens/chat/chat_media_gallery.dart';
import 'package:autohub/screens/chat/chat_settings.dart';
import 'package:autohub/helper/chat_service.dart';

class ChatConversationPage extends StatefulWidget {
  final String chatId;
  final String otherUserId;
  final String otherUserName;
  final String carTitle;

  const ChatConversationPage({
    super.key,
    required this.chatId,
    required this.otherUserId,
    required this.otherUserName,
    required this.carTitle,
  });

  @override
  State<ChatConversationPage> createState() => _ChatConversationPageState();
}

class _ChatConversationPageState extends State<ChatConversationPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService.instance;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _chatService.setTyping(widget.chatId, false);
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    _chatService.setTyping(widget.chatId, false);

    try {
      await _chatService.sendMessage(chatId: widget.chatId, message: text);

      // Scroll to bottom after sending
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending message: $e'),
            backgroundColor: Colors.red,
          ),
        );
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
                widget.otherUserName.isNotEmpty
                    ? widget.otherUserName[0].toUpperCase()
                    : '?',
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
                    widget.otherUserName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  StreamBuilder<bool>(
                    stream: _chatService.getUserOnlineStatus(
                      widget.otherUserId,
                    ),
                    builder: (context, snapshot) {
                      final isOnline = snapshot.data ?? false;
                      return StreamBuilder<bool>(
                        stream: _chatService.getTypingStatus(
                          widget.chatId,
                          widget.otherUserId,
                        ),
                        builder: (context, typingSnapshot) {
                          final isTyping = typingSnapshot.data ?? false;
                          return Text(
                            isTyping
                                ? 'typing...'
                                : (isOnline ? 'Online' : 'Offline'),
                            style: TextStyle(
                              color: isTyping || isOnline
                                  ? Colors.green.withOpacity(0.8)
                                  : Colors.grey.withOpacity(0.8),
                              fontSize: 12,
                              fontStyle: isTyping
                                  ? FontStyle.italic
                                  : FontStyle.normal,
                            ),
                          );
                        },
                      );
                    },
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
                  builder: (context) =>
                      ChatMediaGallery(conversationName: widget.otherUserName),
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
                    builder: (context) =>
                        ChatSettings(conversationName: widget.otherUserName),
                  ),
                );
              } else if (value == 'media') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatMediaGallery(
                      conversationName: widget.otherUserName,
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
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _chatService.getMessages(widget.chatId),
              builder: (context, snapshot) {
                // Show loading only for initial connection
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFFB347)),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading messages',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${snapshot.error}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final messages = snapshot.data ?? [];

                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 60,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No messages yet',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start the conversation!',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isSentByMe =
                        message['senderId'] == _chatService.currentUserId;

                    // Handle timestamp conversion from Firebase (milliseconds)
                    String timeText = '';
                    final timestampValue = message['timestamp'];
                    if (timestampValue != null) {
                      try {
                        DateTime timestamp;
                        if (timestampValue is int) {
                          timestamp = DateTime.fromMillisecondsSinceEpoch(
                            timestampValue,
                          );
                        } else if (timestampValue is DateTime) {
                          timestamp = timestampValue;
                        } else {
                          timestamp = DateTime.now();
                        }
                        timeText =
                            '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
                      } catch (e) {
                        timeText = '';
                      }
                    }

                    return _buildMessage(
                      message['message'] ?? '',
                      isSentByMe,
                      timeText,
                      imageUrl: message['imageUrl'],
                    );
                  },
                );
              },
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
                    onChanged: (text) {
                      // Set typing indicator
                      _chatService.setTyping(widget.chatId, text.isNotEmpty);
                    },
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                      ),
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
                    onPressed: _sendMessage,
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

  Widget _buildMessage(
    String message,
    bool isMe,
    String time, {
    String? imageUrl,
  }) {
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
                  if (imageUrl != null && imageUrl.isNotEmpty) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        width: 200,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 200,
                            height: 150,
                            color: Colors.grey.withOpacity(0.3),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFFFB347),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 200,
                            height: 150,
                            color: Colors.grey.withOpacity(0.3),
                            child: const Icon(
                              Icons.broken_image,
                              color: Colors.white54,
                            ),
                          );
                        },
                      ),
                    ),
                    if (message.isNotEmpty) const SizedBox(height: 8),
                  ],
                  if (message.isNotEmpty)
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
