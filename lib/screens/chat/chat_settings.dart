import 'package:flutter/material.dart';

class ChatSettings extends StatefulWidget {
  final String conversationName;

  const ChatSettings({super.key, required this.conversationName});

  @override
  State<ChatSettings> createState() => _ChatSettingsState();
}

class _ChatSettingsState extends State<ChatSettings> {
  bool notificationsEnabled = true;
  bool mediaAutoDownload = false;
  bool readReceipts = true;

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
          'Chat Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Info
            Container(
              padding: const EdgeInsets.all(24),
              color: const Color(0xFF2C2C2C),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFFFFB347),
                    child: Text(
                      widget.conversationName[0],
                      style: const TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.conversationName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
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
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, color: Colors.green, size: 8),
                        SizedBox(width: 6),
                        Text(
                          'Online',
                          style: TextStyle(color: Colors.green, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Chat Preferences
            _buildSectionHeader('Chat Preferences'),
            _buildSwitchTile(
              'Notifications',
              'Get notified for new messages',
              notificationsEnabled,
              (value) => setState(() => notificationsEnabled = value),
              Icons.notifications,
            ),
            _buildSwitchTile(
              'Media Auto-Download',
              'Automatically download shared media',
              mediaAutoDownload,
              (value) => setState(() => mediaAutoDownload = value),
              Icons.download,
            ),
            _buildSwitchTile(
              'Read Receipts',
              'Let others know when you\'ve read their messages',
              readReceipts,
              (value) => setState(() => readReceipts = value),
              Icons.done_all,
            ),

            const SizedBox(height: 24),

            // Actions
            _buildSectionHeader('Actions'),
            _buildActionTile(
              'View Shared Media',
              Icons.photo_library,
              Colors.blue,
              () => _viewSharedMedia(),
            ),
            _buildActionTile(
              'Search in Conversation',
              Icons.search,
              Colors.green,
              () => _searchInConversation(),
            ),
            _buildActionTile(
              'Export Chat',
              Icons.download,
              Colors.purple,
              () => _exportChat(),
            ),
            _buildActionTile(
              'Clear Chat History',
              Icons.delete_outline,
              Colors.orange,
              () => _clearChatHistory(),
            ),
            _buildActionTile(
              'Block User',
              Icons.block,
              Colors.red,
              () => _blockUser(),
            ),
            _buildActionTile(
              'Report User',
              Icons.flag,
              Colors.red,
              () => _reportUser(),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFFFB347),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        title: Row(
          children: [
            Icon(icon, color: Colors.white70, size: 20),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 32),
          child: Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 13,
            ),
          ),
        ),
        activeColor: const Color(0xFFFFB347),
      ),
    );
  }

  Widget _buildActionTile(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white54),
      ),
    );
  }

  void _viewSharedMedia() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening shared media...'),
        backgroundColor: Color(0xFFFFB347),
      ),
    );
  }

  void _searchInConversation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening search...'),
        backgroundColor: Color(0xFFFFB347),
      ),
    );
  }

  void _exportChat() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: const Text(
            'Export Chat',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Export this conversation as a text file?',
            style: TextStyle(color: Colors.white),
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
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chat exported successfully'),
                    backgroundColor: Color(0xFFFFB347),
                  ),
                );
              },
              child: const Text('Export'),
            ),
          ],
        );
      },
    );
  }

  void _clearChatHistory() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: const Text(
            'Clear Chat History',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to clear all messages? This action cannot be undone.',
            style: TextStyle(color: Colors.white),
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
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chat history cleared'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  void _blockUser() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: const Text(
            'Block User',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Block ${widget.conversationName}? They won\'t be able to message you or see your listings.',
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
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Go back to chat list
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('User blocked'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text('Block'),
            ),
          ],
        );
      },
    );
  }

  void _reportUser() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: const Text(
            'Report User',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Why are you reporting ${widget.conversationName}?',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              ...[
                'Spam',
                'Scam or fraud',
                'Inappropriate behavior',
                'Fake listing',
                'Other',
              ].map((reason) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    reason,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('User reported for: $reason'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
