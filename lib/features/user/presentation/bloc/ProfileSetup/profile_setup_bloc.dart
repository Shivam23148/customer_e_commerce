import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_e_commerce/core/di/service_locator.dart';
import 'package:customer_e_commerce/core/services/geolocator_service.dart';
import 'package:customer_e_commerce/features/user/data/models/address_model.dart';
import 'package:customer_e_commerce/features/user/data/models/profile_models.dart';
import 'package:customer_e_commerce/features/user/domain/repositories/profile_repository.dart';

part 'profile_setup_event.dart';
part 'profile_setup_state.dart';

class ProfileSetupBloc extends Bloc<ProfileSetupEvent, ProfileSetupState> {
  final ProfileRepository profileRepository =
      serviceLocator<ProfileRepository>();
  final GeolocatorService geolocatorService =
      serviceLocator<GeolocatorService>();
  ProfileSetupBloc() : super(ProfileSetupInitial()) {
    on<ProfileSetupResetEvent>((event, emit) {
      emit(ProfileSetupInitial());
    });
    on<SaveBasicInfoEvent>((event, emit) {
      emit(ProfileSetupLoading());
      try {
        profileRepository.saveBasicInfo(event.profileData);
        emit(ProfileBasicInfoSaved());
      } catch (e) {
        rethrow;
      }
    });
    on<RequestLocationPermissionEvent>((event, emit) async {
      emit(ProfileSetupLoading());
      try {
        final hasPermision = await geolocatorService.requestPermission();
        if (hasPermision) {
          emit(LocationPermissionGranted());
        } else {
          emit(LocationPermissionDenied());
        }
        print("Location Permission is ${hasPermision}");
      } catch (e) {
        emit(LocationAddressError(message: "Failed to fetch location"));
        throw Exception("Location permission error: $e");
      }
    });

    on<CheckLocationServiceEvent>((event, emit) async {
      emit(ProfileSetupLoading());
      final isServiceEnabled =
          await geolocatorService.checkLocationServiceEnabled();
      if (!isServiceEnabled) {
        emit(LocationAddressError(
            message: "GPS is off. Please enable it from settings."));
        await geolocatorService.openLocationSettings();
      }
      add(RequestLocationPermissionEvent());
    });
    on<FetchLocationAddressEvent>((event, emit) async {
      emit(ProfileSetupLoading());
      try {
        final address = await geolocatorService.getCurrentLocationAddress();
        emit(LocationAddressFetched(address));
      } catch (e) {
        emit(LocationAddressError(message: 'Could not fetch location'));
        throw Exception("Could not fetch location : $e");
      }
    });
    on<SaveAddressEvent>((event, emit) async {
      emit(ProfileSetupLoading());
      try {
        final location = await geolocatorService.geocodeAddress(event.address);
        final addressWithLocation = event.address.copyWith(
            location: GeoPoint(location.latitude, location.longitude));
        await profileRepository.saveAddress(addressWithLocation);

        /* 
        if (event.isManualEntry) {
          final location =
              await geolocatorService.geocodeAddress(event.address);
          final addressWithLocation = event.address.copyWith(
              location: GeoPoint(location.latitude, location.longitude));
          await profileRepository.saveAddress(addressWithLocation);
        } else {
          await profileRepository.saveAddress(event.address);
        } */
        emit(ProfileSaved());
      } catch (e) {
        emit(ProfileError('Failed to save address'));
        rethrow;
      }
    });
  }
}
