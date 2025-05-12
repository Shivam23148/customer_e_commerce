import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_e_commerce/core/di/service_locator.dart';
import 'package:customer_e_commerce/features/user/data/models/order_model.dart';

class OrderRepository {
  final FirebaseFirestore firestore = serviceLocator<FirebaseFirestore>();

  Future<void> createOrder(UserOrder order) async {
    try {
      await firestore
          .collection('orders')
          .doc(order.orderId)
          .set(order.toJson());
      await firestore
          .collection('users')
          .doc(order.userId)
          .collection('orders')
          .doc(order.orderId)
          .set(order.toJson());
    } catch (e) {
      rethrow;
    }
  }
}
