import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<void> sendEmailVerificaiton();
  Future<bool> isEmailVerified();
  Future<void> resendVerificationEmail();
}
