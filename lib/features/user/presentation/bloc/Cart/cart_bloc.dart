import 'package:bloc/bloc.dart';
import 'package:customer_e_commerce/core/di/service_locator.dart';
import 'package:customer_e_commerce/features/user/data/models/cart_model.dart';
import 'package:customer_e_commerce/features/user/data/repositories/cart_repository.dart';
import 'package:meta/meta.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository = serviceLocator<CartRepository>();

  CartBloc() : super(CartState()) {
    // Add to Cart logic
    on<AddToCart>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      final updatedCartItems = List<CartItem>.from(state.cartItems);

      final existingCartItem = updatedCartItems.firstWhere(
        (item) => item.productId == event.cartItem.productId,
        orElse: () => CartItem.empty(),
      );

      int quantityChange = event.cartItem.quantity ?? 0;

      if (existingCartItem.productId!.isNotEmpty) {
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
        event.cartItem.productId!,
        quantityChange,
      );

      await cartRepository.saveCart(updatedCartItems);
      emit(state.copyWith(cartItems: updatedCartItems, isLoading: false));
    });

    // Update cart item quantity logic
    on<UpdateCartItemQuantity>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      final updatedCartItems = List<CartItem>.from(state.cartItems);

      final existingIndex = updatedCartItems
          .indexWhere((item) => item.productId == event.productId);

      if (existingIndex != -1) {
        final oldItem = updatedCartItems[existingIndex];
        final oldQty = oldItem.quantity ?? 0;
        final newQty = event.newQuantity;

        if (newQty > 0) {
          updatedCartItems[existingIndex] = oldItem.copyWith(quantity: newQty);

          final diff = newQty - oldQty;
          if (diff > 0) {
            await cartRepository.reduceInventory(
                oldItem.shopId!, oldItem.productId!, diff);
          } else if (diff < 0) {
            await cartRepository.restoreInventory(
                oldItem.shopId!, oldItem.productId!, -diff);
          }

          await cartRepository.saveCart(updatedCartItems);
        }
      }

      emit(state.copyWith(cartItems: updatedCartItems, isLoading: false));
    });

    // Remove item from cart logic
    on<RemoveFromCart>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      final updatedCartItems = List<CartItem>.from(state.cartItems);
      final existingItem = updatedCartItems.firstWhere(
        (item) => item.productId == event.productId,
        orElse: () => CartItem.empty(),
      );

      if (existingItem.productId!.isNotEmpty) {
        updatedCartItems.remove(existingItem);

        await cartRepository.restoreInventory(
          existingItem.shopId!,
          existingItem.productId!,
          existingItem.quantity ?? 0,
        );
      }

      await cartRepository.saveCart(updatedCartItems);
      emit(state.copyWith(cartItems: updatedCartItems, isLoading: false));
    });

    // Load cart items
    on<LoadCart>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final cartItems = await cartRepository.loadCart();
      emit(state.copyWith(cartItems: cartItems, isLoading: false));
    });
  }
}
