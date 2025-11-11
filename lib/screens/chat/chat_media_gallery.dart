import 'package:flutter/material.dart';

class ChatMediaGallery extends StatefulWidget {
  final String conversationName;

  const ChatMediaGallery({super.key, required this.conversationName});

  @override
  State<ChatMediaGallery> createState() => _ChatMediaGalleryState();
}

class _ChatMediaGalleryState extends State<ChatMediaGallery>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> mediaItems = [
    {
      'type': 'image',
      'url': 'assets/images/bmw.jpg',
      'date': '2024-01-15',
      'thumbnail': 'assets/images/bmw.jpg',
    },
    {
      'type': 'image',
      'url': 'assets/images/merc.jpg',
      'date': '2024-01-14',
      'thumbnail': 'assets/images/merc.jpg',
    },
    {
      'type': 'image',
      'url': 'assets/images/ford.jpg',
      'date': '2024-01-13',
      'thumbnail': 'assets/images/ford.jpg',
    },
  ];

  final List<Map<String, dynamic>> documentItems = [
    {
      'name': 'Car_Registration.pdf',
      'size': '2.5 MB',
      'date': '2024-01-15',
      'icon': Icons.picture_as_pdf,
    },
    {
      'name': 'Insurance_Document.pdf',
      'size': '1.8 MB',
      'date': '2024-01-14',
      'icon': Icons.description,
    },
  ];

  final List<Map<String, dynamic>> linkItems = [
    {
      'url': 'https://autohub.com/car/bmw-m3',
      'title': 'BMW M3 2022 - AutoHub',
      'date': '2024-01-15',
    },
    {
      'url': 'https://autohub.com/car/mercedes-c-class',
      'title': 'Mercedes C-Class 2021 - AutoHub',
      'date': '2024-01-14',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shared Media',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              widget.conversationName,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFFFB347),
          labelColor: const Color(0xFFFFB347),
          unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(text: 'Photos'),
            Tab(text: 'Documents'),
            Tab(text: 'Links'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildPhotosTab(), _buildDocumentsTab(), _buildLinksTab()],
      ),
    );
  }

  Widget _buildPhotosTab() {
    if (mediaItems.isEmpty) {
      return _buildEmptyState(
        Icons.photo_library,
        'No photos shared',
        'Photos you share will appear here',
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: mediaItems.length,
      itemBuilder: (context, index) {
        return _buildPhotoItem(mediaItems[index]);
      },
    );
  }

  Widget _buildPhotoItem(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () => _viewFullImage(item),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            item['thumbnail'],
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xFF2C2C2C),
                child: const Icon(Icons.image, color: Colors.white54, size: 40),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentsTab() {
    if (documentItems.isEmpty) {
      return _buildEmptyState(
        Icons.folder_open,
        'No documents shared',
        'Documents you share will appear here',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: documentItems.length,
      itemBuilder: (context, index) {
        return _buildDocumentItem(documentItems[index]);
      },
    );
  }

  Widget _buildDocumentItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFB347).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(item['icon'], color: const Color(0xFFFFB347), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      item['size'],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      ' • ${item['date']}',
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
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white54),
            color: const Color(0xFF2C2C2C),
            onSelected: (value) {
              if (value == 'download') {
                _downloadDocument(item);
              } else if (value == 'share') {
                _shareDocument(item);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'download',
                child: Row(
                  children: [
                    Icon(Icons.download, color: Colors.white, size: 20),
                    SizedBox(width: 12),
                    Text('Download', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share, color: Colors.white, size: 20),
                    SizedBox(width: 12),
                    Text('Share', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLinksTab() {
    if (linkItems.isEmpty) {
      return _buildEmptyState(
        Icons.link,
        'No links shared',
        'Links you share will appear here',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: linkItems.length,
      itemBuilder: (context, index) {
        return _buildLinkItem(linkItems[index]);
      },
    );
  }

  Widget _buildLinkItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.link, color: Colors.blue, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item['url'],
                  style: TextStyle(
                    color: Colors.blue.withOpacity(0.8),
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item['date'],
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _openLink(item['url']),
            icon: const Icon(Icons.open_in_new, color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.white.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _viewFullImage(Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.download, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Image downloaded'),
                      backgroundColor: Color(0xFFFFB347),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sharing image...'),
                      backgroundColor: Color(0xFFFFB347),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.asset(item['url'], fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }

  void _downloadDocument(Map<String, dynamic> item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading ${item['name']}...'),
        backgroundColor: const Color(0xFFFFB347),
      ),
    );
  }

  void _shareDocument(Map<String, dynamic> item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${item['name']}...'),
        backgroundColor: const Color(0xFFFFB347),
      ),
    );
  }

  void _openLink(String url) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening $url...'),
        backgroundColor: const Color(0xFFFFB347),
      ),
    );
  }
}
