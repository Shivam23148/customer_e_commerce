part of 'address_bloc.dart';

abstract class AddressState {}

class AddressInitial extends AddressState {}

class AddressListLoadingState extends AddressState {}

class AddressListLoadedState extends AddressState {
  final List<UserAddress> addressList;

  AddressListLoadedState(this.addressList);
}

class AddressAddedState extends AddressState {}

class AddressDeletedState extends AddressState {}

class AddressUpdatedState extends AddressState {}

class AddressErrorMessage extends AddressState {
  final String message;

  AddressErrorMessage(this.message);
}
