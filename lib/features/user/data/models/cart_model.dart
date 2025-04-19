import 'package:customer_e_commerce/features/user/data/models/product_models.dart';

class CartItem {
  final String? productId;
  final String? shopId;
  final String? productName;
  final Product? product;
  final int? quantity;

  CartItem({
    this.productId,
    this.shopId,
    this.productName,
    this.product,
    this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'shopId': shopId,
      'productName': productName,
      'product': product?.toJson(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'],
      shopId: json['shopId'],
      productName: json['productName'],
      product:
          json['product'] != null ? Product.fromJson(json['product']) : null,
      quantity: json['quantity'],
    );
  }

  CartItem copyWith({
    String? productId,
    String? shopId,
    String? productName,
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      shopId: shopId ?? this.shopId,
      productName: productName ?? this.productName,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  static CartItem empty() {
    return CartItem(
      productId: '',
      shopId: '',
      product: null,
      quantity: 0,
    );
  }
}
