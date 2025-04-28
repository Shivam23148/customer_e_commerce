import 'package:customer_e_commerce/core/theme/app_colors.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/Cart/cart_bloc.dart';
import 'package:customer_e_commerce/size_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          title: Text(
            "Your Cart",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state.cartItems.isEmpty) {
              return const Center(child: Text('No items in cart'));
            }

            double subtotal = state.cartItems.fold(
              0,
              (total, item) =>
                  total +
                  (item.productDetails?.productPrice ?? 0) * item.quantity!,
            );
            double platformFee = subtotal * 0.05; // 5% platform fee
            double tax = subtotal * 0.18; // 18% GST
            double total = subtotal + platformFee + tax;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = state.cartItems[index];
                      final isItemLoading = state.itemLoading[
                              cartItem.productDetails?.productId] ??
                          false;

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
                              cartItem.productDetails!.productImageUrl
                                      .isNotEmpty
                                  ? cartItem.productDetails!.productImageUrl
                                  : 'https://demofree.sirv.com/nope-not-here.jpg',
                              height: 100,
                              width: getRelativeWidth(0.2),
                              fit: BoxFit.cover,
                            ),
                            title: Text(
                                cartItem.productDetails?.productName ?? ''),
                            subtitle: Text(
                                'Price: ₹${cartItem.productDetails?.productPrice}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize
                                  .min, // Adjusts the size of the row
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (cartItem.quantity == 1) {
                                      context.read<CartBloc>().add(
                                            RemoveFromCart(cartItem
                                                .productDetails!.productId),
                                          );
                                    } else {
                                      context.read<CartBloc>().add(
                                            UpdateCartItemQuantity(
                                                cartItem
                                                    .productDetails!.productId,
                                                cartItem.quantity! - 1),
                                          );
                                    }
                                  },
                                  icon: Container(
                                    width: 25,
                                    height: 25,
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
                                        height: getRelativeHeight(0.03),
                                        width: getRelativeWidth(0.06),
                                        child: const CircularProgressIndicator(
                                          color: AppColors.primary,
                                          strokeWidth: 1.5,
                                        ),
                                      )
                                    : Text(
                                        '${cartItem.quantity}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                IconButton(
                                  onPressed: () {
                                    context.read<CartBloc>().add(
                                          UpdateCartItemQuantity(
                                              cartItem
                                                  .productDetails!.productId,
                                              cartItem.quantity! + 1),
                                        );
                                  },
                                  icon: Container(
                                    width: 25,
                                    height: 25,
                                    color: Color(0XFFD9D9D9),
                                    child: Icon(
                                      Icons.add,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      );
                    },
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, -2))
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SummaryRow(label: "Subtotal", value: subtotal),
                      SummaryRow(label: "Platform Fee", value: platformFee),
                      SummaryRow(label: "Tax (18%)", value: tax),
                      const Divider(),
                      SummaryRow(label: "Total", value: total, isBold: true),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {},
                          child: const Text("Checkout"),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ));
  }
}

class SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isBold;

  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(
            "₹${value.toStringAsFixed(2)}",
            style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
