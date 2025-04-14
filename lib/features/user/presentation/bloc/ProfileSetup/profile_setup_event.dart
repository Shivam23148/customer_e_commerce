part of 'profile_setup_bloc.dart';

abstract class ProfileSetupEvent {}

class ProfileResetEvent extends ProfileSetupEvent {}

class SaveBasicInfoEvent extends ProfileSetupEvent {
  final Profile profileData;

  SaveBasicInfoEvent({required this.profileData});
}

class RequestLocationPermissionEvent extends ProfileSetupEvent {}

class FetchLocationAddressEvent extends ProfileSetupEvent {}

class CheckLocationServiceEvent extends ProfileSetupEvent {}

class SaveAddressEvent extends ProfileSetupEvent {
  final UserAddress address;
  final bool isManualEntry;

  SaveAddressEvent(this.address, {this.isManualEntry = false});
}
