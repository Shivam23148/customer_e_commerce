import 'package:cloud_firestore/cloud_firestore.dart';

class UserAddress {
  String? id;
  String? houseNo;
  String? street;
  String? landmark;
  String? city;
  String? state;
  String? country;
  String? zip;
  GeoPoint? location;
  String? addressType;
  DateTime? lastUpdated;

  UserAddress({
    this.id,
    this.houseNo,
    this.street,
    this.landmark,
    this.city,
    this.state,
    this.country,
    this.zip,
    this.location,
    this.addressType,
    this.lastUpdated,
  });

  // Create User Address object from a Firestore document (map)
  factory UserAddress.fromFirestore(Map<String, dynamic> data) {
    return UserAddress(
      houseNo: data['houseNo'] as String? ?? '',
      street: data['street'] as String? ?? '',
      landmark: data['landmark'] as String? ?? '',
      city: data['city'] as String? ?? '',
      state: data['state'] as String? ?? '',
      country: data['country'] as String? ?? '',
      zip: data['zip'] as String? ?? '',
      location: data['location'] as GeoPoint?,
      addressType: data['addressType'] as String? ?? '',
      lastUpdated: data['lastUpdated'] != null
          ? (data['lastUpdated'] as Timestamp).toDate()
          : null,
    );
  }

  // Convert User Address object to JSON Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id ?? '',
      'houseNo': houseNo ?? '',
      'street': street ?? '',
      'landmark': landmark ?? '',
      'city': city ?? '',
      'state': state ?? '',
      'country': country ?? '',
      'zip': zip ?? '',
      'location': location,
      'addressType': addressType ?? '',
      'lastUpdated':
          lastUpdated != null ? Timestamp.fromDate(lastUpdated!) : null,
    };
  }

  // CopyWith Method - Creates a new instance with updated fields
  UserAddress copyWith({
    String? id,
    String? houseNo,
    String? street,
    String? landmark,
    String? city,
    String? state,
    String? country,
    String? zip,
    GeoPoint? location,
    String? addressType,
    DateTime? lastUpdated,
  }) {
    return UserAddress(
      id: id ?? this.id,
      houseNo: houseNo ?? this.houseNo,
      street: street ?? this.street,
      landmark: landmark ?? this.landmark,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      zip: zip ?? this.zip,
      location: location ?? this.location,
      addressType: addressType ?? this.addressType,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  String get formattedAddress {
    final buffer = StringBuffer();
    if (houseNo?.isNotEmpty ?? false) buffer.write('$houseNo,');
    if (street?.isNotEmpty ?? false) buffer.write('$street, ');
    if (landmark?.isNotEmpty ?? false) buffer.write('$landmark, ');
    if (city?.isNotEmpty ?? false) buffer.write('$city, ');
    if (state?.isNotEmpty ?? false) buffer.write('$state, ');
    if (country?.isNotEmpty ?? false) buffer.write('$country');
    if (zip?.isNotEmpty ?? false) buffer.write(' - $zip');

    return buffer.toString().trim().replaceAll(RegExp(r',\s*$'), '');
  }
}
