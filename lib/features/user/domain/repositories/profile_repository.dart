import 'package:customer_e_commerce/features/user/data/models/address_model.dart';
import 'package:customer_e_commerce/features/user/data/models/profile_models.dart';

abstract class ProfileRepository {
  Future<void> saveBasicInfo(Profile profile);
  Future<void> saveAddress(UserAddress address);
  Future<Profile> getProfile();
  Future<void> editProfile(String firstName, String lastName);
  Future<void> updatePhone(String phone);
  Future<void> updateEmail(String email);
  Future<void> updatePassword(String password);
  Stream<Profile> profileStream();
}
