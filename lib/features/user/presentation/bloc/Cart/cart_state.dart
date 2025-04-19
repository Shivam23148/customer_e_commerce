part of 'cart_bloc.dart';

class CartState {
  final List<CartItem> cartItems;
  final bool isLoading;

  CartState({this.cartItems = const [], this.isLoading = false});

  CartState copyWith({List<CartItem>? cartItems, bool? isLoading}) {
    return CartState(
        cartItems: cartItems ?? this.cartItems,
        isLoading: isLoading ?? this.isLoading);
  }
}
