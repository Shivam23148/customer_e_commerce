import 'package:customer_e_commerce/core/theme/app_colors.dart';
import 'package:customer_e_commerce/features/user/data/models/cart_model.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/Wishlist/wishlist_bloc.dart';
import 'package:customer_e_commerce/size_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishlistScreen extends StatefulWidget {
  WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          " Wishlist",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: getRelativeWidth(0.05)),
          child: BlocBuilder<WishlistBloc, WishlistState>(
            builder: (context, state) {
              if (state.wishlistItems.isEmpty) {
                return const Center(child: Text('No items in wishlist'));
              }
              if (state.error.isNotEmpty) {
                return Center(child: Text(state.error));
              }
              if (state.isLoading) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: AppColors.primary,
                ));
              }
              return ListView.builder(
                itemCount: state.wishlistItems.length,
                itemBuilder: (context, index) {
                  final item = state.wishlistItems[index];
                  final isItemLoading =
                      state.itemLoading[item.productId] ?? false;
                  return Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: getRelativeWidth(0.02),
                        vertical: getRelativeHeight(0.005)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.borderColor, width: 1.5)),
                    child: ListTile(
                      leading: Image.network(
                        item.productImageUrl!,
                        height: 100,
                        width: getRelativeWidth(0.2),
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        item.productName!,
                        style: TextStyle(
                            fontSize: getRelativeWidth(0.04),
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "₹ ${item.productPrice}",
                        style: TextStyle(
                            fontSize: getRelativeWidth(0.035),
                            fontWeight: FontWeight.bold),
                      ),
                      trailing: isItemLoading
                          ? CircularProgressIndicator()
                          : IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                context
                                    .read<WishlistBloc>()
                                    .add(RemoveFromWishlist(item));
                              }),
                    ),
                  );
                },
              );
            },
          )),
    );
  }
}
