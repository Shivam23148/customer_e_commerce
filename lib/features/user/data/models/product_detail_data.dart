import 'package:customer_e_commerce/features/user/data/models/cart_model.dart';

class ProductDetailData {
  final String shopId;
  final String ownerId;
  final CartProductD product;

  ProductDetailData(this.shopId, this.ownerId, this.product);
}
