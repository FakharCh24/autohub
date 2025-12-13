import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/price_alert_service.dart';

class FirestoreHelper {
  FirestoreHelper._();
  static final FirestoreHelper instance = FirestoreHelper._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final PriceAlertService _alertService = PriceAlertService.instance;

  // Collection references
  CollectionReference get _carsCollection => _firestore.collection('cars');
  CollectionReference get _usersCollection => _firestore.collection('users');

  // ==================== USER OPERATIONS ====================

  /// Create user profile on signup
  Future<bool> createUserProfile({
    required String userId,
    required String email,
    String? name,
    String? photoUrl,
  }) async {
    try {
      await _usersCollection.doc(userId).set({
        'userId': userId,
        'email': email,
        'name': name ?? email.split('@')[0],
        'photoUrl': photoUrl ?? '',
        'phone': '',
        'address': '',
        'bio': '',
        'createdAt': FieldValue.serverTimestamp(),
        'favorites': [],
        'blockedUsers': [],
        'isVerifiedSeller': false,
      });
      return true;
    } catch (e) {
      print('Error creating user profile: $e');
      return false;
    }
  }

  /// Get user profile
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final doc = await _usersCollection.doc(userId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  /// Update user profile
  Future<bool> updateUserProfile({
    required String userId,
    String? name,
    String? photoUrl,
    String? phone,
    String? address,
    String? bio,
  }) async {
    try {
      Map<String, dynamic> updates = {};
      if (name != null) updates['name'] = name;
      if (photoUrl != null) updates['photoUrl'] = photoUrl;
      if (phone != null) updates['phone'] = phone;
      if (address != null) updates['address'] = address;
      if (bio != null) updates['bio'] = bio;

      if (updates.isNotEmpty) {
        await _usersCollection.doc(userId).update(updates);
      }
      return true;
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
    }
  }

  // ==================== CAR OPERATIONS ====================

  /// Add a new car listing
  Future<String?> addCar({
    required String title,
    required int price,
    required String description,
    required int year,
    required int mileage,
    required String category,
    required String fuel,
    required String transmission,
    required String condition,
    required String location,
    required List<String> imageUrls,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      final docRef = await _carsCollection.add({
        'userId': userId,
        'title': title,
        'price': price,
        'description': description,
        'year': year,
        'mileage': mileage,
        'category': category,
        'fuel': fuel,
        'transmission': transmission,
        'condition': condition,
        'location': location,
        'imageUrls': imageUrls,
        'createdAt': FieldValue.serverTimestamp(),
        'views': 0,
        'favoriteCount': 0,
        'isActive': true,
      });

      return docRef.id;
    } catch (e) {
      print('Error adding car: $e');
      return null;
    }
  }

  /// Get all car listings
  /// Sorted client-side to avoid index requirement
  Stream<List<Map<String, dynamic>>> getAllCars() {
    return _carsCollection.where('isActive', isEqualTo: true).snapshots().map((
      snapshot,
    ) {
      final cars = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();

      // Sort by createdAt client-side (no index needed)
      cars.sort((a, b) {
        final aTime = a['createdAt'] as Timestamp?;
        final bTime = b['createdAt'] as Timestamp?;
        if (aTime == null || bTime == null) return 0;
        return bTime.compareTo(aTime); // Descending order (newest first)
      });

      return cars;
    });
  }

  /// Get car listings by current user
  /// Sorted client-side to avoid index requirement
  Stream<List<Map<String, dynamic>>> getMyListings() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }

    return _carsCollection.where('userId', isEqualTo: userId).snapshots().map((
      snapshot,
    ) {
      final cars = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();

      // Sort by createdAt client-side (no index needed)
      cars.sort((a, b) {
        final aTime = a['createdAt'] as Timestamp?;
        final bTime = b['createdAt'] as Timestamp?;
        if (aTime == null || bTime == null) return 0;
        return bTime.compareTo(aTime); // Descending order (newest first)
      });

      return cars;
    });
  }

  /// Get car listings by specific user ID
  /// Sorted client-side to avoid index requirement
  Stream<List<Map<String, dynamic>>> getUserListings(String userId) {
    return _carsCollection
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          final cars = snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return data;
          }).toList();

          // Sort by createdAt client-side (no index needed)
          cars.sort((a, b) {
            final aTime = a['createdAt'] as Timestamp?;
            final bTime = b['createdAt'] as Timestamp?;
            if (aTime == null || bTime == null) return 0;
            return bTime.compareTo(aTime); // Descending order (newest first)
          });

          return cars;
        });
  }

  /// Get a single car by ID
  Future<Map<String, dynamic>?> getCarById(String carId) async {
    try {
      final doc = await _carsCollection.doc(carId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }
      return null;
    } catch (e) {
      print('Error getting car: $e');
      return null;
    }
  }

  /// Update car listing
  Future<bool> updateCar({
    required String carId,
    String? title,
    int? price,
    String? description,
    bool? isActive,
  }) async {
    try {
      Map<String, dynamic> updates = {};
      if (title != null) updates['title'] = title;
      if (price != null) updates['price'] = price;
      if (description != null) updates['description'] = description;
      if (isActive != null) updates['isActive'] = isActive;

      if (updates.isNotEmpty) {
        await _carsCollection.doc(carId).update(updates);

        // If price was updated, check for triggered alerts
        if (price != null) {
          await _alertService.monitorPriceChange(carId, price.toDouble());
        }
      }
      return true;
    } catch (e) {
      print('Error updating car: $e');
      return false;
    }
  }

  /// Delete car listing
  Future<bool> deleteCar(String carId) async {
    try {
      // Soft delete by setting isActive to false
      await _carsCollection.doc(carId).update({'isActive': false});
      return true;
    } catch (e) {
      print('Error deleting car: $e');
      return false;
    }
  }

  /// Increment view count
  Future<void> incrementViews(String carId) async {
    try {
      await _carsCollection.doc(carId).update({
        'views': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error incrementing views: $e');
    }
  }

  // ==================== FAVORITES OPERATIONS ====================

  /// Add car to favorites
  Future<bool> addToFavorites(String carId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      await _usersCollection.doc(userId).update({
        'favorites': FieldValue.arrayUnion([carId]),
      });

      // Increment favorite count on car
      await _carsCollection.doc(carId).update({
        'favoriteCount': FieldValue.increment(1),
      });

      return true;
    } catch (e) {
      print('Error adding to favorites: $e');
      return false;
    }
  }

  /// Remove car from favorites
  Future<bool> removeFromFavorites(String carId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      await _usersCollection.doc(userId).update({
        'favorites': FieldValue.arrayRemove([carId]),
      });

      // Decrement favorite count on car
      await _carsCollection.doc(carId).update({
        'favoriteCount': FieldValue.increment(-1),
      });

      return true;
    } catch (e) {
      print('Error removing from favorites: $e');
      return false;
    }
  }

  /// Get user's favorite cars
  Stream<List<Map<String, dynamic>>> getFavoriteCars() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }

    return _usersCollection.doc(userId).snapshots().asyncMap((userDoc) async {
      if (!userDoc.exists) return [];

      final data = userDoc.data() as Map<String, dynamic>?;
      final favorites = List<String>.from(data?['favorites'] ?? []);
      if (favorites.isEmpty) return [];

      // Fetch all favorite cars
      final List<Map<String, dynamic>> favoriteCars = [];
      for (String carId in favorites) {
        final carData = await getCarById(carId);
        if (carData != null && carData['isActive'] == true) {
          favoriteCars.add(carData);
        }
      }
      return favoriteCars;
    });
  }

  /// Check if car is in favorites
  Future<bool> isCarFavorite(String carId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      final doc = await _usersCollection.doc(userId).get();
      if (!doc.exists) return false;

      final data = doc.data() as Map<String, dynamic>?;
      final favorites = List<String>.from(data?['favorites'] ?? []);
      return favorites.contains(carId);
    } catch (e) {
      print('Error checking favorite: $e');
      return false;
    }
  }

  // ==================== SEARCH OPERATIONS ====================

  /// Search cars by title or category
  /// Uses client-side filtering to avoid complex Firestore index requirements
  Future<List<Map<String, dynamic>>> searchCars({
    String? query,
    String? category,
    int? minPrice,
    int? maxPrice,
    String? fuel,
    String? transmission,
  }) async {
    try {
      // Only use ONE server-side filter to avoid index requirements
      // Fetch all active cars and filter the rest client-side
      Query queryRef = _carsCollection.where('isActive', isEqualTo: true);

      final snapshot = await queryRef.get();
      List<Map<String, dynamic>> results = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();

      // Filter by category locally (no index needed)
      if (category != null && category != 'All') {
        results = results.where((car) {
          return car['category'] == category;
        }).toList();
      }

      // Filter by fuel locally (no index needed)
      if (fuel != null && fuel != 'All') {
        results = results.where((car) {
          return car['fuel'] == fuel;
        }).toList();
      }

      // Filter by transmission locally (no index needed)
      if (transmission != null && transmission != 'All') {
        results = results.where((car) {
          return car['transmission'] == transmission;
        }).toList();
      }

      // Filter by price range locally
      if (minPrice != null || maxPrice != null) {
        results = results.where((car) {
          final price = car['price'] as int;
          if (minPrice != null && price < minPrice) return false;
          if (maxPrice != null && price > maxPrice) return false;
          return true;
        }).toList();
      }

      // Filter by search query locally
      if (query != null && query.isNotEmpty) {
        final lowerQuery = query.toLowerCase();
        results = results.where((car) {
          final title = (car['title'] as String).toLowerCase();
          final description = (car['description'] as String).toLowerCase();
          return title.contains(lowerQuery) || description.contains(lowerQuery);
        }).toList();
      }

      return results;
    } catch (e) {
      print('Error searching cars: $e');
      return [];
    }
  }

  // ==================== REVIEWS OPERATIONS ====================

  /// Add a review for a car
  Future<bool> addReview({
    required String carId,
    required int rating,
    required String reviewText,
    List<String>? imageUrls,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      await _firestore.collection('reviews').add({
        'carId': carId,
        'userId': userId,
        'rating': rating,
        'reviewText': reviewText,
        'imageUrls': imageUrls ?? [],
        'createdAt': FieldValue.serverTimestamp(),
        'helpful': 0,
      });

      return true;
    } catch (e) {
      print('Error adding review: $e');
      return false;
    }
  }

  /// Get reviews for a specific car
  Stream<List<Map<String, dynamic>>> getCarReviews(String carId) {
    return _firestore
        .collection('reviews')
        .where('carId', isEqualTo: carId)
        .snapshots()
        .asyncMap((snapshot) async {
          List<Map<String, dynamic>> reviews = [];

          for (var doc in snapshot.docs) {
            final reviewData = doc.data();
            reviewData['id'] = doc.id;

            // Fetch user info for each review
            final userId = reviewData['userId'];
            if (userId != null) {
              final userDoc = await _usersCollection.doc(userId).get();
              if (userDoc.exists) {
                final userData = userDoc.data() as Map<String, dynamic>;
                reviewData['userName'] = userData['name'] ?? 'Anonymous';
                reviewData['userImage'] = userData['photoUrl'] ?? '';
              }
            }

            reviews.add(reviewData);
          }

          // Sort by createdAt (newest first)
          reviews.sort((a, b) {
            final aTime = a['createdAt'] as Timestamp?;
            final bTime = b['createdAt'] as Timestamp?;
            if (aTime == null || bTime == null) return 0;
            return bTime.compareTo(aTime);
          });

          return reviews;
        });
  }

  /// Increment helpful count on a review
  Future<void> markReviewHelpful(String reviewId) async {
    try {
      await _firestore.collection('reviews').doc(reviewId).update({
        'helpful': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error marking review helpful: $e');
    }
  }

  // ==================== BLOCKED USERS OPERATIONS ====================

  /// Block a user
  Future<bool> blockUser(String userIdToBlock) async {
    try {
      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) return false;

      await _usersCollection.doc(currentUserId).update({
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
    try {
      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) return false;

      await _usersCollection.doc(currentUserId).update({
        'blockedUsers': FieldValue.arrayRemove([userIdToUnblock]),
      });

      return true;
    } catch (e) {
      print('Error unblocking user: $e');
      return false;
    }
  }

  /// Get blocked users list
  Future<List<Map<String, dynamic>>> getBlockedUsers() async {
    try {
      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) return [];

      final userDoc = await _usersCollection.doc(currentUserId).get();
      if (!userDoc.exists) return [];

      final userData = userDoc.data() as Map<String, dynamic>;
      final blockedUserIds = List<String>.from(userData['blockedUsers'] ?? []);

      List<Map<String, dynamic>> blockedUsers = [];
      for (String userId in blockedUserIds) {
        final blockedUserDoc = await _usersCollection.doc(userId).get();
        if (blockedUserDoc.exists) {
          final blockedUserData = blockedUserDoc.data() as Map<String, dynamic>;
          blockedUserData['userId'] = userId;
          blockedUsers.add(blockedUserData);
        }
      }

      return blockedUsers;
    } catch (e) {
      print('Error getting blocked users: $e');
      return [];
    }
  }

  /// Check if a user is blocked
  Future<bool> isUserBlocked(String userId) async {
    try {
      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) return false;

      final userDoc = await _usersCollection.doc(currentUserId).get();
      if (!userDoc.exists) return false;

      final userData = userDoc.data() as Map<String, dynamic>;
      final blockedUsers = List<String>.from(userData['blockedUsers'] ?? []);
      return blockedUsers.contains(userId);
    } catch (e) {
      print('Error checking if user is blocked: $e');
      return false;
    }
  }

  // ==================== STATISTICS OPERATIONS ====================

  /// Get car count by category
  Future<Map<String, int>> getCategoryCounts() async {
    try {
      final snapshot = await _carsCollection
          .where('isActive', isEqualTo: true)
          .get();

      Map<String, int> counts = {};
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final category = data['category'] as String?;
        if (category != null) {
          counts[category] = (counts[category] ?? 0) + 1;
        }
      }

      return counts;
    } catch (e) {
      print('Error getting category counts: $e');
      return {};
    }
  }

  /// Get car count by brand (extracted from title)
  Future<Map<String, int>> getBrandCounts() async {
    try {
      final snapshot = await _carsCollection
          .where('isActive', isEqualTo: true)
          .get();

      Map<String, int> counts = {};
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final title = data['title'] as String?;
        if (title != null && title.isNotEmpty) {
          // Extract first word as brand
          final brand = title.split(' ')[0];
          counts[brand] = (counts[brand] ?? 0) + 1;
        }
      }

      return counts;
    } catch (e) {
      print('Error getting brand counts: $e');
      return {};
    }
  }

  // ==================== NOTIFICATIONS OPERATIONS ====================

  /// Create a notification
  Future<bool> createNotification({
    required String userId,
    required String type,
    required String title,
    required String message,
    String? relatedId,
  }) async {
    try {
      await _firestore.collection('notifications').add({
        'userId': userId,
        'type': type,
        'title': title,
        'message': message,
        'relatedId': relatedId,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print('Error creating notification: $e');
      return false;
    }
  }

  /// Get user notifications
  Stream<List<Map<String, dynamic>>> getUserNotifications() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          }).toList();
        });
  }

  /// Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).update({
        'isRead': true,
      });
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  /// Get unread notification count
  Future<int> getUnreadNotificationCount() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return 0;

      final snapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      return snapshot.docs.length;
    } catch (e) {
      print('Error getting unread count: $e');
      return 0;
    }
  }

  // ==================== USER STATISTICS ====================

  /// Get user statistics (cars listed, sold, average rating)
  Future<Map<String, dynamic>> getUserStats(String userId) async {
    try {
      // Get total cars listed
      final carsSnapshot = await _carsCollection
          .where('userId', isEqualTo: userId)
          .get();

      final totalCars = carsSnapshot.docs.length;
      final activeCars = carsSnapshot.docs
          .where(
            (doc) => (doc.data() as Map<String, dynamic>)['isActive'] == true,
          )
          .length;

      // Get sold cars (assuming we have a 'sold' field or status)
      final soldCars = carsSnapshot.docs
          .where(
            (doc) => (doc.data() as Map<String, dynamic>)['isSold'] == true,
          )
          .length;

      // Get reviews for all user's cars
      final carIds = carsSnapshot.docs.map((doc) => doc.id).toList();
      double averageRating = 0.0;
      int totalReviews = 0;

      if (carIds.isNotEmpty) {
        final reviewsSnapshot = await _firestore
            .collection('reviews')
            .where(
              'carId',
              whereIn: carIds.take(10).toList(),
            ) // Firestore limit
            .get();

        totalReviews = reviewsSnapshot.docs.length;
        if (totalReviews > 0) {
          final sum = reviewsSnapshot.docs.fold<int>(
            0,
            (sum, doc) => sum + ((doc.data()['rating'] ?? 0) as int),
          );
          averageRating = sum / totalReviews;
        }
      }

      return {
        'carsListed': activeCars,
        'carsSold': soldCars,
        'totalCars': totalCars,
        'averageRating': averageRating,
        'totalReviews': totalReviews,
      };
    } catch (e) {
      print('Error getting user stats: $e');
      return {
        'carsListed': 0,
        'carsSold': 0,
        'totalCars': 0,
        'averageRating': 0.0,
        'totalReviews': 0,
      };
    }
  }

  // ==================== PURCHASE HISTORY ====================

  /// Get user's purchase history
  Stream<List<Map<String, dynamic>>> getPurchaseHistory() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('purchases')
        .where('buyerId', isEqualTo: userId)
        .orderBy('purchaseDate', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          List<Map<String, dynamic>> purchases = [];

          for (var doc in snapshot.docs) {
            final purchaseData = doc.data();
            purchaseData['id'] = doc.id;

            // Fetch car info
            final carId = purchaseData['carId'];
            if (carId != null) {
              final carData = await getCarById(carId);
              if (carData != null) {
                purchaseData['carData'] = carData;
              }
            }

            // Fetch seller info
            final sellerId = purchaseData['sellerId'];
            if (sellerId != null) {
              final sellerData = await getUserProfile(sellerId);
              if (sellerData != null) {
                purchaseData['sellerData'] = sellerData;
              }
            }

            purchases.add(purchaseData);
          }

          return purchases;
        });
  }

  /// Record a purchase
  Future<bool> recordPurchase({
    required String carId,
    required String sellerId,
    required int price,
    required String paymentMethod,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      await _firestore.collection('purchases').add({
        'buyerId': userId,
        'sellerId': sellerId,
        'carId': carId,
        'price': price,
        'paymentMethod': paymentMethod,
        'status': 'Completed',
        'purchaseDate': FieldValue.serverTimestamp(),
      });

      // Mark car as sold
      await _carsCollection.doc(carId).update({
        'isSold': true,
        'isActive': false,
      });

      return true;
    } catch (e) {
      print('Error recording purchase: $e');
      return false;
    }
  }

  // ==================== RECENTLY VIEWED ====================

  /// Track a viewed car
  Future<void> trackViewedCar(String carId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      await _firestore.collection('recentlyViewed').doc('${userId}_$carId').set(
        {
          'userId': userId,
          'carId': carId,
          'viewedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      print('Error tracking viewed car: $e');
    }
  }

  /// Get recently viewed cars
  Stream<List<Map<String, dynamic>>> getRecentlyViewedCars() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('recentlyViewed')
        .where('userId', isEqualTo: userId)
        .orderBy('viewedAt', descending: true)
        .limit(20)
        .snapshots()
        .asyncMap((snapshot) async {
          List<Map<String, dynamic>> viewedCars = [];

          for (var doc in snapshot.docs) {
            final viewData = doc.data();
            final carId = viewData['carId'];

            if (carId != null) {
              final carData = await getCarById(carId);
              if (carData != null && carData['isActive'] == true) {
                carData['viewedAt'] = viewData['viewedAt'];
                viewedCars.add(carData);
              }
            }
          }

          return viewedCars;
        });
  }

  /// Clear recently viewed history
  Future<void> clearRecentlyViewed() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final snapshot = await _firestore
          .collection('recentlyViewed')
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error clearing recently viewed: $e');
    }
  }
}
