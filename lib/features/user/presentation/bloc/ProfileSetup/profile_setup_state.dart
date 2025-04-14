part of 'profile_setup_bloc.dart';

abstract class ProfileSetupState {}

class ProfileSetupInitial extends ProfileSetupState {}

class ProfileSetupLoading extends ProfileSetupState {}

class ProfileBasicInfoSaved extends ProfileSetupState {}

class LocationPermissionGranted extends ProfileSetupState {}

class LocationPermissionDenied extends ProfileSetupState {}

class LocationAddressFetched extends ProfileSetupState {
  final UserAddress address;

  LocationAddressFetched(this.address);
}

class LocationAddressError extends ProfileSetupState {
  final String message;

  LocationAddressError({required this.message});
}

class ProfileSaved extends ProfileSetupState {}

class ProfileError extends ProfileSetupState {
  final String message;
  ProfileError(this.message);
}
