import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_e_commerce/features/user/data/models/address_model.dart';
import 'package:customer_e_commerce/features/user/data/models/cart_model.dart';

class UserOrder {
  final String orderId;
  final String userId;
  final String shopId;
  final List<CartItem> cartItems;
  final double totalAmount;
  final String orderStatus;
  final String? orderProgress;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final UserAddress deliveryAddress;

  UserOrder({
    required this.orderId,
    required this.userId,
    required this.shopId,
    required this.cartItems,
    required this.totalAmount,
    this.orderStatus = 'pending',
    this.orderProgress,
    required this.createdAt,
    required this.updatedAt,
    required this.deliveryAddress,
  });

  // Create an order object from Firestore data
  factory UserOrder.fromFirestore(Map<String, dynamic> data, String orderId) {
    var items =
        (data['items'] as List).map((item) => CartItem.fromJson(item)).toList();

    return UserOrder(
      orderId: orderId,
      userId: data['userId'],
      shopId: data['shopId'],
      cartItems: items,
      totalAmount: data['totalAmount'].toDouble(),
      orderStatus: data['orderStatus'],
      orderProgress: data['orderProgress'],
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
      deliveryAddress: UserAddress.fromFirestore(data['deliveryAddress']),
    );
  }

  // Convert order object to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'shopId': shopId,
      'items': cartItems.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'orderStatus': orderStatus,
      'orderProgress': orderProgress,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deliveryAddress': deliveryAddress.toJson(),
    };
  }
}
