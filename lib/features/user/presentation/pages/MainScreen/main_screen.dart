import 'package:customer_e_commerce/core/theme/app_colors.dart';
import 'package:customer_e_commerce/core/utils/global_variable.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/Cart/cart_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/Shop/shop_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/bloc/Wishlist/wishlist_bloc.dart';
import 'package:customer_e_commerce/features/user/presentation/pages/Cart/cart_screen.dart';
import 'package:customer_e_commerce/features/user/presentation/pages/Home/home_screen.dart';
import 'package:customer_e_commerce/features/user/presentation/pages/Profile/profile_screen.dart';
import 'package:customer_e_commerce/features/user/presentation/pages/Wishlist/wishlist_screen.dart';
import 'package:customer_e_commerce/features/user/presentation/widgets/address_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:badges/badges.dart' as badges;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController pageController = PageController();
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);
  bool _popupShown = false;
  @override
  void initState() {
    // TODO: implement initState
    print("MainScreen initState called");
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShopBloc>().add(LoadUserAddresses());
    });
  }

  void _showAddressDialog(BuildContext context) {
    final state = context.read<ShopBloc>().state;
    final addresses = state.userAddresses;

    if (addresses.isEmpty || _popupShown) return;

    _popupShown = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AddressSelectionDialog(
        addresses: addresses,
        onAddressSelected: (address) {
          context.read<ShopBloc>().add(SelectAddressEvent(address));
          GlobalVariable.selectedAddressUser = address;
          context.read<ShopBloc>().add(CalculateNearestShopEvent(address));
          context.read<CartBloc>().add(LoadCart());
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("MainScreen dispose called");
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopBloc, ShopState>(
      listener: (context, state) {
        if (state.userAddresses.isNotEmpty && !_popupShown) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showAddressDialog(context);
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: ValueListenableBuilder<int>(
              valueListenable: _currentPage,
              builder: (context, currentIndex, _) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BottomNavigationBar(
                      currentIndex: currentIndex,
                      onTap: (index) {
                        print("Tapped Index: $index");
                        _currentPage.value = index;
                        pageController.jumpToPage(index);
                      },
                      unselectedItemColor: Colors.black,
                      selectedItemColor: Color(0XFFFD4040),
                      type: BottomNavigationBarType.fixed,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      items: [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home_outlined),
                          label: 'Home',
                        ),
                        BottomNavigationBarItem(
                          icon: BlocBuilder<WishlistBloc, WishlistState>(
                            builder: (context, state) {
                              return state.wishlistItems.length > 0
                                  ? badges.Badge(
                                      badgeAnimation:
                                          badges.BadgeAnimation.slide(
                                        animationDuration:
                                            Duration(milliseconds: 1500),
                                      ),
                                      child:
                                          Icon(Icons.favorite_border_outlined),
                                      position: badges.BadgePosition.topEnd(
                                          top: -12, end: -12),
                                      badgeContent: Text(
                                        state.wishlistItems.length.toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : Icon(Icons.favorite_border_outlined);
                            },
                          ),
                          label: 'Wishlist',
                        ),
                        BottomNavigationBarItem(
                          icon: BlocBuilder<CartBloc, CartState>(
                            builder: (context, state) {
                              return state.cartItems.length > 0
                                  ? badges.Badge(
                                      badgeAnimation:
                                          badges.BadgeAnimation.slide(
                                        animationDuration:
                                            Duration(milliseconds: 1500),
                                      ),
                                      child: Icon(Icons.shopping_cart_outlined),
                                      position: badges.BadgePosition.topEnd(
                                          top: -12, end: -12),
                                      badgeContent: Text(
                                        state.cartItems.length.toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : Icon(Icons.shopping_cart_outlined);
                            },
                          ),
                          label: 'Cart',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.person_outlined),
                          label: 'Profile',
                        ),
                      ],
                    ),
                  ),
                );
              }),
          body: PageView(
            controller: pageController,
            onPageChanged: (index) {
              print("Page Changed Index: $index");
              _currentPage.value = index;
            },
            children: [
              HomeScreen(),
              WishlistScreen(),
              CartScreen(),
              ProfileScreen()
            ],
          ),
        );
      },
    );
  }
}
