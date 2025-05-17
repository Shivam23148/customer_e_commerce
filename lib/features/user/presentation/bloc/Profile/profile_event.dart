part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class FetchProfileDataEvent extends ProfileEvent {}

class EditProfileDataEvent extends ProfileEvent {
  final String firstName, lastName;

  EditProfileDataEvent({required this.firstName, required this.lastName});
}

class VerifyPasswordEvent extends ProfileEvent {
  final String oldPassword;

  VerifyPasswordEvent(this.oldPassword);
}

class UpdatePasswordWithNew extends ProfileEvent {
  final String currentP;
  final String newP;

  UpdatePasswordWithNew(this.currentP, this.newP);
}

class UpdatePhoneEvent extends ProfileEvent {
  final String newPhone;

  UpdatePhoneEvent(this.newPhone);
}

class ProfileResetEvent extends ProfileEvent {}

class LogoutEvent extends ProfileEvent {}
