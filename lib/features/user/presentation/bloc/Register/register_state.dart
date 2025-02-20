part of 'register_bloc.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

// Email Sent Successfully
class EmailSentState extends RegisterState {}

// Email Verified
class EmailVerifiedState extends RegisterState {}

// Registration Completed
class RegistrationCompletedState extends RegisterState {}

// Error State
class RegistrationErrorState extends RegisterState {
  final String message;
  RegistrationErrorState(this.message);
}
