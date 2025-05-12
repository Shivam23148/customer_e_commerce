part of 'cart_bloc.dart';

abstract class CartEvent {}

class AddToCart extends CartEvent {
  final CartItem cartItem;

  AddToCart(this.cartItem);
}

class RemoveFromCart extends CartEvent {
  final String productId;

  RemoveFromCart(this.productId);
}

class UpdateCartItemQuantity extends CartEvent {
  final String productId;
  final int newQuantity;

  UpdateCartItemQuantity(this.productId, this.newQuantity);
}

class ClearCartEvent extends CartEvent {}

class LoadCart extends CartEvent {}
