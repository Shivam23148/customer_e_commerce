/* import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_e_commerce/core/di/service_locator.dart';
import 'package:customer_e_commerce/features/user/data/models/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepository {
  final FirebaseFirestore _firestore = serviceLocator<FirebaseFirestore>();
  static const String _cartKey = 'user_cart';
  final SharedPreferences _prefs = serviceLocator<SharedPreferences>();

  //Load cart from local storage
  Future<List<CartItem>> loadCart() async {
    final cartJson = _prefs.getString(_cartKey);
    if (cartJson == null) return [];
    final List decoded = json.decode(cartJson);
    return decoded.map((item) => CartItem.fromJson(item)).toList();
  }

  //Save Cart to local storage
  Future<void> saveCart(List<CartItem> cart) async {
    final cartJson = json.encode(cart.map((item) => item.toJson()).toList());
    await _prefs.setString(_cartKey, cartJson);
  }

  // Add item to firestore inventory (reduce quantity)
  Future<bool> reduceInventoryQuantity(String shopId, String productId) async {
    final doc = _firestore.collection('shops').doc(shopId);
    final snapshot = await doc.get();
    if (!snapshot.exists) return false;
    final inventory = snapshot.data()?['inventory'] ?? {};
    final currentQty = inventory[productId] ?? 0;
    if (currentQty == null || currentQty <= 0) return false;
    await doc.update({'inventory.$productId': currentQty - 1});
    return true;
  }

  // Increase item quantity in firestore inventory(on remove)
  Future<void> increaseInventoryQuantity(
      String shopId, String productId) async {
    final doc = _firestore.collection('shops').doc(shopId);
    final snapshot = await doc.get();
    if (!snapshot.exists) return;
    final inventory = snapshot.data()?['inventory'] ?? {};
    final currentQty = inventory[productId] ?? 0;
    await doc.update({'inventory.$productId': currentQty + 1});
  }
}
 */

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_e_commerce/core/di/service_locator.dart';
import 'package:customer_e_commerce/features/user/data/models/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepository {
  final FirebaseFirestore _firestore = serviceLocator<FirebaseFirestore>();
  static const String cartKey = 'user_cart';
  final SharedPreferences prefs = serviceLocator<SharedPreferences>();

  Future<void> saveCart(List<CartItem> cart) async {
    final cartJson = json.encode(cart.map((item) => item.toJson()).toList());
    await prefs.setString(cartKey, cartJson);
  }

  Future<List<CartItem>> loadCart() async {
    final cartJson = prefs.getString(cartKey);
    if (cartJson == null) return [];
    final List decoded = json.decode(cartJson);
    return decoded.map((item) => CartItem.fromJson(item)).toList();
  }

  Future<void> clearCart() async {
    await prefs.remove(cartKey);
  }

  Future<void> reduceInventory(
      String shopId, String productId, int quantity) async {
    final shopRef = _firestore.collection('shops').doc(shopId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(shopRef);
      final data = snapshot.data();
      if (data == null) return;

      final inventory = Map<String, dynamic>.from(data['inventory'] ?? {});
      final currentStock = inventory[productId] ?? 0;

      if (currentStock < quantity) {
        throw Exception('Not enough inventory');
      }
      print('Current stock: $currentStock, Quantity: $quantity');

      inventory[productId] = currentStock - quantity;
      transaction.update(shopRef, {'inventory': inventory});
    });
  }

  Future<void> restoreInventory(
      String shopId, String productId, int quantity) async {
    final shopRef = _firestore.collection('shops').doc(shopId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(shopRef);
      final data = snapshot.data();
      if (data == null) return;

      final inventory = Map<String, dynamic>.from(data['inventory'] ?? {});
      final currentStock = inventory[productId] ?? 0;

      inventory[productId] = currentStock + quantity;
      transaction.update(shopRef, {'inventory': inventory});
    });
  }
}
