part of 'wishlist_bloc.dart';

class WishlistState {
  final List<WishlistItem> wishlistItems;
  final Map<String, bool> itemLoading;
  final bool isLoading;

  final String error;

  const WishlistState({
    this.wishlistItems = const [],
    this.itemLoading = const {},
    this.isLoading = false,
    this.error = '',
  });
  WishlistState copyWith({
    List<WishlistItem>? wishlistItems,
    Map<String, bool>? itemLoading,
    bool? isLoading,
    String? error,
  }) {
    return WishlistState(
      wishlistItems: wishlistItems ?? this.wishlistItems,
      itemLoading: itemLoading ?? this.itemLoading,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
