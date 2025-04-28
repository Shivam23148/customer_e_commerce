class WishlistItem {
  final String? productId;
  final String? productName;
  final String? productDescription;
  final double? productPrice;
  final String? productImageUrl;

  WishlistItem({
    this.productId,
    this.productName,
    this.productDescription,
    this.productPrice,
    this.productImageUrl,
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

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      productId: json['productId'],
      productName: json['productName'],
      productDescription: json['productDescription'],
      productPrice: (json['productPrice'] ?? 0).toDouble(),
      productImageUrl: json['productImageUrl'],
    );
  }
  static WishlistItem empty() {
    return WishlistItem(
      productId: '',
      productName: '',
      productDescription: '',
      productPrice: 0.0,
      productImageUrl: '',
    );
  }
}
