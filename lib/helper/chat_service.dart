import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autohub/helper/firestore_helper.dart';

class ChatService {
  ChatService._();
  static final ChatService instance = ChatService._();

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirestoreHelper _firestoreHelper = FirestoreHelper.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  // ==================== CHAT ROOM OPERATIONS ====================

  /// Create or get existing chat room between two users about a specific car
  Future<String?> createOrGetChatRoom({
    required String sellerId,
    required String buyerId,
    required String carId,
    required String carTitle,
  }) async {
    try {
      // Create a consistent chat room ID
      final participants = [sellerId, buyerId]..sort();
      final chatId = '${participants[0]}_${participants[1]}_$carId';

      final chatRef = _database.ref('chats/$chatId');
      final snapshot = await chatRef.get();

      if (!snapshot.exists) {
        // Create new chat room
        await chatRef.set({
          'chatId': chatId,
          'participants': [sellerId, buyerId],
          'sellerId': sellerId,
          'buyerId': buyerId,
          'carId': carId,
          'carTitle': carTitle,
          'createdAt': ServerValue.timestamp,
          'lastMessage': '',
          'lastMessageTime': ServerValue.timestamp,
          'lastMessageSenderId': '',
        });

        // Update unread count for both users
        await chatRef.child('unreadCount').set({sellerId: 0, buyerId: 0});
      }

      return chatId;
    } catch (e) {
      print('Error creating chat room: $e');
      return null;
    }
  }

  /// Get all chat rooms for current user
  Stream<List<Map<String, dynamic>>> getUserChats() {
    final userId = currentUserId;
    if (userId == null) {
      return Stream.value([]);
    }

    return _database
        .ref('chats')
        .orderByChild('lastMessageTime')
        .onValue
        .asyncMap((event) async {
          if (event.snapshot.value == null) return [];

          final chatsMap = event.snapshot.value as Map<dynamic, dynamic>;
          List<Map<String, dynamic>> userChats = [];

          for (var entry in chatsMap.entries) {
            final chatData = Map<String, dynamic>.from(entry.value as Map);
            final participants = List<String>.from(
              chatData['participants'] ?? [],
            );

            if (participants.contains(userId)) {
              chatData['chatId'] = entry.key;

              // Get other user's info
              final otherUserId = participants.firstWhere(
                (id) => id != userId,
                orElse: () => '',
              );
              if (otherUserId.isNotEmpty) {
                final userDoc = await _firestore
                    .collection('users')
                    .doc(otherUserId)
                    .get();
                if (userDoc.exists) {
                  final userData = userDoc.data()!;
                  chatData['otherUserName'] =
                      userData['name'] ?? 'Unknown User';
                  chatData['otherUserPhoto'] = userData['photoUrl'] ?? '';
                }
              }

              // Get unread count
              final unreadCount = chatData['unreadCount']?[userId] ?? 0;
              chatData['unread'] = unreadCount;

              userChats.add(chatData);
            }
          }

          // Sort by last message time (most recent first)
          userChats.sort((a, b) {
            final aTime = a['lastMessageTime'] ?? 0;
            final bTime = b['lastMessageTime'] ?? 0;
            return bTime.compareTo(aTime);
          });

          return userChats;
        });
  }

  // ==================== MESSAGE OPERATIONS ====================

  /// Send a text message
  Future<bool> sendMessage({
    required String chatId,
    required String message,
    String? imageUrl,
  }) async {
    try {
      final userId = currentUserId;
      if (userId == null) return false;

      final messageRef = _database.ref('chats/$chatId/messages').push();
      final messageId = messageRef.key!;

      final messageData = {
        'messageId': messageId,
        'senderId': userId,
        'message': message,
        'imageUrl': imageUrl ?? '',
        'timestamp': ServerValue.timestamp,
        'isRead': false,
      };

      await messageRef.set(messageData);

      // Update chat room last message
      await _database.ref('chats/$chatId').update({
        'lastMessage': message.isEmpty && imageUrl != null
            ? '📷 Image'
            : message,
        'lastMessageTime': ServerValue.timestamp,
        'lastMessageSenderId': userId,
      });

      // Get chat data to create notification
      final chatSnapshot = await _database.ref('chats/$chatId').get();
      if (chatSnapshot.exists) {
        final chatData = Map<String, dynamic>.from(chatSnapshot.value as Map);
        final participants = List<String>.from(chatData['participants'] ?? []);
        final otherUserId = participants.firstWhere(
          (id) => id != userId,
          orElse: () => '',
        );

        if (otherUserId.isNotEmpty) {
          // Increment unread count for other user
          final currentUnread = chatData['unreadCount']?[otherUserId] ?? 0;
          await _database
              .ref('chats/$chatId/unreadCount/$otherUserId')
              .set(currentUnread + 1);

          // Get sender's name
          final senderDoc = await _firestore
              .collection('users')
              .doc(userId)
              .get();
          final senderName = senderDoc.exists
              ? (senderDoc.data()?['name'] ?? 'Someone')
              : 'Someone';

          // Create notification for the recipient
          final carTitle = chatData['carTitle'] ?? 'a car';
          final notificationMessage = message.isEmpty && imageUrl != null
              ? 'sent you an image'
              : message;

          await _firestoreHelper.createNotification(
            userId: otherUserId,
            type: 'message',
            title: '$senderName sent you a message',
            message: 'About $carTitle: $notificationMessage',
            relatedId: chatId,
          );
        }
      }

      return true;
    } catch (e) {
      print('Error sending message: $e');
      return false;
    }
  }

  /// Get messages for a chat room
  Stream<List<Map<String, dynamic>>> getMessages(String chatId) {
    try {
      final messagesRef = _database.ref('chats/$chatId/messages');

      return messagesRef
          .orderByChild('timestamp')
          .onValue
          .asyncMap((event) async {
            // Double-check the snapshot value
            if (event.snapshot.value == null) {
              // Try once more with a direct get
              try {
                final directSnapshot = await messagesRef.get();
                if (directSnapshot.value == null) {
                  return <Map<String, dynamic>>[];
                }
                // If we got data, process it
                final messagesMap =
                    directSnapshot.value as Map<dynamic, dynamic>;
                return _parseMessages(messagesMap);
              } catch (e) {
                print('Error in direct fetch: $e');
                return <Map<String, dynamic>>[];
              }
            }

            try {
              final messagesMap = event.snapshot.value as Map<dynamic, dynamic>;
              return _parseMessages(messagesMap);
            } catch (e) {
              print('Error parsing messages: $e');
              return <Map<String, dynamic>>[];
            }
          })
          .handleError((error) {
            print('Stream error in getMessages: $error');
            return <Map<String, dynamic>>[];
          });
    } catch (e) {
      print('Error creating message stream: $e');
      // Return a stream that immediately emits empty list
      return Stream.value(<Map<String, dynamic>>[]);
    }
  }

  /// Helper method to parse messages from Firebase data
  List<Map<String, dynamic>> _parseMessages(Map<dynamic, dynamic> messagesMap) {
    List<Map<String, dynamic>> messages = [];

    messagesMap.forEach((key, value) {
      if (value != null) {
        try {
          final messageData = Map<String, dynamic>.from(value as Map);
          messageData['messageId'] = key;
          messages.add(messageData);
        } catch (e) {
          print('Error parsing message $key: $e');
        }
      }
    });

    // Sort by timestamp (oldest first for chat display)
    messages.sort((a, b) {
      final aTime = a['timestamp'] ?? 0;
      final bTime = b['timestamp'] ?? 0;
      return aTime.compareTo(bTime);
    });

    return messages;
  }

  /// Mark messages as read
  Future<void> markMessagesAsRead(String chatId) async {
    try {
      final userId = currentUserId;
      if (userId == null) return;

      // Reset unread count for current user
      await _database.ref('chats/$chatId/unreadCount/$userId').set(0);

      // Mark all messages from other user as read
      final messagesSnapshot = await _database
          .ref('chats/$chatId/messages')
          .get();
      if (messagesSnapshot.exists) {
        final messagesMap = messagesSnapshot.value as Map<dynamic, dynamic>;
        messagesMap.forEach((key, value) async {
          final messageData = Map<String, dynamic>.from(value as Map);
          if (messageData['senderId'] != userId &&
              messageData['isRead'] == false) {
            await _database.ref('chats/$chatId/messages/$key/isRead').set(true);
          }
        });
      }
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }

  /// Delete a message
  Future<bool> deleteMessage({
    required String chatId,
    required String messageId,
  }) async {
    try {
      await _database.ref('chats/$chatId/messages/$messageId').remove();
      return true;
    } catch (e) {
      print('Error deleting message: $e');
      return false;
    }
  }

  // ==================== USER STATUS OPERATIONS ====================

  /// Set user online status
  Future<void> setUserOnline() async {
    final userId = currentUserId;
    if (userId == null) return;

    try {
      await _database.ref('userStatus/$userId').set({
        'isOnline': true,
        'lastSeen': ServerValue.timestamp,
      });

      // Set offline when disconnected
      _database.ref('userStatus/$userId/isOnline').onDisconnect().set(false);
      _database
          .ref('userStatus/$userId/lastSeen')
          .onDisconnect()
          .set(ServerValue.timestamp);
    } catch (e) {
      print('Error setting user online: $e');
    }
  }

  /// Set user offline status
  Future<void> setUserOffline() async {
    final userId = currentUserId;
    if (userId == null) return;

    try {
      await _database.ref('userStatus/$userId').set({
        'isOnline': false,
        'lastSeen': ServerValue.timestamp,
      });
    } catch (e) {
      print('Error setting user offline: $e');
    }
  }

  /// Get user online status (boolean only)
  Stream<bool> getUserOnlineStatus(String userId) {
    return _database.ref('userStatus/$userId/isOnline').onValue.map((event) {
      return event.snapshot.value == true;
    });
  }

  /// Get user online status
  Stream<Map<String, dynamic>> getUserStatus(String userId) {
    return _database.ref('userStatus/$userId').onValue.map((event) {
      if (event.snapshot.value == null) {
        return {'isOnline': false, 'lastSeen': 0};
      }
      return Map<String, dynamic>.from(event.snapshot.value as Map);
    });
  }

  // ==================== TYPING INDICATOR ====================

  /// Set typing indicator
  Future<void> setTyping(String chatId, bool isTyping) async {
    final userId = currentUserId;
    if (userId == null) return;

    try {
      await _database.ref('chats/$chatId/typing/$userId').set(isTyping);
    } catch (e) {
      print('Error setting typing indicator: $e');
    }
  }

  /// Get typing status
  Stream<bool> getTypingStatus(String chatId, String otherUserId) {
    return _database.ref('chats/$chatId/typing/$otherUserId').onValue.map((
      event,
    ) {
      return event.snapshot.value as bool? ?? false;
    });
  }

  // ==================== BLOCK USER ====================

  /// Block a user
  Future<bool> blockUser(String userIdToBlock) async {
    final userId = currentUserId;
    if (userId == null) return false;

    try {
      await _firestore.collection('users').doc(userId).update({
        'blockedUsers': FieldValue.arrayUnion([userIdToBlock]),
      });
      return true;
    } catch (e) {
      print('Error blocking user: $e');
      return false;
    }
  }

  /// Unblock a user
  Future<bool> unblockUser(String userIdToUnblock) async {
    final userId = currentUserId;
    if (userId == null) return false;

    try {
      await _firestore.collection('users').doc(userId).update({
        'blockedUsers': FieldValue.arrayRemove([userIdToUnblock]),
      });
      return true;
    } catch (e) {
      print('Error unblocking user: $e');
      return false;
    }
  }

  /// Get blocked users list
  Future<List<String>> getBlockedUsers() async {
    final userId = currentUserId;
    if (userId == null) return [];

    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        final data = doc.data();
        return List<String>.from(data?['blockedUsers'] ?? []);
      }
      return [];
    } catch (e) {
      print('Error getting blocked users: $e');
      return [];
    }
  }
}
