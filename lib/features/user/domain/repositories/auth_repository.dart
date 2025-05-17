import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password);
  Future<User?> completeRegisteration(String email, String password);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<void> sendEmailVerificaiton(String email);
  Future<void> handleEmailEntry(String email);
  Future<bool> isEmailVerified();
  Future<void> resendVerificationEmail();
  Future<void> verifyCurrentPassword(String currentPassword);
  Future<void> updatePasswordCredential(
      String currentPassword, String newPassword);
  Future<void> _saveDeviceToken(User user);
}
