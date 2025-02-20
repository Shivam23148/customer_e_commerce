part of 'register_bloc.dart';

abstract class RegisterEvent {}

class SendVerificationEmailEvent extends RegisterEvent {
  final String email;

  SendVerificationEmailEvent({required this.email});
}

class CheckEmailVerificationEvent extends RegisterEvent {}

class CompleteRegistrationEvent extends RegisterEvent {
  final String email;
  final String password;

  CompleteRegistrationEvent({required this.email, required this.password});
}
