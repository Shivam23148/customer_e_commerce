part of 'profile_bloc.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  final Profile profileData;

  ProfileLoadedState(this.profileData);
}

class ProfileEditedState extends ProfileState {}

class CurrentPasswordVerified extends ProfileState {}

class UpdatePasswordSuccess extends ProfileState {}

class PhoneUpdatedState extends ProfileState {}

class LogoutSuccessfullState extends ProfileState {}

class ProfileErrorMessage extends ProfileState {
  final String message;

  ProfileErrorMessage({required this.message});
}
