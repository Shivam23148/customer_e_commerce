import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_e_commerce/core/di/service_locator.dart';
import 'package:customer_e_commerce/core/theme/app_colors.dart';
import 'package:customer_e_commerce/core/utils/toast_util.dart';
import 'package:customer_e_commerce/features/user/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth = serviceLocator<FirebaseAuth>();
  final FirebaseMessaging _firebaseMessaging =
      serviceLocator<FirebaseMessaging>();
  final FirebaseFirestore firestore = serviceLocator<FirebaseFirestore>();

  void _showToast(String message) {
    Fluttertoast.showToast(
        backgroundColor: AppColors.primary,
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        textColor: Colors.white,
        fontSize: 14);
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      final user = result.user;
      await _saveDeviceToken(user!);
      return user;
    } on FirebaseAuthException catch (e) {
      ToastUtil.showToast(
          e.message ?? "Login failed. Please try again.", AppColors.primary);
      throw Exception(e.message ?? "Login failed. Please try again.");
    } catch (e) {
      throw Exception("An unexpected error occurred: $e");
    }
  }

  @override
  Future<User> register(String email, String password) async {
    final user = _firebaseAuth.currentUser;
    await _saveDeviceToken(user!);

    return user;
  }

  /* @override
  Future<User> register(String email, String password) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Send email verification after successful registration
      if (result.user != null || !result.user!.emailVerified) {
        await result.user!.sendEmailVerification();
      }
      return result.user!;
    } on FirebaseAuthException catch (e) {
      _showToast(e.message ?? "Registration failed. Please try again.");
      throw Exception(e.message ?? "Registration failed. Please try again.");
    } catch (e) {
      throw Exception("An unexpected error occurred: $e");
    }
  } */

  @override
  Future<User?> completeRegisteration(String email, String password) async {
    try {
      final result = _firebaseAuth.currentUser;
      if (result != null && result.emailVerified) {
        await result.updatePassword(password);
      } else {
        _showToast("Email is not verified");
      }
      return result;
    } on FirebaseAuthException catch (e) {
      ToastUtil.showToast(
          e.message ?? "Registeration unable to compelete try again later",
          AppColors.primary);
    } catch (e) {
      rethrow;
    }
    return null;
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      ToastUtil.showToast(
          "Failed to logout. Please try again.", AppColors.primary);
      throw Exception("Failed to logout. Please try again.");
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      return _firebaseAuth.currentUser;
    } catch (e) {
      throw Exception("Failed to get user data.");
    }
  }

  @override
  Future<bool> isEmailVerified() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.reload();
        return user.emailVerified;
      }
      return false;
    } catch (e) {
      throw Exception("Failed to check email verification status.");
    }
  }

  @override
  Future<void> resendVerificationEmail() async {
    try {
      // await sendEmailVerificaiton();
    } catch (e) {
      throw Exception("Failed to resend verification email.");
    }
  }

  @override
  Future<void> sendEmailVerificaiton(String email) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: "TempPassword@123");
      if (result.user != null) {
        await result.user?.sendEmailVerification();
        ToastUtil.showToast(
            "Verification email sent successfully.", AppColors.successColor);
      }
    } on FirebaseAuthException catch (e) {
      ToastUtil.showToast(
          e.message ?? "Can't send verification", AppColors.primary);
    } catch (e) {
      throw Exception("Failed to send verification email.");
    }
  }

  Future<void> _saveDeviceToken(User user) async {
    try {
      final fcmToken = await _firebaseMessaging.getToken();
      if (fcmToken != null) {
        await firestore.collection('users').doc(user.uid).update({
          'fcmToken': fcmToken,
          'tokenUpdatedAt': FieldValue.serverTimestamp()
        });
      }
    } catch (e) {
      print("Failed to save FCM token : $e");
    }
  }
}
