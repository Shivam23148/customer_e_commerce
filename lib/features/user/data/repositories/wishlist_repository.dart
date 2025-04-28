import 'dart:convert';

import 'package:customer_e_commerce/core/di/service_locator.dart';
import 'package:customer_e_commerce/features/user/data/models/wishlist_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistRepository {
  static const String _wishlistKey = 'user_wishlist';
  final SharedPreferences _prefs = serviceLocator<SharedPreferences>();

  Future<void> saveCart(List<WishlistItem> wishlist) async {
    try {
      final wishlistJson =
          json.encode(wishlist.map((item) => item.toJson()).toList());
      await _prefs.setString(_wishlistKey, wishlistJson);
    } catch (e) {
      print('Error saving wishlist: $e');
    }
  }

  Future<List<WishlistItem>> loadCart() async {
    try {
      final wishlistJson = _prefs.getString(_wishlistKey);
      if (wishlistJson == null) return [];
      final List decoded = json.decode(wishlistJson);
      return decoded.map((item) => WishlistItem.fromJson(item)).toList();
    } catch (e) {
      print('Error loading wishlist: $e');
      return [];
    }
  }

  /* Future<void> clearCart() async {
    try {
      await _prefs.remove(_wishlistKey);
    } catch (e) {
      print('Error clearing wishlist: $e');
    }
  } */

  Future<void> addToWishlist(WishlistItem item) async {
    try {
      final wishlist = await loadCart();
      wishlist.add(item);
      await saveCart(wishlist);
    } catch (e) {
      print('Error adding to wishlist: $e');
    }
  }

  Future<void> removeFromWishlist(WishlistItem item) async {
    try {
      final wishlist = await loadCart();
      wishlist.removeWhere((i) => i.productId == item.productId);
      await saveCart(wishlist);
    } catch (e) {
      print('Error removing from wishlist: $e');
    }
  }
}
