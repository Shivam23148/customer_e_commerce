part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthUserChanged extends AuthEvent {
  final User? user;

  AuthUserChanged(this.user);
}
