import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_e_commerce/core/theme/app_colors.dart';
import 'package:customer_e_commerce/core/utils/toast_util.dart';
import 'package:customer_e_commerce/features/user/data/models/address_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;

class GeolocatorService {
  final loc.Location _location = loc.Location();
  Future<bool> checkLocationServiceEnabled() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, return false
      _location.requestService();
    }
    return serviceEnabled;
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openAppSettings();
  }

  Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      ToastUtil.showToast(
          "Location permission denied. Go to Settings > Apps > This App > Permissions > Enable Location.",
          AppColors.successColor);
      await Future.delayed(Duration(milliseconds: 1500));
      openLocationSettings();

      return false;
    }
    print("Location Permission is $permission");
    return true;
  }

  Future<UserAddress> getCurrentLocationAddress() async {
    final position = await Geolocator.getCurrentPosition();
    final places =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    if (places.isEmpty) throw Exception("No Address found for Location");
    final place = places.first;
    return UserAddress(
        street: place.street,
        city: place.locality ?? place.subAdministrativeArea ?? '',
        state: place.administrativeArea,
        country: place.country ?? '',
        zip: place.postalCode ?? '',
        location: GeoPoint(position.latitude, position.longitude));
  }

  Future<Location> geocodeAddress(UserAddress homeaddress) async {
    final address = [
      homeaddress.houseNo,
      homeaddress.street,
      homeaddress.landmark,
      homeaddress.city,
      homeaddress.city,
      homeaddress.state,
      homeaddress.country,
      homeaddress.zip
    ].join(',');
    final locations = await locationFromAddress(address);
    if (locations.isEmpty) throw Exception("Could not geocode address");
    return locations.first;
  }
}
