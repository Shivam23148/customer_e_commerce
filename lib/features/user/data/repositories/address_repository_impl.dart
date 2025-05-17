import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_e_commerce/core/di/service_locator.dart';
import 'package:customer_e_commerce/features/user/data/models/address_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddressRepositoryImpl {
  final CollectionReference userRef =
      FirebaseFirestore.instance.collection('users');
  final userId = serviceLocator<FirebaseAuth>().currentUser?.uid;

  Future<List<UserAddress>> getUserAddresses() async {
    try {
      final snapshot = await userRef
          .doc(userId)
          .collection('address')
          .orderBy('lastUpdated', descending: true)
          .get();
      print("User Address snapshot: ${snapshot.docs}");
      return snapshot.docs
          .map((doc) => UserAddress.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception("Error getting user addresses: $e");
    }
  }

  Future<void> addAddress(UserAddress address) async {
    try {
      await userRef.doc(userId).collection('address').add(address.toJson());
    } catch (e) {
      throw Exception("Error adding address to firestore : $e");
    }
  }

  Future<void> deleteAddress(String id) async {
    try {
      await userRef.doc(userId).collection('address').doc(id).delete();
    } catch (e) {
      throw Exception("Error deleting address to firestore : $e");
    }
  }

  Future<void> updateAddress(UserAddress address, String id) async {
    try {
      await userRef
          .doc(userId)
          .collection('address')
          .doc(id)
          .update(address.toJson());
    } catch (e) {
      throw Exception("Error update address to firestore : $e");
    }
  }
}
