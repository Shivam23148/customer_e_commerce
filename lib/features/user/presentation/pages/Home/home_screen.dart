import 'package:customer_e_commerce/core/di/service_locator.dart';
import 'package:customer_e_commerce/core/router/my_routes.dart';
import 'package:customer_e_commerce/core/theme/app_colors.dart';
import 'package:customer_e_commerce/core/utils/assets_manager.dart';
import 'package:customer_e_commerce/core/utils/toast_util.dart';
import 'package:customer_e_commerce/features/user/data/models/cart_model.dart';
import 'package:customer_e_commerce/features/user/data/models/product_detail_data.dart';
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
          color: AppColors.primary,
          onRefresh: () async {
            context.read<ShopBloc>().add(RefereshShopDataEvent());
          },
          child: BlocBuilder<ShopBloc, ShopState>(
            builder: (context, state) {
              print("State of loading : ${state.isLoading}");
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
                    final ownerId = state.shopWithProducts?.shop.ownerId;
                    final productitem = state.shopWithProducts?.products.entries
                        .elementAt(index);
                    final inventoryitem =
                        state.shopWithProducts!.inventory.entries.firstWhere(
                      (entry) => entry.key == productitem?.key,
                      orElse: () => MapEntry('', 0),
                    );
                    final shopId = state.shopWithProducts?.shop.shopId;

                    return GestureDetector(
                      onTap: () {
                        print("Product: ${productitem.value.toJson()}");
                        GoRouter.of(context).push(MyRoutes.productDetailRoute,
                            extra: ProductDetailData(
                              shopId!,
                              ownerId!,
                              CartProductD(
                                productId: productitem.value.productId,
                                productName: productitem.value.productName,
                                productDescription:
                                    productitem.value.productDescription,
                                productImageUrl:
                                    productitem.value.productimageUrl,
                                productPrice: productitem.value.productPrice,
                              ),
                            ));
                      },
                      child: Card(
                        elevation: 2,
                        color: AppColors.background,
                        child: Column(
                          children: [
                            SizedBox(height: 4),
                            Hero(
                              tag: productitem?.value.productId ?? "",
                              transitionOnUserGestures: true,
                              child: Container(
                                height: getRelativeHeight(0.13),
                                child: Image.network(
                                  productitem!.value.productimageUrl.isNotEmpty
                                      ? productitem.value.productimageUrl
                                      : 'https://demofree.sirv.com/nope-not-here.jpg',
                                  fit: BoxFit.scaleDown,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      AssetsManager.chipsImage,
                                      fit: BoxFit.scaleDown,
                                    );
                                  },
                                ),
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
                            inventoryitem.value == 0
                                ? Text(
                                    "Out of Stock",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  )
                                : BlocConsumer<CartBloc, CartState>(
                                    listener: (context, state) {
                                      if (state.error.isNotEmpty) {
                                        ToastUtil.showToast(
                                            state.error, AppColors.primary);
                                      }
                                    },
                                    builder: (context, state) {
                                      final currentItem =
                                          state.cartItems.firstWhere(
                                        (item) {
                                          return item
                                                  .productDetails?.productId ==
                                              productitem.value.productId;
                                        },
                                        orElse: () => CartItem.empty(),
                                      );
                                      final isItemLoading = state.itemLoading[
                                              productitem.value.productId] ??
                                          false;

                                      if (currentItem.quantity == 0) {
                                        return isItemLoading
                                            ? CircularProgressIndicator(
                                                color: AppColors.primary,
                                              )
                                            : ElevatedButton(
                                                onPressed: state.isLoading
                                                    ? null
                                                    : () {
                                                        context
                                                            .read<CartBloc>()
                                                            .add(AddToCart(
                                                              CartItem(
                                                                  shopId:
                                                                      shopId,
                                                                  quantity: 1,
                                                                  ownerId:
                                                                      ownerId,
                                                                  productDetails: CartProductD(
                                                                      productId: productitem
                                                                          .value
                                                                          .productId,
                                                                      productName: productitem
                                                                          .value
                                                                          .productName,
                                                                      productDescription: productitem
                                                                          .value
                                                                          .productDescription,
                                                                      productImageUrl: productitem
                                                                          .value
                                                                          .productimageUrl,
                                                                      productPrice: productitem
                                                                          .value
                                                                          .productPrice)),
                                                            ));
                                                      },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: state
                                                          .isLoading
                                                      ? AppColors.textSecondary
                                                      : AppColors.primary,
                                                ),
                                                child: Text(
                                                  'Add to Cart',
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.background),
                                                ),
                                              );
                                      } else {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: state.isLoading
                                                  ? null
                                                  : () {
                                                      if (currentItem
                                                              .quantity ==
                                                          1) {
                                                        context
                                                            .read<CartBloc>()
                                                            .add(
                                                              RemoveFromCart(
                                                                  productitem
                                                                      .value
                                                                      .productId),
                                                            );
                                                      } else {
                                                        context
                                                            .read<CartBloc>()
                                                            .add(
                                                              UpdateCartItemQuantity(
                                                                  productitem
                                                                      .value
                                                                      .productId,
                                                                  currentItem
                                                                          .quantity! -
                                                                      1),
                                                            );
                                                      }
                                                    },
                                              icon: Icon(
                                                Icons.remove,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            isItemLoading
                                                ? const CircularProgressIndicator(
                                                    color: AppColors.primary,
                                                  )
                                                : Text(
                                                    '${currentItem.quantity}',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                            IconButton(
                                              onPressed: state.isLoading
                                                  ? null
                                                  : () {
                                                      context
                                                          .read<CartBloc>()
                                                          .add(
                                                            UpdateCartItemQuantity(
                                                                productitem
                                                                    .value
                                                                    .productId,
                                                                currentItem
                                                                        .quantity! +
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
                      ),
                    );
                  });
            },
          ),
        ));
  }
}
