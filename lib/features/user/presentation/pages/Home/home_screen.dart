import 'package:customer_e_commerce/core/di/service_locator.dart';
import 'package:customer_e_commerce/core/router/my_routes.dart';
import 'package:customer_e_commerce/core/theme/app_colors.dart';
import 'package:customer_e_commerce/core/utils/assets_manager.dart';
import 'package:customer_e_commerce/features/user/data/models/cart_model.dart';
import 'package:customer_e_commerce/features/user/domain/repositories/auth_repository.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/Cart/cart_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/Shop/shop_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/widgets/my_elevated_button.dart';
import 'package:customer_e_commerce/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("HomeScreen initState called");
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // This is important to call to keep the state alive
    print("HomeScreen build called");
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          actions: [
            GestureDetector(
              onTap: () {},
              child: Image.asset(
                AssetsManager.notificaitonIcon,
                height: getRelativeHeight(0.05),
                width: getRelativeWidth(0.05),
              ),
            ),
            SizedBox(
              width: getRelativeWidth(0.03),
            ),
            GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.search,
                color: AppColors.primary,
                size: getRelativeHeight(0.035),
              ),
            ),
            SizedBox(
              width: getRelativeWidth(0.01),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<ShopBloc>().add(RefereshShopDataEvent());
          },
          child: BlocBuilder<ShopBloc, ShopState>(
            builder: (context, state) {
              print("Home Screen build called with state: ${state.distance}");
              if (state.isLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                );
              }
              if (state.isRefreshing) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                );
              }
              if (state.errorMessage != null) {
                return Center(
                  child: Text(state.errorMessage!,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: getRelativeHeight(0.02),
                      )),
                );
              }
              if (state.shopWithProducts == null) {
                return Center(
                  child: Text("No shops available",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: getRelativeHeight(0.02),
                      )),
                );
              }
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: state.shopWithProducts?.products.length,
                  itemBuilder: (context, index) {
                    final inventoryitem = state
                        .shopWithProducts?.inventory.entries
                        .elementAt(index);
                    final productitem = state.shopWithProducts?.products.entries
                        .elementAt(index);
                    final shopId = state.shopWithProducts?.shop.shopId;

                    return Card(
                      elevation: 2,
                      color: AppColors.background,
                      child: Column(
                        children: [
                          SizedBox(height: 4),
                          Container(
                            height: getRelativeHeight(0.13),
                            child: Image.network(
                              productitem!.value.productimageUrl,
                              fit: BoxFit.scaleDown,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  AssetsManager.chipsImage,
                                  fit: BoxFit.scaleDown,
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            productitem.value.productName,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 7),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "₹ ${productitem.value.productPrice.toString()}",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 7),
                          inventoryitem?.value == 0
                              ? Text(
                                  "Out of Stock",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                )
                              : BlocBuilder<CartBloc, CartState>(
                                  builder: (context, state) {
                                    final currentItem =
                                        state.cartItems.firstWhere(
                                      (item) {
                                        print("Product ID: ${item.productId}");
                                        return item.productId ==
                                            productitem.value.productId;
                                      },
                                      orElse: () => CartItem.empty(),
                                    );
                                    if (currentItem.quantity == 0) {
                                      return ElevatedButton(
                                        onPressed: () {
                                          context
                                              .read<CartBloc>()
                                              .add(AddToCart(
                                                CartItem(
                                                  productId: productitem
                                                      .value.productId,
                                                  shopId: shopId,
                                                  product: productitem.value,
                                                  quantity: 1,
                                                ),
                                              ));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                        ),
                                        child: Text('Add to Cart'),
                                      );
                                    }
                                    if (state.isLoading == true) {
                                      return SizedBox(
                                        height: 20,
                                        width: 10,
                                        child: CircularProgressIndicator(
                                          color: AppColors.primary,
                                        ),
                                      );
                                    } else {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              context.read<CartBloc>().add(
                                                    UpdateCartItemQuantity(
                                                        productitem
                                                            .value.productId,
                                                        currentItem.quantity! -
                                                            1),
                                                  );
                                            },
                                            icon: Icon(
                                              Icons.remove,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          Text(
                                            '${currentItem.quantity}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              context.read<CartBloc>().add(
                                                    UpdateCartItemQuantity(
                                                        productitem
                                                            .value.productId,
                                                        currentItem.quantity! +
                                                            1),
                                                  );
                                            },
                                            icon: Icon(
                                              Icons.add,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                )
                        ],
                      ),
                    );
                  });
            },
          ),
        ));
  }
}
