import 'package:customer_e_commerce/core/di/service_locator.dart';
import 'package:customer_e_commerce/features/user/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth = serviceLocator<FirebaseAuth>();

  void _showToast(String message) {
    Fluttertoast.showToast(
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

      // Check if the email is verified
      if (!result.user!.emailVerified) {
        throw FirebaseAuthException(
            code: "email-not-verified",
            message: "Email is not verified. Please check your email.");
      }

      return result.user!;
    } on FirebaseAuthException catch (e) {
      _showToast(e.message ?? "Login failed. Please try again.");
      throw Exception(e.message ?? "Login failed. Please try again.");
    } catch (e) {
      throw Exception("An unexpected error occurred: $e");
    }
  }

  @override
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
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      _showToast("Failed to logout. Please try again.");
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
      await sendEmailVerificaiton();
    } catch (e) {
      throw Exception("Failed to resend verification email.");
    }
  }

  @override
  Future<void> sendEmailVerificaiton() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        _showToast("Verification email sent successfully.");
      }
    } catch (e) {
      throw Exception("Failed to send verification email.");
    }
  }
}
