part of 'profile_setup_bloc.dart';

abstract class ProfileSetupState {}

class ProfileSetupInitial extends ProfileSetupState {}

class ProfileSetupLoading extends ProfileSetupState {}

class ProfileBasicInfoSaved extends ProfileSetupState {}

class ProfileSaved extends ProfileSetupState {}

class ProfileError extends ProfileSetupState {
  final String message;
  ProfileError(this.message);
}
