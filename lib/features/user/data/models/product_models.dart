import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String productId;
  final String productName;
  final String productDescription;
  final double productPrice;
  final String productimageUrl;
  final Timestamp createdAt;

  Product(
      {required this.productId,
      required this.productName,
      required this.productDescription,
      required this.productPrice,
      required this.productimageUrl,
      required this.createdAt});

  //Convert Firestore document to Product object
  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
        productId: doc.id,
        productName: data['productName'] ?? '',
        productDescription: data['productDescription'] ?? '',
        productPrice:
            (data['productPrice'] as num?)?.toDouble() ?? 0.0, // Convert safely
        productimageUrl: data['productimageUrl'] ?? '',
        createdAt: data['createdAt'] ?? Timestamp.now());
  }

  //Convert Product object to json for firestore
  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'productDescription': productDescription,
      'productPrice': productPrice,
      'productimageUrl': productimageUrl,
      'createdAt': createdAt
    };
  }

  //deserialize from local JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      productDescription: json['productDescription'] ?? '',
      productPrice: (json['productPrice'] as num?)?.toDouble() ?? 0.0,
      productimageUrl: json['productimageUrl'] ?? '',
      createdAt: Timestamp.fromDate(DateTime.parse(json['createdAt'])),
    );
  }
}
