import 'package:bloc/bloc.dart';
import 'package:customer_e_commerce/core/di/service_locator.dart';
import 'package:customer_e_commerce/features/user/data/models/cart_model.dart';
import 'package:customer_e_commerce/features/user/data/repositories/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository = serviceLocator<CartRepository>();

  CartBloc() : super(CartState()) {
    // Add to Cart logic
    on<AddToCart>((event, emit) async {
      emit(state.copyWith(
          itemLoading: {event.cartItem.productDetails!.productId: true},
          error: ""));

      try {
        final updatedCartItems = List<CartItem>.from(state.cartItems);
        final existingCartItem = updatedCartItems.firstWhere(
          (item) =>
              item.productDetails?.productId ==
              event.cartItem.productDetails!.productId,
          orElse: () => CartItem.empty(),
        );

        int quantityChange = event.cartItem.quantity ?? 0;

        if (existingCartItem.productDetails!.productId.isNotEmpty) {
          final updatedItem = existingCartItem.copyWith(
            quantity: (existingCartItem.quantity ?? 0) + quantityChange,
          );
          updatedCartItems[updatedCartItems.indexOf(existingCartItem)] =
              updatedItem;
        } else {
          updatedCartItems.add(event.cartItem);
        }

        await cartRepository.reduceInventory(
          event.cartItem.shopId!,
          event.cartItem.productDetails!.productId,
          quantityChange,
        );

        await cartRepository.saveCart(updatedCartItems);
        emit(state.copyWith(
            cartItems: updatedCartItems,
            error: "",
            itemLoading: {event.cartItem.productDetails!.productId: false}));
      } catch (e) {
        emit(state.copyWith(
          itemLoading: {event.cartItem.productDetails!.productId: false},
          error: 'Failed to add to cart',
        ));
        print('Failed to add to cart: ${e.toString()}');
      }
    });

    // Update cart item quantity logic
    on<UpdateCartItemQuantity>((event, emit) async {
      emit(state.copyWith(itemLoading: {event.productId: true}, error: ""));
      try {
        final updatedCartItems = List<CartItem>.from(state.cartItems);

        final existingIndex = updatedCartItems.indexWhere(
            (item) => item.productDetails!.productId == event.productId);

        if (existingIndex != -1) {
          final oldItem = updatedCartItems[existingIndex];
          final oldQty = oldItem.quantity ?? 0;
          final newQty = event.newQuantity;

          if (newQty > 0) {
            updatedCartItems[existingIndex] =
                oldItem.copyWith(quantity: newQty);

            final diff = newQty - oldQty;
            if (diff > 0) {
              await cartRepository.reduceInventory(
                  oldItem.shopId!, oldItem.productDetails!.productId, diff);
            } else if (diff < 0) {
              await cartRepository.restoreInventory(
                  oldItem.shopId!, oldItem.productDetails!.productId, -diff);
            }

            await cartRepository.saveCart(updatedCartItems);
          }
        }

        emit(state.copyWith(
            cartItems: updatedCartItems,
            error: "",
            itemLoading: {event.productId: false}));
      } catch (e) {
        emit(state.copyWith(
          itemLoading: {event.productId: false},
          error: 'Failed to update cart item',
        ));
        print('Failed to update cart item: ${e.toString()}');
      }
    });

    // Remove item from cart logic
    on<RemoveFromCart>((event, emit) async {
      emit(state.copyWith(itemLoading: {event.productId: true}, error: ""));

      try {
        final updatedCartItems = List<CartItem>.from(state.cartItems);
        final existingItem = updatedCartItems.firstWhere(
          (item) => item.productDetails!.productId == event.productId,
          orElse: () => CartItem.empty(),
        );

        if (existingItem.productDetails!.productId.isNotEmpty) {
          updatedCartItems.remove(existingItem);

          await cartRepository.restoreInventory(
            existingItem.shopId!,
            existingItem.productDetails!.productId,
            existingItem.quantity ?? 0,
          );
        }

        await cartRepository.saveCart(updatedCartItems);
        emit(state.copyWith(
            cartItems: updatedCartItems,
            error: "",
            itemLoading: {event.productId: false}));
      } catch (e) {
        emit(state.copyWith(
          itemLoading: {event.productId: false},
          error: 'Failed to remove item',
        ));

        print('Failed to remove item: ${e.toString()}');
      }
    });

    // Load cart items
    on<LoadCart>((event, emit) async {
      try {
        final cartItems = await cartRepository.loadCart();
        emit(state.copyWith(
          cartItems: cartItems,
          error: "",
        ));
      } catch (e) {
        emit(state.copyWith(
          error: 'Failed to load cart',
        ));
        print('Failed to load cart: ${e.toString()}');
      }
    });
  }
}
