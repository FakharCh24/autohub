import 'package:cloud_firestore/cloud_firestore.dart';

class PriceAlert {
  final String alertId;
  final String userId;
  final String carId;
  final String carName;
  final double targetPrice;
  final String alertType; // 'Below' or 'Above'
  final bool notifyByPush;
  final bool notifyByEmail;
  final bool isActive;
  final DateTime createdAt;
  final double? currentPrice; // Current price of the car when alert was created
  final String? carImage; // Optional car image for display

  PriceAlert({
    required this.alertId,
    required this.userId,
    required this.carId,
    required this.carName,
    required this.targetPrice,
    required this.alertType,
    required this.notifyByPush,
    required this.notifyByEmail,
    required this.isActive,
    required this.createdAt,
    this.currentPrice,
    this.carImage,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'alertId': alertId,
      'userId': userId,
      'carId': carId,
      'carName': carName,
      'targetPrice': targetPrice,
      'alertType': alertType,
      'notifyByPush': notifyByPush,
      'notifyByEmail': notifyByEmail,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'currentPrice': currentPrice,
      'carImage': carImage,
    };
  }

  // Create from Firestore document
  factory PriceAlert.fromMap(Map<String, dynamic> map) {
    return PriceAlert(
      alertId: map['alertId'] ?? '',
      userId: map['userId'] ?? '',
      carId: map['carId'] ?? '',
      carName: map['carName'] ?? '',
      targetPrice: (map['targetPrice'] ?? 0).toDouble(),
      alertType: map['alertType'] ?? 'Below',
      notifyByPush: map['notifyByPush'] ?? true,
      notifyByEmail: map['notifyByEmail'] ?? false,
      isActive: map['isActive'] ?? true,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      currentPrice: map['currentPrice']?.toDouble(),
      carImage: map['carImage'],
    );
  }

  // Create a copy with updated fields
  PriceAlert copyWith({
    String? alertId,
    String? userId,
    String? carId,
    String? carName,
    double? targetPrice,
    String? alertType,
    bool? notifyByPush,
    bool? notifyByEmail,
    bool? isActive,
    DateTime? createdAt,
    double? currentPrice,
    String? carImage,
  }) {
    return PriceAlert(
      alertId: alertId ?? this.alertId,
      userId: userId ?? this.userId,
      carId: carId ?? this.carId,
      carName: carName ?? this.carName,
      targetPrice: targetPrice ?? this.targetPrice,
      alertType: alertType ?? this.alertType,
      notifyByPush: notifyByPush ?? this.notifyByPush,
      notifyByEmail: notifyByEmail ?? this.notifyByEmail,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      currentPrice: currentPrice ?? this.currentPrice,
      carImage: carImage ?? this.carImage,
    );
  }
}
