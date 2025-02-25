part of 'profile_setup_bloc.dart';

abstract class ProfileSetupEvent {}

class SaveBasicInfoEvent extends ProfileSetupEvent {
  final String name, phone;

  SaveBasicInfoEvent({required this.name, required this.phone});
}

class SaveAddressEvent extends ProfileSetupEvent {
  final String house, buildingNo, landmark, city, state, zip;

  SaveAddressEvent(
      {required this.house,
      required this.buildingNo,
      required this.landmark,
      required this.city,
      required this.state,
      required this.zip});
}
