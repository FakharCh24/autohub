import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/price_alert.dart';

class PriceAlertService {
  PriceAlertService._();
  static final PriceAlertService instance = PriceAlertService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _alertsCollection =>
      _firestore.collection('price_alerts');

  /// Create a new price alert
  Future<String?> createAlert({
    required String carId,
    required String carName,
    required double targetPrice,
    required String alertType,
    required bool notifyByPush,
    required bool notifyByEmail,
    double? currentPrice,
    String? carImage,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Create new alert document
      final alertRef = _alertsCollection.doc();
      final alertId = alertRef.id;

      final alert = PriceAlert(
        alertId: alertId,
        userId: userId,
        carId: carId,
        carName: carName,
        targetPrice: targetPrice,
        alertType: alertType,
        notifyByPush: notifyByPush,
        notifyByEmail: notifyByEmail,
        isActive: true,
        createdAt: DateTime.now(),
        currentPrice: currentPrice,
        carImage: carImage,
      );

      await alertRef.set(alert.toMap());
      return alertId;
    } catch (e) {
      print('Error creating price alert: $e');
      return null;
    }
  }

  /// Get all alerts for current user
  Future<List<PriceAlert>> getUserAlerts() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return [];

      final snapshot = await _alertsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => PriceAlert.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting user alerts: $e');
      return [];
    }
  }

  /// Get active alerts for current user
  Future<List<PriceAlert>> getActiveAlerts() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return [];

      final snapshot = await _alertsCollection
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => PriceAlert.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting active alerts: $e');
      return [];
    }
  }

  /// Get alerts for a specific car
  Future<List<PriceAlert>> getCarAlerts(String carId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return [];

      final snapshot = await _alertsCollection
          .where('userId', isEqualTo: userId)
          .where('carId', isEqualTo: carId)
          .get();

      return snapshot.docs
          .map((doc) => PriceAlert.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting car alerts: $e');
      return [];
    }
  }

  /// Update alert active status
  Future<bool> toggleAlertStatus(String alertId, bool isActive) async {
    try {
      await _alertsCollection.doc(alertId).update({'isActive': isActive});
      return true;
    } catch (e) {
      print('Error toggling alert status: $e');
      return false;
    }
  }

  /// Delete an alert
  Future<bool> deleteAlert(String alertId) async {
    try {
      await _alertsCollection.doc(alertId).delete();
      return true;
    } catch (e) {
      print('Error deleting alert: $e');
      return false;
    }
  }

  /// Update alert settings
  Future<bool> updateAlert({
    required String alertId,
    double? targetPrice,
    String? alertType,
    bool? notifyByPush,
    bool? notifyByEmail,
  }) async {
    try {
      Map<String, dynamic> updates = {};
      if (targetPrice != null) updates['targetPrice'] = targetPrice;
      if (alertType != null) updates['alertType'] = alertType;
      if (notifyByPush != null) updates['notifyByPush'] = notifyByPush;
      if (notifyByEmail != null) updates['notifyByEmail'] = notifyByEmail;

      if (updates.isNotEmpty) {
        await _alertsCollection.doc(alertId).update(updates);
      }
      return true;
    } catch (e) {
      print('Error updating alert: $e');
      return false;
    }
  }

  /// Check if alerts should be triggered (call this when car price changes)
  Future<List<PriceAlert>> checkTriggeredAlerts(
    String carId,
    double newPrice,
  ) async {
    try {
      // Get all active alerts for this car
      final snapshot = await _alertsCollection
          .where('carId', isEqualTo: carId)
          .where('isActive', isEqualTo: true)
          .get();

      List<PriceAlert> triggeredAlerts = [];

      for (var doc in snapshot.docs) {
        final alert = PriceAlert.fromMap(doc.data() as Map<String, dynamic>);

        // Check if alert condition is met
        bool shouldTrigger = false;
        if (alert.alertType == 'Below' && newPrice <= alert.targetPrice) {
          shouldTrigger = true;
        } else if (alert.alertType == 'Above' &&
            newPrice >= alert.targetPrice) {
          shouldTrigger = true;
        }

        if (shouldTrigger) {
          triggeredAlerts.add(alert);
        }
      }

      return triggeredAlerts;
    } catch (e) {
      print('Error checking triggered alerts: $e');
      return [];
    }
  }

  /// Monitor price changes and trigger alerts
  /// This should be called whenever a car price is updated
  Future<void> monitorPriceChange(String carId, double newPrice) async {
    try {
      final triggeredAlerts = await checkTriggeredAlerts(carId, newPrice);

      for (var alert in triggeredAlerts) {
        // Send notification based on user preferences
        if (alert.notifyByPush) {
          await _sendPushNotification(alert, newPrice);
        }
        if (alert.notifyByEmail) {
          await _sendEmailNotification(alert, newPrice);
        }

        // Optionally deactivate the alert after triggering
        // await toggleAlertStatus(alert.alertId, false);
      }
    } catch (e) {
      print('Error monitoring price change: $e');
    }
  }

  /// Send push notification (to be implemented with FCM)
  Future<void> _sendPushNotification(PriceAlert alert, double newPrice) async {
    try {
      // Add notification to Firestore notifications collection
      await _firestore.collection('notifications').add({
        'userId': alert.userId,
        'type': 'alert',
        'title': 'Price Alert Triggered!',
        'message':
            '${alert.carName} is now PKR ${newPrice.toStringAsFixed(0)} - ${alert.alertType} your target of PKR ${alert.targetPrice.toStringAsFixed(0)}',
        'carId': alert.carId,
        'carName': alert.carName,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
        'data': {
          'alertId': alert.alertId,
          'targetPrice': alert.targetPrice,
          'currentPrice': newPrice,
          'alertType': alert.alertType,
        },
      });

      // TODO: Implement Firebase Cloud Messaging for real-time push notifications
      print(
        'Push notification sent for alert: ${alert.alertId} to user: ${alert.userId}',
      );
    } catch (e) {
      print('Error sending push notification: $e');
    }
  }

  /// Send email notification (to be implemented)
  Future<void> _sendEmailNotification(PriceAlert alert, double newPrice) async {
    try {
      // TODO: Implement email notification using Firebase Functions or similar service
      print('Email notification would be sent for alert: ${alert.alertId}');
    } catch (e) {
      print('Error sending email notification: $e');
    }
  }

  /// Get count of active alerts for user
  Future<int> getActiveAlertsCount() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return 0;

      final snapshot = await _alertsCollection
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs.length;
    } catch (e) {
      print('Error getting active alerts count: $e');
      return 0;
    }
  }

  /// Stream of user alerts (for real-time updates)
  Stream<List<PriceAlert>> watchUserAlerts() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _alertsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => PriceAlert.fromMap(doc.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }
}
