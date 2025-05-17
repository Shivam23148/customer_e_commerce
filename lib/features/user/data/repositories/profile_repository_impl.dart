import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_e_commerce/core/di/service_locator.dart';
import 'package:customer_e_commerce/core/theme/app_colors.dart';
import 'package:customer_e_commerce/core/utils/toast_util.dart';
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
      var docRef =
          await profileRef.doc(uid).collection("address").add(address.toJson());

      await docRef.update({'id': docRef.id});
    } on FirebaseException catch (e) {
      throw Exception("Firestore Error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected Error: $e");
    }
  }

  @override
  Future<Profile> getProfile() async {
    // TODO: implement getProfile
    try {
      final uid = firebaseAuth.currentUser?.uid;
      if (uid == null) {
        throw Exception('User not Authenticated');
      }
      final doc = await profileRef.doc(uid).get();
      final data = doc.data();
      if (data == null) {
        throw Exception("Profile data does not exist");
      }

      return Profile.fromFirestore(data as Map<String, dynamic>);
    } on FirebaseAuthException catch (e) {
      throw Exception('Authentication error: ${e.message}');
    } on FirebaseException catch (e) {
      throw Exception('Firestore error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch profile data: $e');
    }
  }

  @override
  Future<void> editProfile(String firstName, String lastName) async {
    // TODO: implement editProfile
    try {
      final uid = firebaseAuth.currentUser?.uid;
      if (uid == null) throw Exception('User not authenticated');

      await profileRef
          .doc(uid)
          .update({'firstName': firstName, 'lastName': lastName});
    } on FirebaseAuthException catch (e) {
      throw Exception('Authentication error: ${e.message}');
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        throw Exception('Profile document does not exist');
      }
      throw Exception('Firestore error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<void> updatePhone(String phone) async {
    // TODO: implement updatePhone
    try {
      final uid = firebaseAuth.currentUser?.uid;
      if (uid == null) throw Exception('User not authenticated');
      await profileRef.doc(uid).update({'phone': phone});
    } on FirebaseAuthException catch (e) {
      throw Exception('Authentication error: ${e.message}');
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        throw Exception('Profile document does not exist');
      }
      throw Exception('Firestore error: ${e.message}');
    } catch (e) {
      throw Exception("Failed to update phone number");
    }
  }

  @override
  Future<void> updateEmail(String email) async {
    // TODO: implement updateEmail
    try {
      final uid = firebaseAuth.currentUser?.uid;
      if (uid == null) throw Exception('User not authenticated');
      await profileRef.doc(uid).update({'email': email});
    } on FirebaseAuthException catch (e) {
      throw Exception('Authentication error: ${e.message}');
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        throw Exception('Profile document does not exist');
      }
      throw Exception('Firestore error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update phone number');
    }
  }

  @override
  Future<void> updatePassword(String password) async {
    // TODO: implement updatePassword
    try {
      final uid = firebaseAuth.currentUser?.uid;
      if (uid == null) throw Exception("User not authenticated");
      await profileRef.doc(uid).update({'password': password});
    } on FirebaseAuthException catch (e) {
      throw Exception('Authentication error:${e.message}');
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        ToastUtil.showToast("Profile does not exist!", AppColors.primary);
        throw Exception('Profile document does not exist');
      }
      throw Exception('Firestore error: ${e.message}');
    } catch (e) {
      throw Exception("Failed to update phone number");
    }
  }

  @override
  Stream<Profile> profileStream() {
    final uid = firebaseAuth.currentUser?.uid;
    if (uid == null) return Stream.error("User not authenticated");

    return profileRef.doc(uid).snapshots().map((snap) {
      if (!snap.exists) throw Exception("Profile not found");
      final data = snap.data();
      if (data == null) throw Exception("Profile data is empty");
      return Profile.fromFirestore(snap.data() as Map<String, dynamic>);
    });
  }
}
