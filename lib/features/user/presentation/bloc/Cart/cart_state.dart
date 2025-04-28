part of 'cart_bloc.dart';

class CartState {
  final List<CartItem> cartItems;
  final bool isLoading;
  final String error;
  final Map<String, bool> itemLoading;

  CartState(
      {this.cartItems = const [],
      this.isLoading = false,
      this.error = '',
      this.itemLoading = const {}});

  CartState copyWith(
      {List<CartItem>? cartItems,
      bool? isLoading,
      String? error,
      Map<String, bool>? itemLoading}) {
    return CartState(
        cartItems: cartItems ?? this.cartItems,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        itemLoading: itemLoading ?? this.itemLoading);
  }
}
