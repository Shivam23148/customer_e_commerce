abstract class ProfileRepository {
  Future<void> saveBasicInfo(String name, String phone);
  Future<void> saveAddress(String house, String buildingNo, String landmark,
      String city, String state, String zip);
}
