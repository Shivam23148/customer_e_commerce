import 'package:bloc/bloc.dart';
import 'package:customer_e_commerce/core/di/service_locator.dart';
import 'package:customer_e_commerce/features/user/data/models/address_model.dart';
import 'package:customer_e_commerce/features/user/data/repositories/address_repository_impl.dart';
import 'package:meta/meta.dart';

part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressRepositoryImpl addressRepo =
      serviceLocator<AddressRepositoryImpl>();
  AddressBloc() : super(AddressInitial()) {
    on<FetchAddressListEvent>((event, emit) async {
      emit(AddressListLoadingState());
      try {
        final addressList = await addressRepo.getUserAddresses();
        emit(AddressListLoadedState(addressList));
      } catch (e) {
        emit(AddressErrorMessage("Failed to fetch address data"));

        print("Failed to fetch address Error : $e");
      }
    });
    on<AddAddressEvent>((event, emit) async {
      emit(AddressListLoadingState());
      try {
        await addressRepo.addAddress(event.address);
        emit(AddressAddedState());
      } catch (e) {
        emit(AddressErrorMessage("Failed to add address"));
        print("Failed to add address Error : $e");
      }
    });
    on<AddressDeleteEvent>((event, emit) async {
      try {
        await addressRepo.deleteAddress(event.id);
        emit(AddressDeletedState());
      } catch (e) {
        emit(AddressErrorMessage("Failed to delete address"));
        print("Failed to delete address Error: $e");
      }
    });
    on<UpdateAddressEvent>((event, emit) async {
      try {
        await addressRepo.updateAddress(event.address, event.id);
        emit(AddressUpdatedState());
      } catch (e) {
        emit(AddressErrorMessage("Failed to update address"));
        print("Failed to update address Error: $e");
      }
    });
  }
}
