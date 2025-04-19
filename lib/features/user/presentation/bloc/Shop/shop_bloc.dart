import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_e_commerce/core/di/service_locator.dart';
import 'package:customer_e_commerce/core/services/geolocator_service.dart';
import 'package:customer_e_commerce/features/user/data/models/address_model.dart';
import 'package:customer_e_commerce/features/user/data/models/shopwithproduct_model.dart';
import 'package:customer_e_commerce/features/user/data/repositories/address_repository_impl.dart';
import 'package:customer_e_commerce/features/user/data/repositories/shop_repositry_impl.dart';
import 'package:meta/meta.dart';

part 'shop_event.dart';
part 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final ShopRepository shopRepository = serviceLocator<ShopRepository>();
  final GeolocatorService geolocatorService =
      serviceLocator<GeolocatorService>();
  final AddressRepositoryImpl addressRepository =
      serviceLocator<AddressRepositoryImpl>();

  ShopBloc() : super(ShopState()) {
    on<LoadUserAddresses>((event, emit) async {
      print("LoadUserAddresses event called");
      emit(state.copyWith(isLoading: true));
      try {
        final address = await addressRepository.getUserAddresses();
        emit(state.copyWith(userAddresses: address, isLoading: false));
      } catch (e) {
        emit(state.copyWith(
            isLoading: false, errorMessage: "Failed to load addresses"));
        throw Exception("Failed to load addresses: $e");
      }
    });
    on<SelectAddressEvent>((event, emit) {
      emit(state.copyWith(selectedAddress: event.address));
      emit(state.copyWith(isLoading: true));
    });
    on<CalculateNearestShopEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final userGeoPoint = state.selectedAddress?.location;
        if (userGeoPoint == null) {
          emit(state.copyWith(
              isLoading: false,
              errorMessage: "User location is not available"));
          return;
        }
        final shopwithProducts =
            await shopRepository.getNearestShopWithProducts(userGeoPoint);
        final distance =
            _calculateDistance(userGeoPoint, shopwithProducts.shop.location!);
        emit(state.copyWith(
            isLoading: false,
            shopWithProducts: shopwithProducts,
            distance: distance,
            selectedAddress: event.userAddress));
      } catch (e) {
        emit(state.copyWith(
            isLoading: false,
            errorMessage: "Failed to calculate nearest shop"));
        throw Exception("Failed to calculate nearest shop: $e");
      }
    });

    on<RefereshShopDataEvent>((event, emit) async {
      if (state.selectedAddress == null) return;
      emit(state.copyWith(isRefreshing: true));
      try {
        final userGeoPoint = state.selectedAddress?.location;
        final shopWithPRoducts =
            await shopRepository.getNearestShopWithProducts(userGeoPoint!);
        final distance =
            _calculateDistance(userGeoPoint, shopWithPRoducts.shop.location!);
        emit(state.copyWith(
          isRefreshing: false,
          shopWithProducts: shopWithPRoducts,
          distance: distance,
        ));
      } catch (e) {
        emit(state.copyWith(
          isRefreshing: false,
          errorMessage: "Failed to refresh shop data",
        ));
        throw Exception("Failed to refresh shop data: $e");
      }
    });
  }
  double _calculateDistance(GeoPoint point1, GeoPoint point2) {
    const double earthRadius = 6371; // km
    double lat1 = point1.latitude;
    double lon1 = point1.longitude;
    double lat2 = point2.latitude;
    double lon2 = point2.longitude;

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degree) => degree * pi / 180;
}
