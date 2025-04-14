part of 'shop_bloc.dart';

abstract class ShopEvent {}

class LoadUserAddresses extends ShopEvent {}

class SelectAddressEvent extends ShopEvent {
  final UserAddress address;

  SelectAddressEvent(this.address);
}

class CalculateNearestShopEvent extends ShopEvent {
  final UserAddress userAddress;

  CalculateNearestShopEvent(this.userAddress);
}

class RefereshShopDataEvent extends ShopEvent {}
