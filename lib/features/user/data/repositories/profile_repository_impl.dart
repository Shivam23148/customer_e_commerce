import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_e_commerce/features/user/domain/repositories/profile_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  ProfileRepositoryImpl({required this.firestore, required this.firebaseAuth});
  @override
  Future<void> saveBasicInfo(String name, String phone) async {
    String uid = firebaseAuth.currentUser!.uid;
    try {
      await firestore.collection('users').doc(uid).set({
        'name': name,
        'phone': phone,
        'email': firebaseAuth.currentUser!.email,
      });
    } on FirebaseException catch (e) {
      print("Firestore Error: ${e.message}");
    }
  }

  @override
  Future<void> saveAddress(String house, String buildingNo, String landmark,
      String city, String state, String zip) async {
    String uid = firebaseAuth.currentUser!.uid;
    try {
      await firestore.collection('users').doc(uid).set({
        'address': {
          'houseNo': house,
          'buildingNo.': buildingNo,
          'landmark': landmark,
          'city': city,
          'state': state,
          'zip': zip
        }
      });
    } on FirebaseException catch (e) {
      print("Firestore Error: ${e.message}");
    }
  }
}
