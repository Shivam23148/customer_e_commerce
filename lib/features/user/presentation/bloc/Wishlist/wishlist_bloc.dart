import 'package:bloc/bloc.dart';
import 'package:customer_e_commerce/core/di/service_locator.dart';
import 'package:customer_e_commerce/features/user/data/models/wishlist_model.dart';
import 'package:customer_e_commerce/features/user/data/repositories/wishlist_repository.dart';
import 'package:meta/meta.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistRepository _wishlistRepository =
      serviceLocator<WishlistRepository>();
  WishlistBloc() : super(WishlistState()) {
    on<AddToWishlist>((event, emit) async {
      emit(state.copyWith(itemLoading: {event.wishlistItem.productId!: true}));
      try {
        await _wishlistRepository.addToWishlist(event.wishlistItem);
        emit(state.copyWith(
          itemLoading: {event.wishlistItem.productId!: false},
          wishlistItems: List.from(state.wishlistItems)
            ..add(event.wishlistItem),
        ));
      } catch (e) {
        print("Failed to add to wishlist: ${e.toString()}");
        emit(state.copyWith(
          itemLoading: {event.wishlistItem.productId!: false},
          error: 'Failed to add to wishlist',
        ));
      }
    });
    on<RemoveFromWishlist>((event, emit) async {
      emit(state.copyWith(itemLoading: {event.wishlistItem.productId!: true}));
      try {
        await _wishlistRepository.removeFromWishlist(event.wishlistItem);
        emit(state.copyWith(
          itemLoading: {event.wishlistItem.productId!: false},
          wishlistItems: List.from(state.wishlistItems)
            ..removeWhere(
                (item) => item.productId == event.wishlistItem.productId),
        ));
      } catch (e) {
        print("Failed to remove from wishlist: ${e.toString()}");
        emit(state.copyWith(
          itemLoading: {event.wishlistItem.productId!: false},
          error: 'Failed to remove from wishlist',
        ));
      }
    });
    on<LoadWishlist>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        // Simulate loading wishlist items
        final wishlistItems = await _wishlistRepository.loadCart();
        emit(state.copyWith(
          wishlistItems: wishlistItems,
          isLoading: false,
        ));
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          error: 'Failed to load wishlist',
        ));
        print("Failed to load wishlist: ${e.toString()}");
      }
    });
  }
}
