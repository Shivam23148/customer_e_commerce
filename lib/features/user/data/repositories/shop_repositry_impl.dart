import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_e_commerce/core/di/service_locator.dart';
import 'package:customer_e_commerce/features/user/data/models/product_models.dart';
import 'package:customer_e_commerce/features/user/data/models/shop_model.dart';
import 'package:customer_e_commerce/features/user/data/models/shopwithproduct_model.dart';

class ShopRepository {
  final FirebaseFirestore firestore = serviceLocator<FirebaseFirestore>();
  final CollectionReference shopRef = serviceLocator<CollectionReference>(
    instanceName: 'shops',
  );
  final CollectionReference productRef = serviceLocator<CollectionReference>(
    instanceName: 'products',
  );

  double _calculateDistance(GeoPoint point1, GeoPoint point2) {
    const double earthRadius = 6371;
    double lat1 = point1.latitude;
    double lon1 = point1.longitude;
    double lat2 = point2.latitude;
    double lon2 = point2.longitude;

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c; // Distance in kilometers
  }

  double _toRadians(double degree) => degree * pi / 180.0;

  Future<List<Shop>> getallShop() async {
    try {
      final snapshot = await shopRef.get();
      return snapshot.docs
          .map((doc) =>
              Shop.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception("Error getting all shops: $e");
    }
  }

  Future<ShopWithProducts> getNearestShopWithProducts(
      GeoPoint userLocation) async {
    final shops = await getallShop();
    if (shops.isEmpty) throw Exception("No shops found");

    Shop nearestShop = shops.first;
    double minDistance =
        _calculateDistance(userLocation, nearestShop.location!);

    for (final shop in shops) {
      if (shop.location == null) continue;
      final distance = _calculateDistance(userLocation, shop.location!);
      if (distance < minDistance) {
        minDistance = distance;
        nearestShop = shop;
      }
    }
    final productIds = nearestShop.inventory?.keys.toList() ?? [];
    final products = await _getProductsByIds(productIds);
    return ShopWithProducts(
      shop: nearestShop,
      products: products,
      inventory: nearestShop.inventory ?? {},
    );
  }

  Future<Map<String, Product>> _getProductsByIds(
      List<String> productIds) async {
    if (productIds.isEmpty) return {};
    const batchSize = 10;
    final Map<String, Product> products = {};
    for (var i = 0; i < productIds.length; i += batchSize) {
      final batch = productIds.sublist(
        i,
        i + batchSize > productIds.length ? productIds.length : i + batchSize,
      );

      final query = productRef.where(FieldPath.documentId, whereIn: batch);

      final snapshot = await query.get();

      for (var doc in snapshot.docs) {
        products[doc.id] = Product.fromFirestore(doc);
      }
    }
    return products;
  }
}
