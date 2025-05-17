part of 'address_bloc.dart';

abstract class AddressEvent {}

class FetchAddressListEvent extends AddressEvent {}

class AddAddressEvent extends AddressEvent {
  final UserAddress address;

  AddAddressEvent(this.address);
}

class UpdateAddressEvent extends AddressEvent {
  final UserAddress address;
  final String id;

  UpdateAddressEvent(this.address, this.id);
}

class AddressDeleteEvent extends AddressEvent {
  final String id;

  AddressDeleteEvent(this.id);
}
