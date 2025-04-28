part of 'wishlist_bloc.dart';

abstract class WishlistEvent {}

class AddToWishlist extends WishlistEvent {
  final WishlistItem wishlistItem;

  AddToWishlist(this.wishlistItem);
}

class RemoveFromWishlist extends WishlistEvent {
  final WishlistItem wishlistItem;

  RemoveFromWishlist(this.wishlistItem);
}

class LoadWishlist extends WishlistEvent {}
