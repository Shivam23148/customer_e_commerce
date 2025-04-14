import 'package:cloud_firestore/cloud_firestore.dart';

class Shop {
  String? shopId;
  String? shopName; // Make nullable
  ShopAddress? shopAddress; // Make nullable
  GeoPoint? location; // Make nullable
  String? ownerId; // Make nullable
  DateTime? createdAt; // Make nullable
  String status; // Keep non-nullable with a default value
  Map<String, int>? inventory;

  Shop({
    this.shopId,
    this.shopName,
    this.shopAddress,
    this.location,
    this.ownerId,
    this.createdAt,
    this.status = 'closed', // Default value for non-nullable field
    this.inventory,
  });

  // Create a Shop object from a Firestore document (Map)
  factory Shop.fromFirestore(Map<String, dynamic> data, String shopId) {
    return Shop(
      shopId: shopId,
      shopName: data['shopName'] as String?, // Cast to nullable String
      shopAddress: data['shopAddress'] != null
          ? ShopAddress.fromFirestore(data['shopAddress'])
          : null, // Cast to nullable String
      location: data['location'] as GeoPoint?, // Cast to nullable GeoPoint
      ownerId: data['ownerId'] as String?, // Cast to nullable String
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null, // Handle null
      status: data['status'] as String? ?? 'closed', // Default value if null
      inventory: data['inventory'] != null
          ? Map<String, int>.from(data['inventory'])
          : null,
    );
  }

  // Convert Shop object to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'shopId': shopId,
      'shopName': shopName,
      'shopAddress': shopAddress?.toJson(),
      'location': location,
      'ownerId': ownerId,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'status': status,
      'inventory': inventory ?? {},
    };
  }
}

class ShopAddress {
  String? buildingNo;
  String? locality;
  String? streetName;
  String? city;
  String? state;
  String? country;
  String? postalCode;
  ShopAddress({
    this.buildingNo,
    this.locality,
    this.streetName,
    this.city,
    this.state,
    this.country,
    this.postalCode,
  });

  // Create ShopAddress object from a Firestore document (Map)
  factory ShopAddress.fromFirestore(Map<String, dynamic> data) {
    return ShopAddress(
      buildingNo: data['buildingNo'] as String?,
      locality: data['locality'] as String?,
      streetName: data['streetName'] as String?, // Corrected typo
      city: data['city'] as String?,
      state: data['state'] as String?,
      country: data['country'] as String?,
      postalCode: data['postalCode'] as String?,
    );
  }

  //Convert Shop object to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'buildingNo': buildingNo,
      'locality': locality,
      'streetName': streetName,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
    };
  }

  String formatAddress() {
    return [
      buildingNo,
      locality,
      streetName,
      city,
      state,
      postalCode,
    ].where((part) => part != null && part.isNotEmpty).join(", ");
  }
}
