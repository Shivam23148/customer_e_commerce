import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_e_commerce/core/di/service_locator.dart';
import 'package:customer_e_commerce/features/user/data/models/address_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddressRepositoryImpl {
  final CollectionReference userRef =
      FirebaseFirestore.instance.collection('users');

  Future<List<UserAddress>> getUserAddresses() async {
    try {
      final userId = serviceLocator<FirebaseAuth>().currentUser?.uid;
      final snapshot = await userRef
          .doc(userId)
          .collection('address')
          .orderBy('lastUpdated', descending: true)
          .get();
      print("User Address snapshot: ${snapshot.docs}");
      return snapshot.docs
          .map((doc) => UserAddress.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      throw Exception("Error getting user addresses: $e");
    }
  }
}
