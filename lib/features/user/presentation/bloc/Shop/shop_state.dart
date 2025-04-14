part of 'shop_bloc.dart';

class ShopState {
  final List<UserAddress> userAddresses;
  final UserAddress? selectedAddress;
  final ShopWithProducts? shopWithProducts;
  final double? distance;
  final bool isLoading;
  final String? errorMessage;
  final bool isRefreshing;

  ShopState(
      {this.userAddresses = const [],
      this.selectedAddress,
      this.shopWithProducts,
      this.distance,
      this.isLoading = false,
      this.errorMessage,
      this.isRefreshing = false});

  @override
  List<Object?> get props => [
        userAddresses,
        selectedAddress,
        shopWithProducts,
        distance,
        isLoading,
        errorMessage,
        isRefreshing
      ];

  ShopState copyWith(
      {List<UserAddress>? userAddresses,
      UserAddress? selectedAddress,
      ShopWithProducts? shopWithProducts,
      double? distance,
      bool? isLoading,
      String? errorMessage,
      bool? isRefreshing}) {
    return ShopState(
        userAddresses: userAddresses ?? this.userAddresses,
        selectedAddress: selectedAddress ?? this.selectedAddress,
        shopWithProducts: shopWithProducts ?? this.shopWithProducts,
        distance: distance ?? this.distance,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
        isRefreshing: isRefreshing ?? this.isRefreshing);
  }
}
