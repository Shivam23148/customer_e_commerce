import 'package:customer_e_commerce/features/user/data/models/product_models.dart';

class CartItem {
  final String? shopId;
  final String? ownerId;
  final int? quantity;
  final CartProductD? productDetails;

  CartItem({
    this.shopId,
    this.ownerId,
    this.quantity,
    this.productDetails,
  });

  Map<String, dynamic> toJson() {
    return {
      'shopId': shopId,
      'ownerId': ownerId,
      'quantity': quantity,
      'productDetails': productDetails?.toJson(),
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      shopId: json['shopId'],
      ownerId: json['ownerId'],
      quantity: json['quantity'],
      productDetails: json['productDetails'] != null
          ? CartProductD.fromJson(json['productDetails'])
          : null,
    );
  }
  CartItem copyWith({
    String? shopId,
    String? ownerId,
    String? productName,
    int? quantity,
  }) {
    return CartItem(
      shopId: shopId ?? this.shopId,
      quantity: quantity ?? this.quantity,
      productDetails: productDetails?.copyWith(
        productName: productName ?? productDetails?.productName,
      ),
    );
  }

  static CartItem empty() {
    return CartItem(
      shopId: null,
      ownerId: null,
      quantity: 0,
      productDetails: CartProductD.empty(),
    );
  }
}

/// CartProductD class to represent product details in the cart
class CartProductD {
  final String productId; // 🔥 New field
  final String productName;
  final String productDescription;
  final double productPrice;
  final String productImageUrl;

  CartProductD({
    required this.productId,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.productImageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productDescription': productDescription,
      'productPrice': productPrice,
      'productImageUrl': productImageUrl,
    };
  }

  factory CartProductD.fromJson(Map<String, dynamic> json) {
    return CartProductD(
      productId: json['productId'],
      productName: json['productName'],
      productDescription: json['productDescription'],
      productPrice: (json['productPrice'] ?? 0).toDouble(),
      productImageUrl: json['productImageUrl'],
    );
  }

  CartProductD copyWith({
    String? productId,
    String? productName,
    String? productDescription,
    double? productPrice,
    String? productImageUrl,
  }) {
    return CartProductD(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productDescription: productDescription ?? this.productDescription,
      productPrice: productPrice ?? this.productPrice,
      productImageUrl: productImageUrl ?? this.productImageUrl,
    );
  }

  static CartProductD empty() {
    return CartProductD(
      productId: '',
      productName: '',
      productDescription: '',
      productPrice: 0.0,
      productImageUrl: '',
    );
  }
}
