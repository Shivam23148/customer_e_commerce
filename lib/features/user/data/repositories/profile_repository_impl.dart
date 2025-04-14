import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_e_commerce/core/di/service_locator.dart';
import 'package:customer_e_commerce/features/user/data/models/address_model.dart';
import 'package:customer_e_commerce/features/user/data/models/profile_models.dart';
import 'package:customer_e_commerce/features/user/domain/repositories/profile_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final profileRef = serviceLocator<CollectionReference>(instanceName: 'users');
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  ProfileRepositoryImpl({required this.firestore, required this.firebaseAuth});
  @override
  Future<void> saveBasicInfo(Profile profile) async {
    String uid = firebaseAuth.currentUser!.uid;

    try {
      await profileRef.doc(uid).set(profile.toJson(), SetOptions(merge: true));
    } on FirebaseAuthException catch (e) {
      throw Exception('Authentication error: ${e.message}');
    } on FirebaseException catch (e) {
      throw Exception('Firestore error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<void> saveAddress(UserAddress address) async {
    String uid = firebaseAuth.currentUser!.uid;
    try {
      await profileRef.doc(uid).set(
        {'address': address.toJson()},
        SetOptions(merge: true),
      );
    } on FirebaseException catch (e) {
      throw Exception("Firestore Error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected Error: $e");
    }
  }
}
