import 'package:customer_e_commerce/core/theme/app_colors.dart';
import 'package:customer_e_commerce/core/utils/assets_manager.dart';
import 'package:customer_e_commerce/features/user/data/models/cart_model.dart';
import 'package:customer_e_commerce/features/user/data/models/wishlist_model.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/Cart/cart_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/Wishlist/wishlist_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/widgets/my_elevated_button.dart';
import 'package:customer_e_commerce/size_config.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailScreen extends StatefulWidget {
  final String shopId;
  final CartProductD product;
  final String ownerId;
  ProductDetailScreen(
      {super.key,
      required this.shopId,
      required this.product,
      required this.ownerId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: getRelativeWidth(0.05)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: widget.product.productId,
              transitionOnUserGestures: true,
              child: Image.network(widget.product.productImageUrl,
                  height: 250, fit: BoxFit.scaleDown,
                  errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  AssetsManager.chipsImage,
                  fit: BoxFit.scaleDown,
                );
              }),
            ),
            SizedBox(height: getRelativeHeight(0.02)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.product.productName,
                    style: TextStyle(
                        fontSize: getRelativeWidth(0.08),
                        fontWeight: FontWeight.bold)),
                BlocBuilder<WishlistBloc, WishlistState>(
                  builder: (context, state) {
                    final isInWishlist = state.wishlistItems.any(
                      (item) => item.productId == widget.product.productId,
                    );
                    final isLoading =
                        state.itemLoading[widget.product.productId] ?? false;
                    return IconButton(
                        onPressed: () {
                          final wishlistItem = WishlistItem(
                            productId: widget.product.productId,
                            productName: widget.product.productName,
                            productImageUrl: widget.product.productImageUrl,
                            productPrice: widget.product.productPrice,
                            // add more fields if needed
                          );
                          if (isInWishlist) {
                            context
                                .read<WishlistBloc>()
                                .add(RemoveFromWishlist(wishlistItem));
                          } else {
                            context
                                .read<WishlistBloc>()
                                .add(AddToWishlist(wishlistItem));
                          }
                        },
                        icon: isLoading
                            ? CircularProgressIndicator(
                                color: AppColors.primary,
                              )
                            : Icon(
                                isInWishlist
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isInWishlist
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ));
                  },
                )
              ],
            ),
            SizedBox(height: getRelativeHeight(0.01)),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                widget.product.productDescription,
                style: TextStyle(
                    fontSize: getRelativeWidth(0.05),
                    fontStyle: FontStyle.italic,
                    color: AppColors.textSecondary),
              ),
            ),
            SizedBox(height: getRelativeHeight(0.02)),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Price: ₹${widget.product.productPrice}",
                style: TextStyle(
                    fontSize: getRelativeWidth(0.06),
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: getRelativeHeight(0.02)),
            BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                final cartItem = state.cartItems.firstWhere(
                  (item) =>
                      item.productDetails?.productId ==
                      widget.product.productId,
                  orElse: () => CartItem(
                    productDetails: widget.product,
                    quantity: 0,
                  ),
                );
                final isItemLoading =
                    state.itemLoading[widget.product.productId] ?? false;
                return cartItem.quantity == 0
                    ? MyElevatedButton(
                        onPressed: () {
                          context.read<CartBloc>().add(
                                AddToCart(
                                  CartItem(
                                    shopId: widget.shopId,
                                    ownerId: widget.ownerId,
                                    productDetails: CartProductD(
                                      productId: widget.product.productId,
                                      productName: widget.product.productName,
                                      productImageUrl:
                                          widget.product.productImageUrl,
                                      productPrice: widget.product.productPrice,
                                      productDescription:
                                          widget.product.productDescription,
                                    ),
                                    quantity: 1,
                                  ),
                                ),
                              );
                        },
                        text: "Add to Cart")
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (cartItem.quantity == 1) {
                                context.read<CartBloc>().add(
                                      RemoveFromCart(
                                          cartItem.productDetails!.productId),
                                    );
                              } else {
                                context.read<CartBloc>().add(
                                      UpdateCartItemQuantity(
                                          cartItem.productDetails!.productId,
                                          cartItem.quantity! - 1),
                                    );
                              }
                            },
                            icon: Container(
                              width: getRelativeWidth(0.1),
                              height: getRelativeHeight(0.05),
                              color: Color(0XFFD9D9D9),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.remove,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          isItemLoading
                              ? SizedBox(
                                  height: getRelativeHeight(0.05),
                                  width: getRelativeWidth(0.1),
                                  child: const CircularProgressIndicator(
                                    color: AppColors.primary,
                                  ),
                                )
                              : Text(
                                  '${cartItem.quantity}',
                                  style: TextStyle(
                                      fontSize: getRelativeWidth(0.1),
                                      fontWeight: FontWeight.w600),
                                ),
                          IconButton(
                            onPressed: () {
                              context.read<CartBloc>().add(
                                    UpdateCartItemQuantity(
                                        cartItem.productDetails!.productId,
                                        cartItem.quantity! + 1),
                                  );
                            },
                            icon: Container(
                              width: getRelativeWidth(0.1),
                              height: getRelativeHeight(0.05),
                              color: Color(0XFFD9D9D9),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.add,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      );
              },
            )
          ],
        ),
      ),
    );
  }
}
