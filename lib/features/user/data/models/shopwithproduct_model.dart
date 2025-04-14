import 'package:customer_e_commerce/features/user/data/models/product_models.dart';
import 'package:customer_e_commerce/features/user/data/models/shop_model.dart';

class ShopWithProducts {
  final Shop shop;
  final Map<String, Product> products; // productId -> Product
  final Map<String, int> inventory; // productId -> quantity

  ShopWithProducts({
    required this.shop,
    required this.products,
    required this.inventory,
  });
}
